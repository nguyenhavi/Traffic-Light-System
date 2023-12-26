module decodeState(
    input[2:0] state,
    output reg[2:0] led1,
    output reg[2:0] led2
);  
    // Bit order of led1 and led2 is G-Y-R
    parameter RR = 0;
    parameter GG = 1;
    parameter YY = 2;
    parameter GR = 3;
    parameter YR = 4;
    parameter RG = 5;
    parameter RY = 6;

    always@(state) begin
        case(state)
            RR: begin
                led1 = 3'b001;
                led2 = 3'b001;
            end
            GG: begin
                led1 = 3'b100;
                led2 = 3'b100;
            end
            YY: begin
                led1 = 3'b010;
                led2 = 3'b010;
            end
            GR: begin
                led1 = 3'b100;
                led2 = 3'b001;
            end
            YR: begin
                led1 = 3'b010;
                led2 = 3'b001;
            end
            RG: begin
                led1 = 3'b001;
                led2 = 3'b100;
            end
            RY: begin
                led1 = 3'b001;
                led2 = 3'b010;
            end
        endcase
    end
endmodule