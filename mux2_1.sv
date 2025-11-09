module mux2_1(out, i0, i1, sel); 			//define all the inputs and outputs of 2 to 1 mux
	output logic out;								//define the output
	input logic i0, i1, sel;					//define the input
	
	assign out = (i1 & sel) | (i0 & ~sel); //output = (input1 AND select) OR (input2 AND not select)
endmodule

module mux2_1_testbench();						//test module that will helpcheck if desing is correct
	logic i0, i1, sel;
	logic out;
	
	mux2_1 dut (.out, .i0, .i1, .sel);
	
	initial begin
			sel=0; i0=0; i1=0; #10;
			sel=0; i0=0; i1=1; #10;
			sel=0; i0=1; i1=0; #10;
			sel=0; i0=1; i1=1; #10;
			sel=1; i0=0; i1=0; #10;
			sel=1; i0=0; i1=1; #10;
			sel=1; i0=1; i1=0; #10;
			sel=1; i0=1; i1=1; #10;
	end
endmodule
