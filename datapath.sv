module datapath #(
	parameter WIDTH = 9
)(
	input logic [WIDTH-1:0] DIN,
	input logic Clock,
	input logic Resetn,
	output logic [WIDTH-1:0] BusWires,
	
	input logic [7:0] Rout,
	input logic [7:0] Rin,
	input logic Gout, DINout,
	input logic IRin, Ain, Gin, AddSub,
	output logic [WIDTH-1:0] IRout, 
	
	output logic [WIDTH-1:0] A,G,AddSub_Res,
	output logic [WIDTH-1:0] R0,R1,R2,R3,R4,R5,R6,R7
);
//signals	


//Register IR
regn #(.WIDTH(WIDTH)) reg_IR (DIN, IRin, Clock, Resetn, IRout);
//Register R0..R7
regn #(.WIDTH(WIDTH)) reg_R0 (BusWires, Rin[0],Clock, Resetn, R0);
regn #(.WIDTH(WIDTH)) reg_R1 (BusWires, Rin[1],Clock, Resetn, R1);
regn #(.WIDTH(WIDTH)) reg_R2 (BusWires, Rin[2],Clock, Resetn, R2);
regn #(.WIDTH(WIDTH)) reg_R3 (BusWires, Rin[3],Clock, Resetn, R3);
regn #(.WIDTH(WIDTH)) reg_R4 (BusWires, Rin[4],Clock, Resetn, R4);
regn #(.WIDTH(WIDTH)) reg_R5 (BusWires, Rin[5],Clock, Resetn, R5);
regn #(.WIDTH(WIDTH)) reg_R6 (BusWires, Rin[6],Clock, Resetn, R6);
regn #(.WIDTH(WIDTH)) reg_R7 (BusWires, Rin[7],Clock, Resetn, R7);

//Register A
regn #(.WIDTH(WIDTH)) reg_A (BusWires, Ain, Clock, Resetn, A);
//AddSub
AddSub #(.WIDTH(WIDTH)) iAddSub (A,BusWires,AddSub,AddSub_Res);
//Register G
regn #(.WIDTH(WIDTH)) reg_G (AddSub_Res, Gin,Clock, Resetn, G);

//Mux
muxn #(.WIDTH(WIDTH)) imuxn (
    .DIN(DIN),           // Nối đầu vào DIN
    .R0(R0),               // Nối mảng thanh ghi R0..R7 [cite: 16, 17]
	 .R1(R1),
	 .R2(R2),
	 .R3(R3),
	 .R4(R4),
	 .R5(R5),
	 .R6(R6),
	 .R7(R7),
    .G(G),               // Nối thanh ghi kết quả G 
    .DINout(DINout),     // Tín hiệu điều khiển xuất DIN ra Bus [cite: 12]
    .Rout(Rout),         // Tín hiệu điều khiển xuất Rx ra Bus [cite: 12]
    .Gout(Gout),         // Tín hiệu điều khiển xuất G ra Bus [cite: 15]
    .Bus(BusWires)       // Ngõ ra kết nối với Bus chung của hệ thống 
);

endmodule



