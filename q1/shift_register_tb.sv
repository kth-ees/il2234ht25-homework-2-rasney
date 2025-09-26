`timescale 1ns/1ps
module shift_register_tb;

    // Parameter
    localparam N = 4;

    // Signals
    logic [N-1:0] parallel_in;
    logic [N-1:0] parallel_out;
    logic clk;
    logic rst_n;
    logic serial_parallel;
    logic load_enable;
    logic serial_in;
    logic serial_out;

    // Instantiate DUT
    shift_register #(.N(N)) UUT (
        .clk(clk),
        .rst_n(rst_n),
        .serial_parallel(serial_parallel),
        .load_enable(load_enable),
        .serial_in(serial_in),
        .parallel_in(parallel_in),
        .parallel_out(parallel_out),
        .serial_out(serial_out)
    );

    // Clock generation
    initial clk = 0;
    always #5 clk = ~clk; // 10ns period

    // Test procedure
    initial begin
        logic [N-1:0] hold_value;
        logic [N-1:0] serial_data;

        // Initialize
        rst_n = 0;
        load_enable = 0;
        serial_in = 0;
        parallel_in = '0;

        // Release reset after some time
        #12 rst_n = 1;

        // ==============================
        // Test 1: Parallel load
        // ==============================
        #10;
        serial_parallel = 1'b1;
        parallel_in = 4'b1001;
        load_enable = 1'b1;
        #10;                 // wait one clock edge
        load_enable = 1'b0;
        $display("After parallel load: parallel_out = %b, serial_out = %b", parallel_out, serial_out);

        // ==============================
        // Test 2: Serial load
        // ==============================
        #10;
        serial_parallel = 1'b0;
        serial_data = 4'b1101;  // LSB first
        load_enable = 1'b1;
        for (int i = 0; i < N; i++) begin
            serial_in = serial_data[i];
            #10; // one clock per bit
        end
        load_enable = 1'b0;
        $display("After serial load: parallel_out = %b, serial_out = %b", parallel_out, serial_out);

        // ==============================
        // Test 3: Hold (load_enable=0)
        // ==============================
        hold_value = parallel_out;
        serial_in = ~serial_in; // change input
        #20;
        if (parallel_out !== hold_value)
            $display("? Hold test failed! parallel_out = %b", parallel_out);
        else
            $display("? Hold test passed! parallel_out = %b", parallel_out);

        $finish;
    end

endmodule
