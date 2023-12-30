`include "define.v"


module configMode(
    input clk,
    input reset,
    input enable,
    input buttonChangeLight,
    input buttonIncreaseTime,
    input buttonDecreaseTime,
    input buttonConfirm,
    input[6:0] greenTime,
    input[6:0] yellowTime,
    input[6:0] redTime,
    output reg[6:0] greenTimeModified,
    output reg[6:0] yellowTimeModified,
    output reg[6:0] redTimeModified,
    output reg[6:0] timeLane1,
    output reg[6:0] timeLane2,
    output reg[2:0] state 
);
    
    parameter RR = 0;
    parameter GG = 1;
    parameter YY = 2;   
    
    reg[6:0] redTemp;
    reg[6:0] greenTemp;
    reg[6:0] yellowTemp;
    
    always@(enable) begin
        if(enable == 1) begin
            state = RR;
            redTemp = redTime;
            greenTemp = greenTime;
            yellowTemp = yellowTime;
            greenTimeModified = greenTime;
            redTimeModified = redTime;
            yellowTimeModified = yellowTime;
            timeLane1 = redTemp;
            timeLane2 = redTemp;
        end
    end
    
    always@(*) begin
        if(enable == 1) begin
            case(state)
                RR: begin
                    if(buttonChangeLight) begin
                        state = GG;
                        timeLane1 = greenTimeModified;
                        timeLane2 = greenTimeModified;                            
                    end
                    if(buttonIncreaseTime) begin
                        redTemp = redTemp + 1; 
                        timeLane1 = redTemp;
                        timeLane2 = redTemp;
                        if(redTemp > `MAX_TIME) begin
                            redTemp = 1;
                            timeLane1 = redTemp;
                            timeLane2 = redTemp;
                        end
                    end
                    if(buttonDecreaseTime) begin
                        redTemp = redTemp - 1;
                        timeLane1 = redTemp;
                        timeLane2 = redTemp;
                        if(redTemp == `MIN_TIME) begin
                            redTemp = 99;
                            timeLane1 = redTemp;
                            timeLane2 = redTemp;                            
                        end
                    end
                    if(buttonConfirm) begin
                        if(redTemp > greenTemp && red_time_o > yellowTemp && redTemp == greenTemp + yellowTemp) begin
                            redTimeModified = redTemp;
                            greenTimeModified = greenTemp;
                            yellowTimeModified = yellowTemp;
                        end
                    end
                end
                GG: begin
                    if(buttonChangeLight) begin 
                        state = YY;
                        timeLane1 = yellowTimeModified;
                        timeLane2 = yellowTimeModified;                        
                    end
                    if(buttonIncreaseTime) begin
                        greenTemp = greenTemp + 1; 
                        timeLane1 = greenTemp;
                        timeLane2 = greenTemp;
                        if(greenTemp > `MAX_TIME) begin
                            greenTemp = 1;
                            timeLane1 = greenTemp;
                            timeLane2 = greenTemp;                            
                        end
                    end
                    if(buttonDecreaseTime) begin
                        greenTemp = greenTemp - 1;
                        timeLane1 = greenTemp;
                        timeLane2 = greenTemp;                        
                        if(greenTemp == `MIN_TIME) begin
                            greenTemp = 99;
                            timeLane1 = greenTemp;
                            timeLane2 = greenTemp;                            
                        end
                    end
                    if(buttonConfirm) begin
                        if(redTemp > greenTemp && red_time_o > yellowTemp && redTemp == greenTemp + yellowTemp) begin
                            redTimeModified = redTemp;
                            greenTimeModified = greenTemp;
                            yellowTimeModified = yellowTemp;
                        end
                    end                    
                end
                YY: begin
                    if(buttonChangeLight) begin
                        state = RR;
                        timeLane1 = redTimeModified;
                        timeLane2 = redTimeModified;                        
                    end 
                    if(buttonIncreaseTime) begin
                        yellowTemp = yellowTemp + 1; 
                        timeLane1 = yellowTemp;
                        timeLane2 = yellowTemp;
                        if(yellowTemp > `MAX_TIME) begin
                            yellowTemp = 1;
                            timeLane1 = yellowTemp;
                            timeLane2 = yellowTemp;                            
                        end
                    end
                    if(buttonDecreaseTime) begin
                        yellowTemp = yellowTemp - 1;
                        timeLane1 = yellowTemp;
                        timeLane2 = yellowTemp;                        
                        if(yellowTemp == `MIN_TIME) begin
                            yellowTemp = 99;
                            timeLane1 = yellowTemp;
                            timeLane2 = yellowTemp;                            
                        end
                    end
                    if(buttonConfirm) begin
                        if(redTemp > greenTemp && red_time_o > yellowTemp && redTemp == greenTemp + yellowTemp) begin
                            redTimeModified = redTemp;
                            greenTimeModified = greenTemp;
                            yellowTimeModified = yellowTemp;
                        end
                    end                    
                end
                default: state <= RR;
            endcase
        end
    end

endmodule