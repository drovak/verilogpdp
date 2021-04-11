module tu55_xilinx (
    clk,
    rst,
    tape_pos,
    /***** front panel stuff *****/
    //unit_number,
    write_enable,
    //remote,
    //seek_left,
    //seek_right,

    /***** from TC08 *****/
    //t_00_l, t_01_l, t_02_l, t_03_l, t_04_l, t_05_l, t_06_l, t_07_l, // unit selector
    t_fwd_l, t_go_l, //t_pwr_clr_l, t_rev_l, t_stop_l, // transport control

    /***** to TC08 *****/
    //t_single_unit_l, 
    t_write_ok_l, 

    /***** tape heads *****/
    t_trk_rd_pos, t_trk_rd_neg, 
    rdmk_rd_pos, rdmk_rd_neg, 
    rdd_02_rd_pos, rdd_02_rd_neg, 
    rdd_01_rd_pos, rdd_01_rd_neg, 
    rdd_00_rd_pos, rdd_00_rd_neg,
    t_trk_wr_pos, t_trk_wr_neg, 
    rdmk_wr_pos, rdmk_wr_neg, 
    rdd_02_wr_pos, rdd_02_wr_neg, 
    rdd_01_wr_pos, rdd_01_wr_neg, 
    rdd_00_wr_pos, rdd_00_wr_neg
);

input clk, rst;
output [20:0] tape_pos;
assign tape_pos = pos;

//input [2:0] unit_number;
input write_enable;
/*
input remote;
input seek_left;
input seek_right;
*/

input t_trk_wr_pos;
input t_trk_wr_neg;
input rdmk_wr_pos;
input rdmk_wr_neg;
input rdd_02_wr_pos;
input rdd_02_wr_neg;
input rdd_01_wr_pos;
input rdd_01_wr_neg;
input rdd_00_wr_pos;
input rdd_00_wr_neg;

output t_trk_rd_pos;
output t_trk_rd_neg;
output rdmk_rd_pos;
output rdmk_rd_neg;
output rdd_02_rd_pos;
output rdd_02_rd_neg;
output rdd_01_rd_pos;
output rdd_01_rd_neg;
output rdd_00_rd_pos;
output rdd_00_rd_neg;

//output t_single_unit_l;
output t_write_ok_l;
assign t_write_ok_l = !write_enable;

/*
input t_00_l;
input t_01_l;
input t_02_l;
input t_03_l;
input t_04_l;
input t_05_l;
input t_06_l;
input t_07_l;
input t_rev_l;
input t_stop_l;
*/
input t_fwd_l;
input t_go_l;
//input t_pwr_clr_l;

/*
wire [3:0] sel_unit = (!t_00_l) ? 4'h0 :
                      (!t_01_l) ? 4'h1 :
                      (!t_02_l) ? 4'h2 :
                      (!t_03_l) ? 4'h3 :
                      (!t_04_l) ? 4'h4 :
                      (!t_05_l) ? 4'h5 :
                      (!t_06_l) ? 4'h6 :
                      (!t_07_l) ? 4'h7 : 4'hf;
                      */

/* motion states */
localparam MOT_ATSR = -3; // at speed, reverse
localparam MOT_DECR = -2; // decel, reverse -> stop
localparam MOT_ACCR = -1; // accel, stop -> reverse
localparam MOT_STOP = 0; // stopped
localparam MOT_ACCF = 1; // accel, stop -> forward
localparam MOT_DECF = 2; // decel, forward -> stop
localparam MOT_ATSF = 3; // at speed, forward

reg signed [2:0] motion_state;

wire go = !t_go_l;
wire fwd = !t_fwd_l;

/* 260 feet of tape, 350 lines per inch = 1,092,000 lines */
//localparam MAX_LINES = 1092000;
//reg [3:0] tape [0:MAX_LINES - 1];
//initial $readmemh("tc08_boot/tc08diag.mem", tape);
//initial $readmemh("tc08_boot/blank.mem", tape);

reg write;
reg [3:0] write_bits;
reg [3:0] to_write;
wire [3:0] tape_in;
wire [3:0] tape_out;
assign tape_in = tape_out & ~write_bits | to_write;

blk_mem_tape tape_mem (
  .clka(clk),
  .wea(write),
  .addra(pos[19:0]),
  .dina(tape_in),
  .douta(tape_out)
);

wire [20:0] pos = time_count[61:41];
reg signed [61:0] time_count;
reg signed [31:0] speed;

/* 97 ips, 350 lines per inch = 33,950 lines per second */
localparam MAX_SPEED = 33950;
localparam LINES_PER_CLOCK = $rtoi($pow(2,41) * MAX_SPEED / 100e6);

localparam SPEED_THRESH = LINES_PER_CLOCK / 2;
wire tape_fwd = (speed > ( SPEED_THRESH)) ? 1'b1 : 1'b0;
wire tape_rev = (speed < (-SPEED_THRESH)) ? 1'b1 : 1'b0;

assign t_trk_rd_pos =  (tape_fwd) ?  time_count[40] : 
                       (tape_rev) ? !time_count[40] : 1'b0;
assign t_trk_rd_neg =  (tape_fwd) ? !time_count[40] : 
                       (tape_rev) ?  time_count[40] : 1'b0;
assign rdmk_rd_pos =   (tape_fwd) ?  tape_out[3] : 
                       (tape_rev) ? !tape_out[3] : 1'b0;
assign rdmk_rd_neg =   (tape_fwd) ? !tape_out[3] : 
                       (tape_rev) ?  tape_out[3] : 1'b0;
