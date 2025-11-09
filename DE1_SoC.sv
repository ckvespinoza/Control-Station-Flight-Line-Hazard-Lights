module DE1_SoC (CLOCK_50, HEX0, HEX1, HEX2, HEX3, HEX4, HEX5, KEY, LEDR, SW);
	input logic CLOCK_50; // 50MHz clock.
	output logic [6:0] HEX0, HEX1, HEX2, HEX3, HEX4, HEX5;
	output logic [9:0] LEDR;
	input logic [3:0] KEY; // True when not pressed, False when pressed
	input logic [9:0] SW;

	assign HEX0 = ~7'b0000000;
	assign HEX1 = ~7'b0000000;
	assign HEX2 = ~7'b0000000;
	assign HEX3 = ~7'b0000000;
	assign HEX4 = ~7'b0000000;
	assign HEX5 = ~7'b0000000;
	
	// Generate clk off of CLOCK_50, whichClock picks rate.

	logic reset;

	logic [31:0] div_clk;

	assign reset = KEY[0];
	parameter whichClock = 25; // 0.75 Hz clock
	clock_divider cdiv (.clock(CLOCK_50),
	.reset(reset),
	.divided_clocks(div_clk));

	 // Clock selection: simulation or FPGA board
	 logic clkSelect;
	 //assign clkSelect = CLOCK_50;           // For simulation
	 assign clkSelect = div_clk[whichClock]; // For board

	 // Hazard lights FSM signals
	 logic [2:0] hazard_LEDR;

	 hazard_lights hl (.clk(clkSelect), .reset(~KEY[0]), .SW(SW[1:0]), .LEDR(hazard_LEDR));

	// Output logic (Moore FSM)
	always_comb begin
		case (hazard_LEDR)
			3'b000:  LEDR = 3'b101;
			3'b001:  LEDR = 3'b010;
			3'b010:  LEDR = 3'b001;
			3'b011:  LEDR = 3'b010;
			3'b100:  LEDR = 3'b100;
			3'b101:  LEDR = 3'b100;
			3'b110:  LEDR = 3'b010;
			3'b111:  LEDR = 3'b001;
			default: LEDR = 3'b000;
		endcase
	end
	 
	// Map FSM output to LEDR[2:0]
	//assign LEDR[2:0] = hazard_LEDR;

endmodule


module DE1_SoC_testbench();
	logic CLOCK_50;
	logic [6:0] HEX0, HEX1, HEX2, HEX3, HEX4, HEX5;
	logic [9:0] LEDR;
	logic [3:0] KEY;
	logic [9:0] SW;
	DE1_SoC dut (CLOCK_50, HEX0, HEX1, HEX2, HEX3, HEX4, HEX5, KEY, LEDR, SW);

	// Set up a simulated clock.
	parameter CLOCK_PERIOD=100;
	initial begin
		CLOCK_50 <= 0;
	
		// Forever toggle the clock
		forever #(CLOCK_PERIOD/2) CLOCK_50 <= ~CLOCK_50;
	end

	// Test the design. 
	initial begin
		SW[1:0]<= 2'b00;
		
		// Apply reset
		KEY[0] <= 0; repeat(2) @(posedge CLOCK_50);
		KEY[0] <= 1; repeat(2) @(posedge CLOCK_50);

		// Test calm: SW = 00
		SW[1:0] <= 2'b00; repeat(6) @(posedge CLOCK_50);

		// Test right-to-left: SW = 01
		SW[1:0] <= 2'b01; repeat(6) @(posedge CLOCK_50);

		// Test left-to-right: SW = 10
		SW[1:0] <= 2'b10; repeat(6) @(posedge CLOCK_50);

		// Return to calm
		SW[1:0] <= 2'b00; repeat(4) @(posedge CLOCK_50);

		$stop;
	end
endmodule
