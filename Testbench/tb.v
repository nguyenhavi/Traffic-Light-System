module tb;

    reg clk;
    reg reset;
    reg buttonChangeMode; // This button only use for change mode
    reg buttonConfig;   // This button use for switch between Auto mode and setting
    reg buttonChangeLight; // This button use for change light in config and mannual mode 
    reg buttonIncreaseTime; // This button only use for increase time in config mode
    reg buttonDecreaseTime; // This button only use for decrease time in config mode
    reg buttonConfirm; // This button only use for save configuration in config mode
    wire[6:0] led7_1;
    wire[6:0] led7_2;
    wire[6:0] led7_3;
    wire[6:0] led7_4;
    wire[2:0] led1;
    wire[2:0] led2;

main dut(clk, reset, buttonChangeMode, buttonConfig, buttonChangeLight, buttonIncreaseTime, buttonDecreaseTime, buttonConfirm, led7_1, led7_2, led7_3, led7_4, led1, led2);

initial begin
    clk = 0;
    reset = 1;
    buttonChangeMode = 0;
    buttonConfig = 0;
    buttonChangeLight = 0;
    buttonIncreaseTime = 0;
    buttonDecreaseTime = 0;
    buttonConfirm = 0;
end

always #10 clk = ~clk;

initial begin
    #15; reset = 0;
    #50; buttonIncreaseTime = 1;
    #2; buttonIncreaseTime = 0;
    #100; buttonChangeLight = 1;
    #2; buttonChangeLight = 0;
    #50; buttonIncreaseTime = 1;
    #2; buttonIncreaseTime = 0;
    #50; buttonConfirm = 1;
    #2; buttonConfirm = 0;
    #50; buttonConfig = 1;
    #2; buttonConfig = 0;
    #100; $finish;
end

endmodule