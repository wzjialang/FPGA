`timescale 1ns / 1ps
module ad(
          input ad_clk,
			 input [11:0] ad1_in,
			 output reg [11:0] ad_ch1
			);

always @(posedge ad_clk)
begin            
    ad_ch1[11] <= ad1_in[0];  
    ad_ch1[10] <= ad1_in[1];  
    ad_ch1[9] <= ad1_in[2];  
    ad_ch1[8] <= ad1_in[3];  
    ad_ch1[7] <= ad1_in[4];  
    ad_ch1[6] <= ad1_in[5];  
    ad_ch1[5] <= ad1_in[6];  
    ad_ch1[4] <= ad1_in[7];  
    ad_ch1[3] <= ad1_in[8];  
    ad_ch1[2] <= ad1_in[9];  
    ad_ch1[1] <= ad1_in[10];  
    ad_ch1[0] <= ad1_in[11];	  
end 
endmodule
