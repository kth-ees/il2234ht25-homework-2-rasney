module shift_register #(parameter N=4)
(
    input  logic clk,
    input  logic rst_n,
    input  logic serial_parallel, // 0 = serial, 1 = parallel
    input  logic load_enable,     // enable loading
    input  logic serial_in,
    input  logic [N-1:0] parallel_in,
    output logic [N-1:0] parallel_out,
    output logic serial_out
);

    // Internal register
    logic [N-1:0] q;

    // Sequential logic
    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            q <= '0;                // asynchronous reset
        else if (load_enable) begin
            if (serial_parallel)
                q <= parallel_in;   // parallel load
            else
                q <= {q[N-2:0], serial_in}; // serial left shift, serial_in at LSB
        end
    end

    // Outputs
    assign parallel_out = q;
    assign serial_out   = q[N-1]; // MSB as serial output

endmodule
