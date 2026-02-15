module proc #(
	parameter WIDTH = 9
)(
	input logic [WIDTH-1:0] DIN,
	input logic Clock,
	input logic Resetn,
	input logic Run,
	
	output logic Done,
	output logic [WIDTH-1:0] BusWires,
	
	output logic pc_inc,
	
	output logic [WIDTH-1:0] IRout, A,G,AddSub_Res,
	output logic [WIDTH-1:0] R0,R1,R2,R3,R4,R5,R6,R7
);
//control signals
	
	logic [7:0] Rin; // R7..R0 in
	logic [7:0] Rout; // R7..R0 out
	logic Gout, DINout;
	logic Ain, Gin, AddSub, IRin;

	datapath M_DP (
		.DIN(DIN),
		.Clock(Clock),
		.Resetn(Resetn),
		.BusWires(BusWires),		
		.Rout(Rout),
		.Rin(Rin),
		.Gout(Gout), 
		.DINout(DINout),
		.IRin(IRin),
		.Ain(Ain),
		.Gin(Gin), 
		.AddSub(AddSub),
		.IRout(IRout),
		.R0(R0),
		.R1(R1),
		.R2(R2),
		.R3(R3),
		.R4(R4),
		.R5(R5),
		.R6(R6),
		.R7(R7),
		.A(A),
		.G(G),
		.AddSub_Res(AddSub_Res)
	);
	
	controlunit M_CU (
		.IRout(IRout),
		.Clock(Clock),
		.Resetn(Resetn),
		.Run(Run),
		
		.Done(Done),
		.Rout(Rout),
		.Rin(Rin),
		.Gout(Gout), 
		.DINout(DINout),
		.IRin(IRin), 
		.Ain(Ain), 
		.Gin(Gin), 
		.AddSub(AddSub),
		.pc_inc(pc_inc)
	);


endmodule



