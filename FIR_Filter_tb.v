`timescale 1ns/1ps
module FIR_Filter_tb ();

parameter Clock_PERIOD = 20.0;
parameter N1 = 8;
parameter N2 = 16;
parameter N3 = 32;

//////////////////// DUT Signals ////////////////////////
reg CLK_tb,RST_tb;
reg signed [N2-1:0] input_data_tb;
reg Enable_tb;
reg [N2-1:0] data [99:0];
wire signed [N3-1:0] output_data_tb;
wire signed [N2-1:0] sampleT_tb;

integer k,FILE1;



////////////////// Clock Generator  ////////////////////
always #(Clock_PERIOD/2) CLK_tb = ~CLK_tb;

/////////////////// DUT Instantiation ///////////////////

FIR_Filter DUT (

.CLK(CLK_tb),
.RST(RST_tb),
.input_data(input_data_tb),
.Enable(Enable_tb),
.output_data(output_data_tb),
.sampleT(sampleT_tb)
	);

////////////////// initial block ///////////////////////

initial 
begin
    $readmemb("input.data",data); // to read the input data from the file from bython
 	FILE1 = $fopen("save.data","w"); // to store the output of the filter "the filtered data"
    $dumpfile("FIR_Filter_DUMP.vcd");
    $dumpvars;

    initialize();
    reset();
    filter();
    #50;
    $stop;

end 

/////////////////////// TASKS //////////////////////////

task initialize;
begin
	CLK_tb = 1'b0;
	input_data_tb = 'b0;
	Enable_tb = 1'b0;
	#(Clock_PERIOD);
end
endtask
///////////////////////////////////
task reset;
begin
    RST_tb = 1'b1;
    #(Clock_PERIOD);
    RST_tb = 1'b0;  
    #(Clock_PERIOD);
    RST_tb = 1'b1;  
end
endtask   
//////////////////////////////////
task filter;
begin
Enable_tb = 1'b1;
input_data_tb = data[0]; 
#(Clock_PERIOD);
for(k=1; k<100; k=k+1)
begin
	$fwrite (FILE1,"%b\n",output_data_tb); //to store the output date in the "save.data" file
	input_data_tb = data[k];
	if (k==99) 
	begin
	$fclose(FILE1); 	
	end 
	#(Clock_PERIOD);
end
end
endtask
//////////////////////////////////
endmodule 