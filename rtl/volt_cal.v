`timescale 1ns / 1ps
module volt_cal(
   input        ad_clk,                  //
	input [11:0] ad_ch1,              //AD��1ͨ��������
	output [19:0] ch1_dec,              //AD��1ͨ��������(ʮ����)
	output reg [7:0] ch1_sig               //AD��1ͨ�������������ַ�
    );
reg [31:0] ch1_data_reg;
reg [12:0] ch1_reg;
reg [31:0] ch1_vol;              //AD��1ͨ��������(16����)

//AD ��ѹ����
always @(posedge ad_clk)
begin
    if(ad_ch1[11]==1'b1) begin                     //����Ǹ���ѹ
	    ch1_reg<=12'hfff - ad_ch1 + 1'b1;
		 ch1_sig <= 45;                                //'-' asic��
	 end
	 else begin
       ch1_reg<=ad_ch1;
		 ch1_sig<=43;                                //'-' asic��
	 end	 
end 		 

//AD ��ѹ����(1 LSB = 5V / 2048 = 2.44mV
always @(posedge ad_clk)
begin
	ch1_data_reg<=ch1_reg * 5000;			
   ch1_vol<=ch1_data_reg >>11;

end	

//16����ת��Ϊʮ���Ƶ�  
bcd bcd1_ist(         
               .hex           (ch1_vol[15:0]),
					.dec           (ch1_dec),
					.clk           (ad_clk)
					);
endmodule


  