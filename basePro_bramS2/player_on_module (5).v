`timescale 1ns / 1ps

module player_on_module
(
    input clk_65M,  input clear, input clk_190,
    input [16:0] h_count, input [16:0] v_count, input game_stop, input game_start,
    input [0:1023] r_data_lsb, r_data_msb,
    output reg [9:0] r_addr_lsb, r_addr_msb, 
    output reg player_on,output reg we, output reg in_shaded,
    input istop,
    output reg game_over,

    //correct data read in values hcount 1-500 , v_count =2
    //redline_shader over here
    input [9:0] raddr_dec_red ,
    output reg [0:1023] lsb_data,
    output reg [0:1023] msb_data,
    output sample_now,
    input [7:0] byte3,
    input [8:0] x_data,
    input [8:0] y_data
);


    parameter HPIXELS = 1344;
    parameter VLINES = 806;
    parameter HBP = 296;
    parameter HFP = 1320;
    parameter VBP = 35;
    parameter VFP = 803;
    parameter HSP = 136;
    parameter VSP = 6;
    parameter HSCREEN = 1024;
    parameter VSCREEN = 768;
    
    parameter XSTART_POSITION = 600;
    parameter YSTART_POSITION = 400;
    parameter PLAYER_SIZE = 10;
    parameter PLAYER_DEFAULT_VELOCITY = 4;

    reg [22:0] sample_counter=0;
    reg up,left,down,right;
    reg prev_sampler;

//    always @(posedge clk_65M )
//    begin
//        sample_counter<=sample_counter+1;
//        prev_sampler<=sample_counter[22];
//        if(sample_counter[22]==1'b1)
//            sample_counter<=0;
//    end

    reg [16:0] player_velocity_reg_x ;
    reg [16:0] player_velocity_reg_y ;
    reg [8:0] y_data_reg,x_data_reg;
    reg [16:0] player_xstart_delta_reg, player_ystart_delta_reg;
    reg [16:0] player_xstart_delta_next, player_ystart_delta_next;
    

    always@(posedge clk_190)
    begin
//        if(byte3[7]==1)
//        begin
            
            up<=(byte3[2]==1) & ((y_data/100)>2);
            down<=byte3[2]==0 & ((y_data/100)>3);
            left<=byte3[3]==1 & ((x_data/100)>3);
            right<=byte3[3]==0 & ((x_data/100)>2);
            y_data_reg<=y_data/100;
            x_data_reg<=x_data/100;        
//        end
//        else
//        begin
//            up<=0;
//            down<=0;
//            left<=0;
//            right<=0;
//            y_data_reg<=0;
//            x_data_reg<=0;
//            player_velocity_reg_x<=0;
//            player_velocity_reg_y<=0;
//        end
    end


    assign sample_now=(prev_sampler==0 && sample_counter[22]==1);

    wire [16:0] player_xstart, player_ystart, player_xstop, player_ystop;

    always @(*)
    begin
        if (((h_count >= player_xstart+HBP) && (h_count < player_xstop+HBP)) && ((v_count >= player_ystart+VBP) && (v_count < player_ystop+VBP)))
            begin
                player_on = 1;
                we=1;
            end
        else
            begin
                player_on = 0;
                we=0;
            end
    end
    
    reg [0:1023] doutb1_up_lsb, doutb1_up_msb, doutb1_down_lsb, doutb1_down_msb;
//    wire [9:0] r_addr1_up_lsb, r_addr1_up_msb, r_addr1_down_lsb, r_addr1_down_msb;
    //reg [1:0] PS,NS;

    //read access - 1
    //fetching for finding in_shaded flag in 5-25 , 805//
    always @(posedge clk_65M)
    begin
        
            
        //read access-2 where is player ,in_shaded flag
        if(h_count >5 && h_count <10 && v_count==805)
            begin
                r_addr_msb <= player_ystart-2;
                r_addr_lsb <= player_ystart-2;
            end
        else if(h_count >10 && h_count <15 && v_count==805)
            begin
                doutb1_up_lsb <= r_data_lsb;
                doutb1_up_msb <= r_data_msb;
            end
        else if(h_count >16 && h_count <20 && v_count==805)
            begin
                r_addr_msb <= player_ystop+2;
                r_addr_lsb <= player_ystop+2;
            end
        else if(h_count >20 && h_count <25 && v_count==805)
            begin
                doutb1_down_lsb <= r_data_lsb;
                doutb1_down_msb <= r_data_msb;
            end 
//           else
//            begin
//                r_addr_msb <= raddr_dec_red;
//                r_addr_lsb <= raddr_dec_red;
//                lsb_data <=   r_data_lsb;
//                msb_data <=   r_data_msb;
//            end

    end

    
//    always @(*)
//    begin
//        if
//        (
//            (doutb1_up_lsb[player_xstart] & doutb1_up_msb[player_xstart] & doutb1_up_lsb[player_xstop] &
//            doutb1_up_msb[player_xstop]) & (doutb1_down_lsb[player_xstart] & doutb1_down_msb[player_xstart] &
//            doutb1_down_lsb[player_xstop] & doutb1_down_msb[player_xstop])
//        )
//            in_shaded = 1;
//        else
//            in_shaded = 0;
//    end
    
     reg gol,gor,god,gou;                
//    assign game_over = gol|gor|god|gou; 
    always @(*)
    begin
        if(up & left)
        begin
            game_over=( ~doutb1_up_lsb[player_xstart-8] & doutb1_up_msb[player_xstart-8] & ~doutb1_up_lsb[player_xstop+8] & doutb1_up_msb[player_xstop+8])&
                (~doutb1_up_lsb[player_xstart-8] & doutb1_up_msb[player_xstart-8] & ~doutb1_down_lsb[player_xstart-8] & doutb1_down_msb[player_xstart -8] );
            in_shaded = ( doutb1_up_lsb[player_xstart] & doutb1_up_msb[player_xstart] &doutb1_up_lsb[player_xstop] & doutb1_up_msb[player_xstop])&
                (doutb1_up_lsb[player_xstart] & doutb1_up_msb[player_xstart] & doutb1_down_lsb[player_xstart] & doutb1_down_msb[player_xstart]);

        end
        else if(up & right)
        begin
            game_over=( ~doutb1_up_lsb[player_xstart-8] & doutb1_up_msb[player_xstart-8] & ~doutb1_up_lsb[player_xstop+8] & doutb1_up_msb[player_xstop+8])
                &(~doutb1_up_lsb[player_xstop+16] & doutb1_up_msb[player_xstop+16] & ~doutb1_down_lsb[player_xstop+16] & doutb1_down_msb[player_xstop+16]);
            in_shaded = ( doutb1_up_lsb[player_xstart] & doutb1_up_msb[player_xstart] &doutb1_up_lsb[player_xstop] & doutb1_up_msb[player_xstop])&
                (doutb1_up_lsb[player_xstop] & doutb1_up_msb[player_xstop] & doutb1_down_lsb[player_xstop] & doutb1_down_msb[player_xstop]);

        end
        else if(down && left)
        begin
            game_over=(~doutb1_down_lsb[player_xstart-8] & doutb1_down_msb[player_xstart-8] & ~doutb1_down_lsb[player_xstop+8] & doutb1_down_msb[player_xstop+8])&
                (~doutb1_up_lsb[player_xstart-8] & doutb1_up_msb[player_xstart-8] & ~doutb1_down_lsb[player_xstart-8] & doutb1_down_msb[player_xstart -8] );
            in_shaded =( doutb1_down_lsb[player_xstart] & doutb1_down_msb[player_xstart] &doutb1_down_lsb[player_xstop] & doutb1_down_msb[player_xstop])&
                (doutb1_up_lsb[player_xstart] & doutb1_up_msb[player_xstart] & doutb1_down_lsb[player_xstart] & doutb1_down_msb[player_xstart]); 

        end
        else if(down & right)
        begin
            game_over=(~doutb1_down_lsb[player_xstart-8] & doutb1_down_msb[player_xstart-8] & ~doutb1_down_lsb[player_xstop+8] & doutb1_down_msb[player_xstop+8])&
                (~doutb1_up_lsb[player_xstop+16] & doutb1_up_msb[player_xstop+16] & ~doutb1_down_lsb[player_xstop+16] & doutb1_down_msb[player_xstop+16]);
            
            in_shaded =( doutb1_down_lsb[player_xstart] & doutb1_down_msb[player_xstart] &doutb1_down_lsb[player_xstop] & doutb1_down_msb[player_xstop])&
                (doutb1_up_lsb[player_xstop] & doutb1_up_msb[player_xstop] & doutb1_down_lsb[player_xstop] & doutb1_down_msb[player_xstop]); 

        end


        else if(left)
            begin
                game_over =~doutb1_up_lsb[player_xstart-8] & doutb1_up_msb[player_xstart-8] & ~doutb1_down_lsb[player_xstart-8] & doutb1_down_msb[player_xstart -8] ;
                in_shaded = (doutb1_up_lsb[player_xstart] & doutb1_up_msb[player_xstart] & doutb1_down_lsb[player_xstart] & doutb1_down_msb[player_xstart]);
//                gou=0;
//                god=0;
//                gor=0;
            end
        else if(right)
            begin
//                gol=0;
//                gou=0;
//                god=0;
                in_shaded = (doutb1_up_lsb[player_xstop] & doutb1_up_msb[player_xstop] & doutb1_down_lsb[player_xstop] & doutb1_down_msb[player_xstop]);
                game_over= ~doutb1_up_lsb[player_xstop+16] & doutb1_up_msb[player_xstop+16] & ~doutb1_down_lsb[player_xstop+16] & doutb1_down_msb[player_xstop+16];
            end
        else if(down)
            begin
//                gol=0;
//                gou=0;
                in_shaded =( doutb1_down_lsb[player_xstart] & doutb1_down_msb[player_xstart] &doutb1_down_lsb[player_xstop] & doutb1_down_msb[player_xstop]); 
                game_over=(~doutb1_down_lsb[player_xstart-8] & doutb1_down_msb[player_xstart-8] & ~doutb1_down_lsb[player_xstop+8] & doutb1_down_msb[player_xstop+8]);
//                gor=0;
                           
            end
         else if(up)
             begin
                game_over=( ~doutb1_up_lsb[player_xstart-8] & doutb1_up_msb[player_xstart-8] & ~doutb1_up_lsb[player_xstop+8] & doutb1_up_msb[player_xstop+8]);
                in_shaded = ( doutb1_up_lsb[player_xstart] & doutb1_up_msb[player_xstart] &doutb1_up_lsb[player_xstop] & doutb1_up_msb[player_xstop]);
//                god=0;
//                gor=0;
//                gol=0;
             end
         else
                begin
                    game_over=1'b0;
                    in_shaded= (doutb1_up_lsb[player_xstart] & doutb1_up_msb[player_xstart] & doutb1_up_lsb[player_xstop] & doutb1_up_msb[player_xstop])
                              & (doutb1_down_lsb[player_xstart] & doutb1_down_msb[player_xstart] &
                                doutb1_down_lsb[player_xstop] & doutb1_down_msb[player_xstop]);
                end
    end
//    assign game_over = ((~doutb1_up_lsb[player_xstart] & doutb1_up_msb[player_xstart] & ~doutb1_up_lsb[player_xstop] &
//                                doutb1_up_msb[player_xstop]) & (~doutb1_down_lsb[player_xstart] & doutb1_down_msb[player_xstart] &
//                                ~doutb1_down_lsb[player_xstop] & doutb1_down_msb[player_xstop])); 
                                
                                
    reg [16:0] player_xstart_reg, player_ystart_reg, player_xstart_next, player_ystart_next;
    assign player_xstart = player_xstart_reg;
    assign player_xstop = player_xstart_reg + PLAYER_SIZE;
    assign player_ystart = player_ystart_reg;
    assign player_ystop = player_ystart_reg + PLAYER_SIZE;
    
    always @(posedge clk_65M)
    begin
        if (clear | game_start)
        begin
            player_xstart_reg <= XSTART_POSITION;
            player_ystart_reg <= YSTART_POSITION;
        end
        else
        begin
            player_xstart_reg <= player_xstart_next;
            player_ystart_reg <= player_ystart_next;
        end
    end
    
    wire refr_tick;
    assign refr_tick = ((h_count == 0) && (v_count == 0));
    
    always @(*)
    begin
        player_xstart_next = player_xstart_reg;
        if (clear)
            player_xstart_next = XSTART_POSITION;
        else if (refr_tick == 1)
            player_xstart_next = player_xstart_reg + player_xstart_delta_reg;
    end
    
    always @(*)
    begin
        player_ystart_next = player_ystart_reg;
        if (clear)
            player_ystart_next = YSTART_POSITION;
        else if (refr_tick == 1)
            player_ystart_next = player_ystart_reg + player_ystart_delta_reg;
    end
    
    always @(posedge clk_65M)
    begin
        if (clear | game_start | player_xstart<0 | player_xstop>HSCREEN-320) 
        begin
            player_xstart_delta_reg <= 0;
        end
        else
        begin
            player_xstart_delta_reg <= player_xstart_delta_next;
        end
    end
    
    always @(posedge clk_65M)
    begin
        if (clear | game_start | player_ystart<0 | player_ystop>VSCREEN) 
        begin
            player_ystart_delta_reg <= 0;
        end
        else
        begin
            player_ystart_delta_reg <= player_ystart_delta_next;
        end
    end
    
    //CODE EDITS FOR PLAYER//
    
    always @(*)
    begin
        player_xstart_delta_next = player_xstart_delta_reg;
        if (left && player_xstart>0)
            player_xstart_delta_next = -3;  // go left until reaches boundary (X=0)
        else if (right && player_xstop<HSCREEN-320 )
            player_xstart_delta_next = 3; // go right until boundary X=HSCREEN
        else if (right && player_xstart>0)
            player_xstart_delta_next = 3;  // go left until reaches boundary (X=0)
        else if (left && player_xstop<HSCREEN-320)
            player_xstart_delta_next = -3; // go right until boundary X=HSCREEN
        
        else
            player_xstart_delta_next = 0;                     // dont MOVE (if no key pressed or at boundary)
     end
    
    always @(*)
    begin
        player_ystart_delta_next = player_ystart_delta_reg;
        if (up && player_ystart>0 )                                         //player go up till it reach (y=0)
            player_ystart_delta_next = -3;                            
        else if (down && player_ystop<VSCREEN-8 )                             // player keep going down till it reach VSCREEN
            player_ystart_delta_next = 3;                                       
        else if (down && player_ystart>0 )                                         //player go up till it reach (y=0)
            player_ystart_delta_next = 3;                            
        else if (up && player_ystop<VSCREEN-8  )                             // player keep going down till it reach VSCREEN
            player_ystart_delta_next = -3;  
        else 
            player_ystart_delta_next = 0;                                // else dont move
    end
    
endmodule