module clkDivider(input clk, output clkOut);
    reg[25:0] counter = 0;
    parameter DIVISOR = 125_000_000;
    always@(posedge clk) begin
        counter <= counter + 1;
        if(counter == DIVISOR - 1) counter <= 0;
        clkOut <= (counter < DIVISOR / 2) ? 1'b1 : 1'b0;
    end
endmodule