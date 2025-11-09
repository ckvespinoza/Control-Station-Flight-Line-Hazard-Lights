module hazard_lights (
    input logic clk,
    input logic reset,
    input logic [1:0] SW,
    output logic [2:0] LEDR
);

    // State encoding
	typedef enum logic [2:0] {
		 CALM1  = 3'b000,
		 CALM2  = 3'b001,
		 RTL1   = 3'b010,
		 RTL2   = 3'b011,
		 RTL3   = 3'b100,
		 LTR1   = 3'b101,
		 LTR2   = 3'b110,
		 LTR3   = 3'b111
	} state_t;

    state_t ps, ns;

    // Next state logic
	always_comb begin
		 case (ps)
			  CALM1: begin
					if (SW == 2'b00 || SW == 2'b11) 			//no change to input
						 ns = CALM2; 			//move to next pattern in calm
					else if (SW == 2'b01) 	//input changes to R2L
						 ns = RTL1; 			//move to first pattern in R2L
					else 							// SW == 2'b10 or L2R since there is no 11
						 ns = LTR1;
			  end

			  CALM2: begin
					if (SW == 2'b00 || SW == 2'b11) 			//no change to input
						 ns = CALM1; 			//move to next pattern in calm
					else if (SW == 2'b01) 	//input changes to R2L
						 ns = RTL1; 			//move to first pattern in R2L
					else 							// SW == 2'b10 or L2R since there is no 11
						 ns = LTR1;
			  end

			  RTL1: begin
					if (SW == 2'b01 || SW == 2'b11) 			//no change to input
						 ns = RTL2; 			//move to next pattern in R2L
					else if (SW == 2'b00) 	//input changes to CALM
						 ns = CALM1; 			//move to first pattern in CALM
					else 							// SW == 2'b10 or L2R since there is no 11
						 ns = LTR1;
			  end

			  RTL2: begin
					if (SW == 2'b01 || SW == 2'b11) 			//no change to input
						 ns = RTL3; 			//move to next pattern in R2L
					else if (SW == 2'b00) 	//input changes to CALM
						 ns = CALM1; 			//move to first pattern in CALM
					else 							// SW == 2'b10 or L2R since there is no 11
						 ns = LTR1;
			  end

			  RTL3: begin
					if (SW == 2'b01 || SW == 2'b11) 			//no change to input
						 ns = RTL1; 			//move to next pattern in R2L
					else if (SW == 2'b00) 	//input changes to CALM
						 ns = CALM1; 			//move to first pattern in CALM
					else 							// SW == 2'b10 or L2R since there is no 11
						 ns = LTR1;
			  end

			  LTR1: begin
					if (SW == 2'b10 || SW == 2'b11) 			//no change to input
						 ns = LTR2; 			//move to next pattern in L2R
					else if (SW == 2'b00) 	//input changes to CALM
						 ns = CALM1; 			//move to first pattern in CALM
					else 							// SW == 2'b01 or R2L since there is no 11
						 ns = RTL1;
			  end

			  LTR2: begin
					if (SW == 2'b10 || SW == 2'b11) 			//no change to input
						 ns = LTR3; 			//move to next pattern in L2R
					else if (SW == 2'b00) 	//input changes to CALM
						 ns = CALM1; 			//move to first pattern in CALM
					else 							// SW == 2'b01 or R2L since there is no 11
						 ns = RTL1;
			  end

			  LTR3: begin
					if (SW == 2'b10 || SW == 2'b11) 			//no change to input
						 ns = LTR1; 			//move to next pattern in L2R
					else if (SW == 2'b00) 	//input changes to CALM
						 ns = CALM1; 			//move to first pattern in CALM
					else 							// SW == 2'b01 or R2L since there is no 11
						 ns = RTL1;
			  end

			  default: ns = CALM1;
		 endcase
	end

    // Sequential logic
    always_ff @(posedge clk or posedge reset) begin
        if (reset)
            ps <= CALM1;					//if reset is true then go to CALM1
        else
            ps <= ns;						//otherwise ns becomes ps
    end

    // Output logic (Moore FSM)
    assign LEDR = ps;

endmodule