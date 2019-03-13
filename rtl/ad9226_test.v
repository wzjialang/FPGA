`timescale 1ns / 1ps
module ad9226_test(
				input clk50m, 
				input reset_n,
	         input rx,                   //uart rx
            output tx,                  //uart tx 			
				input [11:0] ad1_in,
				output ad1_clk

    );
assign ad1_clk=clk50m;
wire [11:0] ad_ch1;
wire [7:0] ch1_sig;
wire [19:0] ch1_dec;
wire [27:0] rdata;
wire valid;

/*����ʱ��96000bps����*/
clkdiv u0(
    .clk50(clk50m), 
    .clkout(rd_clk)
    );
	 
/****************AD��������**************/
ad u1 (
		.ad_clk                     (clk50m),                           
		.ad1_in                     (ad1_in),             //ad1 input
      .ad_ch1                     (ad_ch1)             //ad1 data 12bit

 );

/**********ADʮ������תʮ����***********/
volt_cal u2(
		.ad_clk           		 (clk50m),	
		.ad_ch1            		 (ad_ch1),           //ad1 data 12bit
	
		.ch1_dec                 (ch1_dec),         //ad1 BCD voltage
	
		.ch1_sig                 (ch1_sig)         //ch1 ad ����
	
    );
	 
/*FIFO*/
FIFO_top instance_name (
    .wr_clk(clk50m), 
    .rd_clk(rd_clk), 
    .rst_n(reset_n), 
    .ch1_dec(ch1_dec), 
    .ch1_sig(ch1_sig), 
    .rdata(rdata), 
    .valid(valid)
    );
	 
/**********AD����Uart���ڷ��ͳ���***********/
uart u3(
    .clk50(clk50m), 
    .reset_n(reset_n), 
    .rdata(rdata),
    .ack(valid), 
    .tx(tx)
    );
endmodule
