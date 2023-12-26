module sevenSegmentDisplay(input[6:0] dataIn, output[6:0] dataOut1, output[6:0] dataOut2);

    parameter NONE = 7'b111_1111;   // Don't display
    parameter ZERO = 7'b000_0001;   // Display "0"
    parameter ONE = 7'b100_1111;    // Display "1"
    parameter TWO = 7'b001_0010;    // Display "2"
    parameter THREE = 7'b000_0110;  // Display "3"
    parameter FOUR = 7'b100_1100;   // Display "4"
    parameter FIVE = 7'b010_0100;   // Display "5"
    parameter SIX = 7'b010_0000;    // Display "6"
    parameter SEVEN = 7'b000_1111;  // Display "7"
    parameter EIGHT = 7'b000_0000;  // Display "8"
    parameter NINE = 7'b000_0100;   // Display "0"
    
    reg [6:0] led_1; // This is register for led 7segment correspondingly the unit value
    reg [6:0] led_2; // This is register for led 7segment correspondingly the tens value
    
    wire [3:0] temp[1:0]; // This is a parameter value to get the unit and tens value
    
    assign temp[0] = dataIn == 7'b1111111 ? 10 : dataIn % 10; //Get the unit value
    assign temp[1] = dataIn == 7'b1111111 ? 10 : dataIn / 10; // Get the tens value
    
    always@(dataIn)
        begin
                case(temp[0])
                    4'd0: led_1 <= ZERO;
                    4'd1: led_1 <= ONE;
                    4'd2: led_1 <= TWO;
                    4'd3: led_1 <= THREE;
                    4'd4: led_1 <= FOUR;
                    4'd5: led_1 <= FIVE;
                    4'd6: led_1 <= SIX;
                    4'd7: led_1 <= SEVEN;
                    4'd8: led_1 <= EIGHT;
                    4'd9: led_1 <= NINE;
                    default: led_1 <= NONE;
                endcase
                case(temp[1])
                    4'd0: led_2 <= ZERO;
                    4'd1: led_2 <= ONE;
                    4'd2: led_2 <= TWO;
                    4'd3: led_2 <= THREE;
                    4'd4: led_2 <= FOUR;
                    4'd5: led_2 <= FIVE;
                    4'd6: led_2 <= SIX;
                    4'd7: led_2 <= SEVEN;
                    4'd8: led_2 <= EIGHT;
                    4'd9: led_2 <= NINE;
                    default: led_2 <= NONE;
                endcase
            end
        
        assign dataOut1 = led_1;
        assign dataOut2 = led_2;    
        
endmodule