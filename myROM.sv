module MyROM
#(parameter int unsigned width = 9,
parameter int unsigned depth = 32,
parameter string intFile = "my_ROM.mif",
parameter int unsigned addrBits = 5)
(
input logic CLK,
input logic [addrBits-1:0] ADDRESS, //address 5 bits
output logic [width-1:0] DATAOUT //dataout 9 bits
);
(*ram_init_file = intFile*)
logic [width-1:0] rom [0:depth-1]; //rom: 32 rows, legth 9 bits 
// initialise ROM contents

always_ff @ (posedge CLK)
begin
	DATAOUT <= rom[ADDRESS];
end
endmodule : MyROM