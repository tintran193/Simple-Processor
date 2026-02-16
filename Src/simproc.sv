module simproc (
    input logic MClock,   // Clock cho ROM/Counter
    input logic PClock,   // Clock cho Processor
    input logic Resetn,
    input logic Run,
    output logic [8:0] BusWires,
    output logic Done,
	 
	 output logic [8:0] IRout, A,G,AddSub_Res,
	 output logic [8:0] R0,R1,R2,R3,R4,R5,R6,R7,
	 
	 output logic [4:0] pc_addr,
    output logic [8:0] rom_data,
	 output logic pc_inc
);

    

    // 1. Bộ đếm chương trình (Program Counter)
    always_ff @(posedge PClock or negedge Resetn) begin
        if (!Resetn)
            pc_addr <= 5'b00000;
        else if (pc_inc)
            pc_addr <= pc_addr + 1'b1;
    end

    // 2. Khối ROM (Chứa chương trình từ file .mif) [cite: 1, 6]
    MyROM #(.width(9), .depth(32)) inst_ROM (
        .CLK(MClock),
        .ADDRESS(pc_addr),
        .DATAOUT(rom_data)
    );

    // 3. Vi xử lý (Processor) [cite: 50]
    // Lưu ý: Cần sửa module simproc để có thêm output pc_inc
    proc inst_processor (
        .DIN(rom_data),
        .Clock(PClock),
        .Resetn(Resetn),
        .Run(Run),
        .Done(Done),
        .BusWires(BusWires),
        .pc_inc(pc_inc), // Tín hiệu điều khiển tăng PC
		  	.R0(R0),
			.R1(R1),
			.R2(R2),
			.R3(R3),
			.R4(R4),
			.R5(R5),
			.R6(R6),
			.R7(R7),
			.IRout(IRout),
			.A(A),
			.G(G),
			.AddSub_Res(AddSub_Res)
    );

endmodule