module top(
  input [3:0] add_in1, add_in2,
  input [3:0] mul_in1, mul_in2,
  input [3:0] sub_in1, sub_in2,
  input clk, rst,
  output [4:0] add_out,
  output [7:0] mul_out,
  output [4:0] sub_out
);
  
  adder adder_inst (add_in1, add_in2, clk, rst, add_out);
  mul   mul_inst   (mul_in1, mul_in2, clk, rst, mul_out);
  sub   sub_inst   (sub_in1, sub_in2, clk, rst, sub_out);


endmodule

//                            4-bit adder
module adder (input [3:0] add_in1,add_in2,input clk, rst, output reg [4:0] add_out
             );
  
  always@(posedge clk)
    begin
      if(rst)
        begin
          add_out <= 5'b00000; 
        end
      else
        begin
          add_out <= add_in1 + add_in2;
        end
    end
endmodule

//---------------------------- 4 bit  Mul

module mul (input [3:0] mul_in1,mul_in2, input clk, rst, output reg [7:0] mul_out
             );
  
  always@(posedge clk)
    begin
      if(rst)
        begin
          mul_out <= 5'b00000; 
        end
      else
        begin
          mul_out <= mul_in1 * mul_in2;
        end
    end
endmodule
//--------------------------4 bit  Sub
module sub(input [3 :0] sub_in1, sub_in2, input clk,rst , output reg [7 :0 ] sub_out);

   always@(posedge clk)
    begin
      if(rst)
        begin
          sub_out <= 5'b00000; 
        end
      else
        begin
          sub_out <= {1'b0, sub_in1} - {1'b0, sub_in2}; // 5-bit subtraction

        end
    end

  
endmodule

//                    Interface 
interface add_if;
  logic [3:0] add_in1,add_in2;
  logic clk, rst;
  logic [4:0] add_out;
endinterface

interface mul_if;
  logic [3:0] mul_in1,mul_in2;
  logic clk, rst;
  logic [7:0] mul_out;
endinterface

interface sub_if;
  logic  signed [3 :0] sub_in1 , sub_in2;
  logic clk,rst;
  logic  signed [4:0] sub_out;  
endinterface


