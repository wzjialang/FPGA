`timescale 1ns / 1ps
module uart(
           input clk50,                     //50Mhz clock
			  input reset_n,
			  input [27:0] rdata,
			  input ack,
           output tx			  
    );

/********************************************/
//存储待发送的串口信息
/********************************************/
reg [7:0] uart_ad [12:0];                        //存储发送字符
always @(clk)
begin     //定义发送的字符
   if(uart_stat==3'b000) begin
		 uart_ad[0]<=65;                           //存储字符 A 
		 uart_ad[1]<=68;                           //存储字符 D
		 uart_ad[2]<=49;                           //存储字符 1
		 uart_ad[3]<=58;                           //存储字符 : 
		 uart_ad[4]<=rdata[27:20];                      //存储字符 正负   	 
		 uart_ad[5]<=rdata[15:12] + 48;          //存储字符 个位                          
		 uart_ad[6]<=46;                           //存储字符 . 
		 uart_ad[7]<=rdata[11:8] + 48;           //存储字符 小数点后一位
		 uart_ad[8]<=rdata[7:4] + 48;            //存储字符 小数点后二位
		 uart_ad[9]<=rdata[3:0] + 48;            //存储字符 小数点后三位
		 uart_ad[10]<=86;                          //存储字符 V
		 uart_ad[11]<=10;                          //换行符
		 uart_ad[12]<=13;                          //回车符
	end	 
end 

/********************************************/
//串口发送时间字符串
/********************************************/
reg [15:0] uart_cnt;
reg [2:0] uart_stat;

reg  [7:0]  txdata;             //串口发送字符
reg         wrsig;               //串口发送有效信号

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
         if (k == 12 ) begin          	//发送第26个字符 	 
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
	    else begin                      //发送前25个字符 
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
	 3'b010: begin       //发送finish	 
		 	uart_stat <= 3'b000; 
	 end
	 default:uart_stat <= 3'b000;
    endcase 
  end
end

/**********产生串口时钟***********/
clkdiv u0 (
		.clk50                   (clk50),                           
		.clkout                  (clk)             //串口发送时钟                 
 );

/*************串口发送程序************/
uarttx u1 (
		.clk                     (clk),                           
		.datain                  (txdata),
      .wrsig                   (wrsig), 
      .idle                    (idle), 	
	   .tx                      (tx)		
 );



endmodule
