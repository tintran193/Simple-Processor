module controlunit #(
	parameter WIDTH = 9
)(
	input logic [WIDTH-1:0] IRout,
	input logic Clock,
	input logic Resetn,
	input logic Run,
	
	output logic Done,
	output logic [7:0] Rout,
	output logic [7:0] Rin,
	output logic Gout, DINout,
	output logic IRin, Ain, Gin, AddSub,
	
	output logic pc_inc
	
);
//signals
logic [2:0] opcode;
logic [7:0] XReg, YReg;
	
assign opcode = IRout[8:6];
dec3to8 decoderX (IRout[5:3], 1'b1, XReg);
dec3to8 decoderY (IRout[2:0], 1'b1, YReg);

//time steps

typedef enum logic [1:0] {
	T0 = 2'b00,
	T1 = 2'b01,
	T2 = 2'b10,
	T3 = 2'b11
} state_t;

state_t Tstep_Q, Tstep_D;

//Control FSM flip_flops
	always_ff@(posedge Clock or negedge Resetn) begin
		if(!Resetn) Tstep_Q <= T0;
		else Tstep_Q <= Tstep_D;
	end

// Control FSM state table  
always_comb
begin  
	Tstep_D = Tstep_Q;
	case (Tstep_Q)  
		T0: // data is loaded into IR in this time step  
			if (!Run) Tstep_D = T0;  
			else Tstep_D = T1; 
		T1: 
			if (Done) Tstep_D = T0; //mv, mvi
			else Tstep_D = T2;
		T2: Tstep_D = T3;
		T3: Tstep_D = T0;
		default: Tstep_D = T0;
	endcase  
end 

//Control FSM outputs
always_comb
	begin
	//specify initial value
	IRin = 1'b0; 
	Rin = 8'b00000000;//Rin R7..R0
	Rout = 8'b00000000;// Rout R7..R0
	DINout = 1'b0;
	Gout = 1'b0;
	Ain = 1'b0;
	AddSub = 1'b0;
	Gin = 1'b0;
	Done = 1'b0;
	
	pc_inc = 1'b0;//pc
	
		case (Tstep_Q)  
			T0: //store DIN in IR in time step 0  
				begin
					IRin = 1'b1;
					pc_inc = 1'b1; //pc
				end
			T1: //define signals in time step 1
				case (opcode) 
					3'b000: //mv Rx, Ry
						begin
							Rout = YReg;
							Rin = XReg;
							Done = 1'b1;
						end
					3'b001: //mvi Rx, #D
						begin
							DINout = 1'b1; 
							Rin = XReg;
							pc_inc = 1'b1;//pc
							Done = 1'b1;
						end
					3'b010, 3'b011: //add sub
						begin
							Rout = XReg;
							Ain = 1'b1;
						end
				endcase
			T2: //define signals in time step 2
				case (opcode)
					3'b010: 
						begin
							Rout = YReg;
							Gin = 1'b1;
							AddSub = 1'b0;
						end
					3'b011:
						begin
							Rout = YReg;
							Gin = 1'b1;
							AddSub = 1'b1;
						end
				endcase
			T3: //define signals in time step 3
				case (opcode)
					3'b010, 3'b011:
						begin
							Gout = 1'b1;
							Rin = XReg;
							Done = 1'b1;
						end
				endcase
		endcase
	end

endmodule



