`include "define.v"

module main(
    input clk,  // Input clock frequency is 125MHz
    input reset,
    input buttonChangeMode, // This button only use for change mode
    input buttonConfig, // This button use for switch between Auto mode and setting
    input buttonChangeLight, // This button use for change light in config and mannual mode 
    input buttonIncreaseTime, // This button only use for increase time in config mode
    input buttonDecreaseTime, // This button only use for decrease time in config mode
    input buttonConfirm, // This button only use for save configuration in config mode
    output[6:0] led7_1,
    output[6:0] led7_2,
    output[6:0] led7_3,
    output[6:0] led7_4,
    output[2:0] led1,
    output[2:0] led2
);
    reg[2:0] enable;
    /*
        Enable 100 means traffic system in auto mode
        Enable 010 means traffic system in config mode
        Enable 001 means traffic system in manual mode
    */
    
    parameter autoMode = 3'b100;
    parameter configMode = 3'b010;
    parameter mannualMode = 3'b001;
    
    wire[2:0] stateAuto;
    wire[2:0] stateMannual;
    wire[2:0] stateConfig;
    wire[2:0] state;
  /* 
    The state output for each module below 
    has 7 states including: RR, GG, YY, RG, RY, GR, YR
    - Auto Mode will have 4 per 7 states of these states (RG, RY, GR, YR)
    - Mannual Mode will have 4 states as Auto Mode
    - Config Mode will have 3 per 7 states of these states (RR, GG, YY)
  */    
    
    reg[6:0] greenTime = `GREEN_TIME_DEFAULT;
    reg[6:0] redTime = `RED_TIME_DEFAULT;
    reg[6:0] yellowTime = `YELLOW_TIME_DEFAULT;
    
    wire[6:0] redTimeModified;
    wire[6:0] greenTimeModified;
    wire[6:0] yellowTimeModified;
    
    wire[6:0] timeLane1;
    wire[6:0] timeLane1Auto;
    wire[6:0] timeLane1Mannual;
    wire[6:0] timeLane1Config;
    wire[6:0] timeLane2;
    wire[6:0] timeLane2Auto;
    wire[6:0] timeLane2Mannual;  
    wire[6:0] timeLane2Config;  
    //These two timelanes is pass to sevenSegmentDisplay module
    
    always@(posedge buttonConfirm) begin
        #1; // Wait for 1 clock cycle because signals is not update immediately 
        greenTime <= greenTimeModified;
        redTime <= redTimeModified;
        yellowTime <= yellowTimeModified;
    end
    
    always@(posedge reset) begin
        if(reset) begin
            enable <= autoMode;
        end
    end
    
    always@(posedge buttonChangeMode or posedge buttonConfig) begin
        case(enable)
            autoMode: begin 
                if(buttonChangeMode == 1) enable <= mannualMode;
                else if (buttonConfig == 1) enable <= configMode;
            end 
            mannualMode: begin
                if(buttonChangeMode == 1) enable <= autoMode;
            end
            configMode: begin
                if(buttonConfig == 1) enable <= autoMode;
            end
        endcase
    end
    
    wire clkOut;
    
    decodeState decode(state, led1, led2);
    sevenSegmentDisplay display7Led1(timeLane1, led7_1, led7_2);
    sevenSegmentDisplay display7Led2(timeLane2, led7_3, led7_4);
    clkDivider clkDiv(clk, clkOut);
    
    assign state     = enable == autoMode    ? stateAuto :
                       enable == mannualMode ? stateMannual : 
                                               stateConfig;
    assign timeLane1 = enable == autoMode    ? timeLane1Auto :
                       enable == mannualMode ? timeLane1Mannual : 
                                               timeLane1Config;
    assign timeLane2 = enable == autoMode    ? timeLane2Auto : 
                       enable == mannualMode ? timeLane2Mannual : 
                                               timeLane2Config;

    autoMode auto(
        .clk(clkOut),
        .reset(reset),
        .enable(enable[2]),
        .greenTime(greenTime),
        .yellowTime(yellowTime),
        .redTime(redTime),
        .timeLane1(timeLane1Auto),
        .timeLane2(timeLane2Auto),
        .state(stateAuto) 
    );
    
    mannualMode mannual(
        .clk(clkOut),
        .reset(reset),
        .enable(enable[0]),
        .buttonChangeLight(buttonChangeLight),
        .greenTime(greenTime),
        .yellowTime(yellowTime),
        .redTime(redTime),    
        .timeLane1(timeLane1Mannual),
        .timeLane2(timeLane2Mannual),
        .state(stateMannual)
    );
    
    configMode configuration(
        .clk(clkOut),
        .reset(reset),
        .enable(enable[1]),
        .buttonChangeLight(buttonChangeLight),
        .buttonIncreaseTime(buttonIncreaseTime),
        .buttonDecreaseTime(buttonDecreaseTime),
        .buttonConfirm(buttonConfirm),
        .greenTime(greenTime),
        .yellowTime(yellowTime),
        .redTime(redTime),
        .greenTimeModified(greenTimeModified),
        .yellowTimeModified(yellowTimeModified),
        .redTimeModified(redTimeModified),
        .timeLane1(timeLane1Config),
        .timeLane2(timeLane2Config),
        .state(stateConfig) 
    );
endmodule
