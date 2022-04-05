`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Description: This module receives a 16 bit binary value and converts it to 
// a packed binary coded decimal (BCD).
//
//The output consists of 4 BCD digits as follows:
//BCDOUT[15:12]	- Thousands place
//BCDOUT[11:8]	- Hundreds place
//BCDOUT[7:4]		- Tens place
//BCDOUT[3:0]		- Ones place
//////////////////////////////////////////////////////////////////////////////////
module Binary_To_BCD(
			Clock,
			Reset,
			Start,
			Binary,
			Out
	);
	input Clock;
	input Reset;
	input Start;
	input [15:0] Binary;
	output [15:0] Out;
			
	reg [15:0] Out = 16'h0000;	
	reg [4:0] shiftCount = 5'd0;
	reg [31:0] tmpSR;
	parameter [2:0] Idle = 3'b000,
					Init = 3'b001,
					Shift = 3'b011,
					Check = 3'b010,
					Done = 3'b110;
    reg [2:0] STATE = Idle;

			always @(posedge Clock) begin
					if(Reset == 1'b1) begin
							Out <= 16'h0000;
							tmpSR <= 31'h00000000;
							STATE <= Idle;
					        end
					else begin
							case (STATE)
									Idle : begin
											Out <= Out;							 	
											tmpSR <= 32'h00000000;
											if(Start == 1'b1) begin
													STATE <= Init;
											                  end
											else begin
													STATE <= Idle;
											     end
									       end
									Init : begin
											Out <= Out;	
											tmpSR <= {16'b0000000000000000, Binary};
											STATE <= Shift;
									       end
									Shift : begin
											Out <= Out;		
											tmpSR <= {tmpSR[30:0], 1'b0};	
											shiftCount <= shiftCount + 1'b1;	
											STATE <= Check;		
									        end
									Check : begin
											Out <= Out;							
											if(shiftCount != 5'd16) begin
													if(tmpSR[31:28] >= 3'd5) begin
															tmpSR[31:28] <= tmpSR[31:28] + 2'd3;
													                         end
													if(tmpSR[27:24] >= 3'd5) begin
															tmpSR[27:24] <= tmpSR[27:24] + 2'd3;
													                         end
													if(tmpSR[23:20] >= 3'd5) begin
															tmpSR[23:20] <= tmpSR[23:20] + 2'd3;
													                         end
													if(tmpSR[19:16] >= 3'd5) begin
															tmpSR[19:16] <= tmpSR[19:16] + 2'd3;
													                         end
													STATE <= Shift;
											                         end
											else begin
													STATE <= Done;
											     end											
									        end
									Done : begin								
											Out <= tmpSR[31:16];	
											tmpSR <= 32'h00000000;
											shiftCount <= 5'b00000;
											STATE <= Idle;
									       end
							endcase
					end
			end
endmodule