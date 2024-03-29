`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08/30/2019 02:56:43 PM
// Design Name: 
// Module Name: top
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////

module top
(
    input clk_100M, input clear, input pause, input game_on, input game_start,
    input up, input down, input left, input right,
    input clr,input sel, inout RsRx, inout PS2Clk,
    output [7:0] led, output sample_now,
    output h_sync, output v_sync, output [3:0] vga_red, output [3:0] vga_green, output [3:0] vga_blue
//    output in_shaded, output game_win
     //output [15:0] led
);

    wire [15:0] leds;
    wire we,iwrite;
    wire [9 : 0] w_addr0, w_addr1, r_addr0, r_addr1;
    wire [0:1023] doutb0, doutb1, w_data0, w_data1;
   
   wire clrp;
    wire [9:0] r_addr1_lsb, r_addr1_msb, r_addr2_lsb, r_addr2_msb, r_addr3_lsb, r_addr3_msb,r_addr4_lsb, r_addr4_msb, r_addr_player_lsb, r_addr_player_msb;
    wire [0:1023] r_data1_lsb, r_data1_msb, r_data2_lsb, r_data2_msb, r_data3_lsb, r_data3_msb,r_data4_lsb, r_data4_msb, 
    r_data_player_lsb, r_data_player_msb; 

    wire clk_65M, clk_190, game_start_db, game_stop;
    
    wire [16:0] h_count, v_count;
    wire vid_on, player_on;
    wire [4:1] ball_on;
    wire istop, game_over1, game_over2, game_over3,game_over4;//, in_shaded;
   
    wire up_p, down_p, right_p, left_p;
     
    wire game_over_p,game_over_p2;
    wire in_shaded;
    wire game_win;
    
    wire [6 : 0] rom_intsc_addr;
    wire [255:0] doutb3;
    blk_mem_gen_0 mainScreen
    (
        .clka(clk_65M),    // input wire clka
        .addra(rom_intsc_addr),  // input wire [9 : 0] addra
        .douta(doutb3)  // output wire [1023 : 0] douta
    );
    wire [1:0] life;
    wire game_end;
    wire [7:0] rom_instruction_addr;
    wire [191:0] doutb4;
    instr_screen instruction_screen_rom
    (
        .clka(clk_65M),    // input wire clka
        .addra(rom_instruction_addr),  // input wire [7 : 0] addra
        .douta(doutb4)  // output wire [191 : 0] douta
    );
    
    wire [5:0] rom_lives_addr;
    wire [82:0] doutb5;
    lives lives_rom
    (
        .clka(clk_65M),    // input wire clka
        .addra(rom_lives_addr),  // input wire [5 : 0] addra
        .douta(doutb5)  // output wire [82 : 0] douta
    );

    
    deb_1clk dbp(.clk_deb(clk_190),.deb_out(clrp),.pb_press(clr));
    

    bram_Opt bo
    (
        .r_clk(clk_65M), .w_clk(clk_65M), .w_en(iwrite),.r_en(1),
        .w_addr_lsb(w_addr0), .w_addr_msb(w_addr1), 
        .w_data_lsb(w_data0), .w_data_msb(w_data1),
        .r_addr_lsb(r_addr0), .r_addr_msb(r_addr1), 
        .r1_data_lsb(doutb0), .r1_data_msb(doutb1)
    );
    
    //bram for ball1
    bram_Opt ball1_bram
    (
        .r_clk(clk_65M), .w_clk(clk_65M), .w_en(iwrite),.r_en(1),
        .w_addr_lsb(w_addr0), .w_addr_msb(w_addr1), 
        .w_data_lsb(w_data0), .w_data_msb(w_data1),
        .r_addr_lsb(r_addr1_lsb), .r_addr_msb(r_addr1_msb), 
        .r1_data_lsb(r_data1_lsb), .r1_data_msb(r_data1_msb)
    );
    
  //bram for ball 2
    bram_Opt ball2_bram
    (
        .r_clk(clk_65M), .w_clk(clk_65M), .w_en(iwrite),.r_en(1),
        .w_addr_lsb(w_addr0), .w_addr_msb(w_addr1), 
        .w_data_lsb(w_data0), .w_data_msb(w_data1),
        .r_addr_lsb(r_addr2_lsb),.r_addr_msb(r_addr2_msb), 
        .r1_data_lsb(r_data2_lsb),.r1_data_msb(r_data2_msb)
    );
    
    //bram for ball 2
    bram_Opt ball3_bram
    (
        .r_clk(clk_65M), .w_clk(clk_65M), .w_en(iwrite),.r_en(1),
        .w_addr_lsb(w_addr0),.w_addr_msb(w_addr1), 
        .w_data_lsb(w_data0), .w_data_msb(w_data1),
        .r_addr_lsb(r_addr3_lsb),.r_addr_msb(r_addr3_msb), 
        .r1_data_lsb(r_data3_lsb),.r1_data_msb(r_data3_msb)
    );
    //boundary ball bram
    bram_Opt ball4_bram
    (
        .r_clk(clk_65M), .w_clk(clk_65M), .w_en(iwrite),.r_en(1),
        .w_addr_lsb(w_addr0),.w_addr_msb(w_addr1), 
        .w_data_lsb(w_data0), .w_data_msb(w_data1),
        .r_addr_lsb(r_addr4_lsb),.r_addr_msb(r_addr4_msb), 
        .r1_data_lsb(r_data4_lsb),.r1_data_msb(r_data4_msb)
    );

    //bram for player
    bram_Opt player_bram
    (
        .r_clk(clk_65M), .w_clk(clk_65M), .w_en(iwrite),.r_en(1),
        .w_addr_lsb(w_addr0),.w_addr_msb(w_addr1), 
        .w_data_lsb(w_data0), .w_data_msb(w_data1),
        .r_addr_lsb(r_addr_player_lsb), .r_addr_msb(r_addr_player_msb), 
        .r1_data_lsb(r_data_player_lsb), .r1_data_msb(r_data_player_msb)
    );
    
    debounce d1(.clk(clk_190), .clear(clear), .inp_pb(game_start),.out_pb(game_start_db));
    wire clk_25,clk_8M,clk_10k,clk_6M,clk_8Mp;
    wire [8:0] x,y;
        wire [7:0] byte3;
      
     
    freq_div #(20) f1 (.clk(clk_100M), .clkdiv(clk_190));
     
    clk_wiz_0 clk_wiz(.clk_out1(clk_65M), .clk_in1(clk_100M),.clk_25(clk_25),.clk_8M(clk_8M),.clk_8Mp(clk_8Mp),.clk_6M(clk_6M));
    vga_ctrl vgac(.clk_65M(clk_65M), .clear(1'b0), .v_sync(v_sync), .h_sync(h_sync), .h_count(h_count), .v_count(v_count), .vid_on(vid_on));
    
    assign istop = ((game_over1 | game_over2 | game_over3| game_over4 | game_over_p | game_over_p2) & (~in_shaded));
    
    ball_on_module #(.XSTART_POSITION(400), .YSTART_POSITION(200)) ball1
    (
        .clk_65M(clk_65M), .clear(clear), .pause(pause), .h_count(h_count), .v_count(v_count),
        .game_on(game_on), .game_start(game_start_db), .ball_on(ball_on[1]),
        .r_addr_lsb(r_addr1_lsb), .r_addr_msb(r_addr1_msb),
        .r_data_lsb(r_data1_lsb), .r_data_msb(r_data1_msb),
        .game_over(game_over1),.istop(istop),.game_end(game_end)
    );
    
    ball_on_module #(.XSTART_POSITION(400), .YSTART_POSITION(600)) ball2
    (
        .clk_65M(clk_65M), .clear(clear), .pause(pause), .h_count(h_count), .v_count(v_count),
        .game_on(game_on), .game_start(game_start_db), .ball_on(ball_on[2]),
        .r_addr_lsb(r_addr2_lsb), .r_addr_msb(r_addr2_msb),
        .r_data_lsb(r_data2_lsb), .r_data_msb(r_data2_msb),
        .game_over(game_over2),.istop(istop),.game_end(game_end)
    );
    
    ball_on_module #(.XSTART_POSITION(550), .YSTART_POSITION(200)) ball3
    (
        .clk_65M(clk_65M), .clear(clear), .pause(pause), .h_count(h_count), .v_count(v_count),
        .game_on(game_on), .game_start(game_start_db), .ball_on(ball_on[3]),
        .r_addr_lsb(r_addr3_lsb), .r_addr_msb(r_addr3_msb),
        .r_data_lsb(r_data3_lsb), .r_data_msb(r_data3_msb),
        .game_over(game_over3),.istop(istop),.game_stop(game_stop),.game_end(game_end)
    );
    
    ball_on_module_inv  #(.XSTART_POSITION(5), .YSTART_POSITION(0)) boundaryball
(
    .clk_65M(clk_65M), .clear(clear), .h_count(h_count),.pause(pause),
    .v_count(v_count), .game_start(game_start_db), .game_on(game_on), .istop(istop),
    .r_data_lsb(r_data4_lsb) ,.r_data_msb(r_data4_msb),
    .r_addr_lsb(r_addr4_lsb), .r_addr_msb(r_addr4_msb),
    .game_over(game_over4), .ball_on(ball_on[4]));

    
        
//    give_directions gd(.clk(clk_65M), .up(up), .down(down), .left(left), .right(right), .up_p(up_p), .down_p(down_p), .left_p(left_p), .right_p(right_p),.game_over(game_over_p2),.istop(istop),.in_shaded(in_shaded),.game_stop(game_stop),.game_end(game_end));
    
    wire [0:1023] r_data_in_lsb, r_data_in_msb;                    //read data input from player bram to read converter
    wire [9:0] r_addr_out;                                         //read address input for player bram
    
    freq_div #(9) f2 (.clk(clk_8M), .clkdiv(clk_10k));

    
    player_on_module #(.XSTART_POSITION(512), .YSTART_POSITION(0)) player 
    (
        .clk_65M(clk_65M),  .clear(clear), 
        .h_count(h_count), .v_count(v_count), .game_stop(game_stop), .game_start(game_start), 
        .player_on(player_on),.we(we), .r_data_lsb(r_data_player_lsb), .r_data_msb(r_data_player_msb),
        .r_addr_lsb(r_addr_player_lsb), .r_addr_msb(r_addr_player_msb),
        .in_shaded(in_shaded),
        .raddr_dec_red(r_addr_out), .msb_data(r_data_in_msb), .lsb_data(r_data_in_lsb),
        .game_over(game_over_p),.istop(istop),
        .byte3(byte3),.x_data(x),.y_data(y),.sample_now(sample_now),.clk_190(clk_25)
    );
//    wire clk;
//    assign clk=clk_sel&clk_6M | clk_sel&clk_8Mp;
        moosze mouse(
    .clk_25(clk_25),.clr(clrp), .sel(sel),
			 .PS2C(PS2Clk), .PS2D(RsRx),
			 .byte3(byte3),
			 .x_data(x),
			 .y_data(y)			 
    );
    
//    wire [9:0] w_addr_out;                                          //input to game
//    wire [0:1023] w_data_out_lsb, w_data_out_msb;                   //input to game
    
    life L0(.game_stop(game_stop),.clear(clear),.lives(life) , .game_end(game_end));
    
    game gm
    (   //.i_countscore(led),
        .clk_65M(clk_65M), .clear(clear), .vid_on(vid_on), .game_on(game_on), 
        .h_count(h_count), .v_count(v_count),
        .rom_lives_addr(rom_lives_addr), .doutb5(doutb5),
        .rom_instruction_addr(rom_instruction_addr), .doutb4(doutb4),
        .doutb3(doutb3), .rom_intsc_addr(rom_intsc_addr),
        .ball_on(ball_on), .player_on(player_on), .we(we), 
        .w_addr0(w_addr0), .w_data0(w_data0),
        .r_addr0(r_addr0), .doutb0(doutb0),
        .w_addr1(w_addr1), .w_data1(w_data1),
        .r_addr1(r_addr1), .doutb1(doutb1),
        .vga_red(vga_red), .vga_green(vga_green), .vga_blue(vga_blue),
        .game_win(game_win),
        .test(in_shaded)
        ,.istop(istop)
        ,.game_start(game_start)
        ,.score(leds),
        .game_end(game_end), .life(life)
        
        //.wdata_msb_red(w_data_out_msb), .wdata_lsb_red(w_data_out_lsb), .w_addr_write_red(w_addr_out)
    );
    
    assign iwrite = (we | (in_shaded & vid_on) | (clear& vid_on) | (game_start & vid_on));
    
    assign led=byte3;
//    wire done_shade, we_red;
//    wire [6:0] w_addr_red_bram, r_addr_red_bram;
//    wire [255:0] r_data_red_bram, w_data_red_bram;
    
//    redline_shader red_shade
//    (
//        .clk(clk_65M), .ready(done_shade), .start(in_shaded), .we(we_red),
//        .r_dout(r_data_red_bram), .w_dout(w_data_red_bram), .w_addr(w_addr_red_bram), .r_addr(r_addr_red_bram)
//    );
    
//    write_converter wc
//    (
//        .w_addr_in(w_addr_red_bram), .w_data_in(w_data_red_bram),
//        .w_addr_out(w_addr_out), .w_data_out_lsb(w_data_out_lsb), .w_data_out_msb(w_data_out_msb)
//    );
    
//    read_converter rc
//    (
//        .r_addr_in(r_addr_red_bram), .r_data_in_lsb(r_data_in_lsb), .r_data_in_msb(r_data_in_msb),
//        .r_addr_out(r_addr_out), .r_data_out(r_data_red_bram)
//    );  

endmodule