assign rdd_02_rd_pos = (tape_fwd) ?  tape_out[0] : 
                       (tape_rev) ? !tape_out[0] : 1'b0;
assign rdd_02_rd_neg = (tape_fwd) ? !tape_out[0] : 
                       (tape_rev) ?  tape_out[0] : 1'b0;
assign rdd_01_rd_pos = (tape_fwd) ?  tape_out[1] : 
                       (tape_rev) ? !tape_out[1] : 1'b0;
assign rdd_01_rd_neg = (tape_fwd) ? !tape_out[1] : 
                       (tape_rev) ?  tape_out[1] : 1'b0;
assign rdd_00_rd_pos = (tape_fwd) ?  tape_out[2] : 
                       (tape_rev) ? !tape_out[2] : 1'b0;
assign rdd_00_rd_neg = (tape_fwd) ? !tape_out[2] : 
                       (tape_rev) ?  tape_out[2] : 1'b0;

/* 150 ms */
localparam START_TIME = 15000000; // 10 ns units
localparam ACCEL_VAL = $rtoi(LINES_PER_CLOCK / START_TIME);

/* 100 ms */
localparam STOP_TIME = 10000000; // 10 ns units
localparam DECEL_VAL = $rtoi(LINES_PER_CLOCK / STOP_TIME);

reg t_trk_wr_pos_old;
reg t_trk_rd_pos_old;

always @(posedge clk) begin
    if (rst) begin
        write <= 1'b0;
        write_bits <= 0;
        to_write <= 0;
        motion_state <= MOT_STOP;
        speed <= 0;
        time_count <= {21'o122000, 41'b0}; // keep a bit on the spool initially
        //time_count <= {21'o1000, 41'b0}; // keep a bit on the spool initially
    //end else if (sel_unit == {1'b0, unit_number}) begin
    end else begin
        time_count <= time_count + {{30{speed[31]}}, speed};
        t_trk_wr_pos_old <= t_trk_wr_pos;
        t_trk_rd_pos_old <= t_trk_rd_pos;
        if (write_enable) begin
            if (t_trk_wr_pos ^ t_trk_wr_neg) begin
                if (!t_trk_wr_pos_old && t_trk_wr_pos) begin
                    // synchronize to the timing track being written on rising edge
                    time_count[40] <= 1'b1; 
                    time_count[39:0] <= 40'b0;
                    //$display("[%t] synchronize: %d", $time, pos);
                end
            end
            if (write_bits) 
                write <= 1'b1;
            else 
                write <= 1'b0;

            write_bits <= 0;
            if (!t_trk_rd_pos_old && t_trk_rd_pos) begin
                if (rdmk_wr_pos ^ rdmk_wr_neg) begin
                    to_write[3] <= rdmk_wr_pos;
                    write_bits[3] <= 1'b1;
                end
                if (rdd_02_wr_pos ^ rdd_02_wr_neg) begin
                    to_write[0] <= rdd_02_wr_pos;
                    write_bits[0] <= 1'b1;
                end
                if (rdd_01_wr_pos ^ rdd_01_wr_neg) begin
                    to_write[1] <= rdd_01_wr_pos;
                    write_bits[1] <= 1'b1;
                end
                if (rdd_00_wr_pos ^ rdd_00_wr_neg) begin
                    to_write[2] <= rdd_00_wr_pos;
                    write_bits[2] <= 1'b1;
                end
                //$strobe("[%t] wrote: tape[%d] = %o", $time, pos, tape[pos]);
            end
        end
        case (motion_state)
            MOT_ATSR: begin
                // if stop or going forward...
                if (!go | fwd) motion_state <= MOT_DECR;
                else begin
                    // at speed, reverse
                end
            end
            MOT_DECR: begin
                // if stop or going forward...
                if (!go | fwd) begin
                    // decelerate reverse
                    if (speed < 32'sd0) speed <= speed + DECEL_VAL;
                    else begin
                        speed <= 0;
                        motion_state <= MOT_STOP;
                    end
                end
                // if going reverse...
                else motion_state <= MOT_ACCR;
            end
            MOT_ACCR: begin
                //if stop or going forward...
                if (!go | fwd) motion_state <= MOT_DECR;
                else begin
                    // accelerate reverse
                    if (speed > -LINES_PER_CLOCK) speed <= speed - ACCEL_VAL;
                    else begin
                        speed <= -LINES_PER_CLOCK;
                        motion_state <= MOT_ATSR;
                    end
                end
            end
            MOT_STOP: begin
                if (go) begin
                    if (fwd) motion_state <= MOT_ACCF;
                    else motion_state <= MOT_ACCR;
                end
            end
            MOT_ACCF: begin
                // if stop or going reverse...
                if (!go | !fwd) motion_state <= MOT_DECF;
                else begin
                    // accelerate forward
                    if (speed < LINES_PER_CLOCK) speed <= speed + ACCEL_VAL;
                    else begin
                        speed <= LINES_PER_CLOCK;
                        motion_state <= MOT_ATSF;
                    end
                end
            end
            MOT_DECF: begin
                // if stop or going reverse...
                if (!go | !fwd) begin
                    // decelerate forward
                    if (speed > 0) speed <= speed - DECEL_VAL;
                    else begin
                        speed <= 0;
                        motion_state <= MOT_STOP;
                    end
                end
                // if going forward...
                else motion_state <= MOT_ACCF;
            end
            MOT_ATSF: begin
                // if stop or going reverse...
                if (!go | !fwd) motion_state <= MOT_DECF;
                else begin
                    // at speed, forward
                end
            end
            default: motion_state <= MOT_STOP;
        endcase
    end
end

endmodule
