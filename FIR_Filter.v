module FIR_Filter #( parameter N1 = 8,
					 parameter N2 = 16,
					 parameter N3 = 32)
(

	input wire CLK,RST,
	input wire signed [N2-1:0] input_data,
	input wire Enable,
	output wire signed [N3-1:0] output_data,
	output wire signed [N2-1:0] sampleT
);

reg  signed [N3-1:0] out_data_reg; //to store the output_data
reg  signed [N2-1:0] samples [0:6]; // to store the input and shift the data to achive the equation of the filter 

wire signed [N1-1:0] coef[0:7] ; // the out will be signed num may be -ve or +ve

// now we will assign filter coef , we will make it symetric to get a HPF.

assign coef[0] = 8'b00010000;
assign coef[1] = 8'b00010000;
assign coef[2] = 8'b00010000;
assign coef[3] = 8'b00010000;
assign coef[4] = 8'b00010000;
assign coef[5] = 8'b00010000;
assign coef[6] = 8'b00010000;
assign coef[7] = 8'b00010000;

always @(posedge CLK or negedge RST) 
begin
	if (!RST) 
	begin
		samples [0] <= 0;
		samples [1] <= 0;
		samples [2] <= 0;
		samples [3] <= 0;
		samples [4] <= 0;
		samples [5] <= 0;
		samples [6] <= 0;
		out_data_reg <= 32'b0;
		
	end
	else if (Enable) 
	begin
		out_data_reg <= coef[0]*input_data+
						coef[1]*samples[0]+
						coef[2]*samples[1]+
						coef[3]*samples[2]+
						coef[4]*samples[3]+
						coef[5]*samples[4]+
						coef[6]*samples[5]+
						coef[7]*samples[6] ;

						samples[0] <= input_data;
						samples[1] <= samples[0];
						samples[2] <= samples[1];
						samples[3] <= samples[2];
						samples[4] <= samples[3];
						samples[5] <= samples[4];
						samples[6] <= samples[5];
	end
end

assign output_data = out_data_reg ; 
assign sampleT = samples[0]; // this just to check on the shift operation
endmodule 


