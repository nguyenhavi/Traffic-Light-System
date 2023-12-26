module mannualMode(
    input clk,
    input reset,
    input[2:0] enable,
    input buttonChangeLight,
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

    reg[6:0] tempYellowTime;
    
    always@(enable) begin
        if(enable == 3'b001) begin
            tempYellowTime = yellowTime;
            state = GR;    
            timeLane1 = 7'b1111111;
            timeLane2 = 7'b1111111;
        end
    end

    always@(posedge clk or posedge buttonChangeLight) begin
        if(enable == 3'b001) begin
            case (state)
                GR: begin
                    if(buttonChangeLight == 1) state <= YR;
                end
                YR: begin
                    if(tempYellowTime == 1) begin
                        tempYellowTime <= yellowTime;
                        state <= RG;
                    end else tempYellowTime <= tempYellowTime - 1;
                end
                RG: begin
                    if(buttonChangeLight == 1) state <= RY;
                end
                RY: begin
                    if(tempYellowTime == 1) begin
                        tempYellowTime <= yellowTime;
                        state <= GR;
                    end else tempYellowTime <= tempYellowTime - 1;
                end
                default: state <= GR;                
            endcase
        end
    end

endmodule