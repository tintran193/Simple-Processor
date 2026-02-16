// Module Register
module regn #(
    parameter WIDTH = 9
)(
    input  logic [WIDTH-1:0] RegIn,     // Dữ liệu đầu vào (thường nối với BusWires)
    input  logic Rin,   // Tín hiệu cho phép nạp dữ liệu (Enable)
    input  logic Clock, // Tín hiệu xung nhịp
    input  logic Resetn,// Tín hiệu reset (tùy chọn, tích cực thấp)
    output logic [WIDTH-1:0] RegOut      // Dữ liệu đầu ra (giá trị lưu trong thanh ghi)
);

    always_ff @(posedge Clock or negedge Resetn) begin
        if (!Resetn) begin
            RegOut <= 9'b000000000;                
        end else if (Rin) begin
            RegOut <= RegIn;             
        end
    end

endmodule

// Module Multiplexers
module muxn 
#(
    parameter WIDTH = 9
) (
	input logic [WIDTH-1:0] DIN,
	input logic [WIDTH-1:0] R0,R1,R2,R3,R4,R5,R6,R7,
	input logic [WIDTH-1:0] G,
	
	input logic DINout,
	input logic [7:0] Rout,
	input logic Gout,
	
	output logic [WIDTH-1:0] Bus
);

	always_comb begin
		if(Rout[0]) Bus = R0;
		else if(Rout[1]) Bus = R1;
		else if(Rout[2]) Bus = R2;
		else if(Rout[3]) Bus = R3;
		else if(Rout[4]) Bus = R4;
		else if(Rout[5]) Bus = R5;
		else if(Rout[6]) Bus = R6;
		else if(Rout[7]) Bus = R7;
		else if(DINout) Bus = DIN;
		else if(Gout) Bus = G;
		else Bus = {WIDTH{1'b0}};
	end

endmodule
//Module AddSub
module AddSub 
#(
    parameter WIDTH = 9
)
(
    input  logic [WIDTH-1:0] A,          
    input  logic [WIDTH-1:0] Bus_datain,   
    input  logic AddSub_ctrl,
	 
    output logic [WIDTH-1:0] AddSub_out      
);
    always_comb begin
        if (AddSub_ctrl == 1'b0) begin
            AddSub_out = A + Bus_datain;
        end else begin
            AddSub_out = A + ~Bus_datain + AddSub_ctrl;
        end
    end

endmodule

//Module 3to8 Decoder
module dec3to8 (
	input logic [2:0] W,
	input logic EN,
	output logic [7:0] Y
);
	always_comb begin
		if (EN == 1'b1) begin
			case(W)
				3'b000: Y = 8'b00000001;
				3'b001: Y = 8'b00000010;
				3'b010: Y = 8'b00000100;
				3'b011: Y = 8'b00001000;
				3'b100: Y = 8'b00010000;
				3'b101: Y = 8'b00100000;
				3'b110: Y = 8'b01000000;
				3'b111: Y = 8'b10000000;
			endcase
		end else
			Y = 8'b00000000;
	end
endmodule
