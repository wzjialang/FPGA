`timescale 1ns / 1ps
module uarttx(clk, datain, wrsig, idle, tx);
input clk;               
input [7:0] datain;       
input wrsig;            
output idle;              
output tx;                
reg idle, tx;
reg send;
reg wrsigbuf, wrsigrise;
reg presult;
reg[7:0] cnt;             
parameter paritymode = 1'b0;

always @(posedge clk)
begin
   wrsigbuf <= wrsig;
   wrsigrise <= (~wrsigbuf) & wrsig;
end

always @(posedge clk)
begin
  if (wrsigrise &&  (~idle))  
  begin
     send <= 1'b1;
  end
  else if(cnt == 8'd168)      
  begin
     send <= 1'b0;
  end
end

always @(posedge clk)
begin
  if(send == 1'b1)  begin
    case(cnt)                 
    8'd0: begin
         tx <= 1'b0;
         idle <= 1'b1;
         cnt <= cnt + 8'd1;
    end
    8'd16: begin
         tx <= datain[0];    
         presult <= datain[0]^paritymode;
         idle <= 1'b1;
         cnt <= cnt + 8'd1;
    end
    8'd32: begin
         tx <= datain[1];   
         presult <= datain[1]^presult;
         idle <= 1'b1;
         cnt <= cnt + 8'd1;
    end
    8'd48: begin
         tx <= datain[2];    
         presult <= datain[2]^presult;
         idle <= 1'b1;
         cnt <= cnt + 8'd1;
    end
    8'd64: begin
         tx <= datain[3];   
         presult <= datain[3]^presult;
         idle <= 1'b1;
         cnt <= cnt + 8'd1;
    end
    8'd80: begin 
         tx <= datain[4];   
         presult <= datain[4]^presult;
         idle <= 1'b1;
         cnt <= cnt + 8'd1;
    end
    8'd96: begin
         tx <= datain[5];   
         presult <= datain[5]^presult;
         idle <= 1'b1;
         cnt <= cnt + 8'd1;
    end
    8'd112: begin
         tx <= datain[6];    
         presult <= datain[6]^presult;
         idle <= 1'b1;
         cnt <= cnt + 8'd1;
    end
    8'd128: begin 
         tx <= datain[7];   
         presult <= datain[7]^presult;
         idle <= 1'b1;
         cnt <= cnt + 8'd1;
    end
    8'd144: begin
         tx <= presult;      
         presult <= datain[0]^paritymode;
         idle <= 1'b1;
         cnt <= cnt + 8'd1;
    end
    8'd160: begin
         tx <= 1'b1;                  
         idle <= 1'b1;
         cnt <= cnt + 8'd1;
    end
    8'd168: begin
         tx <= 1'b1;             
         idle <= 1'b0;       
         cnt <= cnt + 8'd1;
    end
    default: begin
          cnt <= cnt + 8'd1;
    end
   endcase
  end
  else  begin
    tx <= 1'b1;
    cnt <= 8'd0;
    idle <= 1'b0;
  end
end
endmodule

