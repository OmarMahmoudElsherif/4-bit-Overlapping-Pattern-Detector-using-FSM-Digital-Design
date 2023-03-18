/**************************************************************************************
 * 
 * Name: Omar Mahmoud Mohamed Khalil Elsherif
 *
 * assignment: pattern Detector
 *
************************************************************************************** 
*/
module pattern_detector(
	input clk,
	input rst,
	input stream_in,
	output reg pattern_found
);

//state register bits, here we have 6 states
parameter state_reg_width = 3 ;
parameter [state_reg_width-1: 0] stateA_1st_bit = 3'b000,
				 stateB_2nd_bit = 3'b001,
				 stateC_3rd_bit = 3'b010,
				 stateD_4th_bit = 3'b011,
				 stateE_5th_bit = 3'b100,
				 stateF_output  = 3'b101;

reg [state_reg_width-1:0] curr_state,next_state;

//State Register
always @(posedge clk) begin
	if(rst) begin
		$display("reset");
	    curr_state <= stateA_1st_bit;
	end
else begin
	$display("Next state");
	curr_state <= next_state;
end

end


// Next State Logic
always @(*) begin

case(curr_state)

stateA_1st_bit: begin
	if(stream_in==1) begin // 1xxxx 
		next_state=stateB_2nd_bit;	
	end	
	else
		next_state=stateA_1st_bit;
end

stateB_2nd_bit: begin
	if(stream_in==1) begin // 11xxx
		next_state=stateC_3rd_bit;
	end
	else
		next_state=stateA_1st_bit;
end


stateC_3rd_bit: begin
	if(stream_in==0) begin // 110xx
		next_state=stateD_4th_bit;
	end
	else
		next_state=stateB_2nd_bit;
end

stateD_4th_bit: begin
	if(stream_in==1)  begin // 1101x
		next_state=stateE_5th_bit;
	end 
	else
		next_state=stateA_1st_bit;
end

stateE_5th_bit: begin
	if(stream_in==0) begin  // 11010
		next_state=stateF_output;
	end
	else
		next_state=stateB_2nd_bit;
end

stateF_output: begin
	if(stream_in==0) begin // 11010-0
		next_state=stateA_1st_bit;
	end
	else		  // 11010-1
		next_state=stateB_2nd_bit;
end

endcase

end


// Output Logic
always @(*) begin
	//Output default values
pattern_found <= 0;

case(curr_state) 
stateF_output: begin
	pattern_found <= 1;
	$display("Pattern Found");
end
default:
	pattern_found <= 0;
endcase


end

endmodule





/****************************** Test Bench ******************************/
`timescale 10ps/10ps
module pattern_detector_tb();

reg clk = 0;
reg rst ;
reg stream_in;
wire pattern_found;

always #(5) clk=~clk;

pattern_detector dut (
	.clk(clk),
	.rst(rst),
	.stream_in(stream_in),
	.pattern_found(pattern_found)
	);


// Input Test Sequence
reg [7:0] stream_in_pattern = 8'b011_11010;
integer i;

initial begin

rst=1;
#10
rst=0;
// pattern 011 11010
for(i=7;i>=0;i=i-1) begin
	stream_in = stream_in_pattern[i];
	#10;
end



end




endmodule













