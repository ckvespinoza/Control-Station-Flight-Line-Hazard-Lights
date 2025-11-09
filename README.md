# Control-Station-Flight-Line-Hazard-Lights
Basic design for hazard lights that communicate the direction of wind through different patterns to landing pilots. #SystemVerilog

The landing lights at Sea-Tac are busted, so we have to come up with a new set. In order to show pilots the wind direction across the runways we will build special wind indicators to put at the ends of all runways at Sea-Tac. Your circuit will have two inputs (SW[0] and SW[1]) to indicate wind direction, and three lights to display the corresponding sequence of lights. It must also include a reset signal, enabled when KEY[0] is pressed (holding the button down keeps the system in reset).

<img width="279" height="227" alt="image" src="https://github.com/user-attachments/assets/4655a688-8bfa-4ec6-b5f8-acc884357988" />

For each situation, the lights should cycle through the given pattern. Thus, if the wind is calm, the lights will cycle between the outside lights lit, and the center light lit, over and over. The right to left and left to right crosswind indicators repeatedly cycle through three patterns each, which have the light “move” from right to left or left to right respectively. Your bonus goal is to develop the smallest circuit possible in terms of FPGA logic and DFF resources. To do this, perform a compilation of your design, and look at the Compilation Report. In the left hand column select Analysis & Synthesis > Resource Utilization by Entity. The “LC Combinationals” column lists the amount of FPGA logic elements being used, which are logic elements that can compute any Boolean combinational function of at most 6 inputs. The “LC Registers” is the number of DFFs used. For each entry there is the listing of the amount of resources used by that specific module (the number  in parentheses), and the amount of resources used by that specific module plus its submodules (the number outside the parentheses).


Project Design Requirements:
- The switches will never both be true
- The switches may change at any point in the pattern
- Your design must use RTL design with “if” and “case” statements
- The main FSM logic should be contained within a new file called hazard_lights.sv

You also need:
- A state diagram of your solution
- A screenshot of the “Resource Utilization by Entity” report for your design and
the calculated size of the FSM you created.
