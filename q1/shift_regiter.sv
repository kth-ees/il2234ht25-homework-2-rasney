module shift_register #(parameter N=4)
(input logic clk,
input logic rst_n,
input logic serial_parallel,
input logic load_enable,
input logic serial_in,
input logic [N-1:0] parallel_in,
output logic [N-1:0] parallel_out,
output logic serial_out);
//complete here
logic q [N-1:0];// initial new inside register
always_ff @(posedge clk or negedge rst_n) begin
    if (!rst_n)
    q<= '0; // all bit in q turns to 0
    serial_out=0;
    else if(load_enable) begin
        if(serial_parallel) begin //parallel
          q<=parallel_in ;
        end
        else begin //serial
           serial_out<={q[N-2,0],serial_in};
           //serial load: shift left and insert serial_in at LSB
        end
    end
end

assign parallel_out=q;
assign serial_out=q[N-1];//the last bit is the serial output

endmodule
