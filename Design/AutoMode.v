module autoMode(
    input clk,
    input reset,
    input[2:0] enable,
    input[6:0] greenTime,
    input[6:0] yellowTime,
    input[6:0] redTime,
    output reg[6:0] timeLane1,
    output reg[6:0] timeLane2,
    output reg[2:0] state 
);
    
    parameter GR = 3;
    parameter YR = 4;
    parameter RG = 5;
    parameter RY = 6;    
    
    always @(enable) begin
        if(enable == 3'b100) begin
            state = GR;
            timeLane1 = greenTime;
            timeLane2 = redTime;     
        end

    end
    
    always @(posedge clk) begin
        if (enable == 3'b100) begin
            case (state)
                GR: begin
                    if (timeLane1 == 1) begin
                        state <= YR;
                        timeLane1 <= yellowTime;
                    end else begin
                        timeLane1 <= timeLane1 - 1;
                    end 
                    timeLane2 <= timeLane2 - 1;
                end
                YR: begin
                    if (timeLane1 == 1) begin
                        state <= RG;
                        timeLane2 <= greenTime;
                        timeLane1 <= redTime;
                    end else begin
                        timeLane1 <= timeLane1 - 1;
                        timeLane2 <= timeLane2 - 1;
                    end
                end
                RG: begin
                    if (timeLane2 == 1) begin
                        state <= RY;
                        timeLane2 <= yellowTime;
                    end else begin
                        timeLane2 <= timeLane2 - 1;                    
                    end 
                    timeLane1 <= timeLane1 - 1;
                end
                RY: begin
                    if (timeLane2 == 1) begin
                        state <= GR;
                        timeLane1 <= greenTime;
                        timeLane2 <= redTime;
                    end else begin
                        timeLane2 <= timeLane2 - 1; 
                        timeLane1 <= timeLane1 - 1;
                    end
                end
                default: state <= GR;
            endcase
        end
    end
endmodule