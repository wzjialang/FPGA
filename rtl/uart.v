`timescale 1ns / 1ps
module uart(
           input clk50,                     //50Mhz clock
			  input reset_n,
			  input [27:0] rdata,
			  input ack,
           output tx			  
    );

/********************************************/
//�洢�����͵Ĵ�����Ϣ
/********************************************/
reg [7:0] uart_ad [12:0];                        //�洢�����ַ�
always @(clk)
begin     //���巢�͵��ַ�
   if(uart_stat==3'b000) begin
		 uart_ad[0]<=65;                           //�洢�ַ� A 
		 uart_ad[1]<=68;                           //�洢�ַ� D
		 uart_ad[2]<=49;                           //�洢�ַ� 1
		 uart_ad[3]<=58;                           //�洢�ַ� : 
		 uart_ad[4]<=rdata[27:20];                      //�洢�ַ� ����   	 
		 uart_ad[5]<=rdata[15:12] + 48;          //�洢�ַ� ��λ                          
		 uart_ad[6]<=46;                           //�洢�ַ� . 
		 uart_ad[7]<=rdata[11:8] + 48;           //�洢�ַ� С�����һλ
		 uart_ad[8]<=rdata[7:4] + 48;            //�洢�ַ� С������λ
		 uart_ad[9]<=rdata[3:0] + 48;            //�洢�ַ� С�������λ
		 uart_ad[10]<=86;                          //�洢�ַ� V
		 uart_ad[11]<=10;                          //���з�
		 uart_ad[12]<=13;                          //�س���
	end	 
end 

/********************************************/
//���ڷ���ʱ���ַ���
/********************************************/
reg [15:0] uart_cnt;
reg [2:0] uart_stat;

reg  [7:0]  txdata;             //���ڷ����ַ�
reg         wrsig;               //���ڷ�����Ч�ź�

reg [8:0] k;

reg [15:0] Time_wait;                  

always @(posedge clk )
begin
  if(!reset_n) begin   
		uart_cnt<=0;
		uart_stat<=3'b000;	
		k<=0;
  end
  else begin
  	 case(uart_stat)
	 3'b000: begin
			if (ack==1) begin
		    uart_stat<=3'b001; 
		 end
		 else begin
			 uart_stat<=3'b000; 
		 end
	 end	
	 3'b001: begin                        
         if (k == 12 ) begin          	//���͵�26���ַ� 	 
				 if(uart_cnt ==0) begin
					txdata <= uart_ad[12]; 
					uart_cnt <= uart_cnt + 1'b1;
					wrsig <= 1'b1;                			
				 end	
				 else if(uart_cnt ==254) begin
					uart_cnt <= 0;
					wrsig <= 1'b0; 				
					uart_stat <= 3'b010; 
					k <= 0;
				 end
				 else	begin			
					 uart_cnt <= uart_cnt + 1'b1;
					 wrsig <= 1'b0;  
				 end
		 end
	    else begin                      //����ǰ25���ַ� 
				 if(uart_cnt ==0) begin      
					txdata <= uart_ad[k]; 
					uart_cnt <= uart_cnt + 1'b1;
					wrsig <= 1'b1;                			
				 end	
				 else if(uart_cnt ==254) begin
					uart_cnt <= 0;
					wrsig <= 1'b0; 
					k <= k + 1'b1;				
				 end
				 else	begin			
					 uart_cnt <= uart_cnt + 1'b1;
					 wrsig <= 1'b0;  
				 end
		 end	 
	 end
	 3'b010: begin       //����finish	 
		 	uart_stat <= 3'b000; 
	 end
	 default:uart_stat <= 3'b000;
    endcase 
  end
end

/**********��������ʱ��***********/
clkdiv u0 (
		.clk50                   (clk50),                           
		.clkout                  (clk)             //���ڷ���ʱ��                 
 );

/*************���ڷ��ͳ���************/
uarttx u1 (
		.clk                     (clk),                           
		.datain                  (txdata),
      .wrsig                   (wrsig), 
      .idle                    (idle), 	
	   .tx                      (tx)		
 );



endmodule
