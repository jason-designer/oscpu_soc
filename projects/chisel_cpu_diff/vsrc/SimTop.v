module IFetch(
  input         reset,
  input         io_jump_en,
  input  [63:0] io_jump_pc,
  input  [63:0] io_pc,
  output [63:0] io_next_pc,
  output        io_valid
);
  wire [63:0] _io_next_pc_T_1 = io_pc + 64'h4; // @[IFetch.scala 13:51]
  assign io_next_pc = io_jump_en ? io_jump_pc : _io_next_pc_T_1; // @[IFetch.scala 13:20]
  assign io_valid = ~reset; // @[IFetch.scala 14:17]
endmodule
module Decode(
  input  [63:0] io_pc,
  input  [31:0] io_inst,
  output        io_rs1_en,
  output        io_rs2_en,
  output [4:0]  io_rs1_addr,
  output [4:0]  io_rs2_addr,
  input  [63:0] io_rs1_data,
  input  [63:0] io_rs2_data,
  output        io_rd_en,
  output [4:0]  io_rd_addr,
  output [5:0]  io_decode_info_fu_code,
  output [15:0] io_decode_info_alu_code,
  output [7:0]  io_decode_info_bu_code,
  output [6:0]  io_decode_info_lu_code,
  output [3:0]  io_decode_info_su_code,
  output [9:0]  io_decode_info_mdu_code,
  output [7:0]  io_decode_info_csru_code,
  output        io_jump_en,
  output [63:0] io_jump_pc,
  output [63:0] io_op1,
  output [63:0] io_op2,
  output [63:0] io_imm,
  output        io_putch,
  input  [63:0] io_mtvec,
  input  [63:0] io_mepc
);
  wire [31:0] _sll_T = io_inst & 32'hfe00707f; // @[Decode.scala 54:20]
  wire  sll = 32'h1033 == _sll_T; // @[Decode.scala 54:20]
  wire  srl = 32'h5033 == _sll_T; // @[Decode.scala 55:20]
  wire  sra = 32'h40005033 == _sll_T; // @[Decode.scala 56:20]
  wire [31:0] _slli_T = io_inst & 32'hfc00707f; // @[Decode.scala 57:21]
  wire  slli = 32'h1013 == _slli_T; // @[Decode.scala 57:21]
  wire  srli = 32'h5013 == _slli_T; // @[Decode.scala 58:21]
  wire  srai = 32'h40005013 == _slli_T; // @[Decode.scala 59:21]
  wire  sllw = 32'h103b == _sll_T; // @[Decode.scala 60:21]
  wire  srlw = 32'h503b == _sll_T; // @[Decode.scala 61:21]
  wire  sraw = 32'h4000503b == _sll_T; // @[Decode.scala 62:21]
  wire  slliw = 32'h101b == _sll_T; // @[Decode.scala 63:22]
  wire  srliw = 32'h501b == _sll_T; // @[Decode.scala 64:22]
  wire  sraiw = 32'h4000501b == _sll_T; // @[Decode.scala 65:22]
  wire  add = 32'h33 == _sll_T; // @[Decode.scala 67:24]
  wire  addw = 32'h3b == _sll_T; // @[Decode.scala 68:24]
  wire [31:0] _addi_T = io_inst & 32'h707f; // @[Decode.scala 69:24]
  wire  addi = 32'h13 == _addi_T; // @[Decode.scala 69:24]
  wire  addiw = 32'h1b == _addi_T; // @[Decode.scala 70:24]
  wire  alu_sub = 32'h40000033 == _sll_T; // @[Decode.scala 71:24]
  wire  alu_subw = 32'h4000003b == _sll_T; // @[Decode.scala 72:24]
  wire [31:0] _lui_T = io_inst & 32'h7f; // @[Decode.scala 73:24]
  wire  lui = 32'h37 == _lui_T; // @[Decode.scala 73:24]
  wire  alu_auipc = 32'h17 == _lui_T; // @[Decode.scala 74:24]
  wire  xor_ = 32'h4033 == _sll_T; // @[Decode.scala 76:24]
  wire  or_ = 32'h6033 == _sll_T; // @[Decode.scala 77:24]
  wire  and_ = 32'h7033 == _sll_T; // @[Decode.scala 78:24]
  wire  xori = 32'h4013 == _addi_T; // @[Decode.scala 79:24]
  wire  ori = 32'h6013 == _addi_T; // @[Decode.scala 80:24]
  wire  andi = 32'h7013 == _addi_T; // @[Decode.scala 81:24]
  wire  slt = 32'h2033 == _sll_T; // @[Decode.scala 83:24]
  wire  sltu = 32'h3033 == _sll_T; // @[Decode.scala 84:24]
  wire  slti = 32'h2013 == _addi_T; // @[Decode.scala 85:24]
  wire  sltiu = 32'h3013 == _addi_T; // @[Decode.scala 86:24]
  wire  beq = 32'h63 == _addi_T; // @[Decode.scala 88:24]
  wire  bne = 32'h1063 == _addi_T; // @[Decode.scala 89:24]
  wire  blt = 32'h4063 == _addi_T; // @[Decode.scala 90:24]
  wire  bge = 32'h5063 == _addi_T; // @[Decode.scala 91:24]
  wire  bltu = 32'h6063 == _addi_T; // @[Decode.scala 92:24]
  wire  bgeu = 32'h7063 == _addi_T; // @[Decode.scala 93:24]
  wire  jal = 32'h6f == _lui_T; // @[Decode.scala 95:24]
  wire  jalr = 32'h67 == _addi_T; // @[Decode.scala 96:24]
  wire  lb = 32'h3 == _addi_T; // @[Decode.scala 98:24]
  wire  lh = 32'h1003 == _addi_T; // @[Decode.scala 99:24]
  wire  lw = 32'h2003 == _addi_T; // @[Decode.scala 100:24]
  wire  ld = 32'h3003 == _addi_T; // @[Decode.scala 101:24]
  wire  lbu = 32'h4003 == _addi_T; // @[Decode.scala 102:24]
  wire  lhu = 32'h5003 == _addi_T; // @[Decode.scala 103:24]
  wire  lwu = 32'h6003 == _addi_T; // @[Decode.scala 104:24]
  wire  sb = 32'h23 == _addi_T; // @[Decode.scala 106:24]
  wire  sh = 32'h1023 == _addi_T; // @[Decode.scala 107:24]
  wire  sw = 32'h2023 == _addi_T; // @[Decode.scala 108:24]
  wire  sd = 32'h3023 == _addi_T; // @[Decode.scala 109:24]
  wire  mul = 32'h2000033 == _sll_T; // @[Decode.scala 111:24]
  wire  mulw = 32'h200003b == _sll_T; // @[Decode.scala 112:24]
  wire  div = 32'h2004033 == _sll_T; // @[Decode.scala 113:24]
  wire  divw = 32'h200403b == _sll_T; // @[Decode.scala 114:24]
  wire  divu = 32'h2005033 == _sll_T; // @[Decode.scala 115:24]
  wire  divuw = 32'h200503b == _sll_T; // @[Decode.scala 116:24]
  wire  rem = 32'h2006033 == _sll_T; // @[Decode.scala 117:24]
  wire  remw = 32'h200603b == _sll_T; // @[Decode.scala 118:24]
  wire  remu = 32'h2007033 == _sll_T; // @[Decode.scala 119:24]
  wire  remuw = 32'h200703b == _sll_T; // @[Decode.scala 120:24]
  wire  ecall = 32'h73 == io_inst; // @[Decode.scala 122:24]
  wire  mret = 32'h30200073 == io_inst; // @[Decode.scala 123:24]
  wire  csrrs = 32'h2073 == _addi_T; // @[Decode.scala 124:24]
  wire  csrrw = 32'h1073 == _addi_T; // @[Decode.scala 125:24]
  wire  csrrc = 32'h3073 == _addi_T; // @[Decode.scala 126:24]
  wire  csrrsi = 32'h6073 == _addi_T; // @[Decode.scala 127:24]
  wire  csrrwi = 32'h5073 == _addi_T; // @[Decode.scala 128:24]
  wire  csrrci = 32'h7073 == _addi_T; // @[Decode.scala 129:24]
  wire  alu_add = add | addi | lui; // @[Decode.scala 137:33]
  wire  alu_addw = addw | addiw; // @[Decode.scala 138:26]
  wire  alu_sll = sll | slli; // @[Decode.scala 143:26]
  wire  alu_srl = srl | srli; // @[Decode.scala 144:26]
  wire  alu_sra = sra | srai; // @[Decode.scala 145:26]
  wire  alu_sllw = sllw | slliw; // @[Decode.scala 146:26]
  wire  alu_srlw = srlw | srliw; // @[Decode.scala 147:26]
  wire  alu_sraw = sraw | sraiw; // @[Decode.scala 148:26]
  wire  alu_xor = xor_ | xori; // @[Decode.scala 150:26]
  wire  alu_or = or_ | ori; // @[Decode.scala 151:26]
  wire  alu_and = and_ | andi; // @[Decode.scala 152:26]
  wire  alu_slt = slt | slti; // @[Decode.scala 154:26]
  wire  alu_sltu = sltu | sltiu; // @[Decode.scala 155:26]
  wire [7:0] alu_code_lo = {alu_sra,alu_srl,alu_sll,alu_auipc,alu_subw,alu_sub,alu_addw,alu_add}; // @[Cat.scala 30:58]
  wire [7:0] alu_code_hi = {alu_sltu,alu_slt,alu_and,alu_or,alu_xor,alu_sraw,alu_srlw,alu_sllw}; // @[Cat.scala 30:58]
  wire [15:0] alu_code = {alu_sltu,alu_slt,alu_and,alu_or,alu_xor,alu_sraw,alu_srlw,alu_sllw,alu_code_lo}; // @[Cat.scala 30:58]
  wire  alu_en = alu_code != 16'h0; // @[Decode.scala 158:29]
  wire [3:0] bu_code_lo = {bge,blt,bne,beq}; // @[Cat.scala 30:58]
  wire [3:0] bu_code_hi = {jalr,jal,bgeu,bltu}; // @[Cat.scala 30:58]
  wire [7:0] bu_code = {jalr,jal,bgeu,bltu,bge,blt,bne,beq}; // @[Cat.scala 30:58]
  wire  bu_en = bu_code != 8'h0; // @[Decode.scala 161:27]
  wire [2:0] lu_code_lo = {lw,lh,lb}; // @[Cat.scala 30:58]
  wire [3:0] lu_code_hi = {lwu,lhu,lbu,ld}; // @[Cat.scala 30:58]
  wire [6:0] lu_code = {lwu,lhu,lbu,ld,lw,lh,lb}; // @[Cat.scala 30:58]
  wire  lu_en = lu_code != 7'h0; // @[Decode.scala 164:27]
  wire [1:0] su_code_lo = {sh,sb}; // @[Cat.scala 30:58]
  wire [1:0] su_code_hi = {sd,sw}; // @[Cat.scala 30:58]
  wire [3:0] su_code = {sd,sw,sh,sb}; // @[Cat.scala 30:58]
  wire  su_en = su_code != 4'h0; // @[Decode.scala 167:27]
  wire [4:0] mdu_code_lo = {divu,divw,div,mulw,mul}; // @[Cat.scala 30:58]
  wire [4:0] mdu_code_hi = {remuw,remu,remw,rem,divuw}; // @[Cat.scala 30:58]
  wire [9:0] mdu_code = {remuw,remu,remw,rem,divuw,divu,divw,div,mulw,mul}; // @[Cat.scala 30:58]
  wire  mdu_en = mdu_code != 10'h0; // @[Decode.scala 170:29]
  wire [3:0] csru_code_lo = {csrrw,csrrs,mret,ecall}; // @[Cat.scala 30:58]
  wire [3:0] csru_code_hi = {csrrci,csrrwi,csrrsi,csrrc}; // @[Cat.scala 30:58]
  wire [7:0] csru_code = {csrrci,csrrwi,csrrsi,csrrc,csrrw,csrrs,mret,ecall}; // @[Cat.scala 30:58]
  wire  csr_en = csru_code != 8'h0; // @[Decode.scala 173:31]
  wire [2:0] fu_code_lo = {lu_en,bu_en,alu_en}; // @[Cat.scala 30:58]
  wire [2:0] fu_code_hi = {csr_en,mdu_en,su_en}; // @[Cat.scala 30:58]
  wire  _type_r_T_5 = sll | srl | sra | sllw | srlw | sraw | add; // @[Decode.scala 178:74]
  wire  _type_r_T_9 = _type_r_T_5 | addw | alu_sub | alu_subw | xor_; // @[Decode.scala 179:54]
  wire  _type_r_T_12 = _type_r_T_9 | or_ | and_ | slt; // @[Decode.scala 180:45]
  wire  _type_r_T_14 = _type_r_T_12 | sltu | mul; // @[Decode.scala 181:36]
  wire  _type_r_T_16 = _type_r_T_14 | mulw | div; // @[Decode.scala 182:36]
  wire  _type_r_T_20 = _type_r_T_16 | divw | divu | divuw | rem; // @[Decode.scala 183:54]
  wire  type_r = _type_r_T_20 | remw | remu | remuw | mret; // @[Decode.scala 184:54]
  wire  _type_i_T_5 = slli | srli | srai | slliw | srliw | sraiw | addi; // @[Decode.scala 186:74]
  wire  _type_i_T_7 = _type_i_T_5 | addiw | xori; // @[Decode.scala 187:36]
  wire  _type_i_T_10 = _type_i_T_7 | ori | andi | slti; // @[Decode.scala 188:45]
  wire  _type_i_T_12 = _type_i_T_10 | sltiu | jalr; // @[Decode.scala 189:36]
  wire  _type_i_T_13 = _type_i_T_12 | lb; // @[Decode.scala 190:27]
  wire  _type_i_T_20 = _type_i_T_13 | lh | lw | ld | lbu | lhu | lwu | ecall; // @[Decode.scala 191:81]
  wire  type_i = _type_i_T_20 | csrrs | csrrw | csrrc | csrrwi | csrrci | csrrsi; // @[Decode.scala 192:74]
  wire  type_s = sb | sh | sw | sd; // @[Decode.scala 193:45]
  wire  type_b = beq | bne | blt | bge | bltu | bgeu; // @[Decode.scala 194:64]
  wire  type_u = lui | alu_auipc; // @[Decode.scala 195:27]
  wire [5:0] inst_type = {type_r,type_i,type_s,type_b,type_u,jal}; // @[Cat.scala 30:58]
  wire [51:0] imm_i_hi = io_inst[31] ? 52'hfffffffffffff : 52'h0; // @[Bitwise.scala 72:12]
  wire [11:0] imm_i_lo = io_inst[31:20]; // @[Decode.scala 201:45]
  wire [63:0] imm_i = {imm_i_hi,imm_i_lo}; // @[Cat.scala 30:58]
  wire [6:0] imm_s_hi_lo = io_inst[31:25]; // @[Decode.scala 202:45]
  wire [4:0] imm_s_lo = io_inst[11:7]; // @[Decode.scala 202:59]
  wire [63:0] imm_s = {imm_i_hi,imm_s_hi_lo,imm_s_lo}; // @[Cat.scala 30:58]
  wire [50:0] imm_b_hi_hi_hi = io_inst[31] ? 51'h7ffffffffffff : 51'h0; // @[Bitwise.scala 72:12]
  wire  imm_b_hi_lo = io_inst[7]; // @[Decode.scala 203:55]
  wire [5:0] imm_b_lo_hi_hi = io_inst[30:25]; // @[Decode.scala 203:64]
  wire [3:0] imm_b_lo_hi_lo = io_inst[11:8]; // @[Decode.scala 203:78]
  wire [63:0] imm_b = {imm_b_hi_hi_hi,io_inst[31],imm_b_hi_lo,imm_b_lo_hi_hi,imm_b_lo_hi_lo,1'h0}; // @[Cat.scala 30:58]
  wire [31:0] imm_u_hi_hi = io_inst[31] ? 32'hffffffff : 32'h0; // @[Bitwise.scala 72:12]
  wire [19:0] imm_u_hi_lo = io_inst[31:12]; // @[Decode.scala 204:45]
  wire [63:0] imm_u = {imm_u_hi_hi,imm_u_hi_lo,12'h0}; // @[Cat.scala 30:58]
  wire [42:0] imm_j_hi_hi_hi = io_inst[31] ? 43'h7ffffffffff : 43'h0; // @[Bitwise.scala 72:12]
  wire [7:0] imm_j_hi_lo = io_inst[19:12]; // @[Decode.scala 205:55]
  wire  imm_j_lo_hi_hi = io_inst[20]; // @[Decode.scala 205:69]
  wire [9:0] imm_j_lo_hi_lo = io_inst[30:21]; // @[Decode.scala 205:79]
  wire [63:0] imm_j = {imm_j_hi_hi_hi,io_inst[31],imm_j_hi_lo,imm_j_lo_hi_hi,imm_j_lo_hi_lo,1'h0}; // @[Cat.scala 30:58]
  wire [63:0] _imm_T_3 = 6'h10 == inst_type ? imm_i : 64'h0; // @[Mux.scala 80:57]
  wire [63:0] _imm_T_5 = 6'h8 == inst_type ? imm_s : _imm_T_3; // @[Mux.scala 80:57]
  wire [63:0] _imm_T_7 = 6'h4 == inst_type ? imm_b : _imm_T_5; // @[Mux.scala 80:57]
  wire [63:0] _imm_T_9 = 6'h2 == inst_type ? imm_u : _imm_T_7; // @[Mux.scala 80:57]
  wire [63:0] imm = 6'h1 == inst_type ? imm_j : _imm_T_9; // @[Mux.scala 80:57]
  wire  _io_rs1_en_T = type_r | type_i; // @[Decode.scala 228:25]
  wire [63:0] _bu_jump_pc_T_2 = io_op1 + io_op2; // @[Decode.scala 240:59]
  wire [63:0] _bu_jump_pc_T_3 = _bu_jump_pc_T_2 & 64'hfffffffffffffffe; // @[Decode.scala 240:66]
  wire [63:0] _bu_jump_pc_T_5 = io_pc + imm; // @[Decode.scala 240:95]
  wire [63:0] bu_jump_pc = bu_code == 8'h80 ? _bu_jump_pc_T_3 : _bu_jump_pc_T_5; // @[Decode.scala 240:25]
  wire  _bu_jump_en_T = io_op1 == io_op2; // @[Decode.scala 242:31]
  wire  _bu_jump_en_T_1 = io_op1 != io_op2; // @[Decode.scala 243:31]
  wire  _bu_jump_en_T_4 = $signed(io_op1) < $signed(io_op2); // @[Decode.scala 244:41]
  wire  _bu_jump_en_T_7 = $signed(io_op1) >= $signed(io_op2); // @[Decode.scala 245:41]
  wire  _bu_jump_en_T_8 = io_op1 < io_op2; // @[Decode.scala 246:32]
  wire  _bu_jump_en_T_9 = io_op1 >= io_op2; // @[Decode.scala 247:32]
  wire  _bu_jump_en_T_13 = 8'h2 == bu_code ? _bu_jump_en_T_1 : 8'h1 == bu_code & _bu_jump_en_T; // @[Mux.scala 80:57]
  wire  _bu_jump_en_T_15 = 8'h4 == bu_code ? _bu_jump_en_T_4 : _bu_jump_en_T_13; // @[Mux.scala 80:57]
  wire  _bu_jump_en_T_17 = 8'h8 == bu_code ? _bu_jump_en_T_7 : _bu_jump_en_T_15; // @[Mux.scala 80:57]
  wire  _bu_jump_en_T_19 = 8'h10 == bu_code ? _bu_jump_en_T_8 : _bu_jump_en_T_17; // @[Mux.scala 80:57]
  wire  _bu_jump_en_T_21 = 8'h20 == bu_code ? _bu_jump_en_T_9 : _bu_jump_en_T_19; // @[Mux.scala 80:57]
  wire  bu_jump_en = 8'h80 == bu_code | (8'h40 == bu_code | _bu_jump_en_T_21); // @[Mux.scala 80:57]
  wire [63:0] _csru_jump_pc_T_1 = 8'h1 == csru_code ? io_mtvec : 64'h0; // @[Mux.scala 80:57]
  wire [63:0] csru_jump_pc = 8'h2 == csru_code ? io_mepc : _csru_jump_pc_T_1; // @[Mux.scala 80:57]
  wire  csru_jump_en = 8'h2 == csru_code | 8'h1 == csru_code; // @[Mux.scala 80:57]
  assign io_rs1_en = type_r | type_i | type_s | type_b; // @[Decode.scala 228:45]
  assign io_rs2_en = type_r | type_s | type_b; // @[Decode.scala 229:35]
  assign io_rs1_addr = io_inst[19:15]; // @[Decode.scala 224:24]
  assign io_rs2_addr = io_inst[24:20]; // @[Decode.scala 225:24]
  assign io_rd_en = _io_rs1_en_T | type_u | jal; // @[Decode.scala 230:45]
  assign io_rd_addr = io_inst[11:7]; // @[Decode.scala 226:24]
  assign io_decode_info_fu_code = {fu_code_hi,fu_code_lo}; // @[Cat.scala 30:58]
  assign io_decode_info_alu_code = {alu_code_hi,alu_code_lo}; // @[Cat.scala 30:58]
  assign io_decode_info_bu_code = {bu_code_hi,bu_code_lo}; // @[Cat.scala 30:58]
  assign io_decode_info_lu_code = {lu_code_hi,lu_code_lo}; // @[Cat.scala 30:58]
  assign io_decode_info_su_code = {su_code_hi,su_code_lo}; // @[Cat.scala 30:58]
  assign io_decode_info_mdu_code = {mdu_code_hi,mdu_code_lo}; // @[Cat.scala 30:58]
  assign io_decode_info_csru_code = {csru_code_hi,csru_code_lo}; // @[Cat.scala 30:58]
  assign io_jump_en = bu_jump_en | csru_jump_en; // @[Decode.scala 261:30]
  assign io_jump_pc = bu_jump_en ? bu_jump_pc : csru_jump_pc; // @[Decode.scala 262:22]
  assign io_op1 = io_rs1_en ? io_rs1_data : 64'h0; // @[Decode.scala 232:18]
  assign io_op2 = io_rs2_en ? io_rs2_data : imm; // @[Decode.scala 233:18]
  assign io_imm = 6'h1 == inst_type ? imm_j : _imm_T_9; // @[Mux.scala 80:57]
  assign io_putch = io_inst == 32'h7b; // @[Decode.scala 132:24]
endmodule
module Execution(
  input  [15:0] io_decode_info_alu_code,
  input  [7:0]  io_decode_info_bu_code,
  input  [9:0]  io_decode_info_mdu_code,
  input  [7:0]  io_decode_info_csru_code,
  input  [63:0] io_op1,
  input  [63:0] io_op2,
  input  [63:0] io_pc,
  output [63:0] io_alu_out,
  output [63:0] io_bu_out,
  output [63:0] io_mdu_out,
  output [63:0] io_csru_out,
  input  [4:0]  io_rs1_addr,
  output [11:0] io_csr_raddr,
  input  [63:0] io_csr_rdata,
  output        io_csr_wen,
  output [11:0] io_csr_waddr,
  output [63:0] io_csr_wdata
);
  wire [63:0] _alu_out_T_1 = io_op1 + io_op2; // @[Execution.scala 51:39]
  wire [31:0] alu_out_hi = _alu_out_T_1[31] ? 32'hffffffff : 32'h0; // @[Bitwise.scala 72:12]
  wire [31:0] alu_out_lo = _alu_out_T_1[31:0]; // @[Execution.scala 41:41]
  wire [63:0] _alu_out_T_6 = {alu_out_hi,alu_out_lo}; // @[Cat.scala 30:58]
  wire [63:0] _alu_out_T_8 = io_op1 - io_op2; // @[Execution.scala 53:39]
  wire [31:0] alu_out_hi_1 = _alu_out_T_8[31] ? 32'hffffffff : 32'h0; // @[Bitwise.scala 72:12]
  wire [31:0] alu_out_lo_1 = _alu_out_T_8[31:0]; // @[Execution.scala 41:41]
  wire [63:0] _alu_out_T_13 = {alu_out_hi_1,alu_out_lo_1}; // @[Cat.scala 30:58]
  wire [63:0] _alu_out_T_15 = io_op2 + io_pc; // @[Execution.scala 55:39]
  wire [126:0] _GEN_0 = {{63'd0}, io_op1}; // @[Execution.scala 56:39]
  wire [126:0] _alu_out_T_17 = _GEN_0 << io_op2[5:0]; // @[Execution.scala 56:39]
  wire [63:0] _alu_out_T_20 = io_op1 >> io_op2[5:0]; // @[Execution.scala 57:39]
  wire [63:0] _alu_out_T_24 = $signed(io_op1) >>> io_op2[5:0]; // @[Execution.scala 58:68]
  wire [62:0] _GEN_1 = {{31'd0}, io_op1[31:0]}; // @[Execution.scala 59:51]
  wire [62:0] _alu_out_T_27 = _GEN_1 << io_op2[4:0]; // @[Execution.scala 59:51]
  wire [31:0] alu_out_hi_2 = _alu_out_T_27[31] ? 32'hffffffff : 32'h0; // @[Bitwise.scala 72:12]
  wire [31:0] alu_out_lo_2 = _alu_out_T_27[31:0]; // @[Execution.scala 41:41]
  wire [63:0] _alu_out_T_30 = {alu_out_hi_2,alu_out_lo_2}; // @[Cat.scala 30:58]
  wire [31:0] alu_out_lo_3 = io_op1[31:0] >> io_op2[4:0]; // @[Execution.scala 60:51]
  wire [31:0] alu_out_hi_3 = alu_out_lo_3[31] ? 32'hffffffff : 32'h0; // @[Bitwise.scala 72:12]
  wire [63:0] _alu_out_T_36 = {alu_out_hi_3,alu_out_lo_3}; // @[Cat.scala 30:58]
  wire [31:0] _alu_out_T_38 = io_op1[31:0]; // @[Execution.scala 61:57]
  wire [31:0] alu_out_lo_4 = $signed(_alu_out_T_38) >>> io_op2[4:0]; // @[Execution.scala 61:80]
  wire [31:0] alu_out_hi_4 = alu_out_lo_4[31] ? 32'hffffffff : 32'h0; // @[Bitwise.scala 72:12]
  wire [63:0] _alu_out_T_44 = {alu_out_hi_4,alu_out_lo_4}; // @[Cat.scala 30:58]
  wire [63:0] _alu_out_T_45 = io_op1 ^ io_op2; // @[Execution.scala 62:39]
  wire [63:0] _alu_out_T_46 = io_op1 | io_op2; // @[Execution.scala 63:39]
  wire [63:0] _alu_out_T_47 = io_op1 & io_op2; // @[Execution.scala 64:39]
  wire  _alu_out_T_50 = $signed(io_op1) < $signed(io_op2); // @[Execution.scala 65:48]
  wire  _alu_out_T_51 = io_op1 < io_op2; // @[Execution.scala 66:39]
  wire [63:0] _alu_out_T_53 = 16'h1 == io_decode_info_alu_code ? _alu_out_T_1 : 64'h0; // @[Mux.scala 80:57]
  wire [63:0] _alu_out_T_55 = 16'h2 == io_decode_info_alu_code ? _alu_out_T_6 : _alu_out_T_53; // @[Mux.scala 80:57]
  wire [63:0] _alu_out_T_57 = 16'h4 == io_decode_info_alu_code ? _alu_out_T_8 : _alu_out_T_55; // @[Mux.scala 80:57]
  wire [63:0] _alu_out_T_59 = 16'h8 == io_decode_info_alu_code ? _alu_out_T_13 : _alu_out_T_57; // @[Mux.scala 80:57]
  wire [63:0] _alu_out_T_61 = 16'h10 == io_decode_info_alu_code ? _alu_out_T_15 : _alu_out_T_59; // @[Mux.scala 80:57]
  wire [63:0] _alu_out_T_63 = 16'h20 == io_decode_info_alu_code ? _alu_out_T_17[63:0] : _alu_out_T_61; // @[Mux.scala 80:57]
  wire [63:0] _alu_out_T_65 = 16'h40 == io_decode_info_alu_code ? _alu_out_T_20 : _alu_out_T_63; // @[Mux.scala 80:57]
  wire [63:0] _alu_out_T_67 = 16'h80 == io_decode_info_alu_code ? _alu_out_T_24 : _alu_out_T_65; // @[Mux.scala 80:57]
  wire [63:0] _alu_out_T_69 = 16'h100 == io_decode_info_alu_code ? _alu_out_T_30 : _alu_out_T_67; // @[Mux.scala 80:57]
  wire [63:0] _alu_out_T_71 = 16'h200 == io_decode_info_alu_code ? _alu_out_T_36 : _alu_out_T_69; // @[Mux.scala 80:57]
  wire [63:0] _alu_out_T_73 = 16'h400 == io_decode_info_alu_code ? _alu_out_T_44 : _alu_out_T_71; // @[Mux.scala 80:57]
  wire [63:0] _alu_out_T_75 = 16'h800 == io_decode_info_alu_code ? _alu_out_T_45 : _alu_out_T_73; // @[Mux.scala 80:57]
  wire [63:0] _alu_out_T_77 = 16'h1000 == io_decode_info_alu_code ? _alu_out_T_46 : _alu_out_T_75; // @[Mux.scala 80:57]
  wire [63:0] _alu_out_T_79 = 16'h2000 == io_decode_info_alu_code ? _alu_out_T_47 : _alu_out_T_77; // @[Mux.scala 80:57]
  wire [63:0] _alu_out_T_81 = 16'h4000 == io_decode_info_alu_code ? {{63'd0}, _alu_out_T_50} : _alu_out_T_79; // @[Mux.scala 80:57]
  wire [63:0] _bu_out_T_4 = io_pc + 64'h4; // @[Execution.scala 70:81]
  wire [127:0] _mdu_out_T = io_op1 * io_op2; // @[Execution.scala 74:33]
  wire [31:0] mdu_out_hi = _mdu_out_T[31] ? 32'hffffffff : 32'h0; // @[Bitwise.scala 72:12]
  wire [31:0] mdu_out_lo = _mdu_out_T[31:0]; // @[Execution.scala 41:41]
  wire [63:0] _mdu_out_T_4 = {mdu_out_hi,mdu_out_lo}; // @[Cat.scala 30:58]
  wire [64:0] _mdu_out_T_8 = $signed(io_op1) / $signed(io_op2); // @[Execution.scala 76:64]
  wire [31:0] _mdu_out_T_12 = io_op2[31:0]; // @[Execution.scala 77:68]
  wire [32:0] _mdu_out_T_14 = $signed(_alu_out_T_38) / $signed(_mdu_out_T_12); // @[Execution.scala 77:78]
  wire [63:0] _mdu_out_T_15 = io_op1 / io_op2; // @[Execution.scala 78:33]
  wire [31:0] _mdu_out_T_18 = io_op1[31:0] / io_op2[31:0]; // @[Execution.scala 79:40]
  wire [63:0] _mdu_out_T_22 = $signed(io_op1) % $signed(io_op2); // @[Execution.scala 80:64]
  wire [31:0] _mdu_out_T_28 = $signed(_alu_out_T_38) % $signed(_mdu_out_T_12); // @[Execution.scala 81:78]
  wire [63:0] _GEN_2 = io_op1 % io_op2; // @[Execution.scala 82:33]
  wire [63:0] _mdu_out_T_29 = _GEN_2[63:0]; // @[Execution.scala 82:33]
  wire [31:0] _GEN_3 = io_op1[31:0] % io_op2[31:0]; // @[Execution.scala 83:40]
  wire [31:0] _mdu_out_T_32 = _GEN_3[31:0]; // @[Execution.scala 83:40]
  wire [127:0] _mdu_out_T_34 = 10'h1 == io_decode_info_mdu_code ? _mdu_out_T : 128'h0; // @[Mux.scala 80:57]
  wire [127:0] _mdu_out_T_36 = 10'h2 == io_decode_info_mdu_code ? {{64'd0}, _mdu_out_T_4} : _mdu_out_T_34; // @[Mux.scala 80:57]
  wire [127:0] _mdu_out_T_38 = 10'h4 == io_decode_info_mdu_code ? {{63'd0}, _mdu_out_T_8} : _mdu_out_T_36; // @[Mux.scala 80:57]
  wire [127:0] _mdu_out_T_40 = 10'h8 == io_decode_info_mdu_code ? {{95'd0}, _mdu_out_T_14} : _mdu_out_T_38; // @[Mux.scala 80:57]
  wire [127:0] _mdu_out_T_42 = 10'h10 == io_decode_info_mdu_code ? {{64'd0}, _mdu_out_T_15} : _mdu_out_T_40; // @[Mux.scala 80:57]
  wire [127:0] _mdu_out_T_44 = 10'h20 == io_decode_info_mdu_code ? {{96'd0}, _mdu_out_T_18} : _mdu_out_T_42; // @[Mux.scala 80:57]
  wire [127:0] _mdu_out_T_46 = 10'h40 == io_decode_info_mdu_code ? {{64'd0}, _mdu_out_T_22} : _mdu_out_T_44; // @[Mux.scala 80:57]
  wire [127:0] _mdu_out_T_48 = 10'h80 == io_decode_info_mdu_code ? {{96'd0}, _mdu_out_T_28} : _mdu_out_T_46; // @[Mux.scala 80:57]
  wire [127:0] _mdu_out_T_50 = 10'h100 == io_decode_info_mdu_code ? {{64'd0}, _mdu_out_T_29} : _mdu_out_T_48; // @[Mux.scala 80:57]
  wire [127:0] mdu_out = 10'h200 == io_decode_info_mdu_code ? {{96'd0}, _mdu_out_T_32} : _mdu_out_T_50; // @[Mux.scala 80:57]
  wire [63:0] _csru_out_T_1 = 8'h4 == io_decode_info_csru_code ? io_csr_rdata : 64'h0; // @[Mux.scala 80:57]
  wire [63:0] _csru_out_T_3 = 8'h8 == io_decode_info_csru_code ? io_csr_rdata : _csru_out_T_1; // @[Mux.scala 80:57]
  wire [63:0] _csru_out_T_5 = 8'h10 == io_decode_info_csru_code ? io_csr_rdata : _csru_out_T_3; // @[Mux.scala 80:57]
  wire [63:0] _csru_out_T_7 = 8'h20 == io_decode_info_csru_code ? io_csr_rdata : _csru_out_T_5; // @[Mux.scala 80:57]
  wire [63:0] _csru_out_T_9 = 8'h40 == io_decode_info_csru_code ? io_csr_rdata : _csru_out_T_7; // @[Mux.scala 80:57]
  wire [63:0] _csr_waddr_T_1 = 8'h4 == io_decode_info_csru_code ? io_op2 : 64'h0; // @[Mux.scala 80:57]
  wire [63:0] _csr_waddr_T_3 = 8'h8 == io_decode_info_csru_code ? io_op2 : _csr_waddr_T_1; // @[Mux.scala 80:57]
  wire [63:0] _csr_waddr_T_5 = 8'h10 == io_decode_info_csru_code ? io_op2 : _csr_waddr_T_3; // @[Mux.scala 80:57]
  wire [63:0] _csr_waddr_T_7 = 8'h20 == io_decode_info_csru_code ? io_op2 : _csr_waddr_T_5; // @[Mux.scala 80:57]
  wire [63:0] _csr_waddr_T_9 = 8'h40 == io_decode_info_csru_code ? io_op2 : _csr_waddr_T_7; // @[Mux.scala 80:57]
  wire [63:0] csr_waddr = 8'h80 == io_decode_info_csru_code ? io_op2 : _csr_waddr_T_9; // @[Mux.scala 80:57]
  wire [63:0] _csr_wdata_T = io_csr_rdata | io_op1; // @[Execution.scala 113:40]
  wire [63:0] _csr_wdata_T_1 = ~io_op1; // @[Execution.scala 115:43]
  wire [63:0] _csr_wdata_T_2 = io_csr_rdata & _csr_wdata_T_1; // @[Execution.scala 115:40]
  wire [63:0] _csr_wdata_T_3 = {59'h0,io_rs1_addr}; // @[Cat.scala 30:58]
  wire [63:0] _csr_wdata_T_4 = io_csr_rdata | _csr_wdata_T_3; // @[Execution.scala 116:40]
  wire [63:0] _csr_wdata_T_7 = ~_csr_wdata_T_3; // @[Execution.scala 118:43]
  wire [63:0] _csr_wdata_T_8 = io_csr_rdata & _csr_wdata_T_7; // @[Execution.scala 118:40]
  wire [63:0] _csr_wdata_T_10 = 8'h4 == io_decode_info_csru_code ? _csr_wdata_T : 64'h0; // @[Mux.scala 80:57]
  wire [63:0] _csr_wdata_T_12 = 8'h8 == io_decode_info_csru_code ? io_op1 : _csr_wdata_T_10; // @[Mux.scala 80:57]
  wire [63:0] _csr_wdata_T_14 = 8'h10 == io_decode_info_csru_code ? _csr_wdata_T_2 : _csr_wdata_T_12; // @[Mux.scala 80:57]
  wire [63:0] _csr_wdata_T_16 = 8'h20 == io_decode_info_csru_code ? _csr_wdata_T_4 : _csr_wdata_T_14; // @[Mux.scala 80:57]
  wire [63:0] _csr_wdata_T_18 = 8'h40 == io_decode_info_csru_code ? _csr_wdata_T_3 : _csr_wdata_T_16; // @[Mux.scala 80:57]
  assign io_alu_out = 16'h8000 == io_decode_info_alu_code ? {{63'd0}, _alu_out_T_51} : _alu_out_T_81; // @[Mux.scala 80:57]
  assign io_bu_out = io_decode_info_bu_code == 8'h80 | io_decode_info_bu_code == 8'h40 ? _bu_out_T_4 : 64'h0; // @[Execution.scala 70:21]
  assign io_mdu_out = mdu_out[63:0]; // @[Execution.scala 124:17]
  assign io_csru_out = 8'h80 == io_decode_info_csru_code ? io_csr_rdata : _csru_out_T_9; // @[Mux.scala 80:57]
  assign io_csr_raddr = io_op2[11:0]; // @[Execution.scala 87:18]
  assign io_csr_wen = 8'h80 == io_decode_info_csru_code | (8'h40 == io_decode_info_csru_code | (8'h20 ==
    io_decode_info_csru_code | (8'h10 == io_decode_info_csru_code | (8'h8 == io_decode_info_csru_code | 8'h4 ==
    io_decode_info_csru_code)))); // @[Mux.scala 80:57]
  assign io_csr_waddr = csr_waddr[11:0]; // @[Execution.scala 129:21]
  assign io_csr_wdata = 8'h80 == io_decode_info_csru_code ? _csr_wdata_T_8 : _csr_wdata_T_18; // @[Mux.scala 80:57]
endmodule
module RegFile(
  input         clock,
  input         reset,
  input  [4:0]  io_rs1_addr,
  input  [4:0]  io_rs2_addr,
  output [63:0] io_rs1_data,
  output [63:0] io_rs2_data,
  input  [4:0]  io_rd_addr,
  input  [63:0] io_rd_data,
  input         io_rd_en,
  output [63:0] rf_10
);
`ifdef RANDOMIZE_REG_INIT
  reg [63:0] _RAND_0;
  reg [63:0] _RAND_1;
  reg [63:0] _RAND_2;
  reg [63:0] _RAND_3;
  reg [63:0] _RAND_4;
  reg [63:0] _RAND_5;
  reg [63:0] _RAND_6;
  reg [63:0] _RAND_7;
  reg [63:0] _RAND_8;
  reg [63:0] _RAND_9;
  reg [63:0] _RAND_10;
  reg [63:0] _RAND_11;
  reg [63:0] _RAND_12;
  reg [63:0] _RAND_13;
  reg [63:0] _RAND_14;
  reg [63:0] _RAND_15;
  reg [63:0] _RAND_16;
  reg [63:0] _RAND_17;
  reg [63:0] _RAND_18;
  reg [63:0] _RAND_19;
  reg [63:0] _RAND_20;
  reg [63:0] _RAND_21;
  reg [63:0] _RAND_22;
  reg [63:0] _RAND_23;
  reg [63:0] _RAND_24;
  reg [63:0] _RAND_25;
  reg [63:0] _RAND_26;
  reg [63:0] _RAND_27;
  reg [63:0] _RAND_28;
  reg [63:0] _RAND_29;
  reg [63:0] _RAND_30;
  reg [63:0] _RAND_31;
`endif // RANDOMIZE_REG_INIT
  wire  dt_ar_clock; // @[RegFile.scala 25:21]
  wire [7:0] dt_ar_coreid; // @[RegFile.scala 25:21]
  wire [63:0] dt_ar_gpr_0; // @[RegFile.scala 25:21]
  wire [63:0] dt_ar_gpr_1; // @[RegFile.scala 25:21]
  wire [63:0] dt_ar_gpr_2; // @[RegFile.scala 25:21]
  wire [63:0] dt_ar_gpr_3; // @[RegFile.scala 25:21]
  wire [63:0] dt_ar_gpr_4; // @[RegFile.scala 25:21]
  wire [63:0] dt_ar_gpr_5; // @[RegFile.scala 25:21]
  wire [63:0] dt_ar_gpr_6; // @[RegFile.scala 25:21]
  wire [63:0] dt_ar_gpr_7; // @[RegFile.scala 25:21]
  wire [63:0] dt_ar_gpr_8; // @[RegFile.scala 25:21]
  wire [63:0] dt_ar_gpr_9; // @[RegFile.scala 25:21]
  wire [63:0] dt_ar_gpr_10; // @[RegFile.scala 25:21]
  wire [63:0] dt_ar_gpr_11; // @[RegFile.scala 25:21]
  wire [63:0] dt_ar_gpr_12; // @[RegFile.scala 25:21]
  wire [63:0] dt_ar_gpr_13; // @[RegFile.scala 25:21]
  wire [63:0] dt_ar_gpr_14; // @[RegFile.scala 25:21]
  wire [63:0] dt_ar_gpr_15; // @[RegFile.scala 25:21]
  wire [63:0] dt_ar_gpr_16; // @[RegFile.scala 25:21]
  wire [63:0] dt_ar_gpr_17; // @[RegFile.scala 25:21]
  wire [63:0] dt_ar_gpr_18; // @[RegFile.scala 25:21]
  wire [63:0] dt_ar_gpr_19; // @[RegFile.scala 25:21]
  wire [63:0] dt_ar_gpr_20; // @[RegFile.scala 25:21]
  wire [63:0] dt_ar_gpr_21; // @[RegFile.scala 25:21]
  wire [63:0] dt_ar_gpr_22; // @[RegFile.scala 25:21]
  wire [63:0] dt_ar_gpr_23; // @[RegFile.scala 25:21]
  wire [63:0] dt_ar_gpr_24; // @[RegFile.scala 25:21]
  wire [63:0] dt_ar_gpr_25; // @[RegFile.scala 25:21]
  wire [63:0] dt_ar_gpr_26; // @[RegFile.scala 25:21]
  wire [63:0] dt_ar_gpr_27; // @[RegFile.scala 25:21]
  wire [63:0] dt_ar_gpr_28; // @[RegFile.scala 25:21]
  wire [63:0] dt_ar_gpr_29; // @[RegFile.scala 25:21]
  wire [63:0] dt_ar_gpr_30; // @[RegFile.scala 25:21]
  wire [63:0] dt_ar_gpr_31; // @[RegFile.scala 25:21]
  reg [63:0] rf__0; // @[RegFile.scala 16:19]
  reg [63:0] rf__1; // @[RegFile.scala 16:19]
  reg [63:0] rf__2; // @[RegFile.scala 16:19]
  reg [63:0] rf__3; // @[RegFile.scala 16:19]
  reg [63:0] rf__4; // @[RegFile.scala 16:19]
  reg [63:0] rf__5; // @[RegFile.scala 16:19]
  reg [63:0] rf__6; // @[RegFile.scala 16:19]
  reg [63:0] rf__7; // @[RegFile.scala 16:19]
  reg [63:0] rf__8; // @[RegFile.scala 16:19]
  reg [63:0] rf__9; // @[RegFile.scala 16:19]
  reg [63:0] rf__10; // @[RegFile.scala 16:19]
  reg [63:0] rf__11; // @[RegFile.scala 16:19]
  reg [63:0] rf__12; // @[RegFile.scala 16:19]
  reg [63:0] rf__13; // @[RegFile.scala 16:19]
  reg [63:0] rf__14; // @[RegFile.scala 16:19]
  reg [63:0] rf__15; // @[RegFile.scala 16:19]
  reg [63:0] rf__16; // @[RegFile.scala 16:19]
  reg [63:0] rf__17; // @[RegFile.scala 16:19]
  reg [63:0] rf__18; // @[RegFile.scala 16:19]
  reg [63:0] rf__19; // @[RegFile.scala 16:19]
  reg [63:0] rf__20; // @[RegFile.scala 16:19]
  reg [63:0] rf__21; // @[RegFile.scala 16:19]
  reg [63:0] rf__22; // @[RegFile.scala 16:19]
  reg [63:0] rf__23; // @[RegFile.scala 16:19]
  reg [63:0] rf__24; // @[RegFile.scala 16:19]
  reg [63:0] rf__25; // @[RegFile.scala 16:19]
  reg [63:0] rf__26; // @[RegFile.scala 16:19]
  reg [63:0] rf__27; // @[RegFile.scala 16:19]
  reg [63:0] rf__28; // @[RegFile.scala 16:19]
  reg [63:0] rf__29; // @[RegFile.scala 16:19]
  reg [63:0] rf__30; // @[RegFile.scala 16:19]
  reg [63:0] rf__31; // @[RegFile.scala 16:19]
  wire [63:0] _GEN_65 = 5'h1 == io_rs1_addr ? rf__1 : rf__0; // @[RegFile.scala 22:21 RegFile.scala 22:21]
  wire [63:0] _GEN_66 = 5'h2 == io_rs1_addr ? rf__2 : _GEN_65; // @[RegFile.scala 22:21 RegFile.scala 22:21]
  wire [63:0] _GEN_67 = 5'h3 == io_rs1_addr ? rf__3 : _GEN_66; // @[RegFile.scala 22:21 RegFile.scala 22:21]
  wire [63:0] _GEN_68 = 5'h4 == io_rs1_addr ? rf__4 : _GEN_67; // @[RegFile.scala 22:21 RegFile.scala 22:21]
  wire [63:0] _GEN_69 = 5'h5 == io_rs1_addr ? rf__5 : _GEN_68; // @[RegFile.scala 22:21 RegFile.scala 22:21]
  wire [63:0] _GEN_70 = 5'h6 == io_rs1_addr ? rf__6 : _GEN_69; // @[RegFile.scala 22:21 RegFile.scala 22:21]
  wire [63:0] _GEN_71 = 5'h7 == io_rs1_addr ? rf__7 : _GEN_70; // @[RegFile.scala 22:21 RegFile.scala 22:21]
  wire [63:0] _GEN_72 = 5'h8 == io_rs1_addr ? rf__8 : _GEN_71; // @[RegFile.scala 22:21 RegFile.scala 22:21]
  wire [63:0] _GEN_73 = 5'h9 == io_rs1_addr ? rf__9 : _GEN_72; // @[RegFile.scala 22:21 RegFile.scala 22:21]
  wire [63:0] _GEN_74 = 5'ha == io_rs1_addr ? rf__10 : _GEN_73; // @[RegFile.scala 22:21 RegFile.scala 22:21]
  wire [63:0] _GEN_75 = 5'hb == io_rs1_addr ? rf__11 : _GEN_74; // @[RegFile.scala 22:21 RegFile.scala 22:21]
  wire [63:0] _GEN_76 = 5'hc == io_rs1_addr ? rf__12 : _GEN_75; // @[RegFile.scala 22:21 RegFile.scala 22:21]
  wire [63:0] _GEN_77 = 5'hd == io_rs1_addr ? rf__13 : _GEN_76; // @[RegFile.scala 22:21 RegFile.scala 22:21]
  wire [63:0] _GEN_78 = 5'he == io_rs1_addr ? rf__14 : _GEN_77; // @[RegFile.scala 22:21 RegFile.scala 22:21]
  wire [63:0] _GEN_79 = 5'hf == io_rs1_addr ? rf__15 : _GEN_78; // @[RegFile.scala 22:21 RegFile.scala 22:21]
  wire [63:0] _GEN_80 = 5'h10 == io_rs1_addr ? rf__16 : _GEN_79; // @[RegFile.scala 22:21 RegFile.scala 22:21]
  wire [63:0] _GEN_81 = 5'h11 == io_rs1_addr ? rf__17 : _GEN_80; // @[RegFile.scala 22:21 RegFile.scala 22:21]
  wire [63:0] _GEN_82 = 5'h12 == io_rs1_addr ? rf__18 : _GEN_81; // @[RegFile.scala 22:21 RegFile.scala 22:21]
  wire [63:0] _GEN_83 = 5'h13 == io_rs1_addr ? rf__19 : _GEN_82; // @[RegFile.scala 22:21 RegFile.scala 22:21]
  wire [63:0] _GEN_84 = 5'h14 == io_rs1_addr ? rf__20 : _GEN_83; // @[RegFile.scala 22:21 RegFile.scala 22:21]
  wire [63:0] _GEN_85 = 5'h15 == io_rs1_addr ? rf__21 : _GEN_84; // @[RegFile.scala 22:21 RegFile.scala 22:21]
  wire [63:0] _GEN_86 = 5'h16 == io_rs1_addr ? rf__22 : _GEN_85; // @[RegFile.scala 22:21 RegFile.scala 22:21]
  wire [63:0] _GEN_87 = 5'h17 == io_rs1_addr ? rf__23 : _GEN_86; // @[RegFile.scala 22:21 RegFile.scala 22:21]
  wire [63:0] _GEN_88 = 5'h18 == io_rs1_addr ? rf__24 : _GEN_87; // @[RegFile.scala 22:21 RegFile.scala 22:21]
  wire [63:0] _GEN_89 = 5'h19 == io_rs1_addr ? rf__25 : _GEN_88; // @[RegFile.scala 22:21 RegFile.scala 22:21]
  wire [63:0] _GEN_90 = 5'h1a == io_rs1_addr ? rf__26 : _GEN_89; // @[RegFile.scala 22:21 RegFile.scala 22:21]
  wire [63:0] _GEN_91 = 5'h1b == io_rs1_addr ? rf__27 : _GEN_90; // @[RegFile.scala 22:21 RegFile.scala 22:21]
  wire [63:0] _GEN_92 = 5'h1c == io_rs1_addr ? rf__28 : _GEN_91; // @[RegFile.scala 22:21 RegFile.scala 22:21]
  wire [63:0] _GEN_93 = 5'h1d == io_rs1_addr ? rf__29 : _GEN_92; // @[RegFile.scala 22:21 RegFile.scala 22:21]
  wire [63:0] _GEN_94 = 5'h1e == io_rs1_addr ? rf__30 : _GEN_93; // @[RegFile.scala 22:21 RegFile.scala 22:21]
  wire [63:0] _GEN_95 = 5'h1f == io_rs1_addr ? rf__31 : _GEN_94; // @[RegFile.scala 22:21 RegFile.scala 22:21]
  wire [63:0] _GEN_97 = 5'h1 == io_rs2_addr ? rf__1 : rf__0; // @[RegFile.scala 23:21 RegFile.scala 23:21]
  wire [63:0] _GEN_98 = 5'h2 == io_rs2_addr ? rf__2 : _GEN_97; // @[RegFile.scala 23:21 RegFile.scala 23:21]
  wire [63:0] _GEN_99 = 5'h3 == io_rs2_addr ? rf__3 : _GEN_98; // @[RegFile.scala 23:21 RegFile.scala 23:21]
  wire [63:0] _GEN_100 = 5'h4 == io_rs2_addr ? rf__4 : _GEN_99; // @[RegFile.scala 23:21 RegFile.scala 23:21]
  wire [63:0] _GEN_101 = 5'h5 == io_rs2_addr ? rf__5 : _GEN_100; // @[RegFile.scala 23:21 RegFile.scala 23:21]
  wire [63:0] _GEN_102 = 5'h6 == io_rs2_addr ? rf__6 : _GEN_101; // @[RegFile.scala 23:21 RegFile.scala 23:21]
  wire [63:0] _GEN_103 = 5'h7 == io_rs2_addr ? rf__7 : _GEN_102; // @[RegFile.scala 23:21 RegFile.scala 23:21]
  wire [63:0] _GEN_104 = 5'h8 == io_rs2_addr ? rf__8 : _GEN_103; // @[RegFile.scala 23:21 RegFile.scala 23:21]
  wire [63:0] _GEN_105 = 5'h9 == io_rs2_addr ? rf__9 : _GEN_104; // @[RegFile.scala 23:21 RegFile.scala 23:21]
  wire [63:0] _GEN_106 = 5'ha == io_rs2_addr ? rf__10 : _GEN_105; // @[RegFile.scala 23:21 RegFile.scala 23:21]
  wire [63:0] _GEN_107 = 5'hb == io_rs2_addr ? rf__11 : _GEN_106; // @[RegFile.scala 23:21 RegFile.scala 23:21]
  wire [63:0] _GEN_108 = 5'hc == io_rs2_addr ? rf__12 : _GEN_107; // @[RegFile.scala 23:21 RegFile.scala 23:21]
  wire [63:0] _GEN_109 = 5'hd == io_rs2_addr ? rf__13 : _GEN_108; // @[RegFile.scala 23:21 RegFile.scala 23:21]
  wire [63:0] _GEN_110 = 5'he == io_rs2_addr ? rf__14 : _GEN_109; // @[RegFile.scala 23:21 RegFile.scala 23:21]
  wire [63:0] _GEN_111 = 5'hf == io_rs2_addr ? rf__15 : _GEN_110; // @[RegFile.scala 23:21 RegFile.scala 23:21]
  wire [63:0] _GEN_112 = 5'h10 == io_rs2_addr ? rf__16 : _GEN_111; // @[RegFile.scala 23:21 RegFile.scala 23:21]
  wire [63:0] _GEN_113 = 5'h11 == io_rs2_addr ? rf__17 : _GEN_112; // @[RegFile.scala 23:21 RegFile.scala 23:21]
  wire [63:0] _GEN_114 = 5'h12 == io_rs2_addr ? rf__18 : _GEN_113; // @[RegFile.scala 23:21 RegFile.scala 23:21]
  wire [63:0] _GEN_115 = 5'h13 == io_rs2_addr ? rf__19 : _GEN_114; // @[RegFile.scala 23:21 RegFile.scala 23:21]
  wire [63:0] _GEN_116 = 5'h14 == io_rs2_addr ? rf__20 : _GEN_115; // @[RegFile.scala 23:21 RegFile.scala 23:21]
  wire [63:0] _GEN_117 = 5'h15 == io_rs2_addr ? rf__21 : _GEN_116; // @[RegFile.scala 23:21 RegFile.scala 23:21]
  wire [63:0] _GEN_118 = 5'h16 == io_rs2_addr ? rf__22 : _GEN_117; // @[RegFile.scala 23:21 RegFile.scala 23:21]
  wire [63:0] _GEN_119 = 5'h17 == io_rs2_addr ? rf__23 : _GEN_118; // @[RegFile.scala 23:21 RegFile.scala 23:21]
  wire [63:0] _GEN_120 = 5'h18 == io_rs2_addr ? rf__24 : _GEN_119; // @[RegFile.scala 23:21 RegFile.scala 23:21]
  wire [63:0] _GEN_121 = 5'h19 == io_rs2_addr ? rf__25 : _GEN_120; // @[RegFile.scala 23:21 RegFile.scala 23:21]
  wire [63:0] _GEN_122 = 5'h1a == io_rs2_addr ? rf__26 : _GEN_121; // @[RegFile.scala 23:21 RegFile.scala 23:21]
  wire [63:0] _GEN_123 = 5'h1b == io_rs2_addr ? rf__27 : _GEN_122; // @[RegFile.scala 23:21 RegFile.scala 23:21]
  wire [63:0] _GEN_124 = 5'h1c == io_rs2_addr ? rf__28 : _GEN_123; // @[RegFile.scala 23:21 RegFile.scala 23:21]
  wire [63:0] _GEN_125 = 5'h1d == io_rs2_addr ? rf__29 : _GEN_124; // @[RegFile.scala 23:21 RegFile.scala 23:21]
  wire [63:0] _GEN_126 = 5'h1e == io_rs2_addr ? rf__30 : _GEN_125; // @[RegFile.scala 23:21 RegFile.scala 23:21]
  wire [63:0] _GEN_127 = 5'h1f == io_rs2_addr ? rf__31 : _GEN_126; // @[RegFile.scala 23:21 RegFile.scala 23:21]
  DifftestArchIntRegState dt_ar ( // @[RegFile.scala 25:21]
    .clock(dt_ar_clock),
    .coreid(dt_ar_coreid),
    .gpr_0(dt_ar_gpr_0),
    .gpr_1(dt_ar_gpr_1),
    .gpr_2(dt_ar_gpr_2),
    .gpr_3(dt_ar_gpr_3),
    .gpr_4(dt_ar_gpr_4),
    .gpr_5(dt_ar_gpr_5),
    .gpr_6(dt_ar_gpr_6),
    .gpr_7(dt_ar_gpr_7),
    .gpr_8(dt_ar_gpr_8),
    .gpr_9(dt_ar_gpr_9),
    .gpr_10(dt_ar_gpr_10),
    .gpr_11(dt_ar_gpr_11),
    .gpr_12(dt_ar_gpr_12),
    .gpr_13(dt_ar_gpr_13),
    .gpr_14(dt_ar_gpr_14),
    .gpr_15(dt_ar_gpr_15),
    .gpr_16(dt_ar_gpr_16),
    .gpr_17(dt_ar_gpr_17),
    .gpr_18(dt_ar_gpr_18),
    .gpr_19(dt_ar_gpr_19),
    .gpr_20(dt_ar_gpr_20),
    .gpr_21(dt_ar_gpr_21),
    .gpr_22(dt_ar_gpr_22),
    .gpr_23(dt_ar_gpr_23),
    .gpr_24(dt_ar_gpr_24),
    .gpr_25(dt_ar_gpr_25),
    .gpr_26(dt_ar_gpr_26),
    .gpr_27(dt_ar_gpr_27),
    .gpr_28(dt_ar_gpr_28),
    .gpr_29(dt_ar_gpr_29),
    .gpr_30(dt_ar_gpr_30),
    .gpr_31(dt_ar_gpr_31)
  );
  assign io_rs1_data = io_rs1_addr != 5'h0 ? _GEN_95 : 64'h0; // @[RegFile.scala 22:21]
  assign io_rs2_data = io_rs2_addr != 5'h0 ? _GEN_127 : 64'h0; // @[RegFile.scala 23:21]
  assign rf_10 = rf__10;
  assign dt_ar_clock = clock; // @[RegFile.scala 26:19]
  assign dt_ar_coreid = 8'h0; // @[RegFile.scala 27:19]
  assign dt_ar_gpr_0 = rf__0; // @[RegFile.scala 28:19]
  assign dt_ar_gpr_1 = rf__1; // @[RegFile.scala 28:19]
  assign dt_ar_gpr_2 = rf__2; // @[RegFile.scala 28:19]
  assign dt_ar_gpr_3 = rf__3; // @[RegFile.scala 28:19]
  assign dt_ar_gpr_4 = rf__4; // @[RegFile.scala 28:19]
  assign dt_ar_gpr_5 = rf__5; // @[RegFile.scala 28:19]
  assign dt_ar_gpr_6 = rf__6; // @[RegFile.scala 28:19]
  assign dt_ar_gpr_7 = rf__7; // @[RegFile.scala 28:19]
  assign dt_ar_gpr_8 = rf__8; // @[RegFile.scala 28:19]
  assign dt_ar_gpr_9 = rf__9; // @[RegFile.scala 28:19]
  assign dt_ar_gpr_10 = rf__10; // @[RegFile.scala 28:19]
  assign dt_ar_gpr_11 = rf__11; // @[RegFile.scala 28:19]
  assign dt_ar_gpr_12 = rf__12; // @[RegFile.scala 28:19]
  assign dt_ar_gpr_13 = rf__13; // @[RegFile.scala 28:19]
  assign dt_ar_gpr_14 = rf__14; // @[RegFile.scala 28:19]
  assign dt_ar_gpr_15 = rf__15; // @[RegFile.scala 28:19]
  assign dt_ar_gpr_16 = rf__16; // @[RegFile.scala 28:19]
  assign dt_ar_gpr_17 = rf__17; // @[RegFile.scala 28:19]
  assign dt_ar_gpr_18 = rf__18; // @[RegFile.scala 28:19]
  assign dt_ar_gpr_19 = rf__19; // @[RegFile.scala 28:19]
  assign dt_ar_gpr_20 = rf__20; // @[RegFile.scala 28:19]
  assign dt_ar_gpr_21 = rf__21; // @[RegFile.scala 28:19]
  assign dt_ar_gpr_22 = rf__22; // @[RegFile.scala 28:19]
  assign dt_ar_gpr_23 = rf__23; // @[RegFile.scala 28:19]
  assign dt_ar_gpr_24 = rf__24; // @[RegFile.scala 28:19]
  assign dt_ar_gpr_25 = rf__25; // @[RegFile.scala 28:19]
  assign dt_ar_gpr_26 = rf__26; // @[RegFile.scala 28:19]
  assign dt_ar_gpr_27 = rf__27; // @[RegFile.scala 28:19]
  assign dt_ar_gpr_28 = rf__28; // @[RegFile.scala 28:19]
  assign dt_ar_gpr_29 = rf__29; // @[RegFile.scala 28:19]
  assign dt_ar_gpr_30 = rf__30; // @[RegFile.scala 28:19]
  assign dt_ar_gpr_31 = rf__31; // @[RegFile.scala 28:19]
  always @(posedge clock) begin
    if (reset) begin // @[RegFile.scala 16:19]
      rf__0 <= 64'h0; // @[RegFile.scala 16:19]
    end else if (io_rd_en & io_rd_addr != 5'h0) begin // @[RegFile.scala 18:43]
      if (5'h0 == io_rd_addr) begin // @[RegFile.scala 19:20]
        rf__0 <= io_rd_data; // @[RegFile.scala 19:20]
      end
    end
    if (reset) begin // @[RegFile.scala 16:19]
      rf__1 <= 64'h0; // @[RegFile.scala 16:19]
    end else if (io_rd_en & io_rd_addr != 5'h0) begin // @[RegFile.scala 18:43]
      if (5'h1 == io_rd_addr) begin // @[RegFile.scala 19:20]
        rf__1 <= io_rd_data; // @[RegFile.scala 19:20]
      end
    end
    if (reset) begin // @[RegFile.scala 16:19]
      rf__2 <= 64'h0; // @[RegFile.scala 16:19]
    end else if (io_rd_en & io_rd_addr != 5'h0) begin // @[RegFile.scala 18:43]
      if (5'h2 == io_rd_addr) begin // @[RegFile.scala 19:20]
        rf__2 <= io_rd_data; // @[RegFile.scala 19:20]
      end
    end
    if (reset) begin // @[RegFile.scala 16:19]
      rf__3 <= 64'h0; // @[RegFile.scala 16:19]
    end else if (io_rd_en & io_rd_addr != 5'h0) begin // @[RegFile.scala 18:43]
      if (5'h3 == io_rd_addr) begin // @[RegFile.scala 19:20]
        rf__3 <= io_rd_data; // @[RegFile.scala 19:20]
      end
    end
    if (reset) begin // @[RegFile.scala 16:19]
      rf__4 <= 64'h0; // @[RegFile.scala 16:19]
    end else if (io_rd_en & io_rd_addr != 5'h0) begin // @[RegFile.scala 18:43]
      if (5'h4 == io_rd_addr) begin // @[RegFile.scala 19:20]
        rf__4 <= io_rd_data; // @[RegFile.scala 19:20]
      end
    end
    if (reset) begin // @[RegFile.scala 16:19]
      rf__5 <= 64'h0; // @[RegFile.scala 16:19]
    end else if (io_rd_en & io_rd_addr != 5'h0) begin // @[RegFile.scala 18:43]
      if (5'h5 == io_rd_addr) begin // @[RegFile.scala 19:20]
        rf__5 <= io_rd_data; // @[RegFile.scala 19:20]
      end
    end
    if (reset) begin // @[RegFile.scala 16:19]
      rf__6 <= 64'h0; // @[RegFile.scala 16:19]
    end else if (io_rd_en & io_rd_addr != 5'h0) begin // @[RegFile.scala 18:43]
      if (5'h6 == io_rd_addr) begin // @[RegFile.scala 19:20]
        rf__6 <= io_rd_data; // @[RegFile.scala 19:20]
      end
    end
    if (reset) begin // @[RegFile.scala 16:19]
      rf__7 <= 64'h0; // @[RegFile.scala 16:19]
    end else if (io_rd_en & io_rd_addr != 5'h0) begin // @[RegFile.scala 18:43]
      if (5'h7 == io_rd_addr) begin // @[RegFile.scala 19:20]
        rf__7 <= io_rd_data; // @[RegFile.scala 19:20]
      end
    end
    if (reset) begin // @[RegFile.scala 16:19]
      rf__8 <= 64'h0; // @[RegFile.scala 16:19]
    end else if (io_rd_en & io_rd_addr != 5'h0) begin // @[RegFile.scala 18:43]
      if (5'h8 == io_rd_addr) begin // @[RegFile.scala 19:20]
        rf__8 <= io_rd_data; // @[RegFile.scala 19:20]
      end
    end
    if (reset) begin // @[RegFile.scala 16:19]
      rf__9 <= 64'h0; // @[RegFile.scala 16:19]
    end else if (io_rd_en & io_rd_addr != 5'h0) begin // @[RegFile.scala 18:43]
      if (5'h9 == io_rd_addr) begin // @[RegFile.scala 19:20]
        rf__9 <= io_rd_data; // @[RegFile.scala 19:20]
      end
    end
    if (reset) begin // @[RegFile.scala 16:19]
      rf__10 <= 64'h0; // @[RegFile.scala 16:19]
    end else if (io_rd_en & io_rd_addr != 5'h0) begin // @[RegFile.scala 18:43]
      if (5'ha == io_rd_addr) begin // @[RegFile.scala 19:20]
        rf__10 <= io_rd_data; // @[RegFile.scala 19:20]
      end
    end
    if (reset) begin // @[RegFile.scala 16:19]
      rf__11 <= 64'h0; // @[RegFile.scala 16:19]
    end else if (io_rd_en & io_rd_addr != 5'h0) begin // @[RegFile.scala 18:43]
      if (5'hb == io_rd_addr) begin // @[RegFile.scala 19:20]
        rf__11 <= io_rd_data; // @[RegFile.scala 19:20]
      end
    end
    if (reset) begin // @[RegFile.scala 16:19]
      rf__12 <= 64'h0; // @[RegFile.scala 16:19]
    end else if (io_rd_en & io_rd_addr != 5'h0) begin // @[RegFile.scala 18:43]
      if (5'hc == io_rd_addr) begin // @[RegFile.scala 19:20]
        rf__12 <= io_rd_data; // @[RegFile.scala 19:20]
      end
    end
    if (reset) begin // @[RegFile.scala 16:19]
      rf__13 <= 64'h0; // @[RegFile.scala 16:19]
    end else if (io_rd_en & io_rd_addr != 5'h0) begin // @[RegFile.scala 18:43]
      if (5'hd == io_rd_addr) begin // @[RegFile.scala 19:20]
        rf__13 <= io_rd_data; // @[RegFile.scala 19:20]
      end
    end
    if (reset) begin // @[RegFile.scala 16:19]
      rf__14 <= 64'h0; // @[RegFile.scala 16:19]
    end else if (io_rd_en & io_rd_addr != 5'h0) begin // @[RegFile.scala 18:43]
      if (5'he == io_rd_addr) begin // @[RegFile.scala 19:20]
        rf__14 <= io_rd_data; // @[RegFile.scala 19:20]
      end
    end
    if (reset) begin // @[RegFile.scala 16:19]
      rf__15 <= 64'h0; // @[RegFile.scala 16:19]
    end else if (io_rd_en & io_rd_addr != 5'h0) begin // @[RegFile.scala 18:43]
      if (5'hf == io_rd_addr) begin // @[RegFile.scala 19:20]
        rf__15 <= io_rd_data; // @[RegFile.scala 19:20]
      end
    end
    if (reset) begin // @[RegFile.scala 16:19]
      rf__16 <= 64'h0; // @[RegFile.scala 16:19]
    end else if (io_rd_en & io_rd_addr != 5'h0) begin // @[RegFile.scala 18:43]
      if (5'h10 == io_rd_addr) begin // @[RegFile.scala 19:20]
        rf__16 <= io_rd_data; // @[RegFile.scala 19:20]
      end
    end
    if (reset) begin // @[RegFile.scala 16:19]
      rf__17 <= 64'h0; // @[RegFile.scala 16:19]
    end else if (io_rd_en & io_rd_addr != 5'h0) begin // @[RegFile.scala 18:43]
      if (5'h11 == io_rd_addr) begin // @[RegFile.scala 19:20]
        rf__17 <= io_rd_data; // @[RegFile.scala 19:20]
      end
    end
    if (reset) begin // @[RegFile.scala 16:19]
      rf__18 <= 64'h0; // @[RegFile.scala 16:19]
    end else if (io_rd_en & io_rd_addr != 5'h0) begin // @[RegFile.scala 18:43]
      if (5'h12 == io_rd_addr) begin // @[RegFile.scala 19:20]
        rf__18 <= io_rd_data; // @[RegFile.scala 19:20]
      end
    end
    if (reset) begin // @[RegFile.scala 16:19]
      rf__19 <= 64'h0; // @[RegFile.scala 16:19]
    end else if (io_rd_en & io_rd_addr != 5'h0) begin // @[RegFile.scala 18:43]
      if (5'h13 == io_rd_addr) begin // @[RegFile.scala 19:20]
        rf__19 <= io_rd_data; // @[RegFile.scala 19:20]
      end
    end
    if (reset) begin // @[RegFile.scala 16:19]
      rf__20 <= 64'h0; // @[RegFile.scala 16:19]
    end else if (io_rd_en & io_rd_addr != 5'h0) begin // @[RegFile.scala 18:43]
      if (5'h14 == io_rd_addr) begin // @[RegFile.scala 19:20]
        rf__20 <= io_rd_data; // @[RegFile.scala 19:20]
      end
    end
    if (reset) begin // @[RegFile.scala 16:19]
      rf__21 <= 64'h0; // @[RegFile.scala 16:19]
    end else if (io_rd_en & io_rd_addr != 5'h0) begin // @[RegFile.scala 18:43]
      if (5'h15 == io_rd_addr) begin // @[RegFile.scala 19:20]
        rf__21 <= io_rd_data; // @[RegFile.scala 19:20]
      end
    end
    if (reset) begin // @[RegFile.scala 16:19]
      rf__22 <= 64'h0; // @[RegFile.scala 16:19]
    end else if (io_rd_en & io_rd_addr != 5'h0) begin // @[RegFile.scala 18:43]
      if (5'h16 == io_rd_addr) begin // @[RegFile.scala 19:20]
        rf__22 <= io_rd_data; // @[RegFile.scala 19:20]
      end
    end
    if (reset) begin // @[RegFile.scala 16:19]
      rf__23 <= 64'h0; // @[RegFile.scala 16:19]
    end else if (io_rd_en & io_rd_addr != 5'h0) begin // @[RegFile.scala 18:43]
      if (5'h17 == io_rd_addr) begin // @[RegFile.scala 19:20]
        rf__23 <= io_rd_data; // @[RegFile.scala 19:20]
      end
    end
    if (reset) begin // @[RegFile.scala 16:19]
      rf__24 <= 64'h0; // @[RegFile.scala 16:19]
    end else if (io_rd_en & io_rd_addr != 5'h0) begin // @[RegFile.scala 18:43]
      if (5'h18 == io_rd_addr) begin // @[RegFile.scala 19:20]
        rf__24 <= io_rd_data; // @[RegFile.scala 19:20]
      end
    end
    if (reset) begin // @[RegFile.scala 16:19]
      rf__25 <= 64'h0; // @[RegFile.scala 16:19]
    end else if (io_rd_en & io_rd_addr != 5'h0) begin // @[RegFile.scala 18:43]
      if (5'h19 == io_rd_addr) begin // @[RegFile.scala 19:20]
        rf__25 <= io_rd_data; // @[RegFile.scala 19:20]
      end
    end
    if (reset) begin // @[RegFile.scala 16:19]
      rf__26 <= 64'h0; // @[RegFile.scala 16:19]
    end else if (io_rd_en & io_rd_addr != 5'h0) begin // @[RegFile.scala 18:43]
      if (5'h1a == io_rd_addr) begin // @[RegFile.scala 19:20]
        rf__26 <= io_rd_data; // @[RegFile.scala 19:20]
      end
    end
    if (reset) begin // @[RegFile.scala 16:19]
      rf__27 <= 64'h0; // @[RegFile.scala 16:19]
    end else if (io_rd_en & io_rd_addr != 5'h0) begin // @[RegFile.scala 18:43]
      if (5'h1b == io_rd_addr) begin // @[RegFile.scala 19:20]
        rf__27 <= io_rd_data; // @[RegFile.scala 19:20]
      end
    end
    if (reset) begin // @[RegFile.scala 16:19]
      rf__28 <= 64'h0; // @[RegFile.scala 16:19]
    end else if (io_rd_en & io_rd_addr != 5'h0) begin // @[RegFile.scala 18:43]
      if (5'h1c == io_rd_addr) begin // @[RegFile.scala 19:20]
        rf__28 <= io_rd_data; // @[RegFile.scala 19:20]
      end
    end
    if (reset) begin // @[RegFile.scala 16:19]
      rf__29 <= 64'h0; // @[RegFile.scala 16:19]
    end else if (io_rd_en & io_rd_addr != 5'h0) begin // @[RegFile.scala 18:43]
      if (5'h1d == io_rd_addr) begin // @[RegFile.scala 19:20]
        rf__29 <= io_rd_data; // @[RegFile.scala 19:20]
      end
    end
    if (reset) begin // @[RegFile.scala 16:19]
      rf__30 <= 64'h0; // @[RegFile.scala 16:19]
    end else if (io_rd_en & io_rd_addr != 5'h0) begin // @[RegFile.scala 18:43]
      if (5'h1e == io_rd_addr) begin // @[RegFile.scala 19:20]
        rf__30 <= io_rd_data; // @[RegFile.scala 19:20]
      end
    end
    if (reset) begin // @[RegFile.scala 16:19]
      rf__31 <= 64'h0; // @[RegFile.scala 16:19]
    end else if (io_rd_en & io_rd_addr != 5'h0) begin // @[RegFile.scala 18:43]
      if (5'h1f == io_rd_addr) begin // @[RegFile.scala 19:20]
        rf__31 <= io_rd_data; // @[RegFile.scala 19:20]
      end
    end
  end
// Register and memory initialization
`ifdef RANDOMIZE_GARBAGE_ASSIGN
`define RANDOMIZE
`endif
`ifdef RANDOMIZE_INVALID_ASSIGN
`define RANDOMIZE
`endif
`ifdef RANDOMIZE_REG_INIT
`define RANDOMIZE
`endif
`ifdef RANDOMIZE_MEM_INIT
`define RANDOMIZE
`endif
`ifndef RANDOM
`define RANDOM $random
`endif
`ifdef RANDOMIZE_MEM_INIT
  integer initvar;
`endif
`ifndef SYNTHESIS
`ifdef FIRRTL_BEFORE_INITIAL
`FIRRTL_BEFORE_INITIAL
`endif
initial begin
  `ifdef RANDOMIZE
    `ifdef INIT_RANDOM
      `INIT_RANDOM
    `endif
    `ifndef VERILATOR
      `ifdef RANDOMIZE_DELAY
        #`RANDOMIZE_DELAY begin end
      `else
        #0.002 begin end
      `endif
    `endif
`ifdef RANDOMIZE_REG_INIT
  _RAND_0 = {2{`RANDOM}};
  rf__0 = _RAND_0[63:0];
  _RAND_1 = {2{`RANDOM}};
  rf__1 = _RAND_1[63:0];
  _RAND_2 = {2{`RANDOM}};
  rf__2 = _RAND_2[63:0];
  _RAND_3 = {2{`RANDOM}};
  rf__3 = _RAND_3[63:0];
  _RAND_4 = {2{`RANDOM}};
  rf__4 = _RAND_4[63:0];
  _RAND_5 = {2{`RANDOM}};
  rf__5 = _RAND_5[63:0];
  _RAND_6 = {2{`RANDOM}};
  rf__6 = _RAND_6[63:0];
  _RAND_7 = {2{`RANDOM}};
  rf__7 = _RAND_7[63:0];
  _RAND_8 = {2{`RANDOM}};
  rf__8 = _RAND_8[63:0];
  _RAND_9 = {2{`RANDOM}};
  rf__9 = _RAND_9[63:0];
  _RAND_10 = {2{`RANDOM}};
  rf__10 = _RAND_10[63:0];
  _RAND_11 = {2{`RANDOM}};
  rf__11 = _RAND_11[63:0];
  _RAND_12 = {2{`RANDOM}};
  rf__12 = _RAND_12[63:0];
  _RAND_13 = {2{`RANDOM}};
  rf__13 = _RAND_13[63:0];
  _RAND_14 = {2{`RANDOM}};
  rf__14 = _RAND_14[63:0];
  _RAND_15 = {2{`RANDOM}};
  rf__15 = _RAND_15[63:0];
  _RAND_16 = {2{`RANDOM}};
  rf__16 = _RAND_16[63:0];
  _RAND_17 = {2{`RANDOM}};
  rf__17 = _RAND_17[63:0];
  _RAND_18 = {2{`RANDOM}};
  rf__18 = _RAND_18[63:0];
  _RAND_19 = {2{`RANDOM}};
  rf__19 = _RAND_19[63:0];
  _RAND_20 = {2{`RANDOM}};
  rf__20 = _RAND_20[63:0];
  _RAND_21 = {2{`RANDOM}};
  rf__21 = _RAND_21[63:0];
  _RAND_22 = {2{`RANDOM}};
  rf__22 = _RAND_22[63:0];
  _RAND_23 = {2{`RANDOM}};
  rf__23 = _RAND_23[63:0];
  _RAND_24 = {2{`RANDOM}};
  rf__24 = _RAND_24[63:0];
  _RAND_25 = {2{`RANDOM}};
  rf__25 = _RAND_25[63:0];
  _RAND_26 = {2{`RANDOM}};
  rf__26 = _RAND_26[63:0];
  _RAND_27 = {2{`RANDOM}};
  rf__27 = _RAND_27[63:0];
  _RAND_28 = {2{`RANDOM}};
  rf__28 = _RAND_28[63:0];
  _RAND_29 = {2{`RANDOM}};
  rf__29 = _RAND_29[63:0];
  _RAND_30 = {2{`RANDOM}};
  rf__30 = _RAND_30[63:0];
  _RAND_31 = {2{`RANDOM}};
  rf__31 = _RAND_31[63:0];
`endif // RANDOMIZE_REG_INIT
  `endif // RANDOMIZE
end // initial
`ifdef FIRRTL_AFTER_INITIAL
`FIRRTL_AFTER_INITIAL
`endif
`endif // SYNTHESIS
endmodule
module Csr(
  input         clock,
  input         reset,
  input  [11:0] io_raddr,
  output [63:0] io_rdata,
  input         io_wen,
  input  [11:0] io_waddr,
  input  [63:0] io_wdata,
  input         io_csru_code_valid,
  input  [7:0]  io_csru_code,
  input  [63:0] io_pc,
  output [63:0] io_mtvec,
  output [63:0] io_mepc
);
`ifdef RANDOMIZE_REG_INIT
  reg [63:0] _RAND_0;
  reg [63:0] _RAND_1;
  reg [63:0] _RAND_2;
  reg [63:0] _RAND_3;
  reg [63:0] _RAND_4;
  reg [63:0] _RAND_5;
  reg [63:0] _RAND_6;
  reg [63:0] _RAND_7;
  reg [63:0] _RAND_8;
  reg [63:0] _RAND_9;
`endif // RANDOMIZE_REG_INIT
  wire  dt_cs_clock; // @[Csr.scala 105:23]
  wire [7:0] dt_cs_coreid; // @[Csr.scala 105:23]
  wire [1:0] dt_cs_priviledgeMode; // @[Csr.scala 105:23]
  wire [63:0] dt_cs_mstatus; // @[Csr.scala 105:23]
  wire [63:0] dt_cs_sstatus; // @[Csr.scala 105:23]
  wire [63:0] dt_cs_mepc; // @[Csr.scala 105:23]
  wire [63:0] dt_cs_sepc; // @[Csr.scala 105:23]
  wire [63:0] dt_cs_mtval; // @[Csr.scala 105:23]
  wire [63:0] dt_cs_stval; // @[Csr.scala 105:23]
  wire [63:0] dt_cs_mtvec; // @[Csr.scala 105:23]
  wire [63:0] dt_cs_stvec; // @[Csr.scala 105:23]
  wire [63:0] dt_cs_mcause; // @[Csr.scala 105:23]
  wire [63:0] dt_cs_scause; // @[Csr.scala 105:23]
  wire [63:0] dt_cs_satp; // @[Csr.scala 105:23]
  wire [63:0] dt_cs_mip; // @[Csr.scala 105:23]
  wire [63:0] dt_cs_mie; // @[Csr.scala 105:23]
  wire [63:0] dt_cs_mscratch; // @[Csr.scala 105:23]
  wire [63:0] dt_cs_sscratch; // @[Csr.scala 105:23]
  wire [63:0] dt_cs_mideleg; // @[Csr.scala 105:23]
  wire [63:0] dt_cs_medeleg; // @[Csr.scala 105:23]
  reg [63:0] mstatus; // @[Csr.scala 40:30]
  reg [63:0] mtvec; // @[Csr.scala 41:30]
  reg [63:0] mepc; // @[Csr.scala 42:30]
  reg [63:0] mcause; // @[Csr.scala 43:30]
  reg [63:0] mcycle; // @[Csr.scala 44:30]
  reg [63:0] mhartid; // @[Csr.scala 46:30]
  reg [63:0] mie; // @[Csr.scala 47:30]
  reg [63:0] mip; // @[Csr.scala 48:30]
  reg [63:0] mscratch; // @[Csr.scala 49:30]
  reg [63:0] satp; // @[Csr.scala 50:30]
  wire [63:0] _io_rdata_T_1 = 12'h300 == io_raddr ? mstatus : 64'h0; // @[Mux.scala 80:57]
  wire [63:0] _io_rdata_T_3 = 12'h305 == io_raddr ? mtvec : _io_rdata_T_1; // @[Mux.scala 80:57]
  wire [63:0] _io_rdata_T_5 = 12'h341 == io_raddr ? mepc : _io_rdata_T_3; // @[Mux.scala 80:57]
  wire [63:0] _io_rdata_T_7 = 12'h342 == io_raddr ? mcause : _io_rdata_T_5; // @[Mux.scala 80:57]
  wire [63:0] _io_rdata_T_9 = 12'hb00 == io_raddr ? mcycle : _io_rdata_T_7; // @[Mux.scala 80:57]
  wire [63:0] _io_rdata_T_11 = 12'hf14 == io_raddr ? mhartid : _io_rdata_T_9; // @[Mux.scala 80:57]
  wire [63:0] _io_rdata_T_13 = 12'h304 == io_raddr ? mie : _io_rdata_T_11; // @[Mux.scala 80:57]
  wire [63:0] _io_rdata_T_15 = 12'h344 == io_raddr ? mip : _io_rdata_T_13; // @[Mux.scala 80:57]
  wire [63:0] _io_rdata_T_17 = 12'h340 == io_raddr ? mscratch : _io_rdata_T_15; // @[Mux.scala 80:57]
  wire [63:0] _mcycle_T_3 = mcycle + 64'h1; // @[Csr.scala 65:68]
  wire  mstatus_SD = io_wdata[14:13] == 2'h3 | io_wdata[16:15] == 2'h3; // @[Csr.scala 67:60]
  wire [62:0] mstatus_lo = io_wdata[62:0]; // @[Csr.scala 69:44]
  wire [63:0] _mstatus_T = {mstatus_SD,mstatus_lo}; // @[Cat.scala 30:58]
  wire  _T_3 = io_csru_code_valid & io_csru_code == 8'h1; // @[Csr.scala 71:34]
  wire [50:0] mstatus_hi_hi_hi = mstatus[63:13]; // @[Csr.scala 72:31]
  wire [2:0] mstatus_hi_lo_hi = mstatus[10:8]; // @[Csr.scala 72:61]
  wire  mstatus_hi_lo_lo = mstatus[3]; // @[Csr.scala 72:76]
  wire [2:0] mstatus_lo_hi_hi = mstatus[6:4]; // @[Csr.scala 72:88]
  wire [2:0] mstatus_lo_lo = mstatus[2:0]; // @[Csr.scala 72:108]
  wire [63:0] _mstatus_T_1 = {mstatus_hi_hi_hi,2'h3,mstatus_hi_lo_hi,mstatus_hi_lo_lo,mstatus_lo_hi_hi,1'h0,
    mstatus_lo_lo}; // @[Cat.scala 30:58]
  wire  mstatus_lo_hi_lo = mstatus[7]; // @[Csr.scala 75:96]
  wire [63:0] _mstatus_T_2 = {mstatus_hi_hi_hi,2'h0,mstatus_hi_lo_hi,1'h1,mstatus_lo_hi_hi,mstatus_lo_hi_lo,
    mstatus_lo_lo}; // @[Cat.scala 30:58]
  DifftestCSRState dt_cs ( // @[Csr.scala 105:23]
    .clock(dt_cs_clock),
    .coreid(dt_cs_coreid),
    .priviledgeMode(dt_cs_priviledgeMode),
    .mstatus(dt_cs_mstatus),
    .sstatus(dt_cs_sstatus),
    .mepc(dt_cs_mepc),
    .sepc(dt_cs_sepc),
    .mtval(dt_cs_mtval),
    .stval(dt_cs_stval),
    .mtvec(dt_cs_mtvec),
    .stvec(dt_cs_stvec),
    .mcause(dt_cs_mcause),
    .scause(dt_cs_scause),
    .satp(dt_cs_satp),
    .mip(dt_cs_mip),
    .mie(dt_cs_mie),
    .mscratch(dt_cs_mscratch),
    .sscratch(dt_cs_sscratch),
    .mideleg(dt_cs_mideleg),
    .medeleg(dt_cs_medeleg)
  );
  assign io_rdata = 12'h180 == io_raddr ? satp : _io_rdata_T_17; // @[Mux.scala 80:57]
  assign io_mtvec = mtvec; // @[Csr.scala 99:14]
  assign io_mepc = mepc; // @[Csr.scala 100:14]
  assign dt_cs_clock = clock; // @[Csr.scala 106:29]
  assign dt_cs_coreid = 8'h0; // @[Csr.scala 107:29]
  assign dt_cs_priviledgeMode = 2'h3; // @[Csr.scala 108:29]
  assign dt_cs_mstatus = mstatus; // @[Csr.scala 109:29]
  assign dt_cs_sstatus = mstatus & 64'h80000003000de122; // @[Csr.scala 110:40]
  assign dt_cs_mepc = mepc; // @[Csr.scala 111:29]
  assign dt_cs_sepc = 64'h0; // @[Csr.scala 112:29]
  assign dt_cs_mtval = 64'h0; // @[Csr.scala 113:29]
  assign dt_cs_stval = 64'h0; // @[Csr.scala 114:29]
  assign dt_cs_mtvec = mtvec; // @[Csr.scala 115:29]
  assign dt_cs_stvec = 64'h0; // @[Csr.scala 116:29]
  assign dt_cs_mcause = mcause; // @[Csr.scala 117:29]
  assign dt_cs_scause = 64'h0; // @[Csr.scala 118:29]
  assign dt_cs_satp = satp; // @[Csr.scala 119:29]
  assign dt_cs_mip = mip; // @[Csr.scala 120:29]
  assign dt_cs_mie = mie; // @[Csr.scala 121:29]
  assign dt_cs_mscratch = mscratch; // @[Csr.scala 122:29]
  assign dt_cs_sscratch = 64'h0; // @[Csr.scala 123:29]
  assign dt_cs_mideleg = 64'h0; // @[Csr.scala 124:29]
  assign dt_cs_medeleg = 64'h0; // @[Csr.scala 125:29]
  always @(posedge clock) begin
    if (reset) begin // @[Csr.scala 40:30]
      mstatus <= 64'h1800; // @[Csr.scala 40:30]
    end else if (io_wen & io_waddr == 12'h300) begin // @[Csr.scala 68:41]
      mstatus <= _mstatus_T; // @[Csr.scala 69:17]
    end else if (io_csru_code_valid & io_csru_code == 8'h1) begin // @[Csr.scala 71:64]
      mstatus <= _mstatus_T_1; // @[Csr.scala 72:17]
    end else if (io_csru_code_valid & io_csru_code == 8'h2) begin // @[Csr.scala 74:64]
      mstatus <= _mstatus_T_2; // @[Csr.scala 75:17]
    end
    if (reset) begin // @[Csr.scala 41:30]
      mtvec <= 64'h0; // @[Csr.scala 41:30]
    end else if (io_wen & io_waddr == 12'h305) begin // @[Csr.scala 81:19]
      mtvec <= io_wdata;
    end
    if (reset) begin // @[Csr.scala 42:30]
      mepc <= 64'h0; // @[Csr.scala 42:30]
    end else if (io_wen & io_waddr == 12'h341) begin // @[Csr.scala 83:39]
      mepc <= io_wdata; // @[Csr.scala 83:45]
    end else if (_T_3) begin // @[Csr.scala 84:65]
      mepc <= io_pc; // @[Csr.scala 84:71]
    end
    if (reset) begin // @[Csr.scala 43:30]
      mcause <= 64'h0; // @[Csr.scala 43:30]
    end else if (io_wen & io_waddr == 12'h342) begin // @[Csr.scala 88:41]
      mcause <= io_wdata; // @[Csr.scala 88:49]
    end else if (_T_3) begin // @[Csr.scala 89:65]
      mcause <= 64'hb; // @[Csr.scala 89:73]
    end
    if (reset) begin // @[Csr.scala 44:30]
      mcycle <= 64'h0; // @[Csr.scala 44:30]
    end else if (io_wen & io_waddr == 12'hb00) begin // @[Csr.scala 65:19]
      mcycle <= io_wdata;
    end else begin
      mcycle <= _mcycle_T_3;
    end
    if (reset) begin // @[Csr.scala 46:30]
      mhartid <= 64'h0; // @[Csr.scala 46:30]
    end else if (io_wen & io_waddr == 12'hf14) begin // @[Csr.scala 92:23]
      mhartid <= io_wdata;
    end
    if (reset) begin // @[Csr.scala 47:30]
      mie <= 64'h0; // @[Csr.scala 47:30]
    end else if (io_wen & io_waddr == 12'h304) begin // @[Csr.scala 93:23]
      mie <= io_wdata;
    end
    if (reset) begin // @[Csr.scala 48:30]
      mip <= 64'h0; // @[Csr.scala 48:30]
    end else if (io_wen & io_waddr == 12'h344) begin // @[Csr.scala 94:23]
      mip <= io_wdata;
    end
    if (reset) begin // @[Csr.scala 49:30]
      mscratch <= 64'h0; // @[Csr.scala 49:30]
    end else if (io_wen & io_waddr == 12'h340) begin // @[Csr.scala 95:23]
      mscratch <= io_wdata;
    end
    if (reset) begin // @[Csr.scala 50:30]
      satp <= 64'h0; // @[Csr.scala 50:30]
    end else if (io_wen & io_waddr == 12'h180) begin // @[Csr.scala 96:23]
      satp <= io_wdata;
    end
  end
// Register and memory initialization
`ifdef RANDOMIZE_GARBAGE_ASSIGN
`define RANDOMIZE
`endif
`ifdef RANDOMIZE_INVALID_ASSIGN
`define RANDOMIZE
`endif
`ifdef RANDOMIZE_REG_INIT
`define RANDOMIZE
`endif
`ifdef RANDOMIZE_MEM_INIT
`define RANDOMIZE
`endif
`ifndef RANDOM
`define RANDOM $random
`endif
`ifdef RANDOMIZE_MEM_INIT
  integer initvar;
`endif
`ifndef SYNTHESIS
`ifdef FIRRTL_BEFORE_INITIAL
`FIRRTL_BEFORE_INITIAL
`endif
initial begin
  `ifdef RANDOMIZE
    `ifdef INIT_RANDOM
      `INIT_RANDOM
    `endif
    `ifndef VERILATOR
      `ifdef RANDOMIZE_DELAY
        #`RANDOMIZE_DELAY begin end
      `else
        #0.002 begin end
      `endif
    `endif
`ifdef RANDOMIZE_REG_INIT
  _RAND_0 = {2{`RANDOM}};
  mstatus = _RAND_0[63:0];
  _RAND_1 = {2{`RANDOM}};
  mtvec = _RAND_1[63:0];
  _RAND_2 = {2{`RANDOM}};
  mepc = _RAND_2[63:0];
  _RAND_3 = {2{`RANDOM}};
  mcause = _RAND_3[63:0];
  _RAND_4 = {2{`RANDOM}};
  mcycle = _RAND_4[63:0];
  _RAND_5 = {2{`RANDOM}};
  mhartid = _RAND_5[63:0];
  _RAND_6 = {2{`RANDOM}};
  mie = _RAND_6[63:0];
  _RAND_7 = {2{`RANDOM}};
  mip = _RAND_7[63:0];
  _RAND_8 = {2{`RANDOM}};
  mscratch = _RAND_8[63:0];
  _RAND_9 = {2{`RANDOM}};
  satp = _RAND_9[63:0];
`endif // RANDOMIZE_REG_INIT
  `endif // RANDOMIZE
end // initial
`ifdef FIRRTL_AFTER_INITIAL
`FIRRTL_AFTER_INITIAL
`endif
`endif // SYNTHESIS
endmodule
module PreAccessMemory(
  input  [6:0]  io_lu_code,
  input  [3:0]  io_su_code,
  input  [63:0] io_op1,
  input  [63:0] io_op2,
  input  [63:0] io_imm,
  output [5:0]  io_lu_shift,
  output        io_ren,
  output [63:0] io_raddr,
  output        io_wen,
  output [63:0] io_waddr,
  output [63:0] io_wdata,
  output [7:0]  io_wmask
);
  wire [63:0] lu_offset = io_op1 + io_op2; // @[PreAccessMemory.scala 23:28]
  wire [63:0] su_offset = io_op1 + io_imm; // @[PreAccessMemory.scala 29:28]
  wire [5:0] su_shift = {su_offset[2:0], 3'h0}; // @[PreAccessMemory.scala 30:37]
  wire [126:0] _GEN_0 = {{63'd0}, io_op2}; // @[PreAccessMemory.scala 33:28]
  wire [126:0] su_wdata = _GEN_0 << su_shift; // @[PreAccessMemory.scala 33:28]
  wire [7:0] _su_wmask_T_1 = 8'h1 << su_offset[2:0]; // @[PreAccessMemory.scala 35:37]
  wire [8:0] _su_wmask_T_3 = 9'h3 << su_offset[2:0]; // @[PreAccessMemory.scala 36:37]
  wire [10:0] _su_wmask_T_5 = 11'hf << su_offset[2:0]; // @[PreAccessMemory.scala 37:37]
  wire [7:0] _su_wmask_T_7 = 4'h1 == io_su_code ? _su_wmask_T_1 : 8'h0; // @[Mux.scala 80:57]
  wire [8:0] _su_wmask_T_9 = 4'h2 == io_su_code ? _su_wmask_T_3 : {{1'd0}, _su_wmask_T_7}; // @[Mux.scala 80:57]
  wire [10:0] _su_wmask_T_11 = 4'h4 == io_su_code ? _su_wmask_T_5 : {{2'd0}, _su_wmask_T_9}; // @[Mux.scala 80:57]
  wire [10:0] su_wmask = 4'h8 == io_su_code ? 11'hff : _su_wmask_T_11; // @[Mux.scala 80:57]
  assign io_lu_shift = {lu_offset[2:0], 3'h0}; // @[PreAccessMemory.scala 24:36]
  assign io_ren = io_lu_code != 7'h0; // @[PreAccessMemory.scala 25:29]
  assign io_raddr = lu_offset & 64'hfffffffffffffff8; // @[PreAccessMemory.scala 26:30]
  assign io_wen = io_su_code != 4'h0; // @[PreAccessMemory.scala 31:32]
  assign io_waddr = su_offset & 64'hfffffffffffffff8; // @[PreAccessMemory.scala 32:31]
  assign io_wdata = su_wdata[63:0]; // @[PreAccessMemory.scala 46:17]
  assign io_wmask = su_wmask[7:0]; // @[PreAccessMemory.scala 47:17]
endmodule
module AccessMemory(
  input  [6:0]  io_lu_code,
  input  [5:0]  io_lu_shift,
  input  [63:0] io_rdata,
  output [63:0] io_lu_out
);
  wire [63:0] _io_lu_out_T = io_rdata >> io_lu_shift; // @[AccessMemory.scala 23:41]
  wire [55:0] io_lu_out_hi = _io_lu_out_T[7] ? 56'hffffffffffffff : 56'h0; // @[Bitwise.scala 72:12]
  wire [7:0] io_lu_out_lo = _io_lu_out_T[7:0]; // @[AccessMemory.scala 13:40]
  wire [63:0] _io_lu_out_T_3 = {io_lu_out_hi,io_lu_out_lo}; // @[Cat.scala 30:58]
  wire [47:0] io_lu_out_hi_1 = _io_lu_out_T[15] ? 48'hffffffffffff : 48'h0; // @[Bitwise.scala 72:12]
  wire [15:0] io_lu_out_lo_1 = _io_lu_out_T[15:0]; // @[AccessMemory.scala 14:41]
  wire [63:0] _io_lu_out_T_7 = {io_lu_out_hi_1,io_lu_out_lo_1}; // @[Cat.scala 30:58]
  wire [31:0] io_lu_out_hi_2 = _io_lu_out_T[31] ? 32'hffffffff : 32'h0; // @[Bitwise.scala 72:12]
  wire [31:0] io_lu_out_lo_2 = _io_lu_out_T[31:0]; // @[AccessMemory.scala 15:41]
  wire [63:0] _io_lu_out_T_11 = {io_lu_out_hi_2,io_lu_out_lo_2}; // @[Cat.scala 30:58]
  wire [63:0] _io_lu_out_T_14 = {56'h0,io_lu_out_lo}; // @[Cat.scala 30:58]
  wire [63:0] _io_lu_out_T_16 = {48'h0,io_lu_out_lo_1}; // @[Cat.scala 30:58]
  wire [63:0] _io_lu_out_T_18 = {32'h0,io_lu_out_lo_2}; // @[Cat.scala 30:58]
  wire [63:0] _io_lu_out_T_20 = 7'h1 == io_lu_code ? _io_lu_out_T_3 : 64'h0; // @[Mux.scala 80:57]
  wire [63:0] _io_lu_out_T_22 = 7'h2 == io_lu_code ? _io_lu_out_T_7 : _io_lu_out_T_20; // @[Mux.scala 80:57]
  wire [63:0] _io_lu_out_T_24 = 7'h4 == io_lu_code ? _io_lu_out_T_11 : _io_lu_out_T_22; // @[Mux.scala 80:57]
  wire [63:0] _io_lu_out_T_26 = 7'h8 == io_lu_code ? _io_lu_out_T : _io_lu_out_T_24; // @[Mux.scala 80:57]
  wire [63:0] _io_lu_out_T_28 = 7'h10 == io_lu_code ? _io_lu_out_T_14 : _io_lu_out_T_26; // @[Mux.scala 80:57]
  wire [63:0] _io_lu_out_T_30 = 7'h20 == io_lu_code ? _io_lu_out_T_16 : _io_lu_out_T_28; // @[Mux.scala 80:57]
  assign io_lu_out = 7'h40 == io_lu_code ? _io_lu_out_T_18 : _io_lu_out_T_30; // @[Mux.scala 80:57]
endmodule
module WriteBack(
  input  [5:0]  io_fu_code,
  input  [63:0] io_alu_out,
  input  [63:0] io_bu_out,
  input  [63:0] io_mdu_out,
  input  [63:0] io_lu_out,
  input  [63:0] io_csru_out,
  output [63:0] io_out
);
  wire [63:0] _io_out_T_1 = 6'h1 == io_fu_code ? io_alu_out : 64'h0; // @[Mux.scala 80:57]
  wire [63:0] _io_out_T_3 = 6'h2 == io_fu_code ? io_bu_out : _io_out_T_1; // @[Mux.scala 80:57]
  wire [63:0] _io_out_T_5 = 6'h4 == io_fu_code ? io_lu_out : _io_out_T_3; // @[Mux.scala 80:57]
  wire [63:0] _io_out_T_7 = 6'h8 == io_fu_code ? 64'h0 : _io_out_T_5; // @[Mux.scala 80:57]
  wire [63:0] _io_out_T_9 = 6'h10 == io_fu_code ? io_mdu_out : _io_out_T_7; // @[Mux.scala 80:57]
  assign io_out = 6'h20 == io_fu_code ? io_csru_out : _io_out_T_9; // @[Mux.scala 80:57]
endmodule
module CorrelationConflict(
  input        io_rs_valid,
  input        io_rd_valid,
  input        io_rs1_en,
  input        io_rs2_en,
  input  [4:0] io_rs1_addr,
  input  [4:0] io_rs2_addr,
  input        io_rd_en,
  input  [4:0] io_rd_addr,
  output       io_conflict
);
  wire  inst_valid = io_rs_valid & io_rd_valid; // @[PipelineReg.scala 156:39]
  wire  rs1_conflict = io_rs1_en & io_rs1_addr == io_rd_addr; // @[PipelineReg.scala 157:37]
  wire  rs2_conflict = io_rs2_en & io_rs2_addr == io_rd_addr; // @[PipelineReg.scala 158:37]
  wire  rd_valid = io_rd_addr != 5'h0 & io_rd_en; // @[PipelineReg.scala 159:48]
  assign io_conflict = inst_valid & rd_valid & (rs1_conflict | rs2_conflict); // @[PipelineReg.scala 161:43]
endmodule
module RegfileConflict(
  input        io_rs_valid,
  input        io_rs1_en,
  input        io_rs2_en,
  input  [4:0] io_rs1_addr,
  input  [4:0] io_rs2_addr,
  input        io_rd1_valid,
  input        io_rd1_en,
  input  [4:0] io_rd1_addr,
  input        io_rd2_valid,
  input        io_rd2_en,
  input  [4:0] io_rd2_addr,
  input        io_rd3_valid,
  input        io_rd3_en,
  input  [4:0] io_rd3_addr,
  output       io_conflict
);
  wire  cconflict1_io_rs_valid; // @[PipelineReg.scala 184:28]
  wire  cconflict1_io_rd_valid; // @[PipelineReg.scala 184:28]
  wire  cconflict1_io_rs1_en; // @[PipelineReg.scala 184:28]
  wire  cconflict1_io_rs2_en; // @[PipelineReg.scala 184:28]
  wire [4:0] cconflict1_io_rs1_addr; // @[PipelineReg.scala 184:28]
  wire [4:0] cconflict1_io_rs2_addr; // @[PipelineReg.scala 184:28]
  wire  cconflict1_io_rd_en; // @[PipelineReg.scala 184:28]
  wire [4:0] cconflict1_io_rd_addr; // @[PipelineReg.scala 184:28]
  wire  cconflict1_io_conflict; // @[PipelineReg.scala 184:28]
  wire  cconflict2_io_rs_valid; // @[PipelineReg.scala 185:28]
  wire  cconflict2_io_rd_valid; // @[PipelineReg.scala 185:28]
  wire  cconflict2_io_rs1_en; // @[PipelineReg.scala 185:28]
  wire  cconflict2_io_rs2_en; // @[PipelineReg.scala 185:28]
  wire [4:0] cconflict2_io_rs1_addr; // @[PipelineReg.scala 185:28]
  wire [4:0] cconflict2_io_rs2_addr; // @[PipelineReg.scala 185:28]
  wire  cconflict2_io_rd_en; // @[PipelineReg.scala 185:28]
  wire [4:0] cconflict2_io_rd_addr; // @[PipelineReg.scala 185:28]
  wire  cconflict2_io_conflict; // @[PipelineReg.scala 185:28]
  wire  cconflict3_io_rs_valid; // @[PipelineReg.scala 186:28]
  wire  cconflict3_io_rd_valid; // @[PipelineReg.scala 186:28]
  wire  cconflict3_io_rs1_en; // @[PipelineReg.scala 186:28]
  wire  cconflict3_io_rs2_en; // @[PipelineReg.scala 186:28]
  wire [4:0] cconflict3_io_rs1_addr; // @[PipelineReg.scala 186:28]
  wire [4:0] cconflict3_io_rs2_addr; // @[PipelineReg.scala 186:28]
  wire  cconflict3_io_rd_en; // @[PipelineReg.scala 186:28]
  wire [4:0] cconflict3_io_rd_addr; // @[PipelineReg.scala 186:28]
  wire  cconflict3_io_conflict; // @[PipelineReg.scala 186:28]
  CorrelationConflict cconflict1 ( // @[PipelineReg.scala 184:28]
    .io_rs_valid(cconflict1_io_rs_valid),
    .io_rd_valid(cconflict1_io_rd_valid),
    .io_rs1_en(cconflict1_io_rs1_en),
    .io_rs2_en(cconflict1_io_rs2_en),
    .io_rs1_addr(cconflict1_io_rs1_addr),
    .io_rs2_addr(cconflict1_io_rs2_addr),
    .io_rd_en(cconflict1_io_rd_en),
    .io_rd_addr(cconflict1_io_rd_addr),
    .io_conflict(cconflict1_io_conflict)
  );
  CorrelationConflict cconflict2 ( // @[PipelineReg.scala 185:28]
    .io_rs_valid(cconflict2_io_rs_valid),
    .io_rd_valid(cconflict2_io_rd_valid),
    .io_rs1_en(cconflict2_io_rs1_en),
    .io_rs2_en(cconflict2_io_rs2_en),
    .io_rs1_addr(cconflict2_io_rs1_addr),
    .io_rs2_addr(cconflict2_io_rs2_addr),
    .io_rd_en(cconflict2_io_rd_en),
    .io_rd_addr(cconflict2_io_rd_addr),
    .io_conflict(cconflict2_io_conflict)
  );
  CorrelationConflict cconflict3 ( // @[PipelineReg.scala 186:28]
    .io_rs_valid(cconflict3_io_rs_valid),
    .io_rd_valid(cconflict3_io_rd_valid),
    .io_rs1_en(cconflict3_io_rs1_en),
    .io_rs2_en(cconflict3_io_rs2_en),
    .io_rs1_addr(cconflict3_io_rs1_addr),
    .io_rs2_addr(cconflict3_io_rs2_addr),
    .io_rd_en(cconflict3_io_rd_en),
    .io_rd_addr(cconflict3_io_rd_addr),
    .io_conflict(cconflict3_io_conflict)
  );
  assign io_conflict = cconflict1_io_conflict | cconflict2_io_conflict | cconflict3_io_conflict; // @[PipelineReg.scala 215:69]
  assign cconflict1_io_rs_valid = io_rs_valid; // @[PipelineReg.scala 188:29]
  assign cconflict1_io_rd_valid = io_rd1_valid; // @[PipelineReg.scala 189:29]
  assign cconflict1_io_rs1_en = io_rs1_en; // @[PipelineReg.scala 190:29]
  assign cconflict1_io_rs2_en = io_rs2_en; // @[PipelineReg.scala 191:29]
  assign cconflict1_io_rs1_addr = io_rs1_addr; // @[PipelineReg.scala 192:29]
  assign cconflict1_io_rs2_addr = io_rs2_addr; // @[PipelineReg.scala 193:29]
  assign cconflict1_io_rd_en = io_rd1_en; // @[PipelineReg.scala 194:29]
  assign cconflict1_io_rd_addr = io_rd1_addr; // @[PipelineReg.scala 195:29]
  assign cconflict2_io_rs_valid = io_rs_valid; // @[PipelineReg.scala 197:29]
  assign cconflict2_io_rd_valid = io_rd2_valid; // @[PipelineReg.scala 198:29]
  assign cconflict2_io_rs1_en = io_rs1_en; // @[PipelineReg.scala 199:29]
  assign cconflict2_io_rs2_en = io_rs2_en; // @[PipelineReg.scala 200:29]
  assign cconflict2_io_rs1_addr = io_rs1_addr; // @[PipelineReg.scala 201:29]
  assign cconflict2_io_rs2_addr = io_rs2_addr; // @[PipelineReg.scala 202:29]
  assign cconflict2_io_rd_en = io_rd2_en; // @[PipelineReg.scala 203:29]
  assign cconflict2_io_rd_addr = io_rd2_addr; // @[PipelineReg.scala 204:29]
  assign cconflict3_io_rs_valid = io_rs_valid; // @[PipelineReg.scala 206:29]
  assign cconflict3_io_rd_valid = io_rd3_valid; // @[PipelineReg.scala 207:29]
  assign cconflict3_io_rs1_en = io_rs1_en; // @[PipelineReg.scala 208:29]
  assign cconflict3_io_rs2_en = io_rs2_en; // @[PipelineReg.scala 209:29]
  assign cconflict3_io_rs1_addr = io_rs1_addr; // @[PipelineReg.scala 210:29]
  assign cconflict3_io_rs2_addr = io_rs2_addr; // @[PipelineReg.scala 211:29]
  assign cconflict3_io_rd_en = io_rd3_en; // @[PipelineReg.scala 212:29]
  assign cconflict3_io_rd_addr = io_rd3_addr; // @[PipelineReg.scala 213:29]
endmodule
module IDReg(
  input         clock,
  input         reset,
  input         io_en,
  input         io_in_valid,
  input  [63:0] io_in_pc,
  output        io_out_valid,
  output [63:0] io_out_pc,
  output [63:0] io_imem__addr,
  output        io_imem__en,
  input  [31:0] io_imem__data,
  output [31:0] io_inst
);
`ifdef RANDOMIZE_REG_INIT
  reg [31:0] _RAND_0;
  reg [63:0] _RAND_1;
`endif // RANDOMIZE_REG_INIT
  reg  valid; // @[Reg.scala 27:20]
  reg [63:0] pc; // @[Reg.scala 27:20]
  assign io_out_valid = valid; // @[PipelineReg.scala 28:21]
  assign io_out_pc = pc; // @[PipelineReg.scala 29:21]
  assign io_imem__addr = io_in_pc; // @[PipelineReg.scala 23:21]
  assign io_imem__en = io_en; // @[PipelineReg.scala 24:21]
  assign io_inst = io_imem__data; // @[PipelineReg.scala 25:21]
  always @(posedge clock) begin
    if (reset) begin // @[Reg.scala 27:20]
      valid <= 1'h0; // @[Reg.scala 27:20]
    end else if (io_en) begin // @[Reg.scala 28:19]
      valid <= io_in_valid; // @[Reg.scala 28:23]
    end
    if (reset) begin // @[Reg.scala 27:20]
      pc <= 64'h7ffffffc; // @[Reg.scala 27:20]
    end else if (io_en) begin // @[Reg.scala 28:19]
      pc <= io_in_pc; // @[Reg.scala 28:23]
    end
  end
// Register and memory initialization
`ifdef RANDOMIZE_GARBAGE_ASSIGN
`define RANDOMIZE
`endif
`ifdef RANDOMIZE_INVALID_ASSIGN
`define RANDOMIZE
`endif
`ifdef RANDOMIZE_REG_INIT
`define RANDOMIZE
`endif
`ifdef RANDOMIZE_MEM_INIT
`define RANDOMIZE
`endif
`ifndef RANDOM
`define RANDOM $random
`endif
`ifdef RANDOMIZE_MEM_INIT
  integer initvar;
`endif
`ifndef SYNTHESIS
`ifdef FIRRTL_BEFORE_INITIAL
`FIRRTL_BEFORE_INITIAL
`endif
initial begin
  `ifdef RANDOMIZE
    `ifdef INIT_RANDOM
      `INIT_RANDOM
    `endif
    `ifndef VERILATOR
      `ifdef RANDOMIZE_DELAY
        #`RANDOMIZE_DELAY begin end
      `else
        #0.002 begin end
      `endif
    `endif
`ifdef RANDOMIZE_REG_INIT
  _RAND_0 = {1{`RANDOM}};
  valid = _RAND_0[0:0];
  _RAND_1 = {2{`RANDOM}};
  pc = _RAND_1[63:0];
`endif // RANDOMIZE_REG_INIT
  `endif // RANDOMIZE
end // initial
`ifdef FIRRTL_AFTER_INITIAL
`FIRRTL_AFTER_INITIAL
`endif
`endif // SYNTHESIS
endmodule
module ExeReg(
  input         clock,
  input         reset,
  input         io_en,
  input         io_in_valid,
  input  [63:0] io_in_pc,
  input  [31:0] io_in_inst,
  input         io_in_rd_en,
  input  [4:0]  io_in_rd_addr,
  input  [63:0] io_in_imm,
  input  [63:0] io_in_op1,
  input  [63:0] io_in_op2,
  input  [5:0]  io_in_fu_code,
  input  [15:0] io_in_alu_code,
  input  [7:0]  io_in_bu_code,
  input  [6:0]  io_in_lu_code,
  input  [3:0]  io_in_su_code,
  input  [9:0]  io_in_mdu_code,
  input  [7:0]  io_in_csru_code,
  input  [4:0]  io_in_rs1_addr,
  input         io_in_putch,
  output        io_out_valid,
  output [63:0] io_out_pc,
  output [31:0] io_out_inst,
  output        io_out_rd_en,
  output [4:0]  io_out_rd_addr,
  output [63:0] io_out_imm,
  output [63:0] io_out_op1,
  output [63:0] io_out_op2,
  output [5:0]  io_out_fu_code,
  output [15:0] io_out_alu_code,
  output [7:0]  io_out_bu_code,
  output [6:0]  io_out_lu_code,
  output [3:0]  io_out_su_code,
  output [9:0]  io_out_mdu_code,
  output [7:0]  io_out_csru_code,
  output [4:0]  io_out_rs1_addr,
  output        io_out_putch
);
`ifdef RANDOMIZE_REG_INIT
  reg [31:0] _RAND_0;
  reg [63:0] _RAND_1;
  reg [31:0] _RAND_2;
  reg [31:0] _RAND_3;
  reg [31:0] _RAND_4;
  reg [63:0] _RAND_5;
  reg [63:0] _RAND_6;
  reg [63:0] _RAND_7;
  reg [31:0] _RAND_8;
  reg [31:0] _RAND_9;
  reg [31:0] _RAND_10;
  reg [31:0] _RAND_11;
  reg [31:0] _RAND_12;
  reg [31:0] _RAND_13;
  reg [31:0] _RAND_14;
  reg [31:0] _RAND_15;
  reg [31:0] _RAND_16;
`endif // RANDOMIZE_REG_INIT
  reg  reg_valid; // @[Reg.scala 27:20]
  reg [63:0] reg_pc; // @[Reg.scala 27:20]
  reg [31:0] reg_inst; // @[Reg.scala 27:20]
  reg  reg_rd_en; // @[Reg.scala 27:20]
  reg [4:0] reg_rd_addr; // @[Reg.scala 27:20]
  reg [63:0] reg_imm; // @[Reg.scala 27:20]
  reg [63:0] reg_op1; // @[Reg.scala 27:20]
  reg [63:0] reg_op2; // @[Reg.scala 27:20]
  reg [5:0] reg_fu_code; // @[Reg.scala 27:20]
  reg [15:0] reg_alu_code; // @[Reg.scala 27:20]
  reg [7:0] reg_bu_code; // @[Reg.scala 27:20]
  reg [6:0] reg_lu_code; // @[Reg.scala 27:20]
  reg [3:0] reg_su_code; // @[Reg.scala 27:20]
  reg [9:0] reg_mdu_code; // @[Reg.scala 27:20]
  reg [7:0] reg_csru_code; // @[Reg.scala 27:20]
  reg [4:0] reg_rs1_addr; // @[Reg.scala 27:20]
  reg  reg_putch; // @[Reg.scala 27:20]
  assign io_out_valid = reg_valid; // @[PipelineReg.scala 62:10]
  assign io_out_pc = reg_pc; // @[PipelineReg.scala 62:10]
  assign io_out_inst = reg_inst; // @[PipelineReg.scala 62:10]
  assign io_out_rd_en = reg_rd_en; // @[PipelineReg.scala 62:10]
  assign io_out_rd_addr = reg_rd_addr; // @[PipelineReg.scala 62:10]
  assign io_out_imm = reg_imm; // @[PipelineReg.scala 62:10]
  assign io_out_op1 = reg_op1; // @[PipelineReg.scala 62:10]
  assign io_out_op2 = reg_op2; // @[PipelineReg.scala 62:10]
  assign io_out_fu_code = reg_fu_code; // @[PipelineReg.scala 62:10]
  assign io_out_alu_code = reg_alu_code; // @[PipelineReg.scala 62:10]
  assign io_out_bu_code = reg_bu_code; // @[PipelineReg.scala 62:10]
  assign io_out_lu_code = reg_lu_code; // @[PipelineReg.scala 62:10]
  assign io_out_su_code = reg_su_code; // @[PipelineReg.scala 62:10]
  assign io_out_mdu_code = reg_mdu_code; // @[PipelineReg.scala 62:10]
  assign io_out_csru_code = reg_csru_code; // @[PipelineReg.scala 62:10]
  assign io_out_rs1_addr = reg_rs1_addr; // @[PipelineReg.scala 62:10]
  assign io_out_putch = reg_putch; // @[PipelineReg.scala 62:10]
  always @(posedge clock) begin
    if (reset) begin // @[Reg.scala 27:20]
      reg_valid <= 1'h0; // @[Reg.scala 27:20]
    end else if (io_en) begin // @[Reg.scala 28:19]
      reg_valid <= io_in_valid; // @[Reg.scala 28:23]
    end
    if (reset) begin // @[Reg.scala 27:20]
      reg_pc <= 64'h0; // @[Reg.scala 27:20]
    end else if (io_en) begin // @[Reg.scala 28:19]
      reg_pc <= io_in_pc; // @[Reg.scala 28:23]
    end
    if (reset) begin // @[Reg.scala 27:20]
      reg_inst <= 32'h0; // @[Reg.scala 27:20]
    end else if (io_en) begin // @[Reg.scala 28:19]
      reg_inst <= io_in_inst; // @[Reg.scala 28:23]
    end
    if (reset) begin // @[Reg.scala 27:20]
      reg_rd_en <= 1'h0; // @[Reg.scala 27:20]
    end else if (io_en) begin // @[Reg.scala 28:19]
      reg_rd_en <= io_in_rd_en; // @[Reg.scala 28:23]
    end
    if (reset) begin // @[Reg.scala 27:20]
      reg_rd_addr <= 5'h0; // @[Reg.scala 27:20]
    end else if (io_en) begin // @[Reg.scala 28:19]
      reg_rd_addr <= io_in_rd_addr; // @[Reg.scala 28:23]
    end
    if (reset) begin // @[Reg.scala 27:20]
      reg_imm <= 64'h0; // @[Reg.scala 27:20]
    end else if (io_en) begin // @[Reg.scala 28:19]
      reg_imm <= io_in_imm; // @[Reg.scala 28:23]
    end
    if (reset) begin // @[Reg.scala 27:20]
      reg_op1 <= 64'h0; // @[Reg.scala 27:20]
    end else if (io_en) begin // @[Reg.scala 28:19]
      reg_op1 <= io_in_op1; // @[Reg.scala 28:23]
    end
    if (reset) begin // @[Reg.scala 27:20]
      reg_op2 <= 64'h0; // @[Reg.scala 27:20]
    end else if (io_en) begin // @[Reg.scala 28:19]
      reg_op2 <= io_in_op2; // @[Reg.scala 28:23]
    end
    if (reset) begin // @[Reg.scala 27:20]
      reg_fu_code <= 6'h0; // @[Reg.scala 27:20]
    end else if (io_en) begin // @[Reg.scala 28:19]
      reg_fu_code <= io_in_fu_code; // @[Reg.scala 28:23]
    end
    if (reset) begin // @[Reg.scala 27:20]
      reg_alu_code <= 16'h0; // @[Reg.scala 27:20]
    end else if (io_en) begin // @[Reg.scala 28:19]
      reg_alu_code <= io_in_alu_code; // @[Reg.scala 28:23]
    end
    if (reset) begin // @[Reg.scala 27:20]
      reg_bu_code <= 8'h0; // @[Reg.scala 27:20]
    end else if (io_en) begin // @[Reg.scala 28:19]
      reg_bu_code <= io_in_bu_code; // @[Reg.scala 28:23]
    end
    if (reset) begin // @[Reg.scala 27:20]
      reg_lu_code <= 7'h0; // @[Reg.scala 27:20]
    end else if (io_en) begin // @[Reg.scala 28:19]
      reg_lu_code <= io_in_lu_code; // @[Reg.scala 28:23]
    end
    if (reset) begin // @[Reg.scala 27:20]
      reg_su_code <= 4'h0; // @[Reg.scala 27:20]
    end else if (io_en) begin // @[Reg.scala 28:19]
      reg_su_code <= io_in_su_code; // @[Reg.scala 28:23]
    end
    if (reset) begin // @[Reg.scala 27:20]
      reg_mdu_code <= 10'h0; // @[Reg.scala 27:20]
    end else if (io_en) begin // @[Reg.scala 28:19]
      reg_mdu_code <= io_in_mdu_code; // @[Reg.scala 28:23]
    end
    if (reset) begin // @[Reg.scala 27:20]
      reg_csru_code <= 8'h0; // @[Reg.scala 27:20]
    end else if (io_en) begin // @[Reg.scala 28:19]
      reg_csru_code <= io_in_csru_code; // @[Reg.scala 28:23]
    end
    if (reset) begin // @[Reg.scala 27:20]
      reg_rs1_addr <= 5'h0; // @[Reg.scala 27:20]
    end else if (io_en) begin // @[Reg.scala 28:19]
      reg_rs1_addr <= io_in_rs1_addr; // @[Reg.scala 28:23]
    end
    if (reset) begin // @[Reg.scala 27:20]
      reg_putch <= 1'h0; // @[Reg.scala 27:20]
    end else if (io_en) begin // @[Reg.scala 28:19]
      reg_putch <= io_in_putch; // @[Reg.scala 28:23]
    end
  end
// Register and memory initialization
`ifdef RANDOMIZE_GARBAGE_ASSIGN
`define RANDOMIZE
`endif
`ifdef RANDOMIZE_INVALID_ASSIGN
`define RANDOMIZE
`endif
`ifdef RANDOMIZE_REG_INIT
`define RANDOMIZE
`endif
`ifdef RANDOMIZE_MEM_INIT
`define RANDOMIZE
`endif
`ifndef RANDOM
`define RANDOM $random
`endif
`ifdef RANDOMIZE_MEM_INIT
  integer initvar;
`endif
`ifndef SYNTHESIS
`ifdef FIRRTL_BEFORE_INITIAL
`FIRRTL_BEFORE_INITIAL
`endif
initial begin
  `ifdef RANDOMIZE
    `ifdef INIT_RANDOM
      `INIT_RANDOM
    `endif
    `ifndef VERILATOR
      `ifdef RANDOMIZE_DELAY
        #`RANDOMIZE_DELAY begin end
      `else
        #0.002 begin end
      `endif
    `endif
`ifdef RANDOMIZE_REG_INIT
  _RAND_0 = {1{`RANDOM}};
  reg_valid = _RAND_0[0:0];
  _RAND_1 = {2{`RANDOM}};
  reg_pc = _RAND_1[63:0];
  _RAND_2 = {1{`RANDOM}};
  reg_inst = _RAND_2[31:0];
  _RAND_3 = {1{`RANDOM}};
  reg_rd_en = _RAND_3[0:0];
  _RAND_4 = {1{`RANDOM}};
  reg_rd_addr = _RAND_4[4:0];
  _RAND_5 = {2{`RANDOM}};
  reg_imm = _RAND_5[63:0];
  _RAND_6 = {2{`RANDOM}};
  reg_op1 = _RAND_6[63:0];
  _RAND_7 = {2{`RANDOM}};
  reg_op2 = _RAND_7[63:0];
  _RAND_8 = {1{`RANDOM}};
  reg_fu_code = _RAND_8[5:0];
  _RAND_9 = {1{`RANDOM}};
  reg_alu_code = _RAND_9[15:0];
  _RAND_10 = {1{`RANDOM}};
  reg_bu_code = _RAND_10[7:0];
  _RAND_11 = {1{`RANDOM}};
  reg_lu_code = _RAND_11[6:0];
  _RAND_12 = {1{`RANDOM}};
  reg_su_code = _RAND_12[3:0];
  _RAND_13 = {1{`RANDOM}};
  reg_mdu_code = _RAND_13[9:0];
  _RAND_14 = {1{`RANDOM}};
  reg_csru_code = _RAND_14[7:0];
  _RAND_15 = {1{`RANDOM}};
  reg_rs1_addr = _RAND_15[4:0];
  _RAND_16 = {1{`RANDOM}};
  reg_putch = _RAND_16[0:0];
`endif // RANDOMIZE_REG_INIT
  `endif // RANDOMIZE
end // initial
`ifdef FIRRTL_AFTER_INITIAL
`FIRRTL_AFTER_INITIAL
`endif
`endif // SYNTHESIS
endmodule
module MemReg(
  input         clock,
  input         reset,
  input         io_en,
  input         io_in_valid,
  input  [63:0] io_in_pc,
  input  [31:0] io_in_inst,
  input         io_in_rd_en,
  input  [4:0]  io_in_rd_addr,
  input  [63:0] io_in_imm,
  input  [63:0] io_in_op1,
  input  [63:0] io_in_op2,
  input  [63:0] io_in_alu_out,
  input  [63:0] io_in_bu_out,
  input  [63:0] io_in_mdu_out,
  input  [63:0] io_in_csru_out,
  input  [5:0]  io_in_fu_code,
  input  [6:0]  io_in_lu_code,
  input  [3:0]  io_in_su_code,
  input  [7:0]  io_in_csru_code,
  input         io_in_putch,
  input         io_in_csr_wen,
  input  [11:0] io_in_csr_waddr,
  input  [63:0] io_in_csr_wdata,
  output        io_out_valid,
  output [63:0] io_out_pc,
  output [31:0] io_out_inst,
  output        io_out_rd_en,
  output [4:0]  io_out_rd_addr,
  output [63:0] io_out_imm,
  output [63:0] io_out_op1,
  output [63:0] io_out_op2,
  output [63:0] io_out_alu_out,
  output [63:0] io_out_bu_out,
  output [63:0] io_out_mdu_out,
  output [63:0] io_out_csru_out,
  output [5:0]  io_out_fu_code,
  output [6:0]  io_out_lu_code,
  output [3:0]  io_out_su_code,
  output [7:0]  io_out_csru_code,
  output        io_out_putch,
  output        io_out_csr_wen,
  output [11:0] io_out_csr_waddr,
  output [63:0] io_out_csr_wdata
);
`ifdef RANDOMIZE_REG_INIT
  reg [31:0] _RAND_0;
  reg [63:0] _RAND_1;
  reg [31:0] _RAND_2;
  reg [31:0] _RAND_3;
  reg [31:0] _RAND_4;
  reg [63:0] _RAND_5;
  reg [63:0] _RAND_6;
  reg [63:0] _RAND_7;
  reg [63:0] _RAND_8;
  reg [63:0] _RAND_9;
  reg [63:0] _RAND_10;
  reg [63:0] _RAND_11;
  reg [31:0] _RAND_12;
  reg [31:0] _RAND_13;
  reg [31:0] _RAND_14;
  reg [31:0] _RAND_15;
  reg [31:0] _RAND_16;
  reg [31:0] _RAND_17;
  reg [31:0] _RAND_18;
  reg [63:0] _RAND_19;
`endif // RANDOMIZE_REG_INIT
  reg  reg_valid; // @[Reg.scala 27:20]
  reg [63:0] reg_pc; // @[Reg.scala 27:20]
  reg [31:0] reg_inst; // @[Reg.scala 27:20]
  reg  reg_rd_en; // @[Reg.scala 27:20]
  reg [4:0] reg_rd_addr; // @[Reg.scala 27:20]
  reg [63:0] reg_imm; // @[Reg.scala 27:20]
  reg [63:0] reg_op1; // @[Reg.scala 27:20]
  reg [63:0] reg_op2; // @[Reg.scala 27:20]
  reg [63:0] reg_alu_out; // @[Reg.scala 27:20]
  reg [63:0] reg_bu_out; // @[Reg.scala 27:20]
  reg [63:0] reg_mdu_out; // @[Reg.scala 27:20]
  reg [63:0] reg_csru_out; // @[Reg.scala 27:20]
  reg [5:0] reg_fu_code; // @[Reg.scala 27:20]
  reg [6:0] reg_lu_code; // @[Reg.scala 27:20]
  reg [3:0] reg_su_code; // @[Reg.scala 27:20]
  reg [7:0] reg_csru_code; // @[Reg.scala 27:20]
  reg  reg_putch; // @[Reg.scala 27:20]
  reg  reg_csr_wen; // @[Reg.scala 27:20]
  reg [11:0] reg_csr_waddr; // @[Reg.scala 27:20]
  reg [63:0] reg_csr_wdata; // @[Reg.scala 27:20]
  assign io_out_valid = reg_valid; // @[PipelineReg.scala 104:10]
  assign io_out_pc = reg_pc; // @[PipelineReg.scala 104:10]
  assign io_out_inst = reg_inst; // @[PipelineReg.scala 104:10]
  assign io_out_rd_en = reg_rd_en; // @[PipelineReg.scala 104:10]
  assign io_out_rd_addr = reg_rd_addr; // @[PipelineReg.scala 104:10]
  assign io_out_imm = reg_imm; // @[PipelineReg.scala 104:10]
  assign io_out_op1 = reg_op1; // @[PipelineReg.scala 104:10]
  assign io_out_op2 = reg_op2; // @[PipelineReg.scala 104:10]
  assign io_out_alu_out = reg_alu_out; // @[PipelineReg.scala 104:10]
  assign io_out_bu_out = reg_bu_out; // @[PipelineReg.scala 104:10]
  assign io_out_mdu_out = reg_mdu_out; // @[PipelineReg.scala 104:10]
  assign io_out_csru_out = reg_csru_out; // @[PipelineReg.scala 104:10]
  assign io_out_fu_code = reg_fu_code; // @[PipelineReg.scala 104:10]
  assign io_out_lu_code = reg_lu_code; // @[PipelineReg.scala 104:10]
  assign io_out_su_code = reg_su_code; // @[PipelineReg.scala 104:10]
  assign io_out_csru_code = reg_csru_code; // @[PipelineReg.scala 104:10]
  assign io_out_putch = reg_putch; // @[PipelineReg.scala 104:10]
  assign io_out_csr_wen = reg_csr_wen; // @[PipelineReg.scala 104:10]
  assign io_out_csr_waddr = reg_csr_waddr; // @[PipelineReg.scala 104:10]
  assign io_out_csr_wdata = reg_csr_wdata; // @[PipelineReg.scala 104:10]
  always @(posedge clock) begin
    if (reset) begin // @[Reg.scala 27:20]
      reg_valid <= 1'h0; // @[Reg.scala 27:20]
    end else if (io_en) begin // @[Reg.scala 28:19]
      reg_valid <= io_in_valid; // @[Reg.scala 28:23]
    end
    if (reset) begin // @[Reg.scala 27:20]
      reg_pc <= 64'h0; // @[Reg.scala 27:20]
    end else if (io_en) begin // @[Reg.scala 28:19]
      reg_pc <= io_in_pc; // @[Reg.scala 28:23]
    end
    if (reset) begin // @[Reg.scala 27:20]
      reg_inst <= 32'h0; // @[Reg.scala 27:20]
    end else if (io_en) begin // @[Reg.scala 28:19]
      reg_inst <= io_in_inst; // @[Reg.scala 28:23]
    end
    if (reset) begin // @[Reg.scala 27:20]
      reg_rd_en <= 1'h0; // @[Reg.scala 27:20]
    end else if (io_en) begin // @[Reg.scala 28:19]
      reg_rd_en <= io_in_rd_en; // @[Reg.scala 28:23]
    end
    if (reset) begin // @[Reg.scala 27:20]
      reg_rd_addr <= 5'h0; // @[Reg.scala 27:20]
    end else if (io_en) begin // @[Reg.scala 28:19]
      reg_rd_addr <= io_in_rd_addr; // @[Reg.scala 28:23]
    end
    if (reset) begin // @[Reg.scala 27:20]
      reg_imm <= 64'h0; // @[Reg.scala 27:20]
    end else if (io_en) begin // @[Reg.scala 28:19]
      reg_imm <= io_in_imm; // @[Reg.scala 28:23]
    end
    if (reset) begin // @[Reg.scala 27:20]
      reg_op1 <= 64'h0; // @[Reg.scala 27:20]
    end else if (io_en) begin // @[Reg.scala 28:19]
      reg_op1 <= io_in_op1; // @[Reg.scala 28:23]
    end
    if (reset) begin // @[Reg.scala 27:20]
      reg_op2 <= 64'h0; // @[Reg.scala 27:20]
    end else if (io_en) begin // @[Reg.scala 28:19]
      reg_op2 <= io_in_op2; // @[Reg.scala 28:23]
    end
    if (reset) begin // @[Reg.scala 27:20]
      reg_alu_out <= 64'h0; // @[Reg.scala 27:20]
    end else if (io_en) begin // @[Reg.scala 28:19]
      reg_alu_out <= io_in_alu_out; // @[Reg.scala 28:23]
    end
    if (reset) begin // @[Reg.scala 27:20]
      reg_bu_out <= 64'h0; // @[Reg.scala 27:20]
    end else if (io_en) begin // @[Reg.scala 28:19]
      reg_bu_out <= io_in_bu_out; // @[Reg.scala 28:23]
    end
    if (reset) begin // @[Reg.scala 27:20]
      reg_mdu_out <= 64'h0; // @[Reg.scala 27:20]
    end else if (io_en) begin // @[Reg.scala 28:19]
      reg_mdu_out <= io_in_mdu_out; // @[Reg.scala 28:23]
    end
    if (reset) begin // @[Reg.scala 27:20]
      reg_csru_out <= 64'h0; // @[Reg.scala 27:20]
    end else if (io_en) begin // @[Reg.scala 28:19]
      reg_csru_out <= io_in_csru_out; // @[Reg.scala 28:23]
    end
    if (reset) begin // @[Reg.scala 27:20]
      reg_fu_code <= 6'h0; // @[Reg.scala 27:20]
    end else if (io_en) begin // @[Reg.scala 28:19]
      reg_fu_code <= io_in_fu_code; // @[Reg.scala 28:23]
    end
    if (reset) begin // @[Reg.scala 27:20]
      reg_lu_code <= 7'h0; // @[Reg.scala 27:20]
    end else if (io_en) begin // @[Reg.scala 28:19]
      reg_lu_code <= io_in_lu_code; // @[Reg.scala 28:23]
    end
    if (reset) begin // @[Reg.scala 27:20]
      reg_su_code <= 4'h0; // @[Reg.scala 27:20]
    end else if (io_en) begin // @[Reg.scala 28:19]
      reg_su_code <= io_in_su_code; // @[Reg.scala 28:23]
    end
    if (reset) begin // @[Reg.scala 27:20]
      reg_csru_code <= 8'h0; // @[Reg.scala 27:20]
    end else if (io_en) begin // @[Reg.scala 28:19]
      reg_csru_code <= io_in_csru_code; // @[Reg.scala 28:23]
    end
    if (reset) begin // @[Reg.scala 27:20]
      reg_putch <= 1'h0; // @[Reg.scala 27:20]
    end else if (io_en) begin // @[Reg.scala 28:19]
      reg_putch <= io_in_putch; // @[Reg.scala 28:23]
    end
    if (reset) begin // @[Reg.scala 27:20]
      reg_csr_wen <= 1'h0; // @[Reg.scala 27:20]
    end else if (io_en) begin // @[Reg.scala 28:19]
      reg_csr_wen <= io_in_csr_wen; // @[Reg.scala 28:23]
    end
    if (reset) begin // @[Reg.scala 27:20]
      reg_csr_waddr <= 12'h0; // @[Reg.scala 27:20]
    end else if (io_en) begin // @[Reg.scala 28:19]
      reg_csr_waddr <= io_in_csr_waddr; // @[Reg.scala 28:23]
    end
    if (reset) begin // @[Reg.scala 27:20]
      reg_csr_wdata <= 64'h0; // @[Reg.scala 27:20]
    end else if (io_en) begin // @[Reg.scala 28:19]
      reg_csr_wdata <= io_in_csr_wdata; // @[Reg.scala 28:23]
    end
  end
// Register and memory initialization
`ifdef RANDOMIZE_GARBAGE_ASSIGN
`define RANDOMIZE
`endif
`ifdef RANDOMIZE_INVALID_ASSIGN
`define RANDOMIZE
`endif
`ifdef RANDOMIZE_REG_INIT
`define RANDOMIZE
`endif
`ifdef RANDOMIZE_MEM_INIT
`define RANDOMIZE
`endif
`ifndef RANDOM
`define RANDOM $random
`endif
`ifdef RANDOMIZE_MEM_INIT
  integer initvar;
`endif
`ifndef SYNTHESIS
`ifdef FIRRTL_BEFORE_INITIAL
`FIRRTL_BEFORE_INITIAL
`endif
initial begin
  `ifdef RANDOMIZE
    `ifdef INIT_RANDOM
      `INIT_RANDOM
    `endif
    `ifndef VERILATOR
      `ifdef RANDOMIZE_DELAY
        #`RANDOMIZE_DELAY begin end
      `else
        #0.002 begin end
      `endif
    `endif
`ifdef RANDOMIZE_REG_INIT
  _RAND_0 = {1{`RANDOM}};
  reg_valid = _RAND_0[0:0];
  _RAND_1 = {2{`RANDOM}};
  reg_pc = _RAND_1[63:0];
  _RAND_2 = {1{`RANDOM}};
  reg_inst = _RAND_2[31:0];
  _RAND_3 = {1{`RANDOM}};
  reg_rd_en = _RAND_3[0:0];
  _RAND_4 = {1{`RANDOM}};
  reg_rd_addr = _RAND_4[4:0];
  _RAND_5 = {2{`RANDOM}};
  reg_imm = _RAND_5[63:0];
  _RAND_6 = {2{`RANDOM}};
  reg_op1 = _RAND_6[63:0];
  _RAND_7 = {2{`RANDOM}};
  reg_op2 = _RAND_7[63:0];
  _RAND_8 = {2{`RANDOM}};
  reg_alu_out = _RAND_8[63:0];
  _RAND_9 = {2{`RANDOM}};
  reg_bu_out = _RAND_9[63:0];
  _RAND_10 = {2{`RANDOM}};
  reg_mdu_out = _RAND_10[63:0];
  _RAND_11 = {2{`RANDOM}};
  reg_csru_out = _RAND_11[63:0];
  _RAND_12 = {1{`RANDOM}};
  reg_fu_code = _RAND_12[5:0];
  _RAND_13 = {1{`RANDOM}};
  reg_lu_code = _RAND_13[6:0];
  _RAND_14 = {1{`RANDOM}};
  reg_su_code = _RAND_14[3:0];
  _RAND_15 = {1{`RANDOM}};
  reg_csru_code = _RAND_15[7:0];
  _RAND_16 = {1{`RANDOM}};
  reg_putch = _RAND_16[0:0];
  _RAND_17 = {1{`RANDOM}};
  reg_csr_wen = _RAND_17[0:0];
  _RAND_18 = {1{`RANDOM}};
  reg_csr_waddr = _RAND_18[11:0];
  _RAND_19 = {2{`RANDOM}};
  reg_csr_wdata = _RAND_19[63:0];
`endif // RANDOMIZE_REG_INIT
  `endif // RANDOMIZE
end // initial
`ifdef FIRRTL_AFTER_INITIAL
`FIRRTL_AFTER_INITIAL
`endif
`endif // SYNTHESIS
endmodule
module WBReg(
  input         clock,
  input         reset,
  input         io_en,
  input         io_in_valid,
  input  [63:0] io_in_pc,
  input  [31:0] io_in_inst,
  input         io_in_rd_en,
  input  [4:0]  io_in_rd_addr,
  input  [63:0] io_in_alu_out,
  input  [63:0] io_in_bu_out,
  input  [63:0] io_in_mdu_out,
  input  [63:0] io_in_csru_out,
  input  [5:0]  io_in_fu_code,
  input  [6:0]  io_in_lu_code,
  input  [7:0]  io_in_csru_code,
  input  [5:0]  io_in_lu_shift,
  input         io_in_putch,
  input         io_in_csr_wen,
  input  [11:0] io_in_csr_waddr,
  input  [63:0] io_in_csr_wdata,
  output        io_out_valid,
  output [63:0] io_out_pc,
  output [31:0] io_out_inst,
  output        io_out_rd_en,
  output [4:0]  io_out_rd_addr,
  output [63:0] io_out_alu_out,
  output [63:0] io_out_bu_out,
  output [63:0] io_out_mdu_out,
  output [63:0] io_out_csru_out,
  output [5:0]  io_out_fu_code,
  output [6:0]  io_out_lu_code,
  output [7:0]  io_out_csru_code,
  output [5:0]  io_out_lu_shift,
  output        io_out_putch,
  output        io_out_csr_wen,
  output [11:0] io_out_csr_waddr,
  output [63:0] io_out_csr_wdata
);
`ifdef RANDOMIZE_REG_INIT
  reg [31:0] _RAND_0;
  reg [63:0] _RAND_1;
  reg [31:0] _RAND_2;
  reg [31:0] _RAND_3;
  reg [31:0] _RAND_4;
  reg [63:0] _RAND_5;
  reg [63:0] _RAND_6;
  reg [63:0] _RAND_7;
  reg [63:0] _RAND_8;
  reg [31:0] _RAND_9;
  reg [31:0] _RAND_10;
  reg [31:0] _RAND_11;
  reg [31:0] _RAND_12;
  reg [31:0] _RAND_13;
  reg [31:0] _RAND_14;
  reg [31:0] _RAND_15;
  reg [63:0] _RAND_16;
`endif // RANDOMIZE_REG_INIT
  reg  reg_valid; // @[Reg.scala 27:20]
  reg [63:0] reg_pc; // @[Reg.scala 27:20]
  reg [31:0] reg_inst; // @[Reg.scala 27:20]
  reg  reg_rd_en; // @[Reg.scala 27:20]
  reg [4:0] reg_rd_addr; // @[Reg.scala 27:20]
  reg [63:0] reg_alu_out; // @[Reg.scala 27:20]
  reg [63:0] reg_bu_out; // @[Reg.scala 27:20]
  reg [63:0] reg_mdu_out; // @[Reg.scala 27:20]
  reg [63:0] reg_csru_out; // @[Reg.scala 27:20]
  reg [5:0] reg_fu_code; // @[Reg.scala 27:20]
  reg [6:0] reg_lu_code; // @[Reg.scala 27:20]
  reg [7:0] reg_csru_code; // @[Reg.scala 27:20]
  reg [5:0] reg_lu_shift; // @[Reg.scala 27:20]
  reg  reg_putch; // @[Reg.scala 27:20]
  reg  reg_csr_wen; // @[Reg.scala 27:20]
  reg [11:0] reg_csr_waddr; // @[Reg.scala 27:20]
  reg [63:0] reg_csr_wdata; // @[Reg.scala 27:20]
  assign io_out_valid = reg_valid; // @[PipelineReg.scala 140:10]
  assign io_out_pc = reg_pc; // @[PipelineReg.scala 140:10]
  assign io_out_inst = reg_inst; // @[PipelineReg.scala 140:10]
  assign io_out_rd_en = reg_rd_en; // @[PipelineReg.scala 140:10]
  assign io_out_rd_addr = reg_rd_addr; // @[PipelineReg.scala 140:10]
  assign io_out_alu_out = reg_alu_out; // @[PipelineReg.scala 140:10]
  assign io_out_bu_out = reg_bu_out; // @[PipelineReg.scala 140:10]
  assign io_out_mdu_out = reg_mdu_out; // @[PipelineReg.scala 140:10]
  assign io_out_csru_out = reg_csru_out; // @[PipelineReg.scala 140:10]
  assign io_out_fu_code = reg_fu_code; // @[PipelineReg.scala 140:10]
  assign io_out_lu_code = reg_lu_code; // @[PipelineReg.scala 140:10]
  assign io_out_csru_code = reg_csru_code; // @[PipelineReg.scala 140:10]
  assign io_out_lu_shift = reg_lu_shift; // @[PipelineReg.scala 140:10]
  assign io_out_putch = reg_putch; // @[PipelineReg.scala 140:10]
  assign io_out_csr_wen = reg_csr_wen; // @[PipelineReg.scala 140:10]
  assign io_out_csr_waddr = reg_csr_waddr; // @[PipelineReg.scala 140:10]
  assign io_out_csr_wdata = reg_csr_wdata; // @[PipelineReg.scala 140:10]
  always @(posedge clock) begin
    if (reset) begin // @[Reg.scala 27:20]
      reg_valid <= 1'h0; // @[Reg.scala 27:20]
    end else if (io_en) begin // @[Reg.scala 28:19]
      reg_valid <= io_in_valid; // @[Reg.scala 28:23]
    end
    if (reset) begin // @[Reg.scala 27:20]
      reg_pc <= 64'h0; // @[Reg.scala 27:20]
    end else if (io_en) begin // @[Reg.scala 28:19]
      reg_pc <= io_in_pc; // @[Reg.scala 28:23]
    end
    if (reset) begin // @[Reg.scala 27:20]
      reg_inst <= 32'h0; // @[Reg.scala 27:20]
    end else if (io_en) begin // @[Reg.scala 28:19]
      reg_inst <= io_in_inst; // @[Reg.scala 28:23]
    end
    if (reset) begin // @[Reg.scala 27:20]
      reg_rd_en <= 1'h0; // @[Reg.scala 27:20]
    end else if (io_en) begin // @[Reg.scala 28:19]
      reg_rd_en <= io_in_rd_en; // @[Reg.scala 28:23]
    end
    if (reset) begin // @[Reg.scala 27:20]
      reg_rd_addr <= 5'h0; // @[Reg.scala 27:20]
    end else if (io_en) begin // @[Reg.scala 28:19]
      reg_rd_addr <= io_in_rd_addr; // @[Reg.scala 28:23]
    end
    if (reset) begin // @[Reg.scala 27:20]
      reg_alu_out <= 64'h0; // @[Reg.scala 27:20]
    end else if (io_en) begin // @[Reg.scala 28:19]
      reg_alu_out <= io_in_alu_out; // @[Reg.scala 28:23]
    end
    if (reset) begin // @[Reg.scala 27:20]
      reg_bu_out <= 64'h0; // @[Reg.scala 27:20]
    end else if (io_en) begin // @[Reg.scala 28:19]
      reg_bu_out <= io_in_bu_out; // @[Reg.scala 28:23]
    end
    if (reset) begin // @[Reg.scala 27:20]
      reg_mdu_out <= 64'h0; // @[Reg.scala 27:20]
    end else if (io_en) begin // @[Reg.scala 28:19]
      reg_mdu_out <= io_in_mdu_out; // @[Reg.scala 28:23]
    end
    if (reset) begin // @[Reg.scala 27:20]
      reg_csru_out <= 64'h0; // @[Reg.scala 27:20]
    end else if (io_en) begin // @[Reg.scala 28:19]
      reg_csru_out <= io_in_csru_out; // @[Reg.scala 28:23]
    end
    if (reset) begin // @[Reg.scala 27:20]
      reg_fu_code <= 6'h0; // @[Reg.scala 27:20]
    end else if (io_en) begin // @[Reg.scala 28:19]
      reg_fu_code <= io_in_fu_code; // @[Reg.scala 28:23]
    end
    if (reset) begin // @[Reg.scala 27:20]
      reg_lu_code <= 7'h0; // @[Reg.scala 27:20]
    end else if (io_en) begin // @[Reg.scala 28:19]
      reg_lu_code <= io_in_lu_code; // @[Reg.scala 28:23]
    end
    if (reset) begin // @[Reg.scala 27:20]
      reg_csru_code <= 8'h0; // @[Reg.scala 27:20]
    end else if (io_en) begin // @[Reg.scala 28:19]
      reg_csru_code <= io_in_csru_code; // @[Reg.scala 28:23]
    end
    if (reset) begin // @[Reg.scala 27:20]
      reg_lu_shift <= 6'h0; // @[Reg.scala 27:20]
    end else if (io_en) begin // @[Reg.scala 28:19]
      reg_lu_shift <= io_in_lu_shift; // @[Reg.scala 28:23]
    end
    if (reset) begin // @[Reg.scala 27:20]
      reg_putch <= 1'h0; // @[Reg.scala 27:20]
    end else if (io_en) begin // @[Reg.scala 28:19]
      reg_putch <= io_in_putch; // @[Reg.scala 28:23]
    end
    if (reset) begin // @[Reg.scala 27:20]
      reg_csr_wen <= 1'h0; // @[Reg.scala 27:20]
    end else if (io_en) begin // @[Reg.scala 28:19]
      reg_csr_wen <= io_in_csr_wen; // @[Reg.scala 28:23]
    end
    if (reset) begin // @[Reg.scala 27:20]
      reg_csr_waddr <= 12'h0; // @[Reg.scala 27:20]
    end else if (io_en) begin // @[Reg.scala 28:19]
      reg_csr_waddr <= io_in_csr_waddr; // @[Reg.scala 28:23]
    end
    if (reset) begin // @[Reg.scala 27:20]
      reg_csr_wdata <= 64'h0; // @[Reg.scala 27:20]
    end else if (io_en) begin // @[Reg.scala 28:19]
      reg_csr_wdata <= io_in_csr_wdata; // @[Reg.scala 28:23]
    end
  end
// Register and memory initialization
`ifdef RANDOMIZE_GARBAGE_ASSIGN
`define RANDOMIZE
`endif
`ifdef RANDOMIZE_INVALID_ASSIGN
`define RANDOMIZE
`endif
`ifdef RANDOMIZE_REG_INIT
`define RANDOMIZE
`endif
`ifdef RANDOMIZE_MEM_INIT
`define RANDOMIZE
`endif
`ifndef RANDOM
`define RANDOM $random
`endif
`ifdef RANDOMIZE_MEM_INIT
  integer initvar;
`endif
`ifndef SYNTHESIS
`ifdef FIRRTL_BEFORE_INITIAL
`FIRRTL_BEFORE_INITIAL
`endif
initial begin
  `ifdef RANDOMIZE
    `ifdef INIT_RANDOM
      `INIT_RANDOM
    `endif
    `ifndef VERILATOR
      `ifdef RANDOMIZE_DELAY
        #`RANDOMIZE_DELAY begin end
      `else
        #0.002 begin end
      `endif
    `endif
`ifdef RANDOMIZE_REG_INIT
  _RAND_0 = {1{`RANDOM}};
  reg_valid = _RAND_0[0:0];
  _RAND_1 = {2{`RANDOM}};
  reg_pc = _RAND_1[63:0];
  _RAND_2 = {1{`RANDOM}};
  reg_inst = _RAND_2[31:0];
  _RAND_3 = {1{`RANDOM}};
  reg_rd_en = _RAND_3[0:0];
  _RAND_4 = {1{`RANDOM}};
  reg_rd_addr = _RAND_4[4:0];
  _RAND_5 = {2{`RANDOM}};
  reg_alu_out = _RAND_5[63:0];
  _RAND_6 = {2{`RANDOM}};
  reg_bu_out = _RAND_6[63:0];
  _RAND_7 = {2{`RANDOM}};
  reg_mdu_out = _RAND_7[63:0];
  _RAND_8 = {2{`RANDOM}};
  reg_csru_out = _RAND_8[63:0];
  _RAND_9 = {1{`RANDOM}};
  reg_fu_code = _RAND_9[5:0];
  _RAND_10 = {1{`RANDOM}};
  reg_lu_code = _RAND_10[6:0];
  _RAND_11 = {1{`RANDOM}};
  reg_csru_code = _RAND_11[7:0];
  _RAND_12 = {1{`RANDOM}};
  reg_lu_shift = _RAND_12[5:0];
  _RAND_13 = {1{`RANDOM}};
  reg_putch = _RAND_13[0:0];
  _RAND_14 = {1{`RANDOM}};
  reg_csr_wen = _RAND_14[0:0];
  _RAND_15 = {1{`RANDOM}};
  reg_csr_waddr = _RAND_15[11:0];
  _RAND_16 = {2{`RANDOM}};
  reg_csr_wdata = _RAND_16[63:0];
`endif // RANDOMIZE_REG_INIT
  `endif // RANDOMIZE
end // initial
`ifdef FIRRTL_AFTER_INITIAL
`FIRRTL_AFTER_INITIAL
`endif
`endif // SYNTHESIS
endmodule
module Core(
  input         clock,
  input         reset,
  output [63:0] io_imem_addr,
  output        io_imem_en,
  input  [31:0] io_imem_data,
  input         io_imem_ok,
  output        io_dmem_en,
  output        io_dmem_op,
  output [63:0] io_dmem_addr,
  output [63:0] io_dmem_wdata,
  output [7:0]  io_dmem_wmask,
  input         io_dmem_ok,
  input  [63:0] io_dmem_rdata
);
`ifdef RANDOMIZE_REG_INIT
  reg [31:0] _RAND_0;
  reg [63:0] _RAND_1;
  reg [31:0] _RAND_2;
  reg [31:0] _RAND_3;
  reg [31:0] _RAND_4;
  reg [63:0] _RAND_5;
  reg [31:0] _RAND_6;
  reg [63:0] _RAND_7;
  reg [63:0] _RAND_8;
`endif // RANDOMIZE_REG_INIT
  wire  ifu_reset; // @[Core.scala 30:23]
  wire  ifu_io_jump_en; // @[Core.scala 30:23]
  wire [63:0] ifu_io_jump_pc; // @[Core.scala 30:23]
  wire [63:0] ifu_io_pc; // @[Core.scala 30:23]
  wire [63:0] ifu_io_next_pc; // @[Core.scala 30:23]
  wire  ifu_io_valid; // @[Core.scala 30:23]
  wire [63:0] idu_io_pc; // @[Core.scala 31:23]
  wire [31:0] idu_io_inst; // @[Core.scala 31:23]
  wire  idu_io_rs1_en; // @[Core.scala 31:23]
  wire  idu_io_rs2_en; // @[Core.scala 31:23]
  wire [4:0] idu_io_rs1_addr; // @[Core.scala 31:23]
  wire [4:0] idu_io_rs2_addr; // @[Core.scala 31:23]
  wire [63:0] idu_io_rs1_data; // @[Core.scala 31:23]
  wire [63:0] idu_io_rs2_data; // @[Core.scala 31:23]
  wire  idu_io_rd_en; // @[Core.scala 31:23]
  wire [4:0] idu_io_rd_addr; // @[Core.scala 31:23]
  wire [5:0] idu_io_decode_info_fu_code; // @[Core.scala 31:23]
  wire [15:0] idu_io_decode_info_alu_code; // @[Core.scala 31:23]
  wire [7:0] idu_io_decode_info_bu_code; // @[Core.scala 31:23]
  wire [6:0] idu_io_decode_info_lu_code; // @[Core.scala 31:23]
  wire [3:0] idu_io_decode_info_su_code; // @[Core.scala 31:23]
  wire [9:0] idu_io_decode_info_mdu_code; // @[Core.scala 31:23]
  wire [7:0] idu_io_decode_info_csru_code; // @[Core.scala 31:23]
  wire  idu_io_jump_en; // @[Core.scala 31:23]
  wire [63:0] idu_io_jump_pc; // @[Core.scala 31:23]
  wire [63:0] idu_io_op1; // @[Core.scala 31:23]
  wire [63:0] idu_io_op2; // @[Core.scala 31:23]
  wire [63:0] idu_io_imm; // @[Core.scala 31:23]
  wire  idu_io_putch; // @[Core.scala 31:23]
  wire [63:0] idu_io_mtvec; // @[Core.scala 31:23]
  wire [63:0] idu_io_mepc; // @[Core.scala 31:23]
  wire [15:0] ieu_io_decode_info_alu_code; // @[Core.scala 32:23]
  wire [7:0] ieu_io_decode_info_bu_code; // @[Core.scala 32:23]
  wire [9:0] ieu_io_decode_info_mdu_code; // @[Core.scala 32:23]
  wire [7:0] ieu_io_decode_info_csru_code; // @[Core.scala 32:23]
  wire [63:0] ieu_io_op1; // @[Core.scala 32:23]
  wire [63:0] ieu_io_op2; // @[Core.scala 32:23]
  wire [63:0] ieu_io_pc; // @[Core.scala 32:23]
  wire [63:0] ieu_io_alu_out; // @[Core.scala 32:23]
  wire [63:0] ieu_io_bu_out; // @[Core.scala 32:23]
  wire [63:0] ieu_io_mdu_out; // @[Core.scala 32:23]
  wire [63:0] ieu_io_csru_out; // @[Core.scala 32:23]
  wire [4:0] ieu_io_rs1_addr; // @[Core.scala 32:23]
  wire [11:0] ieu_io_csr_raddr; // @[Core.scala 32:23]
  wire [63:0] ieu_io_csr_rdata; // @[Core.scala 32:23]
  wire  ieu_io_csr_wen; // @[Core.scala 32:23]
  wire [11:0] ieu_io_csr_waddr; // @[Core.scala 32:23]
  wire [63:0] ieu_io_csr_wdata; // @[Core.scala 32:23]
  wire  rfu_clock; // @[Core.scala 33:23]
  wire  rfu_reset; // @[Core.scala 33:23]
  wire [4:0] rfu_io_rs1_addr; // @[Core.scala 33:23]
  wire [4:0] rfu_io_rs2_addr; // @[Core.scala 33:23]
  wire [63:0] rfu_io_rs1_data; // @[Core.scala 33:23]
  wire [63:0] rfu_io_rs2_data; // @[Core.scala 33:23]
  wire [4:0] rfu_io_rd_addr; // @[Core.scala 33:23]
  wire [63:0] rfu_io_rd_data; // @[Core.scala 33:23]
  wire  rfu_io_rd_en; // @[Core.scala 33:23]
  wire [63:0] rfu_rf_10; // @[Core.scala 33:23]
  wire  csru_clock; // @[Core.scala 34:23]
  wire  csru_reset; // @[Core.scala 34:23]
  wire [11:0] csru_io_raddr; // @[Core.scala 34:23]
  wire [63:0] csru_io_rdata; // @[Core.scala 34:23]
  wire  csru_io_wen; // @[Core.scala 34:23]
  wire [11:0] csru_io_waddr; // @[Core.scala 34:23]
  wire [63:0] csru_io_wdata; // @[Core.scala 34:23]
  wire  csru_io_csru_code_valid; // @[Core.scala 34:23]
  wire [7:0] csru_io_csru_code; // @[Core.scala 34:23]
  wire [63:0] csru_io_pc; // @[Core.scala 34:23]
  wire [63:0] csru_io_mtvec; // @[Core.scala 34:23]
  wire [63:0] csru_io_mepc; // @[Core.scala 34:23]
  wire [6:0] preamu_io_lu_code; // @[Core.scala 35:23]
  wire [3:0] preamu_io_su_code; // @[Core.scala 35:23]
  wire [63:0] preamu_io_op1; // @[Core.scala 35:23]
  wire [63:0] preamu_io_op2; // @[Core.scala 35:23]
  wire [63:0] preamu_io_imm; // @[Core.scala 35:23]
  wire [5:0] preamu_io_lu_shift; // @[Core.scala 35:23]
  wire  preamu_io_ren; // @[Core.scala 35:23]
  wire [63:0] preamu_io_raddr; // @[Core.scala 35:23]
  wire  preamu_io_wen; // @[Core.scala 35:23]
  wire [63:0] preamu_io_waddr; // @[Core.scala 35:23]
  wire [63:0] preamu_io_wdata; // @[Core.scala 35:23]
  wire [7:0] preamu_io_wmask; // @[Core.scala 35:23]
  wire [6:0] amu_io_lu_code; // @[Core.scala 36:23]
  wire [5:0] amu_io_lu_shift; // @[Core.scala 36:23]
  wire [63:0] amu_io_rdata; // @[Core.scala 36:23]
  wire [63:0] amu_io_lu_out; // @[Core.scala 36:23]
  wire [5:0] wbu_io_fu_code; // @[Core.scala 37:23]
  wire [63:0] wbu_io_alu_out; // @[Core.scala 37:23]
  wire [63:0] wbu_io_bu_out; // @[Core.scala 37:23]
  wire [63:0] wbu_io_mdu_out; // @[Core.scala 37:23]
  wire [63:0] wbu_io_lu_out; // @[Core.scala 37:23]
  wire [63:0] wbu_io_csru_out; // @[Core.scala 37:23]
  wire [63:0] wbu_io_out; // @[Core.scala 37:23]
  wire  rfconflict_io_rs_valid; // @[Core.scala 39:27]
  wire  rfconflict_io_rs1_en; // @[Core.scala 39:27]
  wire  rfconflict_io_rs2_en; // @[Core.scala 39:27]
  wire [4:0] rfconflict_io_rs1_addr; // @[Core.scala 39:27]
  wire [4:0] rfconflict_io_rs2_addr; // @[Core.scala 39:27]
  wire  rfconflict_io_rd1_valid; // @[Core.scala 39:27]
  wire  rfconflict_io_rd1_en; // @[Core.scala 39:27]
  wire [4:0] rfconflict_io_rd1_addr; // @[Core.scala 39:27]
  wire  rfconflict_io_rd2_valid; // @[Core.scala 39:27]
  wire  rfconflict_io_rd2_en; // @[Core.scala 39:27]
  wire [4:0] rfconflict_io_rd2_addr; // @[Core.scala 39:27]
  wire  rfconflict_io_rd3_valid; // @[Core.scala 39:27]
  wire  rfconflict_io_rd3_en; // @[Core.scala 39:27]
  wire [4:0] rfconflict_io_rd3_addr; // @[Core.scala 39:27]
  wire  rfconflict_io_conflict; // @[Core.scala 39:27]
  wire  idreg_clock; // @[Core.scala 41:23]
  wire  idreg_reset; // @[Core.scala 41:23]
  wire  idreg_io_en; // @[Core.scala 41:23]
  wire  idreg_io_in_valid; // @[Core.scala 41:23]
  wire [63:0] idreg_io_in_pc; // @[Core.scala 41:23]
  wire  idreg_io_out_valid; // @[Core.scala 41:23]
  wire [63:0] idreg_io_out_pc; // @[Core.scala 41:23]
  wire [63:0] idreg_io_imem__addr; // @[Core.scala 41:23]
  wire  idreg_io_imem__en; // @[Core.scala 41:23]
  wire [31:0] idreg_io_imem__data; // @[Core.scala 41:23]
  wire [31:0] idreg_io_inst; // @[Core.scala 41:23]
  wire  exereg_clock; // @[Core.scala 42:23]
  wire  exereg_reset; // @[Core.scala 42:23]
  wire  exereg_io_en; // @[Core.scala 42:23]
  wire  exereg_io_in_valid; // @[Core.scala 42:23]
  wire [63:0] exereg_io_in_pc; // @[Core.scala 42:23]
  wire [31:0] exereg_io_in_inst; // @[Core.scala 42:23]
  wire  exereg_io_in_rd_en; // @[Core.scala 42:23]
  wire [4:0] exereg_io_in_rd_addr; // @[Core.scala 42:23]
  wire [63:0] exereg_io_in_imm; // @[Core.scala 42:23]
  wire [63:0] exereg_io_in_op1; // @[Core.scala 42:23]
  wire [63:0] exereg_io_in_op2; // @[Core.scala 42:23]
  wire [5:0] exereg_io_in_fu_code; // @[Core.scala 42:23]
  wire [15:0] exereg_io_in_alu_code; // @[Core.scala 42:23]
  wire [7:0] exereg_io_in_bu_code; // @[Core.scala 42:23]
  wire [6:0] exereg_io_in_lu_code; // @[Core.scala 42:23]
  wire [3:0] exereg_io_in_su_code; // @[Core.scala 42:23]
  wire [9:0] exereg_io_in_mdu_code; // @[Core.scala 42:23]
  wire [7:0] exereg_io_in_csru_code; // @[Core.scala 42:23]
  wire [4:0] exereg_io_in_rs1_addr; // @[Core.scala 42:23]
  wire  exereg_io_in_putch; // @[Core.scala 42:23]
  wire  exereg_io_out_valid; // @[Core.scala 42:23]
  wire [63:0] exereg_io_out_pc; // @[Core.scala 42:23]
  wire [31:0] exereg_io_out_inst; // @[Core.scala 42:23]
  wire  exereg_io_out_rd_en; // @[Core.scala 42:23]
  wire [4:0] exereg_io_out_rd_addr; // @[Core.scala 42:23]
  wire [63:0] exereg_io_out_imm; // @[Core.scala 42:23]
  wire [63:0] exereg_io_out_op1; // @[Core.scala 42:23]
  wire [63:0] exereg_io_out_op2; // @[Core.scala 42:23]
  wire [5:0] exereg_io_out_fu_code; // @[Core.scala 42:23]
  wire [15:0] exereg_io_out_alu_code; // @[Core.scala 42:23]
  wire [7:0] exereg_io_out_bu_code; // @[Core.scala 42:23]
  wire [6:0] exereg_io_out_lu_code; // @[Core.scala 42:23]
  wire [3:0] exereg_io_out_su_code; // @[Core.scala 42:23]
  wire [9:0] exereg_io_out_mdu_code; // @[Core.scala 42:23]
  wire [7:0] exereg_io_out_csru_code; // @[Core.scala 42:23]
  wire [4:0] exereg_io_out_rs1_addr; // @[Core.scala 42:23]
  wire  exereg_io_out_putch; // @[Core.scala 42:23]
  wire  memreg_clock; // @[Core.scala 43:23]
  wire  memreg_reset; // @[Core.scala 43:23]
  wire  memreg_io_en; // @[Core.scala 43:23]
  wire  memreg_io_in_valid; // @[Core.scala 43:23]
  wire [63:0] memreg_io_in_pc; // @[Core.scala 43:23]
  wire [31:0] memreg_io_in_inst; // @[Core.scala 43:23]
  wire  memreg_io_in_rd_en; // @[Core.scala 43:23]
  wire [4:0] memreg_io_in_rd_addr; // @[Core.scala 43:23]
  wire [63:0] memreg_io_in_imm; // @[Core.scala 43:23]
  wire [63:0] memreg_io_in_op1; // @[Core.scala 43:23]
  wire [63:0] memreg_io_in_op2; // @[Core.scala 43:23]
  wire [63:0] memreg_io_in_alu_out; // @[Core.scala 43:23]
  wire [63:0] memreg_io_in_bu_out; // @[Core.scala 43:23]
  wire [63:0] memreg_io_in_mdu_out; // @[Core.scala 43:23]
  wire [63:0] memreg_io_in_csru_out; // @[Core.scala 43:23]
  wire [5:0] memreg_io_in_fu_code; // @[Core.scala 43:23]
  wire [6:0] memreg_io_in_lu_code; // @[Core.scala 43:23]
  wire [3:0] memreg_io_in_su_code; // @[Core.scala 43:23]
  wire [7:0] memreg_io_in_csru_code; // @[Core.scala 43:23]
  wire  memreg_io_in_putch; // @[Core.scala 43:23]
  wire  memreg_io_in_csr_wen; // @[Core.scala 43:23]
  wire [11:0] memreg_io_in_csr_waddr; // @[Core.scala 43:23]
  wire [63:0] memreg_io_in_csr_wdata; // @[Core.scala 43:23]
  wire  memreg_io_out_valid; // @[Core.scala 43:23]
  wire [63:0] memreg_io_out_pc; // @[Core.scala 43:23]
  wire [31:0] memreg_io_out_inst; // @[Core.scala 43:23]
  wire  memreg_io_out_rd_en; // @[Core.scala 43:23]
  wire [4:0] memreg_io_out_rd_addr; // @[Core.scala 43:23]
  wire [63:0] memreg_io_out_imm; // @[Core.scala 43:23]
  wire [63:0] memreg_io_out_op1; // @[Core.scala 43:23]
  wire [63:0] memreg_io_out_op2; // @[Core.scala 43:23]
  wire [63:0] memreg_io_out_alu_out; // @[Core.scala 43:23]
  wire [63:0] memreg_io_out_bu_out; // @[Core.scala 43:23]
  wire [63:0] memreg_io_out_mdu_out; // @[Core.scala 43:23]
  wire [63:0] memreg_io_out_csru_out; // @[Core.scala 43:23]
  wire [5:0] memreg_io_out_fu_code; // @[Core.scala 43:23]
  wire [6:0] memreg_io_out_lu_code; // @[Core.scala 43:23]
  wire [3:0] memreg_io_out_su_code; // @[Core.scala 43:23]
  wire [7:0] memreg_io_out_csru_code; // @[Core.scala 43:23]
  wire  memreg_io_out_putch; // @[Core.scala 43:23]
  wire  memreg_io_out_csr_wen; // @[Core.scala 43:23]
  wire [11:0] memreg_io_out_csr_waddr; // @[Core.scala 43:23]
  wire [63:0] memreg_io_out_csr_wdata; // @[Core.scala 43:23]
  wire  wbreg_clock; // @[Core.scala 44:23]
  wire  wbreg_reset; // @[Core.scala 44:23]
  wire  wbreg_io_en; // @[Core.scala 44:23]
  wire  wbreg_io_in_valid; // @[Core.scala 44:23]
  wire [63:0] wbreg_io_in_pc; // @[Core.scala 44:23]
  wire [31:0] wbreg_io_in_inst; // @[Core.scala 44:23]
  wire  wbreg_io_in_rd_en; // @[Core.scala 44:23]
  wire [4:0] wbreg_io_in_rd_addr; // @[Core.scala 44:23]
  wire [63:0] wbreg_io_in_alu_out; // @[Core.scala 44:23]
  wire [63:0] wbreg_io_in_bu_out; // @[Core.scala 44:23]
  wire [63:0] wbreg_io_in_mdu_out; // @[Core.scala 44:23]
  wire [63:0] wbreg_io_in_csru_out; // @[Core.scala 44:23]
  wire [5:0] wbreg_io_in_fu_code; // @[Core.scala 44:23]
  wire [6:0] wbreg_io_in_lu_code; // @[Core.scala 44:23]
  wire [7:0] wbreg_io_in_csru_code; // @[Core.scala 44:23]
  wire [5:0] wbreg_io_in_lu_shift; // @[Core.scala 44:23]
  wire  wbreg_io_in_putch; // @[Core.scala 44:23]
  wire  wbreg_io_in_csr_wen; // @[Core.scala 44:23]
  wire [11:0] wbreg_io_in_csr_waddr; // @[Core.scala 44:23]
  wire [63:0] wbreg_io_in_csr_wdata; // @[Core.scala 44:23]
  wire  wbreg_io_out_valid; // @[Core.scala 44:23]
  wire [63:0] wbreg_io_out_pc; // @[Core.scala 44:23]
  wire [31:0] wbreg_io_out_inst; // @[Core.scala 44:23]
  wire  wbreg_io_out_rd_en; // @[Core.scala 44:23]
  wire [4:0] wbreg_io_out_rd_addr; // @[Core.scala 44:23]
  wire [63:0] wbreg_io_out_alu_out; // @[Core.scala 44:23]
  wire [63:0] wbreg_io_out_bu_out; // @[Core.scala 44:23]
  wire [63:0] wbreg_io_out_mdu_out; // @[Core.scala 44:23]
  wire [63:0] wbreg_io_out_csru_out; // @[Core.scala 44:23]
  wire [5:0] wbreg_io_out_fu_code; // @[Core.scala 44:23]
  wire [6:0] wbreg_io_out_lu_code; // @[Core.scala 44:23]
  wire [7:0] wbreg_io_out_csru_code; // @[Core.scala 44:23]
  wire [5:0] wbreg_io_out_lu_shift; // @[Core.scala 44:23]
  wire  wbreg_io_out_putch; // @[Core.scala 44:23]
  wire  wbreg_io_out_csr_wen; // @[Core.scala 44:23]
  wire [11:0] wbreg_io_out_csr_waddr; // @[Core.scala 44:23]
  wire [63:0] wbreg_io_out_csr_wdata; // @[Core.scala 44:23]
  wire  dt_ic_clock; // @[Core.scala 259:21]
  wire [7:0] dt_ic_coreid; // @[Core.scala 259:21]
  wire [7:0] dt_ic_index; // @[Core.scala 259:21]
  wire  dt_ic_valid; // @[Core.scala 259:21]
  wire [63:0] dt_ic_pc; // @[Core.scala 259:21]
  wire [31:0] dt_ic_instr; // @[Core.scala 259:21]
  wire [7:0] dt_ic_special; // @[Core.scala 259:21]
  wire  dt_ic_skip; // @[Core.scala 259:21]
  wire  dt_ic_isRVC; // @[Core.scala 259:21]
  wire  dt_ic_scFailed; // @[Core.scala 259:21]
  wire  dt_ic_wen; // @[Core.scala 259:21]
  wire [63:0] dt_ic_wdata; // @[Core.scala 259:21]
  wire [7:0] dt_ic_wdest; // @[Core.scala 259:21]
  wire  dt_ae_clock; // @[Core.scala 274:21]
  wire [7:0] dt_ae_coreid; // @[Core.scala 274:21]
  wire [31:0] dt_ae_intrNO; // @[Core.scala 274:21]
  wire [31:0] dt_ae_cause; // @[Core.scala 274:21]
  wire [63:0] dt_ae_exceptionPC; // @[Core.scala 274:21]
  wire [31:0] dt_ae_exceptionInst; // @[Core.scala 274:21]
  wire  dt_te_clock; // @[Core.scala 290:21]
  wire [7:0] dt_te_coreid; // @[Core.scala 290:21]
  wire  dt_te_valid; // @[Core.scala 290:21]
  wire [2:0] dt_te_code; // @[Core.scala 290:21]
  wire [63:0] dt_te_pc; // @[Core.scala 290:21]
  wire [63:0] dt_te_cycleCnt; // @[Core.scala 290:21]
  wire [63:0] dt_te_instrCnt; // @[Core.scala 290:21]
  wire  dmem_en = preamu_io_ren | preamu_io_wen; // @[Core.scala 122:31]
  wire  imem_not_ok = ~io_imem_ok; // @[Core.scala 202:21]
  wire  dmem_not_ok = ~io_dmem_ok; // @[Core.scala 203:21]
  wire  stall = rfconflict_io_conflict | imem_not_ok; // @[Core.scala 205:38]
  wire  _exereg_io_in_valid_T = ~stall; // @[Core.scala 217:48]
  wire  _commit_valid_T = ~dmem_not_ok; // @[Core.scala 220:44]
  wire  commit_valid = wbreg_io_out_valid & ~dmem_not_ok; // @[Core.scala 220:41]
  wire  skip_putch = wbreg_io_out_inst == 32'h7b; // @[Core.scala 254:38]
  wire [31:0] _read_mcycle_T = wbreg_io_out_inst & 32'hfff0307f; // @[Core.scala 255:27]
  wire  read_mcycle = _read_mcycle_T == 32'hb0002073; // @[Core.scala 255:44]
  wire  read_mtime = wbreg_io_out_inst == 32'hff86b683; // @[Core.scala 256:25]
  wire  write_mtimecmp = wbreg_io_out_inst == 32'hd7b023; // @[Core.scala 257:29]
  reg  dt_ic_io_valid_REG; // @[Core.scala 263:31]
  reg [63:0] dt_ic_io_pc_REG; // @[Core.scala 264:31]
  reg [31:0] dt_ic_io_instr_REG; // @[Core.scala 265:31]
  reg  dt_ic_io_skip_REG; // @[Core.scala 267:31]
  reg  dt_ic_io_wen_REG; // @[Core.scala 270:31]
  reg [63:0] dt_ic_io_wdata_REG; // @[Core.scala 271:31]
  reg [4:0] dt_ic_io_wdest_REG; // @[Core.scala 272:31]
  reg [63:0] cycle_cnt; // @[Core.scala 281:26]
  reg [63:0] instr_cnt; // @[Core.scala 282:26]
  wire [63:0] _cycle_cnt_T_1 = cycle_cnt + 64'h1; // @[Core.scala 284:26]
  wire [63:0] _instr_cnt_T_1 = instr_cnt + 64'h1; // @[Core.scala 285:44]
  wire [63:0] rf_a0_0 = rfu_rf_10;
  IFetch ifu ( // @[Core.scala 30:23]
    .reset(ifu_reset),
    .io_jump_en(ifu_io_jump_en),
    .io_jump_pc(ifu_io_jump_pc),
    .io_pc(ifu_io_pc),
    .io_next_pc(ifu_io_next_pc),
    .io_valid(ifu_io_valid)
  );
  Decode idu ( // @[Core.scala 31:23]
    .io_pc(idu_io_pc),
    .io_inst(idu_io_inst),
    .io_rs1_en(idu_io_rs1_en),
    .io_rs2_en(idu_io_rs2_en),
    .io_rs1_addr(idu_io_rs1_addr),
    .io_rs2_addr(idu_io_rs2_addr),
    .io_rs1_data(idu_io_rs1_data),
    .io_rs2_data(idu_io_rs2_data),
    .io_rd_en(idu_io_rd_en),
    .io_rd_addr(idu_io_rd_addr),
    .io_decode_info_fu_code(idu_io_decode_info_fu_code),
    .io_decode_info_alu_code(idu_io_decode_info_alu_code),
    .io_decode_info_bu_code(idu_io_decode_info_bu_code),
    .io_decode_info_lu_code(idu_io_decode_info_lu_code),
    .io_decode_info_su_code(idu_io_decode_info_su_code),
    .io_decode_info_mdu_code(idu_io_decode_info_mdu_code),
    .io_decode_info_csru_code(idu_io_decode_info_csru_code),
    .io_jump_en(idu_io_jump_en),
    .io_jump_pc(idu_io_jump_pc),
    .io_op1(idu_io_op1),
    .io_op2(idu_io_op2),
    .io_imm(idu_io_imm),
    .io_putch(idu_io_putch),
    .io_mtvec(idu_io_mtvec),
    .io_mepc(idu_io_mepc)
  );
  Execution ieu ( // @[Core.scala 32:23]
    .io_decode_info_alu_code(ieu_io_decode_info_alu_code),
    .io_decode_info_bu_code(ieu_io_decode_info_bu_code),
    .io_decode_info_mdu_code(ieu_io_decode_info_mdu_code),
    .io_decode_info_csru_code(ieu_io_decode_info_csru_code),
    .io_op1(ieu_io_op1),
    .io_op2(ieu_io_op2),
    .io_pc(ieu_io_pc),
    .io_alu_out(ieu_io_alu_out),
    .io_bu_out(ieu_io_bu_out),
    .io_mdu_out(ieu_io_mdu_out),
    .io_csru_out(ieu_io_csru_out),
    .io_rs1_addr(ieu_io_rs1_addr),
    .io_csr_raddr(ieu_io_csr_raddr),
    .io_csr_rdata(ieu_io_csr_rdata),
    .io_csr_wen(ieu_io_csr_wen),
    .io_csr_waddr(ieu_io_csr_waddr),
    .io_csr_wdata(ieu_io_csr_wdata)
  );
  RegFile rfu ( // @[Core.scala 33:23]
    .clock(rfu_clock),
    .reset(rfu_reset),
    .io_rs1_addr(rfu_io_rs1_addr),
    .io_rs2_addr(rfu_io_rs2_addr),
    .io_rs1_data(rfu_io_rs1_data),
    .io_rs2_data(rfu_io_rs2_data),
    .io_rd_addr(rfu_io_rd_addr),
    .io_rd_data(rfu_io_rd_data),
    .io_rd_en(rfu_io_rd_en),
    .rf_10(rfu_rf_10)
  );
  Csr csru ( // @[Core.scala 34:23]
    .clock(csru_clock),
    .reset(csru_reset),
    .io_raddr(csru_io_raddr),
    .io_rdata(csru_io_rdata),
    .io_wen(csru_io_wen),
    .io_waddr(csru_io_waddr),
    .io_wdata(csru_io_wdata),
    .io_csru_code_valid(csru_io_csru_code_valid),
    .io_csru_code(csru_io_csru_code),
    .io_pc(csru_io_pc),
    .io_mtvec(csru_io_mtvec),
    .io_mepc(csru_io_mepc)
  );
  PreAccessMemory preamu ( // @[Core.scala 35:23]
    .io_lu_code(preamu_io_lu_code),
    .io_su_code(preamu_io_su_code),
    .io_op1(preamu_io_op1),
    .io_op2(preamu_io_op2),
    .io_imm(preamu_io_imm),
    .io_lu_shift(preamu_io_lu_shift),
    .io_ren(preamu_io_ren),
    .io_raddr(preamu_io_raddr),
    .io_wen(preamu_io_wen),
    .io_waddr(preamu_io_waddr),
    .io_wdata(preamu_io_wdata),
    .io_wmask(preamu_io_wmask)
  );
  AccessMemory amu ( // @[Core.scala 36:23]
    .io_lu_code(amu_io_lu_code),
    .io_lu_shift(amu_io_lu_shift),
    .io_rdata(amu_io_rdata),
    .io_lu_out(amu_io_lu_out)
  );
  WriteBack wbu ( // @[Core.scala 37:23]
    .io_fu_code(wbu_io_fu_code),
    .io_alu_out(wbu_io_alu_out),
    .io_bu_out(wbu_io_bu_out),
    .io_mdu_out(wbu_io_mdu_out),
    .io_lu_out(wbu_io_lu_out),
    .io_csru_out(wbu_io_csru_out),
    .io_out(wbu_io_out)
  );
  RegfileConflict rfconflict ( // @[Core.scala 39:27]
    .io_rs_valid(rfconflict_io_rs_valid),
    .io_rs1_en(rfconflict_io_rs1_en),
    .io_rs2_en(rfconflict_io_rs2_en),
    .io_rs1_addr(rfconflict_io_rs1_addr),
    .io_rs2_addr(rfconflict_io_rs2_addr),
    .io_rd1_valid(rfconflict_io_rd1_valid),
    .io_rd1_en(rfconflict_io_rd1_en),
    .io_rd1_addr(rfconflict_io_rd1_addr),
    .io_rd2_valid(rfconflict_io_rd2_valid),
    .io_rd2_en(rfconflict_io_rd2_en),
    .io_rd2_addr(rfconflict_io_rd2_addr),
    .io_rd3_valid(rfconflict_io_rd3_valid),
    .io_rd3_en(rfconflict_io_rd3_en),
    .io_rd3_addr(rfconflict_io_rd3_addr),
    .io_conflict(rfconflict_io_conflict)
  );
  IDReg idreg ( // @[Core.scala 41:23]
    .clock(idreg_clock),
    .reset(idreg_reset),
    .io_en(idreg_io_en),
    .io_in_valid(idreg_io_in_valid),
    .io_in_pc(idreg_io_in_pc),
    .io_out_valid(idreg_io_out_valid),
    .io_out_pc(idreg_io_out_pc),
    .io_imem__addr(idreg_io_imem__addr),
    .io_imem__en(idreg_io_imem__en),
    .io_imem__data(idreg_io_imem__data),
    .io_inst(idreg_io_inst)
  );
  ExeReg exereg ( // @[Core.scala 42:23]
    .clock(exereg_clock),
    .reset(exereg_reset),
    .io_en(exereg_io_en),
    .io_in_valid(exereg_io_in_valid),
    .io_in_pc(exereg_io_in_pc),
    .io_in_inst(exereg_io_in_inst),
    .io_in_rd_en(exereg_io_in_rd_en),
    .io_in_rd_addr(exereg_io_in_rd_addr),
    .io_in_imm(exereg_io_in_imm),
    .io_in_op1(exereg_io_in_op1),
    .io_in_op2(exereg_io_in_op2),
    .io_in_fu_code(exereg_io_in_fu_code),
    .io_in_alu_code(exereg_io_in_alu_code),
    .io_in_bu_code(exereg_io_in_bu_code),
    .io_in_lu_code(exereg_io_in_lu_code),
    .io_in_su_code(exereg_io_in_su_code),
    .io_in_mdu_code(exereg_io_in_mdu_code),
    .io_in_csru_code(exereg_io_in_csru_code),
    .io_in_rs1_addr(exereg_io_in_rs1_addr),
    .io_in_putch(exereg_io_in_putch),
    .io_out_valid(exereg_io_out_valid),
    .io_out_pc(exereg_io_out_pc),
    .io_out_inst(exereg_io_out_inst),
    .io_out_rd_en(exereg_io_out_rd_en),
    .io_out_rd_addr(exereg_io_out_rd_addr),
    .io_out_imm(exereg_io_out_imm),
    .io_out_op1(exereg_io_out_op1),
    .io_out_op2(exereg_io_out_op2),
    .io_out_fu_code(exereg_io_out_fu_code),
    .io_out_alu_code(exereg_io_out_alu_code),
    .io_out_bu_code(exereg_io_out_bu_code),
    .io_out_lu_code(exereg_io_out_lu_code),
    .io_out_su_code(exereg_io_out_su_code),
    .io_out_mdu_code(exereg_io_out_mdu_code),
    .io_out_csru_code(exereg_io_out_csru_code),
    .io_out_rs1_addr(exereg_io_out_rs1_addr),
    .io_out_putch(exereg_io_out_putch)
  );
  MemReg memreg ( // @[Core.scala 43:23]
    .clock(memreg_clock),
    .reset(memreg_reset),
    .io_en(memreg_io_en),
    .io_in_valid(memreg_io_in_valid),
    .io_in_pc(memreg_io_in_pc),
    .io_in_inst(memreg_io_in_inst),
    .io_in_rd_en(memreg_io_in_rd_en),
    .io_in_rd_addr(memreg_io_in_rd_addr),
    .io_in_imm(memreg_io_in_imm),
    .io_in_op1(memreg_io_in_op1),
    .io_in_op2(memreg_io_in_op2),
    .io_in_alu_out(memreg_io_in_alu_out),
    .io_in_bu_out(memreg_io_in_bu_out),
    .io_in_mdu_out(memreg_io_in_mdu_out),
    .io_in_csru_out(memreg_io_in_csru_out),
    .io_in_fu_code(memreg_io_in_fu_code),
    .io_in_lu_code(memreg_io_in_lu_code),
    .io_in_su_code(memreg_io_in_su_code),
    .io_in_csru_code(memreg_io_in_csru_code),
    .io_in_putch(memreg_io_in_putch),
    .io_in_csr_wen(memreg_io_in_csr_wen),
    .io_in_csr_waddr(memreg_io_in_csr_waddr),
    .io_in_csr_wdata(memreg_io_in_csr_wdata),
    .io_out_valid(memreg_io_out_valid),
    .io_out_pc(memreg_io_out_pc),
    .io_out_inst(memreg_io_out_inst),
    .io_out_rd_en(memreg_io_out_rd_en),
    .io_out_rd_addr(memreg_io_out_rd_addr),
    .io_out_imm(memreg_io_out_imm),
    .io_out_op1(memreg_io_out_op1),
    .io_out_op2(memreg_io_out_op2),
    .io_out_alu_out(memreg_io_out_alu_out),
    .io_out_bu_out(memreg_io_out_bu_out),
    .io_out_mdu_out(memreg_io_out_mdu_out),
    .io_out_csru_out(memreg_io_out_csru_out),
    .io_out_fu_code(memreg_io_out_fu_code),
    .io_out_lu_code(memreg_io_out_lu_code),
    .io_out_su_code(memreg_io_out_su_code),
    .io_out_csru_code(memreg_io_out_csru_code),
    .io_out_putch(memreg_io_out_putch),
    .io_out_csr_wen(memreg_io_out_csr_wen),
    .io_out_csr_waddr(memreg_io_out_csr_waddr),
    .io_out_csr_wdata(memreg_io_out_csr_wdata)
  );
  WBReg wbreg ( // @[Core.scala 44:23]
    .clock(wbreg_clock),
    .reset(wbreg_reset),
    .io_en(wbreg_io_en),
    .io_in_valid(wbreg_io_in_valid),
    .io_in_pc(wbreg_io_in_pc),
    .io_in_inst(wbreg_io_in_inst),
    .io_in_rd_en(wbreg_io_in_rd_en),
    .io_in_rd_addr(wbreg_io_in_rd_addr),
    .io_in_alu_out(wbreg_io_in_alu_out),
    .io_in_bu_out(wbreg_io_in_bu_out),
    .io_in_mdu_out(wbreg_io_in_mdu_out),
    .io_in_csru_out(wbreg_io_in_csru_out),
    .io_in_fu_code(wbreg_io_in_fu_code),
    .io_in_lu_code(wbreg_io_in_lu_code),
    .io_in_csru_code(wbreg_io_in_csru_code),
    .io_in_lu_shift(wbreg_io_in_lu_shift),
    .io_in_putch(wbreg_io_in_putch),
    .io_in_csr_wen(wbreg_io_in_csr_wen),
    .io_in_csr_waddr(wbreg_io_in_csr_waddr),
    .io_in_csr_wdata(wbreg_io_in_csr_wdata),
    .io_out_valid(wbreg_io_out_valid),
    .io_out_pc(wbreg_io_out_pc),
    .io_out_inst(wbreg_io_out_inst),
    .io_out_rd_en(wbreg_io_out_rd_en),
    .io_out_rd_addr(wbreg_io_out_rd_addr),
    .io_out_alu_out(wbreg_io_out_alu_out),
    .io_out_bu_out(wbreg_io_out_bu_out),
    .io_out_mdu_out(wbreg_io_out_mdu_out),
    .io_out_csru_out(wbreg_io_out_csru_out),
    .io_out_fu_code(wbreg_io_out_fu_code),
    .io_out_lu_code(wbreg_io_out_lu_code),
    .io_out_csru_code(wbreg_io_out_csru_code),
    .io_out_lu_shift(wbreg_io_out_lu_shift),
    .io_out_putch(wbreg_io_out_putch),
    .io_out_csr_wen(wbreg_io_out_csr_wen),
    .io_out_csr_waddr(wbreg_io_out_csr_waddr),
    .io_out_csr_wdata(wbreg_io_out_csr_wdata)
  );
  DifftestInstrCommit dt_ic ( // @[Core.scala 259:21]
    .clock(dt_ic_clock),
    .coreid(dt_ic_coreid),
    .index(dt_ic_index),
    .valid(dt_ic_valid),
    .pc(dt_ic_pc),
    .instr(dt_ic_instr),
    .special(dt_ic_special),
    .skip(dt_ic_skip),
    .isRVC(dt_ic_isRVC),
    .scFailed(dt_ic_scFailed),
    .wen(dt_ic_wen),
    .wdata(dt_ic_wdata),
    .wdest(dt_ic_wdest)
  );
  DifftestArchEvent dt_ae ( // @[Core.scala 274:21]
    .clock(dt_ae_clock),
    .coreid(dt_ae_coreid),
    .intrNO(dt_ae_intrNO),
    .cause(dt_ae_cause),
    .exceptionPC(dt_ae_exceptionPC),
    .exceptionInst(dt_ae_exceptionInst)
  );
  DifftestTrapEvent dt_te ( // @[Core.scala 290:21]
    .clock(dt_te_clock),
    .coreid(dt_te_coreid),
    .valid(dt_te_valid),
    .code(dt_te_code),
    .pc(dt_te_pc),
    .cycleCnt(dt_te_cycleCnt),
    .instrCnt(dt_te_instrCnt)
  );
  assign io_imem_addr = idreg_io_imem__addr; // @[Core.scala 50:17]
  assign io_imem_en = idreg_io_imem__en; // @[Core.scala 50:17]
  assign io_dmem_en = dmem_en & memreg_io_out_valid; // @[Core.scala 125:28]
  assign io_dmem_op = preamu_io_wen; // @[Core.scala 126:17]
  assign io_dmem_addr = preamu_io_wen ? preamu_io_waddr : preamu_io_raddr; // @[Core.scala 124:22]
  assign io_dmem_wdata = preamu_io_wdata; // @[Core.scala 128:17]
  assign io_dmem_wmask = preamu_io_wmask; // @[Core.scala 129:17]
  assign ifu_reset = reset;
  assign ifu_io_jump_en = idu_io_jump_en; // @[Core.scala 46:19]
  assign ifu_io_jump_pc = idu_io_jump_pc; // @[Core.scala 47:19]
  assign ifu_io_pc = idreg_io_out_pc; // @[Core.scala 48:19]
  assign idu_io_pc = idreg_io_out_pc; // @[Core.scala 53:19]
  assign idu_io_inst = idreg_io_inst; // @[Core.scala 54:19]
  assign idu_io_rs1_data = rfu_io_rs1_data; // @[Core.scala 55:19]
  assign idu_io_rs2_data = rfu_io_rs2_data; // @[Core.scala 56:19]
  assign idu_io_mtvec = csru_io_mtvec; // @[Core.scala 57:19]
  assign idu_io_mepc = csru_io_mepc; // @[Core.scala 58:19]
  assign ieu_io_decode_info_alu_code = exereg_io_out_alu_code; // @[Core.scala 78:31]
  assign ieu_io_decode_info_bu_code = exereg_io_out_bu_code; // @[Core.scala 79:31]
  assign ieu_io_decode_info_mdu_code = exereg_io_out_mdu_code; // @[Core.scala 80:31]
  assign ieu_io_decode_info_csru_code = exereg_io_out_csru_code; // @[Core.scala 83:32]
  assign ieu_io_op1 = exereg_io_out_op1; // @[Core.scala 84:14]
  assign ieu_io_op2 = exereg_io_out_op2; // @[Core.scala 85:14]
  assign ieu_io_pc = exereg_io_out_pc; // @[Core.scala 86:14]
  assign ieu_io_rs1_addr = exereg_io_out_rs1_addr; // @[Core.scala 88:19]
  assign ieu_io_csr_rdata = csru_io_rdata; // @[Core.scala 89:20]
  assign rfu_clock = clock;
  assign rfu_reset = reset;
  assign rfu_io_rs1_addr = idu_io_rs1_addr; // @[Core.scala 170:19]
  assign rfu_io_rs2_addr = idu_io_rs2_addr; // @[Core.scala 171:19]
  assign rfu_io_rd_addr = wbreg_io_out_rd_addr; // @[Core.scala 173:19]
  assign rfu_io_rd_data = wbu_io_out; // @[Core.scala 175:19]
  assign rfu_io_rd_en = wbreg_io_out_rd_en & commit_valid; // @[Core.scala 229:39]
  assign csru_clock = clock;
  assign csru_reset = reset;
  assign csru_io_raddr = ieu_io_csr_raddr; // @[Core.scala 178:21]
  assign csru_io_wen = wbreg_io_out_csr_wen & commit_valid; // @[Core.scala 230:41]
  assign csru_io_waddr = wbreg_io_out_csr_waddr; // @[Core.scala 179:21]
  assign csru_io_wdata = wbreg_io_out_csr_wdata; // @[Core.scala 180:21]
  assign csru_io_csru_code_valid = wbreg_io_out_valid & ~dmem_not_ok; // @[Core.scala 220:41]
  assign csru_io_csru_code = wbreg_io_out_csru_code; // @[Core.scala 181:21]
  assign csru_io_pc = wbreg_io_out_pc; // @[Core.scala 182:21]
  assign preamu_io_lu_code = memreg_io_out_lu_code; // @[Core.scala 116:21]
  assign preamu_io_su_code = memreg_io_out_su_code; // @[Core.scala 117:21]
  assign preamu_io_op1 = memreg_io_out_op1; // @[Core.scala 118:21]
  assign preamu_io_op2 = memreg_io_out_op2; // @[Core.scala 119:21]
  assign preamu_io_imm = memreg_io_out_imm; // @[Core.scala 120:21]
  assign amu_io_lu_code = wbreg_io_out_lu_code; // @[Core.scala 156:19]
  assign amu_io_lu_shift = wbreg_io_out_lu_shift; // @[Core.scala 157:19]
  assign amu_io_rdata = io_dmem_rdata; // @[Core.scala 158:19]
  assign wbu_io_fu_code = wbreg_io_out_fu_code; // @[Core.scala 160:19]
  assign wbu_io_alu_out = wbreg_io_out_alu_out; // @[Core.scala 161:19]
  assign wbu_io_bu_out = wbreg_io_out_bu_out; // @[Core.scala 162:19]
  assign wbu_io_mdu_out = wbreg_io_out_mdu_out; // @[Core.scala 163:19]
  assign wbu_io_lu_out = amu_io_lu_out; // @[Core.scala 165:19]
  assign wbu_io_csru_out = wbreg_io_out_csru_out; // @[Core.scala 164:19]
  assign rfconflict_io_rs_valid = idreg_io_out_valid; // @[Core.scala 186:28]
  assign rfconflict_io_rs1_en = idu_io_rs1_en; // @[Core.scala 187:28]
  assign rfconflict_io_rs2_en = idu_io_rs2_en; // @[Core.scala 188:28]
  assign rfconflict_io_rs1_addr = idu_io_rs1_addr; // @[Core.scala 189:28]
  assign rfconflict_io_rs2_addr = idu_io_rs2_addr; // @[Core.scala 190:28]
  assign rfconflict_io_rd1_valid = exereg_io_out_valid; // @[Core.scala 191:28]
  assign rfconflict_io_rd1_en = exereg_io_out_rd_en; // @[Core.scala 192:28]
  assign rfconflict_io_rd1_addr = exereg_io_out_rd_addr; // @[Core.scala 193:28]
  assign rfconflict_io_rd2_valid = memreg_io_out_valid; // @[Core.scala 194:28]
  assign rfconflict_io_rd2_en = memreg_io_out_rd_en; // @[Core.scala 195:28]
  assign rfconflict_io_rd2_addr = memreg_io_out_rd_addr; // @[Core.scala 196:28]
  assign rfconflict_io_rd3_valid = wbreg_io_out_valid; // @[Core.scala 197:28]
  assign rfconflict_io_rd3_en = wbreg_io_out_rd_en; // @[Core.scala 198:28]
  assign rfconflict_io_rd3_addr = wbreg_io_out_rd_addr; // @[Core.scala 199:28]
  assign idreg_clock = clock;
  assign idreg_reset = reset;
  assign idreg_io_en = _exereg_io_in_valid_T & _commit_valid_T; // @[Core.scala 222:26]
  assign idreg_io_in_valid = ifu_io_valid; // @[Core.scala 216:22]
  assign idreg_io_in_pc = ifu_io_next_pc; // @[Core.scala 51:19]
  assign idreg_io_imem__data = io_imem_data; // @[Core.scala 50:17]
  assign exereg_clock = clock;
  assign exereg_reset = reset;
  assign exereg_io_en = ~dmem_not_ok; // @[Core.scala 223:19]
  assign exereg_io_in_valid = idreg_io_out_valid & ~stall; // @[Core.scala 217:44]
  assign exereg_io_in_pc = idreg_io_out_pc; // @[Core.scala 60:25]
  assign exereg_io_in_inst = idreg_io_inst; // @[Core.scala 61:25]
  assign exereg_io_in_rd_en = idu_io_rd_en; // @[Core.scala 62:25]
  assign exereg_io_in_rd_addr = idu_io_rd_addr; // @[Core.scala 63:25]
  assign exereg_io_in_imm = idu_io_imm; // @[Core.scala 64:25]
  assign exereg_io_in_op1 = idu_io_op1; // @[Core.scala 65:25]
  assign exereg_io_in_op2 = idu_io_op2; // @[Core.scala 66:25]
  assign exereg_io_in_fu_code = idu_io_decode_info_fu_code; // @[Core.scala 68:25]
  assign exereg_io_in_alu_code = idu_io_decode_info_alu_code; // @[Core.scala 69:25]
  assign exereg_io_in_bu_code = idu_io_decode_info_bu_code; // @[Core.scala 70:25]
  assign exereg_io_in_lu_code = idu_io_decode_info_lu_code; // @[Core.scala 72:25]
  assign exereg_io_in_su_code = idu_io_decode_info_su_code; // @[Core.scala 73:25]
  assign exereg_io_in_mdu_code = idu_io_decode_info_mdu_code; // @[Core.scala 71:25]
  assign exereg_io_in_csru_code = idu_io_decode_info_csru_code; // @[Core.scala 74:29]
  assign exereg_io_in_rs1_addr = idu_io_rs1_addr; // @[Core.scala 67:25]
  assign exereg_io_in_putch = idu_io_putch; // @[Core.scala 75:25]
  assign memreg_clock = clock;
  assign memreg_reset = reset;
  assign memreg_io_en = ~dmem_not_ok; // @[Core.scala 224:19]
  assign memreg_io_in_valid = exereg_io_out_valid; // @[Core.scala 218:22]
  assign memreg_io_in_pc = exereg_io_out_pc; // @[Core.scala 91:25]
  assign memreg_io_in_inst = exereg_io_out_inst; // @[Core.scala 92:25]
  assign memreg_io_in_rd_en = exereg_io_out_rd_en; // @[Core.scala 93:25]
  assign memreg_io_in_rd_addr = exereg_io_out_rd_addr; // @[Core.scala 94:25]
  assign memreg_io_in_imm = exereg_io_out_imm; // @[Core.scala 95:25]
  assign memreg_io_in_op1 = exereg_io_out_op1; // @[Core.scala 96:25]
  assign memreg_io_in_op2 = exereg_io_out_op2; // @[Core.scala 97:25]
  assign memreg_io_in_alu_out = ieu_io_alu_out; // @[Core.scala 106:25]
  assign memreg_io_in_bu_out = ieu_io_bu_out; // @[Core.scala 107:25]
  assign memreg_io_in_mdu_out = ieu_io_mdu_out; // @[Core.scala 108:25]
  assign memreg_io_in_csru_out = ieu_io_csru_out; // @[Core.scala 109:25]
  assign memreg_io_in_fu_code = exereg_io_out_fu_code; // @[Core.scala 98:25]
  assign memreg_io_in_lu_code = exereg_io_out_lu_code; // @[Core.scala 102:25]
  assign memreg_io_in_su_code = exereg_io_out_su_code; // @[Core.scala 103:25]
  assign memreg_io_in_csru_code = exereg_io_out_csru_code; // @[Core.scala 104:26]
  assign memreg_io_in_putch = exereg_io_out_putch; // @[Core.scala 111:27]
  assign memreg_io_in_csr_wen = ieu_io_csr_wen; // @[Core.scala 112:27]
  assign memreg_io_in_csr_waddr = ieu_io_csr_waddr; // @[Core.scala 113:27]
  assign memreg_io_in_csr_wdata = ieu_io_csr_wdata; // @[Core.scala 114:27]
  assign wbreg_clock = clock;
  assign wbreg_reset = reset;
  assign wbreg_io_en = ~dmem_not_ok; // @[Core.scala 225:19]
  assign wbreg_io_in_valid = memreg_io_out_valid; // @[Core.scala 219:22]
  assign wbreg_io_in_pc = memreg_io_out_pc; // @[Core.scala 137:25]
  assign wbreg_io_in_inst = memreg_io_out_inst; // @[Core.scala 138:25]
  assign wbreg_io_in_rd_en = memreg_io_out_rd_en; // @[Core.scala 139:25]
  assign wbreg_io_in_rd_addr = memreg_io_out_rd_addr; // @[Core.scala 140:25]
  assign wbreg_io_in_alu_out = memreg_io_out_alu_out; // @[Core.scala 141:25]
  assign wbreg_io_in_bu_out = memreg_io_out_bu_out; // @[Core.scala 142:25]
  assign wbreg_io_in_mdu_out = memreg_io_out_mdu_out; // @[Core.scala 143:25]
  assign wbreg_io_in_csru_out = memreg_io_out_csru_out; // @[Core.scala 144:25]
  assign wbreg_io_in_fu_code = memreg_io_out_fu_code; // @[Core.scala 145:25]
  assign wbreg_io_in_lu_code = memreg_io_out_lu_code; // @[Core.scala 146:25]
  assign wbreg_io_in_csru_code = memreg_io_out_csru_code; // @[Core.scala 147:25]
  assign wbreg_io_in_lu_shift = preamu_io_lu_shift; // @[Core.scala 149:25]
  assign wbreg_io_in_putch = memreg_io_out_putch; // @[Core.scala 151:25]
  assign wbreg_io_in_csr_wen = memreg_io_out_csr_wen; // @[Core.scala 152:25]
  assign wbreg_io_in_csr_waddr = memreg_io_out_csr_waddr; // @[Core.scala 153:25]
  assign wbreg_io_in_csr_wdata = memreg_io_out_csr_wdata; // @[Core.scala 154:25]
  assign dt_ic_clock = clock; // @[Core.scala 260:21]
  assign dt_ic_coreid = 8'h0; // @[Core.scala 261:21]
  assign dt_ic_index = 8'h0; // @[Core.scala 262:21]
  assign dt_ic_valid = dt_ic_io_valid_REG; // @[Core.scala 263:21]
  assign dt_ic_pc = dt_ic_io_pc_REG; // @[Core.scala 264:21]
  assign dt_ic_instr = dt_ic_io_instr_REG; // @[Core.scala 265:21]
  assign dt_ic_special = 8'h0; // @[Core.scala 266:21]
  assign dt_ic_skip = dt_ic_io_skip_REG; // @[Core.scala 267:21]
  assign dt_ic_isRVC = 1'h0; // @[Core.scala 268:21]
  assign dt_ic_scFailed = 1'h0; // @[Core.scala 269:21]
  assign dt_ic_wen = dt_ic_io_wen_REG; // @[Core.scala 270:21]
  assign dt_ic_wdata = dt_ic_io_wdata_REG; // @[Core.scala 271:21]
  assign dt_ic_wdest = {{3'd0}, dt_ic_io_wdest_REG}; // @[Core.scala 272:21]
  assign dt_ae_clock = clock; // @[Core.scala 275:25]
  assign dt_ae_coreid = 8'h0; // @[Core.scala 276:25]
  assign dt_ae_intrNO = 32'h0; // @[Core.scala 277:25]
  assign dt_ae_cause = 32'h0; // @[Core.scala 278:25]
  assign dt_ae_exceptionPC = 64'h0; // @[Core.scala 279:25]
  assign dt_ae_exceptionInst = 32'h0;
  assign dt_te_clock = clock; // @[Core.scala 291:21]
  assign dt_te_coreid = 8'h0; // @[Core.scala 292:21]
  assign dt_te_valid = wbreg_io_out_inst == 32'h6b & commit_valid; // @[Core.scala 293:62]
  assign dt_te_code = rf_a0_0[2:0]; // @[Core.scala 294:29]
  assign dt_te_pc = wbreg_io_out_pc; // @[Core.scala 295:21]
  assign dt_te_cycleCnt = cycle_cnt; // @[Core.scala 296:21]
  assign dt_te_instrCnt = instr_cnt; // @[Core.scala 297:21]
  always @(posedge clock) begin
    dt_ic_io_valid_REG <= wbreg_io_out_valid & ~dmem_not_ok; // @[Core.scala 220:41]
    dt_ic_io_pc_REG <= wbreg_io_out_pc; // @[Core.scala 264:31]
    dt_ic_io_instr_REG <= wbreg_io_out_inst; // @[Core.scala 265:31]
    dt_ic_io_skip_REG <= skip_putch | read_mcycle | read_mtime | write_mtimecmp | wbreg_io_out_inst == 32'h7b703; // @[Core.scala 267:90]
    dt_ic_io_wen_REG <= wbreg_io_out_rd_en; // @[Core.scala 270:31]
    dt_ic_io_wdata_REG <= wbu_io_out; // @[Core.scala 271:31]
    dt_ic_io_wdest_REG <= wbreg_io_out_rd_addr; // @[Core.scala 272:31]
    if (reset) begin // @[Core.scala 281:26]
      cycle_cnt <= 64'h0; // @[Core.scala 281:26]
    end else begin
      cycle_cnt <= _cycle_cnt_T_1; // @[Core.scala 284:13]
    end
    if (reset) begin // @[Core.scala 282:26]
      instr_cnt <= 64'h0; // @[Core.scala 282:26]
    end else if (commit_valid) begin // @[Core.scala 285:19]
      instr_cnt <= _instr_cnt_T_1;
    end
    `ifndef SYNTHESIS
    `ifdef PRINTF_COND
      if (`PRINTF_COND) begin
    `endif
        if (wbreg_io_out_putch & commit_valid & ~reset) begin
          $fwrite(32'h80000002,"%c",rf_a0_0); // @[Core.scala 237:51]
        end
    `ifdef PRINTF_COND
      end
    `endif
    `endif // SYNTHESIS
  end
// Register and memory initialization
`ifdef RANDOMIZE_GARBAGE_ASSIGN
`define RANDOMIZE
`endif
`ifdef RANDOMIZE_INVALID_ASSIGN
`define RANDOMIZE
`endif
`ifdef RANDOMIZE_REG_INIT
`define RANDOMIZE
`endif
`ifdef RANDOMIZE_MEM_INIT
`define RANDOMIZE
`endif
`ifndef RANDOM
`define RANDOM $random
`endif
`ifdef RANDOMIZE_MEM_INIT
  integer initvar;
`endif
`ifndef SYNTHESIS
`ifdef FIRRTL_BEFORE_INITIAL
`FIRRTL_BEFORE_INITIAL
`endif
initial begin
  `ifdef RANDOMIZE
    `ifdef INIT_RANDOM
      `INIT_RANDOM
    `endif
    `ifndef VERILATOR
      `ifdef RANDOMIZE_DELAY
        #`RANDOMIZE_DELAY begin end
      `else
        #0.002 begin end
      `endif
    `endif
`ifdef RANDOMIZE_REG_INIT
  _RAND_0 = {1{`RANDOM}};
  dt_ic_io_valid_REG = _RAND_0[0:0];
  _RAND_1 = {2{`RANDOM}};
  dt_ic_io_pc_REG = _RAND_1[63:0];
  _RAND_2 = {1{`RANDOM}};
  dt_ic_io_instr_REG = _RAND_2[31:0];
  _RAND_3 = {1{`RANDOM}};
  dt_ic_io_skip_REG = _RAND_3[0:0];
  _RAND_4 = {1{`RANDOM}};
  dt_ic_io_wen_REG = _RAND_4[0:0];
  _RAND_5 = {2{`RANDOM}};
  dt_ic_io_wdata_REG = _RAND_5[63:0];
  _RAND_6 = {1{`RANDOM}};
  dt_ic_io_wdest_REG = _RAND_6[4:0];
  _RAND_7 = {2{`RANDOM}};
  cycle_cnt = _RAND_7[63:0];
  _RAND_8 = {2{`RANDOM}};
  instr_cnt = _RAND_8[63:0];
`endif // RANDOMIZE_REG_INIT
  `endif // RANDOMIZE
end // initial
`ifdef FIRRTL_AFTER_INITIAL
`FIRRTL_AFTER_INITIAL
`endif
`endif // SYNTHESIS
endmodule
module ICache(
  input          clock,
  input          reset,
  input  [63:0]  io_imem_addr,
  input          io_imem_en,
  output [31:0]  io_imem_data,
  output         io_imem_ok,
  output         io_axi_req,
  output [63:0]  io_axi_addr,
  input          io_axi_valid,
  input  [127:0] io_axi_data
);
`ifdef RANDOMIZE_REG_INIT
  reg [63:0] _RAND_0;
  reg [31:0] _RAND_1;
  reg [31:0] _RAND_2;
  reg [31:0] _RAND_3;
  reg [31:0] _RAND_4;
  reg [31:0] _RAND_5;
  reg [31:0] _RAND_6;
  reg [31:0] _RAND_7;
  reg [31:0] _RAND_8;
  reg [63:0] _RAND_9;
  reg [63:0] _RAND_10;
  reg [63:0] _RAND_11;
  reg [63:0] _RAND_12;
  reg [127:0] _RAND_13;
  reg [127:0] _RAND_14;
  reg [127:0] _RAND_15;
  reg [127:0] _RAND_16;
  reg [31:0] _RAND_17;
  reg [31:0] _RAND_18;
  reg [31:0] _RAND_19;
  reg [31:0] _RAND_20;
  reg [31:0] _RAND_21;
  reg [31:0] _RAND_22;
  reg [31:0] _RAND_23;
  reg [31:0] _RAND_24;
  reg [63:0] _RAND_25;
  reg [63:0] _RAND_26;
  reg [63:0] _RAND_27;
  reg [63:0] _RAND_28;
  reg [127:0] _RAND_29;
  reg [127:0] _RAND_30;
  reg [127:0] _RAND_31;
  reg [127:0] _RAND_32;
  reg [31:0] _RAND_33;
  reg [31:0] _RAND_34;
`endif // RANDOMIZE_REG_INIT
  wire  _addr_T = io_imem_en & io_imem_ok; // @[ICache.scala 45:62]
  reg [63:0] addr; // @[Reg.scala 27:20]
  wire [57:0] tag_addr = addr[63:6]; // @[ICache.scala 48:27]
  wire [1:0] index_addr = addr[5:4]; // @[ICache.scala 49:27]
  wire [3:0] offset_addr = addr[3:0]; // @[ICache.scala 50:27]
  reg  v1_0; // @[ICache.scala 52:26]
  reg  v1_1; // @[ICache.scala 52:26]
  reg  v1_2; // @[ICache.scala 52:26]
  reg  v1_3; // @[ICache.scala 52:26]
  reg  age1_0; // @[ICache.scala 53:26]
  reg  age1_1; // @[ICache.scala 53:26]
  reg  age1_2; // @[ICache.scala 53:26]
  reg  age1_3; // @[ICache.scala 53:26]
  reg [57:0] tag1_0; // @[ICache.scala 54:26]
  reg [57:0] tag1_1; // @[ICache.scala 54:26]
  reg [57:0] tag1_2; // @[ICache.scala 54:26]
  reg [57:0] tag1_3; // @[ICache.scala 54:26]
  reg [127:0] block1_0; // @[ICache.scala 55:26]
  reg [127:0] block1_1; // @[ICache.scala 55:26]
  reg [127:0] block1_2; // @[ICache.scala 55:26]
  reg [127:0] block1_3; // @[ICache.scala 55:26]
  reg  v2_0; // @[ICache.scala 56:26]
  reg  v2_1; // @[ICache.scala 56:26]
  reg  v2_2; // @[ICache.scala 56:26]
  reg  v2_3; // @[ICache.scala 56:26]
  reg  age2_0; // @[ICache.scala 57:26]
  reg  age2_1; // @[ICache.scala 57:26]
  reg  age2_2; // @[ICache.scala 57:26]
  reg  age2_3; // @[ICache.scala 57:26]
  reg [57:0] tag2_0; // @[ICache.scala 58:26]
  reg [57:0] tag2_1; // @[ICache.scala 58:26]
  reg [57:0] tag2_2; // @[ICache.scala 58:26]
  reg [57:0] tag2_3; // @[ICache.scala 58:26]
  reg [127:0] block2_0; // @[ICache.scala 59:26]
  reg [127:0] block2_1; // @[ICache.scala 59:26]
  reg [127:0] block2_2; // @[ICache.scala 59:26]
  reg [127:0] block2_3; // @[ICache.scala 59:26]
  wire [57:0] _GEN_2 = 2'h1 == index_addr ? tag1_1 : tag1_0; // @[ICache.scala 61:28 ICache.scala 61:28]
  wire [57:0] _GEN_3 = 2'h2 == index_addr ? tag1_2 : _GEN_2; // @[ICache.scala 61:28 ICache.scala 61:28]
  wire [57:0] _GEN_4 = 2'h3 == index_addr ? tag1_3 : _GEN_3; // @[ICache.scala 61:28 ICache.scala 61:28]
  wire  _GEN_6 = 2'h1 == index_addr ? v1_1 : v1_0; // @[ICache.scala 61:67 ICache.scala 61:67]
  wire  _GEN_7 = 2'h2 == index_addr ? v1_2 : _GEN_6; // @[ICache.scala 61:67 ICache.scala 61:67]
  wire  _GEN_8 = 2'h3 == index_addr ? v1_3 : _GEN_7; // @[ICache.scala 61:67 ICache.scala 61:67]
  wire  hit1 = tag_addr == _GEN_4 & _GEN_8; // @[ICache.scala 61:49]
  wire [57:0] _GEN_10 = 2'h1 == index_addr ? tag2_1 : tag2_0; // @[ICache.scala 62:28 ICache.scala 62:28]
  wire [57:0] _GEN_11 = 2'h2 == index_addr ? tag2_2 : _GEN_10; // @[ICache.scala 62:28 ICache.scala 62:28]
  wire [57:0] _GEN_12 = 2'h3 == index_addr ? tag2_3 : _GEN_11; // @[ICache.scala 62:28 ICache.scala 62:28]
  wire  _GEN_14 = 2'h1 == index_addr ? v2_1 : v2_0; // @[ICache.scala 62:67 ICache.scala 62:67]
  wire  _GEN_15 = 2'h2 == index_addr ? v2_2 : _GEN_14; // @[ICache.scala 62:67 ICache.scala 62:67]
  wire  _GEN_16 = 2'h3 == index_addr ? v2_3 : _GEN_15; // @[ICache.scala 62:67 ICache.scala 62:67]
  wire  hit2 = tag_addr == _GEN_12 & _GEN_16; // @[ICache.scala 62:49]
  wire [6:0] _data1_T = {offset_addr, 3'h0}; // @[ICache.scala 63:55]
  wire [127:0] _GEN_18 = 2'h1 == index_addr ? block1_1 : block1_0; // @[ICache.scala 63:39 ICache.scala 63:39]
  wire [127:0] _GEN_19 = 2'h2 == index_addr ? block1_2 : _GEN_18; // @[ICache.scala 63:39 ICache.scala 63:39]
  wire [127:0] _GEN_20 = 2'h3 == index_addr ? block1_3 : _GEN_19; // @[ICache.scala 63:39 ICache.scala 63:39]
  wire [127:0] _data1_T_1 = _GEN_20 >> _data1_T; // @[ICache.scala 63:39]
  wire [31:0] data1 = _data1_T_1[31:0]; // @[ICache.scala 63:61]
  wire [127:0] _GEN_22 = 2'h1 == index_addr ? block2_1 : block2_0; // @[ICache.scala 64:39 ICache.scala 64:39]
  wire [127:0] _GEN_23 = 2'h2 == index_addr ? block2_2 : _GEN_22; // @[ICache.scala 64:39 ICache.scala 64:39]
  wire [127:0] _GEN_24 = 2'h3 == index_addr ? block2_3 : _GEN_23; // @[ICache.scala 64:39 ICache.scala 64:39]
  wire [127:0] _data2_T_1 = _GEN_24 >> _data1_T; // @[ICache.scala 64:39]
  wire [31:0] data2 = _data2_T_1[31:0]; // @[ICache.scala 64:61]
  wire  hit = hit1 | hit2; // @[ICache.scala 66:24]
  wire [31:0] _data_T = hit1 ? data1 : 32'h0; // @[ICache.scala 67:39]
  wire  _age1_T = hit1 ^ hit2; // @[ICache.scala 70:34]
  wire  _GEN_26 = 2'h1 == index_addr ? age1_1 : age1_0; // @[ICache.scala 70:28 ICache.scala 70:28]
  wire  _GEN_27 = 2'h2 == index_addr ? age1_2 : _GEN_26; // @[ICache.scala 70:28 ICache.scala 70:28]
  wire  _GEN_28 = 2'h3 == index_addr ? age1_3 : _GEN_27; // @[ICache.scala 70:28 ICache.scala 70:28]
  wire  _GEN_34 = 2'h1 == index_addr ? age2_1 : age2_0; // @[ICache.scala 71:28 ICache.scala 71:28]
  wire  _GEN_35 = 2'h2 == index_addr ? age2_2 : _GEN_34; // @[ICache.scala 71:28 ICache.scala 71:28]
  wire  _GEN_36 = 2'h3 == index_addr ? age2_3 : _GEN_35; // @[ICache.scala 71:28 ICache.scala 71:28]
  reg  state; // @[ICache.scala 74:24]
  reg  not_en_yet; // @[ICache.scala 77:30]
  wire  _not_en_yet_T = io_imem_en ? 1'h0 : not_en_yet; // @[ICache.scala 78:27]
  wire  _io_imem_ok_T_1 = ~state; // @[ICache.scala 81:53]
  wire  _GEN_41 = ~hit & ~not_en_yet | state; // @[ICache.scala 85:39 ICache.scala 85:46 ICache.scala 74:24]
  wire [1:0] age = {_GEN_36,_GEN_28}; // @[Cat.scala 30:58]
  wire  updateway2 = age == 2'h1; // @[ICache.scala 98:26]
  wire  updateway1 = ~updateway2; // @[ICache.scala 99:22]
  wire  update = state & io_axi_valid; // @[ICache.scala 100:33]
  wire  _block1_T = update & updateway1; // @[ICache.scala 101:40]
  wire  _block2_T = update & updateway2; // @[ICache.scala 104:40]
  assign io_imem_data = hit2 ? data2 : _data_T; // @[ICache.scala 67:22]
  assign io_imem_ok = (hit | not_en_yet) & ~state; // @[ICache.scala 81:44]
  assign io_axi_req = state; // @[ICache.scala 93:28]
  assign io_axi_addr = addr & 64'hfffffffffffffff0; // @[ICache.scala 94:27]
  always @(posedge clock) begin
    if (reset) begin // @[Reg.scala 27:20]
      addr <= 64'h0; // @[Reg.scala 27:20]
    end else if (_addr_T) begin // @[Reg.scala 28:19]
      addr <= io_imem_addr; // @[Reg.scala 28:23]
    end
    if (reset) begin // @[ICache.scala 52:26]
      v1_0 <= 1'h0; // @[ICache.scala 52:26]
    end else if (2'h0 == index_addr) begin // @[ICache.scala 103:26]
      v1_0 <= _block1_T | _GEN_8; // @[ICache.scala 103:26]
    end
    if (reset) begin // @[ICache.scala 52:26]
      v1_1 <= 1'h0; // @[ICache.scala 52:26]
    end else if (2'h1 == index_addr) begin // @[ICache.scala 103:26]
      v1_1 <= _block1_T | _GEN_8; // @[ICache.scala 103:26]
    end
    if (reset) begin // @[ICache.scala 52:26]
      v1_2 <= 1'h0; // @[ICache.scala 52:26]
    end else if (2'h2 == index_addr) begin // @[ICache.scala 103:26]
      v1_2 <= _block1_T | _GEN_8; // @[ICache.scala 103:26]
    end
    if (reset) begin // @[ICache.scala 52:26]
      v1_3 <= 1'h0; // @[ICache.scala 52:26]
    end else if (2'h3 == index_addr) begin // @[ICache.scala 103:26]
      v1_3 <= _block1_T | _GEN_8; // @[ICache.scala 103:26]
    end
    if (reset) begin // @[ICache.scala 53:26]
      age1_0 <= 1'h0; // @[ICache.scala 53:26]
    end else if (2'h0 == index_addr) begin // @[ICache.scala 70:22]
      if (hit1 ^ hit2) begin // @[ICache.scala 70:28]
        age1_0 <= hit1;
      end else if (2'h3 == index_addr) begin // @[ICache.scala 70:28]
        age1_0 <= age1_3; // @[ICache.scala 70:28]
      end else begin
        age1_0 <= _GEN_27;
      end
    end
    if (reset) begin // @[ICache.scala 53:26]
      age1_1 <= 1'h0; // @[ICache.scala 53:26]
    end else if (2'h1 == index_addr) begin // @[ICache.scala 70:22]
      if (hit1 ^ hit2) begin // @[ICache.scala 70:28]
        age1_1 <= hit1;
      end else if (2'h3 == index_addr) begin // @[ICache.scala 70:28]
        age1_1 <= age1_3; // @[ICache.scala 70:28]
      end else begin
        age1_1 <= _GEN_27;
      end
    end
    if (reset) begin // @[ICache.scala 53:26]
      age1_2 <= 1'h0; // @[ICache.scala 53:26]
    end else if (2'h2 == index_addr) begin // @[ICache.scala 70:22]
      if (hit1 ^ hit2) begin // @[ICache.scala 70:28]
        age1_2 <= hit1;
      end else if (2'h3 == index_addr) begin // @[ICache.scala 70:28]
        age1_2 <= age1_3; // @[ICache.scala 70:28]
      end else begin
        age1_2 <= _GEN_27;
      end
    end
    if (reset) begin // @[ICache.scala 53:26]
      age1_3 <= 1'h0; // @[ICache.scala 53:26]
    end else if (2'h3 == index_addr) begin // @[ICache.scala 70:22]
      if (hit1 ^ hit2) begin // @[ICache.scala 70:28]
        age1_3 <= hit1;
      end else if (!(2'h3 == index_addr)) begin // @[ICache.scala 70:28]
        age1_3 <= _GEN_27;
      end
    end
    if (reset) begin // @[ICache.scala 54:26]
      tag1_0 <= 58'h0; // @[ICache.scala 54:26]
    end else if (2'h0 == index_addr) begin // @[ICache.scala 102:26]
      if (_block1_T) begin // @[ICache.scala 102:32]
        tag1_0 <= tag_addr;
      end else if (2'h3 == index_addr) begin // @[ICache.scala 61:28]
        tag1_0 <= tag1_3; // @[ICache.scala 61:28]
      end else begin
        tag1_0 <= _GEN_3;
      end
    end
    if (reset) begin // @[ICache.scala 54:26]
      tag1_1 <= 58'h0; // @[ICache.scala 54:26]
    end else if (2'h1 == index_addr) begin // @[ICache.scala 102:26]
      if (_block1_T) begin // @[ICache.scala 102:32]
        tag1_1 <= tag_addr;
      end else if (2'h3 == index_addr) begin // @[ICache.scala 61:28]
        tag1_1 <= tag1_3; // @[ICache.scala 61:28]
      end else begin
        tag1_1 <= _GEN_3;
      end
    end
    if (reset) begin // @[ICache.scala 54:26]
      tag1_2 <= 58'h0; // @[ICache.scala 54:26]
    end else if (2'h2 == index_addr) begin // @[ICache.scala 102:26]
      if (_block1_T) begin // @[ICache.scala 102:32]
        tag1_2 <= tag_addr;
      end else if (2'h3 == index_addr) begin // @[ICache.scala 61:28]
        tag1_2 <= tag1_3; // @[ICache.scala 61:28]
      end else begin
        tag1_2 <= _GEN_3;
      end
    end
    if (reset) begin // @[ICache.scala 54:26]
      tag1_3 <= 58'h0; // @[ICache.scala 54:26]
    end else if (2'h3 == index_addr) begin // @[ICache.scala 102:26]
      if (_block1_T) begin // @[ICache.scala 102:32]
        tag1_3 <= tag_addr;
      end else if (!(2'h3 == index_addr)) begin // @[ICache.scala 61:28]
        tag1_3 <= _GEN_3;
      end
    end
    if (reset) begin // @[ICache.scala 55:26]
      block1_0 <= 128'h0; // @[ICache.scala 55:26]
    end else if (2'h0 == index_addr) begin // @[ICache.scala 101:26]
      if (update & updateway1) begin // @[ICache.scala 101:32]
        block1_0 <= io_axi_data;
      end else if (2'h3 == index_addr) begin // @[ICache.scala 63:39]
        block1_0 <= block1_3; // @[ICache.scala 63:39]
      end else begin
        block1_0 <= _GEN_19;
      end
    end
    if (reset) begin // @[ICache.scala 55:26]
      block1_1 <= 128'h0; // @[ICache.scala 55:26]
    end else if (2'h1 == index_addr) begin // @[ICache.scala 101:26]
      if (update & updateway1) begin // @[ICache.scala 101:32]
        block1_1 <= io_axi_data;
      end else if (2'h3 == index_addr) begin // @[ICache.scala 63:39]
        block1_1 <= block1_3; // @[ICache.scala 63:39]
      end else begin
        block1_1 <= _GEN_19;
      end
    end
    if (reset) begin // @[ICache.scala 55:26]
      block1_2 <= 128'h0; // @[ICache.scala 55:26]
    end else if (2'h2 == index_addr) begin // @[ICache.scala 101:26]
      if (update & updateway1) begin // @[ICache.scala 101:32]
        block1_2 <= io_axi_data;
      end else if (2'h3 == index_addr) begin // @[ICache.scala 63:39]
        block1_2 <= block1_3; // @[ICache.scala 63:39]
      end else begin
        block1_2 <= _GEN_19;
      end
    end
    if (reset) begin // @[ICache.scala 55:26]
      block1_3 <= 128'h0; // @[ICache.scala 55:26]
    end else if (2'h3 == index_addr) begin // @[ICache.scala 101:26]
      if (update & updateway1) begin // @[ICache.scala 101:32]
        block1_3 <= io_axi_data;
      end else if (!(2'h3 == index_addr)) begin // @[ICache.scala 63:39]
        block1_3 <= _GEN_19;
      end
    end
    if (reset) begin // @[ICache.scala 56:26]
      v2_0 <= 1'h0; // @[ICache.scala 56:26]
    end else if (2'h0 == index_addr) begin // @[ICache.scala 106:26]
      v2_0 <= _block2_T | _GEN_16; // @[ICache.scala 106:26]
    end
    if (reset) begin // @[ICache.scala 56:26]
      v2_1 <= 1'h0; // @[ICache.scala 56:26]
    end else if (2'h1 == index_addr) begin // @[ICache.scala 106:26]
      v2_1 <= _block2_T | _GEN_16; // @[ICache.scala 106:26]
    end
    if (reset) begin // @[ICache.scala 56:26]
      v2_2 <= 1'h0; // @[ICache.scala 56:26]
    end else if (2'h2 == index_addr) begin // @[ICache.scala 106:26]
      v2_2 <= _block2_T | _GEN_16; // @[ICache.scala 106:26]
    end
    if (reset) begin // @[ICache.scala 56:26]
      v2_3 <= 1'h0; // @[ICache.scala 56:26]
    end else if (2'h3 == index_addr) begin // @[ICache.scala 106:26]
      v2_3 <= _block2_T | _GEN_16; // @[ICache.scala 106:26]
    end
    if (reset) begin // @[ICache.scala 57:26]
      age2_0 <= 1'h0; // @[ICache.scala 57:26]
    end else if (2'h0 == index_addr) begin // @[ICache.scala 71:22]
      if (_age1_T) begin // @[ICache.scala 71:28]
        age2_0 <= hit2;
      end else if (2'h3 == index_addr) begin // @[ICache.scala 71:28]
        age2_0 <= age2_3; // @[ICache.scala 71:28]
      end else begin
        age2_0 <= _GEN_35;
      end
    end
    if (reset) begin // @[ICache.scala 57:26]
      age2_1 <= 1'h0; // @[ICache.scala 57:26]
    end else if (2'h1 == index_addr) begin // @[ICache.scala 71:22]
      if (_age1_T) begin // @[ICache.scala 71:28]
        age2_1 <= hit2;
      end else if (2'h3 == index_addr) begin // @[ICache.scala 71:28]
        age2_1 <= age2_3; // @[ICache.scala 71:28]
      end else begin
        age2_1 <= _GEN_35;
      end
    end
    if (reset) begin // @[ICache.scala 57:26]
      age2_2 <= 1'h0; // @[ICache.scala 57:26]
    end else if (2'h2 == index_addr) begin // @[ICache.scala 71:22]
      if (_age1_T) begin // @[ICache.scala 71:28]
        age2_2 <= hit2;
      end else if (2'h3 == index_addr) begin // @[ICache.scala 71:28]
        age2_2 <= age2_3; // @[ICache.scala 71:28]
      end else begin
        age2_2 <= _GEN_35;
      end
    end
    if (reset) begin // @[ICache.scala 57:26]
      age2_3 <= 1'h0; // @[ICache.scala 57:26]
    end else if (2'h3 == index_addr) begin // @[ICache.scala 71:22]
      if (_age1_T) begin // @[ICache.scala 71:28]
        age2_3 <= hit2;
      end else if (!(2'h3 == index_addr)) begin // @[ICache.scala 71:28]
        age2_3 <= _GEN_35;
      end
    end
    if (reset) begin // @[ICache.scala 58:26]
      tag2_0 <= 58'h0; // @[ICache.scala 58:26]
    end else if (2'h0 == index_addr) begin // @[ICache.scala 105:26]
      if (_block2_T) begin // @[ICache.scala 105:32]
        tag2_0 <= tag_addr;
      end else if (2'h3 == index_addr) begin // @[ICache.scala 62:28]
        tag2_0 <= tag2_3; // @[ICache.scala 62:28]
      end else begin
        tag2_0 <= _GEN_11;
      end
    end
    if (reset) begin // @[ICache.scala 58:26]
      tag2_1 <= 58'h0; // @[ICache.scala 58:26]
    end else if (2'h1 == index_addr) begin // @[ICache.scala 105:26]
      if (_block2_T) begin // @[ICache.scala 105:32]
        tag2_1 <= tag_addr;
      end else if (2'h3 == index_addr) begin // @[ICache.scala 62:28]
        tag2_1 <= tag2_3; // @[ICache.scala 62:28]
      end else begin
        tag2_1 <= _GEN_11;
      end
    end
    if (reset) begin // @[ICache.scala 58:26]
      tag2_2 <= 58'h0; // @[ICache.scala 58:26]
    end else if (2'h2 == index_addr) begin // @[ICache.scala 105:26]
      if (_block2_T) begin // @[ICache.scala 105:32]
        tag2_2 <= tag_addr;
      end else if (2'h3 == index_addr) begin // @[ICache.scala 62:28]
        tag2_2 <= tag2_3; // @[ICache.scala 62:28]
      end else begin
        tag2_2 <= _GEN_11;
      end
    end
    if (reset) begin // @[ICache.scala 58:26]
      tag2_3 <= 58'h0; // @[ICache.scala 58:26]
    end else if (2'h3 == index_addr) begin // @[ICache.scala 105:26]
      if (_block2_T) begin // @[ICache.scala 105:32]
        tag2_3 <= tag_addr;
      end else if (!(2'h3 == index_addr)) begin // @[ICache.scala 62:28]
        tag2_3 <= _GEN_11;
      end
    end
    if (reset) begin // @[ICache.scala 59:26]
      block2_0 <= 128'h0; // @[ICache.scala 59:26]
    end else if (2'h0 == index_addr) begin // @[ICache.scala 104:26]
      if (update & updateway2) begin // @[ICache.scala 104:32]
        block2_0 <= io_axi_data;
      end else if (2'h3 == index_addr) begin // @[ICache.scala 64:39]
        block2_0 <= block2_3; // @[ICache.scala 64:39]
      end else begin
        block2_0 <= _GEN_23;
      end
    end
    if (reset) begin // @[ICache.scala 59:26]
      block2_1 <= 128'h0; // @[ICache.scala 59:26]
    end else if (2'h1 == index_addr) begin // @[ICache.scala 104:26]
      if (update & updateway2) begin // @[ICache.scala 104:32]
        block2_1 <= io_axi_data;
      end else if (2'h3 == index_addr) begin // @[ICache.scala 64:39]
        block2_1 <= block2_3; // @[ICache.scala 64:39]
      end else begin
        block2_1 <= _GEN_23;
      end
    end
    if (reset) begin // @[ICache.scala 59:26]
      block2_2 <= 128'h0; // @[ICache.scala 59:26]
    end else if (2'h2 == index_addr) begin // @[ICache.scala 104:26]
      if (update & updateway2) begin // @[ICache.scala 104:32]
        block2_2 <= io_axi_data;
      end else if (2'h3 == index_addr) begin // @[ICache.scala 64:39]
        block2_2 <= block2_3; // @[ICache.scala 64:39]
      end else begin
        block2_2 <= _GEN_23;
      end
    end
    if (reset) begin // @[ICache.scala 59:26]
      block2_3 <= 128'h0; // @[ICache.scala 59:26]
    end else if (2'h3 == index_addr) begin // @[ICache.scala 104:26]
      if (update & updateway2) begin // @[ICache.scala 104:32]
        block2_3 <= io_axi_data;
      end else if (!(2'h3 == index_addr)) begin // @[ICache.scala 64:39]
        block2_3 <= _GEN_23;
      end
    end
    if (reset) begin // @[ICache.scala 74:24]
      state <= 1'h0; // @[ICache.scala 74:24]
    end else if (_io_imem_ok_T_1) begin // @[Conditional.scala 40:58]
      state <= _GEN_41;
    end else if (state) begin // @[Conditional.scala 39:67]
      if (io_axi_valid) begin // @[ICache.scala 88:32]
        state <= 1'h0; // @[ICache.scala 88:39]
      end
    end
    not_en_yet <= reset | _not_en_yet_T; // @[ICache.scala 77:30 ICache.scala 77:30 ICache.scala 78:21]
  end
// Register and memory initialization
`ifdef RANDOMIZE_GARBAGE_ASSIGN
`define RANDOMIZE
`endif
`ifdef RANDOMIZE_INVALID_ASSIGN
`define RANDOMIZE
`endif
`ifdef RANDOMIZE_REG_INIT
`define RANDOMIZE
`endif
`ifdef RANDOMIZE_MEM_INIT
`define RANDOMIZE
`endif
`ifndef RANDOM
`define RANDOM $random
`endif
`ifdef RANDOMIZE_MEM_INIT
  integer initvar;
`endif
`ifndef SYNTHESIS
`ifdef FIRRTL_BEFORE_INITIAL
`FIRRTL_BEFORE_INITIAL
`endif
initial begin
  `ifdef RANDOMIZE
    `ifdef INIT_RANDOM
      `INIT_RANDOM
    `endif
    `ifndef VERILATOR
      `ifdef RANDOMIZE_DELAY
        #`RANDOMIZE_DELAY begin end
      `else
        #0.002 begin end
      `endif
    `endif
`ifdef RANDOMIZE_REG_INIT
  _RAND_0 = {2{`RANDOM}};
  addr = _RAND_0[63:0];
  _RAND_1 = {1{`RANDOM}};
  v1_0 = _RAND_1[0:0];
  _RAND_2 = {1{`RANDOM}};
  v1_1 = _RAND_2[0:0];
  _RAND_3 = {1{`RANDOM}};
  v1_2 = _RAND_3[0:0];
  _RAND_4 = {1{`RANDOM}};
  v1_3 = _RAND_4[0:0];
  _RAND_5 = {1{`RANDOM}};
  age1_0 = _RAND_5[0:0];
  _RAND_6 = {1{`RANDOM}};
  age1_1 = _RAND_6[0:0];
  _RAND_7 = {1{`RANDOM}};
  age1_2 = _RAND_7[0:0];
  _RAND_8 = {1{`RANDOM}};
  age1_3 = _RAND_8[0:0];
  _RAND_9 = {2{`RANDOM}};
  tag1_0 = _RAND_9[57:0];
  _RAND_10 = {2{`RANDOM}};
  tag1_1 = _RAND_10[57:0];
  _RAND_11 = {2{`RANDOM}};
  tag1_2 = _RAND_11[57:0];
  _RAND_12 = {2{`RANDOM}};
  tag1_3 = _RAND_12[57:0];
  _RAND_13 = {4{`RANDOM}};
  block1_0 = _RAND_13[127:0];
  _RAND_14 = {4{`RANDOM}};
  block1_1 = _RAND_14[127:0];
  _RAND_15 = {4{`RANDOM}};
  block1_2 = _RAND_15[127:0];
  _RAND_16 = {4{`RANDOM}};
  block1_3 = _RAND_16[127:0];
  _RAND_17 = {1{`RANDOM}};
  v2_0 = _RAND_17[0:0];
  _RAND_18 = {1{`RANDOM}};
  v2_1 = _RAND_18[0:0];
  _RAND_19 = {1{`RANDOM}};
  v2_2 = _RAND_19[0:0];
  _RAND_20 = {1{`RANDOM}};
  v2_3 = _RAND_20[0:0];
  _RAND_21 = {1{`RANDOM}};
  age2_0 = _RAND_21[0:0];
  _RAND_22 = {1{`RANDOM}};
  age2_1 = _RAND_22[0:0];
  _RAND_23 = {1{`RANDOM}};
  age2_2 = _RAND_23[0:0];
  _RAND_24 = {1{`RANDOM}};
  age2_3 = _RAND_24[0:0];
  _RAND_25 = {2{`RANDOM}};
  tag2_0 = _RAND_25[57:0];
  _RAND_26 = {2{`RANDOM}};
  tag2_1 = _RAND_26[57:0];
  _RAND_27 = {2{`RANDOM}};
  tag2_2 = _RAND_27[57:0];
  _RAND_28 = {2{`RANDOM}};
  tag2_3 = _RAND_28[57:0];
  _RAND_29 = {4{`RANDOM}};
  block2_0 = _RAND_29[127:0];
  _RAND_30 = {4{`RANDOM}};
  block2_1 = _RAND_30[127:0];
  _RAND_31 = {4{`RANDOM}};
  block2_2 = _RAND_31[127:0];
  _RAND_32 = {4{`RANDOM}};
  block2_3 = _RAND_32[127:0];
  _RAND_33 = {1{`RANDOM}};
  state = _RAND_33[0:0];
  _RAND_34 = {1{`RANDOM}};
  not_en_yet = _RAND_34[0:0];
`endif // RANDOMIZE_REG_INIT
  `endif // RANDOMIZE
end // initial
`ifdef FIRRTL_AFTER_INITIAL
`FIRRTL_AFTER_INITIAL
`endif
`endif // SYNTHESIS
endmodule
module DCache(
  input          clock,
  input          reset,
  input          io_dmem_en,
  input          io_dmem_op,
  input  [63:0]  io_dmem_addr,
  input  [63:0]  io_dmem_wdata,
  input  [7:0]   io_dmem_wmask,
  output         io_dmem_ok,
  output [63:0]  io_dmem_rdata,
  output         io_axi_req,
  output [63:0]  io_axi_raddr,
  input          io_axi_rvalid,
  input  [127:0] io_axi_rdata,
  output         io_axi_weq,
  output [63:0]  io_axi_waddr,
  output [127:0] io_axi_wdata,
  input          io_axi_wdone
);
`ifdef RANDOMIZE_REG_INIT
  reg [31:0] _RAND_0;
  reg [63:0] _RAND_1;
  reg [63:0] _RAND_2;
  reg [31:0] _RAND_3;
  reg [31:0] _RAND_4;
  reg [31:0] _RAND_5;
  reg [31:0] _RAND_6;
  reg [31:0] _RAND_7;
  reg [31:0] _RAND_8;
  reg [31:0] _RAND_9;
  reg [31:0] _RAND_10;
  reg [31:0] _RAND_11;
  reg [31:0] _RAND_12;
  reg [31:0] _RAND_13;
  reg [31:0] _RAND_14;
  reg [31:0] _RAND_15;
  reg [63:0] _RAND_16;
  reg [63:0] _RAND_17;
  reg [63:0] _RAND_18;
  reg [63:0] _RAND_19;
  reg [127:0] _RAND_20;
  reg [127:0] _RAND_21;
  reg [127:0] _RAND_22;
  reg [127:0] _RAND_23;
  reg [31:0] _RAND_24;
  reg [31:0] _RAND_25;
  reg [31:0] _RAND_26;
  reg [31:0] _RAND_27;
  reg [31:0] _RAND_28;
  reg [31:0] _RAND_29;
  reg [31:0] _RAND_30;
  reg [31:0] _RAND_31;
  reg [31:0] _RAND_32;
  reg [31:0] _RAND_33;
  reg [31:0] _RAND_34;
  reg [31:0] _RAND_35;
  reg [63:0] _RAND_36;
  reg [63:0] _RAND_37;
  reg [63:0] _RAND_38;
  reg [63:0] _RAND_39;
  reg [127:0] _RAND_40;
  reg [127:0] _RAND_41;
  reg [127:0] _RAND_42;
  reg [127:0] _RAND_43;
  reg [31:0] _RAND_44;
  reg [31:0] _RAND_45;
`endif // RANDOMIZE_REG_INIT
  wire  _op_T = io_dmem_en & io_dmem_ok; // @[DCache.scala 39:66]
  reg  op; // @[Reg.scala 27:20]
  reg [63:0] addr; // @[Reg.scala 27:20]
  reg [63:0] wdata; // @[Reg.scala 27:20]
  reg [7:0] wm; // @[Reg.scala 27:20]
  wire [57:0] tag_addr = addr[63:6]; // @[DCache.scala 45:27]
  wire [1:0] index_addr = addr[5:4]; // @[DCache.scala 46:27]
  wire [3:0] offset_addr = addr[3:0]; // @[DCache.scala 47:27]
  reg  v1_0; // @[DCache.scala 49:26]
  reg  v1_1; // @[DCache.scala 49:26]
  reg  v1_2; // @[DCache.scala 49:26]
  reg  v1_3; // @[DCache.scala 49:26]
  reg  d1_0; // @[DCache.scala 50:26]
  reg  d1_1; // @[DCache.scala 50:26]
  reg  d1_2; // @[DCache.scala 50:26]
  reg  d1_3; // @[DCache.scala 50:26]
  reg  age1_0; // @[DCache.scala 51:26]
  reg  age1_1; // @[DCache.scala 51:26]
  reg  age1_2; // @[DCache.scala 51:26]
  reg  age1_3; // @[DCache.scala 51:26]
  reg [57:0] tag1_0; // @[DCache.scala 52:26]
  reg [57:0] tag1_1; // @[DCache.scala 52:26]
  reg [57:0] tag1_2; // @[DCache.scala 52:26]
  reg [57:0] tag1_3; // @[DCache.scala 52:26]
  reg [127:0] block1_0; // @[DCache.scala 53:26]
  reg [127:0] block1_1; // @[DCache.scala 53:26]
  reg [127:0] block1_2; // @[DCache.scala 53:26]
  reg [127:0] block1_3; // @[DCache.scala 53:26]
  reg  v2_0; // @[DCache.scala 54:26]
  reg  v2_1; // @[DCache.scala 54:26]
  reg  v2_2; // @[DCache.scala 54:26]
  reg  v2_3; // @[DCache.scala 54:26]
  reg  d2_0; // @[DCache.scala 55:26]
  reg  d2_1; // @[DCache.scala 55:26]
  reg  d2_2; // @[DCache.scala 55:26]
  reg  d2_3; // @[DCache.scala 55:26]
  reg  age2_0; // @[DCache.scala 56:26]
  reg  age2_1; // @[DCache.scala 56:26]
  reg  age2_2; // @[DCache.scala 56:26]
  reg  age2_3; // @[DCache.scala 56:26]
  reg [57:0] tag2_0; // @[DCache.scala 57:26]
  reg [57:0] tag2_1; // @[DCache.scala 57:26]
  reg [57:0] tag2_2; // @[DCache.scala 57:26]
  reg [57:0] tag2_3; // @[DCache.scala 57:26]
  reg [127:0] block2_0; // @[DCache.scala 58:26]
  reg [127:0] block2_1; // @[DCache.scala 58:26]
  reg [127:0] block2_2; // @[DCache.scala 58:26]
  reg [127:0] block2_3; // @[DCache.scala 58:26]
  wire [57:0] _GEN_5 = 2'h1 == index_addr ? tag1_1 : tag1_0; // @[DCache.scala 60:28 DCache.scala 60:28]
  wire [57:0] _GEN_6 = 2'h2 == index_addr ? tag1_2 : _GEN_5; // @[DCache.scala 60:28 DCache.scala 60:28]
  wire [57:0] _GEN_7 = 2'h3 == index_addr ? tag1_3 : _GEN_6; // @[DCache.scala 60:28 DCache.scala 60:28]
  wire  _GEN_9 = 2'h1 == index_addr ? v1_1 : v1_0; // @[DCache.scala 60:67 DCache.scala 60:67]
  wire  _GEN_10 = 2'h2 == index_addr ? v1_2 : _GEN_9; // @[DCache.scala 60:67 DCache.scala 60:67]
  wire  _GEN_11 = 2'h3 == index_addr ? v1_3 : _GEN_10; // @[DCache.scala 60:67 DCache.scala 60:67]
  wire  hit1 = tag_addr == _GEN_7 & _GEN_11; // @[DCache.scala 60:49]
  wire [57:0] _GEN_13 = 2'h1 == index_addr ? tag2_1 : tag2_0; // @[DCache.scala 61:28 DCache.scala 61:28]
  wire [57:0] _GEN_14 = 2'h2 == index_addr ? tag2_2 : _GEN_13; // @[DCache.scala 61:28 DCache.scala 61:28]
  wire [57:0] _GEN_15 = 2'h3 == index_addr ? tag2_3 : _GEN_14; // @[DCache.scala 61:28 DCache.scala 61:28]
  wire  _GEN_17 = 2'h1 == index_addr ? v2_1 : v2_0; // @[DCache.scala 61:67 DCache.scala 61:67]
  wire  _GEN_18 = 2'h2 == index_addr ? v2_2 : _GEN_17; // @[DCache.scala 61:67 DCache.scala 61:67]
  wire  _GEN_19 = 2'h3 == index_addr ? v2_3 : _GEN_18; // @[DCache.scala 61:67 DCache.scala 61:67]
  wire  hit2 = tag_addr == _GEN_15 & _GEN_19; // @[DCache.scala 61:49]
  wire [6:0] _rdata1_T = {offset_addr, 3'h0}; // @[DCache.scala 62:55]
  wire [127:0] _GEN_21 = 2'h1 == index_addr ? block1_1 : block1_0; // @[DCache.scala 62:39 DCache.scala 62:39]
  wire [127:0] _GEN_22 = 2'h2 == index_addr ? block1_2 : _GEN_21; // @[DCache.scala 62:39 DCache.scala 62:39]
  wire [127:0] _GEN_23 = 2'h3 == index_addr ? block1_3 : _GEN_22; // @[DCache.scala 62:39 DCache.scala 62:39]
  wire [127:0] _rdata1_T_1 = _GEN_23 >> _rdata1_T; // @[DCache.scala 62:39]
  wire [63:0] rdata1 = _rdata1_T_1[63:0]; // @[DCache.scala 62:61]
  wire [127:0] _GEN_25 = 2'h1 == index_addr ? block2_1 : block2_0; // @[DCache.scala 63:39 DCache.scala 63:39]
  wire [127:0] _GEN_26 = 2'h2 == index_addr ? block2_2 : _GEN_25; // @[DCache.scala 63:39 DCache.scala 63:39]
  wire [127:0] _GEN_27 = 2'h3 == index_addr ? block2_3 : _GEN_26; // @[DCache.scala 63:39 DCache.scala 63:39]
  wire [127:0] _rdata2_T_1 = _GEN_27 >> _rdata1_T; // @[DCache.scala 63:39]
  wire [63:0] rdata2 = _rdata2_T_1[63:0]; // @[DCache.scala 63:61]
  reg [1:0] state; // @[DCache.scala 66:24]
  wire  hit = hit1 | hit2; // @[DCache.scala 68:28]
  wire [63:0] _rdata_T = hit1 ? rdata1 : 64'h0; // @[DCache.scala 69:44]
  reg  not_en_yet; // @[DCache.scala 71:30]
  wire  _not_en_yet_T = io_dmem_en ? 1'h0 : not_en_yet; // @[DCache.scala 72:27]
  wire  _age1_T = hit1 ^ hit2; // @[DCache.scala 78:35]
  wire  _GEN_29 = 2'h1 == index_addr ? age1_1 : age1_0; // @[DCache.scala 78:28 DCache.scala 78:28]
  wire  _GEN_30 = 2'h2 == index_addr ? age1_2 : _GEN_29; // @[DCache.scala 78:28 DCache.scala 78:28]
  wire  _GEN_31 = 2'h3 == index_addr ? age1_3 : _GEN_30; // @[DCache.scala 78:28 DCache.scala 78:28]
  wire  _GEN_37 = 2'h1 == index_addr ? age2_1 : age2_0; // @[DCache.scala 79:28 DCache.scala 79:28]
  wire  _GEN_38 = 2'h2 == index_addr ? age2_2 : _GEN_37; // @[DCache.scala 79:28 DCache.scala 79:28]
  wire  _GEN_39 = 2'h3 == index_addr ? age2_3 : _GEN_38; // @[DCache.scala 79:28 DCache.scala 79:28]
  wire [1:0] age = {_GEN_39,_GEN_31}; // @[Cat.scala 30:58]
  wire  updateway2 = age == 2'h1; // @[DCache.scala 83:27]
  wire  updateway1 = ~updateway2; // @[DCache.scala 84:23]
  wire  miss = ~hit; // @[DCache.scala 85:23]
  wire  _GEN_45 = 2'h1 == index_addr ? d1_1 : d1_0; // @[DCache.scala 86:26 DCache.scala 86:26]
  wire  _GEN_46 = 2'h2 == index_addr ? d1_2 : _GEN_45; // @[DCache.scala 86:26 DCache.scala 86:26]
  wire  _GEN_47 = 2'h3 == index_addr ? d1_3 : _GEN_46; // @[DCache.scala 86:26 DCache.scala 86:26]
  wire  _GEN_49 = 2'h1 == index_addr ? d2_1 : d2_0; // @[DCache.scala 86:26 DCache.scala 86:26]
  wire  _GEN_50 = 2'h2 == index_addr ? d2_2 : _GEN_49; // @[DCache.scala 86:26 DCache.scala 86:26]
  wire  _GEN_51 = 2'h3 == index_addr ? d2_3 : _GEN_50; // @[DCache.scala 86:26 DCache.scala 86:26]
  wire  dirty = updateway1 ? _GEN_47 : _GEN_51; // @[DCache.scala 86:26]
  wire  _T = 2'h0 == state; // @[Conditional.scala 37:30]
  wire  _T_3 = 2'h1 == state; // @[Conditional.scala 37:30]
  wire  _T_4 = 2'h2 == state; // @[Conditional.scala 37:30]
  wire [1:0] _GEN_54 = io_axi_rvalid ? 2'h0 : state; // @[DCache.scala 97:33 DCache.scala 97:40 DCache.scala 66:24]
  wire  update = state == 2'h2 & io_axi_rvalid; // @[DCache.scala 103:39]
  wire  way1write = hit1 & op; // @[DCache.scala 104:26]
  wire  way2write = hit2 & op; // @[DCache.scala 105:26]
  wire  _d1_T = update & updateway1; // @[DCache.scala 106:34]
  wire  _d2_T = update & updateway2; // @[DCache.scala 107:34]
  wire [7:0] mask64_hi_hi_hi_lo = wm[7] ? 8'hff : 8'h0; // @[Bitwise.scala 72:12]
  wire [7:0] mask64_hi_hi_lo = wm[6] ? 8'hff : 8'h0; // @[Bitwise.scala 72:12]
  wire [7:0] mask64_hi_lo_hi = wm[5] ? 8'hff : 8'h0; // @[Bitwise.scala 72:12]
  wire [7:0] mask64_hi_lo_lo = wm[4] ? 8'hff : 8'h0; // @[Bitwise.scala 72:12]
  wire [7:0] mask64_lo_hi_hi = wm[3] ? 8'hff : 8'h0; // @[Bitwise.scala 72:12]
  wire [7:0] mask64_lo_hi_lo = wm[2] ? 8'hff : 8'h0; // @[Bitwise.scala 72:12]
  wire [7:0] mask64_lo_lo_hi = wm[1] ? 8'hff : 8'h0; // @[Bitwise.scala 72:12]
  wire [7:0] mask64_lo_lo_lo = wm[0] ? 8'hff : 8'h0; // @[Bitwise.scala 72:12]
  wire [127:0] mask64 = {64'h0,mask64_hi_hi_hi_lo,mask64_hi_hi_lo,mask64_hi_lo_hi,mask64_hi_lo_lo,mask64_lo_hi_hi,
    mask64_lo_hi_lo,mask64_lo_lo_hi,mask64_lo_lo_lo}; // @[Cat.scala 30:58]
  wire [6:0] _blockmask_T_1 = {offset_addr[3], 6'h0}; // @[DCache.scala 112:52]
  wire [254:0] _GEN_90 = {{127'd0}, mask64}; // @[DCache.scala 112:29]
  wire [254:0] _blockmask_T_2 = _GEN_90 << _blockmask_T_1; // @[DCache.scala 112:29]
  wire [127:0] blockmask = _blockmask_T_2[127:0]; // @[DCache.scala 112:58]
  wire [190:0] _GEN_91 = {{127'd0}, wdata}; // @[DCache.scala 113:29]
  wire [190:0] _blockwdata_T_2 = _GEN_91 << _blockmask_T_1; // @[DCache.scala 113:29]
  wire [127:0] blockwdata = _blockwdata_T_2[127:0]; // @[DCache.scala 113:58]
  wire [127:0] _block1_after_write_T = ~blockmask; // @[DCache.scala 114:53]
  wire [127:0] _block1_after_write_T_1 = _GEN_23 & _block1_after_write_T; // @[DCache.scala 114:50]
  wire [127:0] _block1_after_write_T_2 = blockmask & blockwdata; // @[DCache.scala 114:79]
  wire [127:0] block1_after_write = _block1_after_write_T_1 | _block1_after_write_T_2; // @[DCache.scala 114:66]
  wire [127:0] _block2_after_write_T_1 = _GEN_27 & _block1_after_write_T; // @[DCache.scala 115:50]
  wire [127:0] block2_after_write = _block2_after_write_T_1 | _block1_after_write_T_2; // @[DCache.scala 115:66]
  wire [57:0] io_axi_waddr_hi_hi = updateway1 ? _GEN_7 : _GEN_15; // @[DCache.scala 129:31]
  wire [59:0] io_axi_waddr_hi = {io_axi_waddr_hi_hi,index_addr}; // @[Cat.scala 30:58]
  assign io_dmem_ok = (hit | not_en_yet) & state == 2'h0; // @[DCache.scala 75:44]
  assign io_dmem_rdata = hit2 ? rdata2 : _rdata_T; // @[DCache.scala 69:26]
  assign io_axi_req = state == 2'h2; // @[DCache.scala 126:30]
  assign io_axi_raddr = addr & 64'hfffffffffffffff0; // @[DCache.scala 127:29]
  assign io_axi_weq = state == 2'h1; // @[DCache.scala 128:30]
  assign io_axi_waddr = {io_axi_waddr_hi,4'h0}; // @[Cat.scala 30:58]
  assign io_axi_wdata = updateway1 ? _GEN_23 : _GEN_27; // @[DCache.scala 130:27]
  always @(posedge clock) begin
    if (reset) begin // @[Reg.scala 27:20]
      op <= 1'h0; // @[Reg.scala 27:20]
    end else if (_op_T) begin // @[Reg.scala 28:19]
      op <= io_dmem_op; // @[Reg.scala 28:23]
    end
    if (reset) begin // @[Reg.scala 27:20]
      addr <= 64'h0; // @[Reg.scala 27:20]
    end else if (_op_T) begin // @[Reg.scala 28:19]
      addr <= io_dmem_addr; // @[Reg.scala 28:23]
    end
    if (reset) begin // @[Reg.scala 27:20]
      wdata <= 64'h0; // @[Reg.scala 27:20]
    end else if (_op_T) begin // @[Reg.scala 28:19]
      wdata <= io_dmem_wdata; // @[Reg.scala 28:23]
    end
    if (reset) begin // @[Reg.scala 27:20]
      wm <= 8'h0; // @[Reg.scala 27:20]
    end else if (_op_T) begin // @[Reg.scala 28:19]
      wm <= io_dmem_wmask; // @[Reg.scala 28:23]
    end
    if (reset) begin // @[DCache.scala 49:26]
      v1_0 <= 1'h0; // @[DCache.scala 49:26]
    end else if (2'h0 == index_addr) begin // @[DCache.scala 120:26]
      v1_0 <= _d1_T | _GEN_11; // @[DCache.scala 120:26]
    end
    if (reset) begin // @[DCache.scala 49:26]
      v1_1 <= 1'h0; // @[DCache.scala 49:26]
    end else if (2'h1 == index_addr) begin // @[DCache.scala 120:26]
      v1_1 <= _d1_T | _GEN_11; // @[DCache.scala 120:26]
    end
    if (reset) begin // @[DCache.scala 49:26]
      v1_2 <= 1'h0; // @[DCache.scala 49:26]
    end else if (2'h2 == index_addr) begin // @[DCache.scala 120:26]
      v1_2 <= _d1_T | _GEN_11; // @[DCache.scala 120:26]
    end
    if (reset) begin // @[DCache.scala 49:26]
      v1_3 <= 1'h0; // @[DCache.scala 49:26]
    end else if (2'h3 == index_addr) begin // @[DCache.scala 120:26]
      v1_3 <= _d1_T | _GEN_11; // @[DCache.scala 120:26]
    end
    if (reset) begin // @[DCache.scala 50:26]
      d1_0 <= 1'h0; // @[DCache.scala 50:26]
    end else if (2'h0 == index_addr) begin // @[DCache.scala 106:20]
      if (update & updateway1) begin // @[DCache.scala 106:26]
        d1_0 <= 1'h0;
      end else begin
        d1_0 <= way1write | _GEN_47;
      end
    end
    if (reset) begin // @[DCache.scala 50:26]
      d1_1 <= 1'h0; // @[DCache.scala 50:26]
    end else if (2'h1 == index_addr) begin // @[DCache.scala 106:20]
      if (update & updateway1) begin // @[DCache.scala 106:26]
        d1_1 <= 1'h0;
      end else begin
        d1_1 <= way1write | _GEN_47;
      end
    end
    if (reset) begin // @[DCache.scala 50:26]
      d1_2 <= 1'h0; // @[DCache.scala 50:26]
    end else if (2'h2 == index_addr) begin // @[DCache.scala 106:20]
      if (update & updateway1) begin // @[DCache.scala 106:26]
        d1_2 <= 1'h0;
      end else begin
        d1_2 <= way1write | _GEN_47;
      end
    end
    if (reset) begin // @[DCache.scala 50:26]
      d1_3 <= 1'h0; // @[DCache.scala 50:26]
    end else if (2'h3 == index_addr) begin // @[DCache.scala 106:20]
      if (update & updateway1) begin // @[DCache.scala 106:26]
        d1_3 <= 1'h0;
      end else begin
        d1_3 <= way1write | _GEN_47;
      end
    end
    if (reset) begin // @[DCache.scala 51:26]
      age1_0 <= 1'h0; // @[DCache.scala 51:26]
    end else if (2'h0 == index_addr) begin // @[DCache.scala 78:22]
      if (hit1 ^ hit2) begin // @[DCache.scala 78:28]
        age1_0 <= hit1;
      end else if (2'h3 == index_addr) begin // @[DCache.scala 78:28]
        age1_0 <= age1_3; // @[DCache.scala 78:28]
      end else begin
        age1_0 <= _GEN_30;
      end
    end
    if (reset) begin // @[DCache.scala 51:26]
      age1_1 <= 1'h0; // @[DCache.scala 51:26]
    end else if (2'h1 == index_addr) begin // @[DCache.scala 78:22]
      if (hit1 ^ hit2) begin // @[DCache.scala 78:28]
        age1_1 <= hit1;
      end else if (2'h3 == index_addr) begin // @[DCache.scala 78:28]
        age1_1 <= age1_3; // @[DCache.scala 78:28]
      end else begin
        age1_1 <= _GEN_30;
      end
    end
    if (reset) begin // @[DCache.scala 51:26]
      age1_2 <= 1'h0; // @[DCache.scala 51:26]
    end else if (2'h2 == index_addr) begin // @[DCache.scala 78:22]
      if (hit1 ^ hit2) begin // @[DCache.scala 78:28]
        age1_2 <= hit1;
      end else if (2'h3 == index_addr) begin // @[DCache.scala 78:28]
        age1_2 <= age1_3; // @[DCache.scala 78:28]
      end else begin
        age1_2 <= _GEN_30;
      end
    end
    if (reset) begin // @[DCache.scala 51:26]
      age1_3 <= 1'h0; // @[DCache.scala 51:26]
    end else if (2'h3 == index_addr) begin // @[DCache.scala 78:22]
      if (hit1 ^ hit2) begin // @[DCache.scala 78:28]
        age1_3 <= hit1;
      end else if (!(2'h3 == index_addr)) begin // @[DCache.scala 78:28]
        age1_3 <= _GEN_30;
      end
    end
    if (reset) begin // @[DCache.scala 52:26]
      tag1_0 <= 58'h0; // @[DCache.scala 52:26]
    end else if (2'h0 == index_addr) begin // @[DCache.scala 119:26]
      if (_d1_T) begin // @[DCache.scala 119:32]
        tag1_0 <= tag_addr;
      end else if (2'h3 == index_addr) begin // @[DCache.scala 60:28]
        tag1_0 <= tag1_3; // @[DCache.scala 60:28]
      end else begin
        tag1_0 <= _GEN_6;
      end
    end
    if (reset) begin // @[DCache.scala 52:26]
      tag1_1 <= 58'h0; // @[DCache.scala 52:26]
    end else if (2'h1 == index_addr) begin // @[DCache.scala 119:26]
      if (_d1_T) begin // @[DCache.scala 119:32]
        tag1_1 <= tag_addr;
      end else if (2'h3 == index_addr) begin // @[DCache.scala 60:28]
        tag1_1 <= tag1_3; // @[DCache.scala 60:28]
      end else begin
        tag1_1 <= _GEN_6;
      end
    end
    if (reset) begin // @[DCache.scala 52:26]
      tag1_2 <= 58'h0; // @[DCache.scala 52:26]
    end else if (2'h2 == index_addr) begin // @[DCache.scala 119:26]
      if (_d1_T) begin // @[DCache.scala 119:32]
        tag1_2 <= tag_addr;
      end else if (2'h3 == index_addr) begin // @[DCache.scala 60:28]
        tag1_2 <= tag1_3; // @[DCache.scala 60:28]
      end else begin
        tag1_2 <= _GEN_6;
      end
    end
    if (reset) begin // @[DCache.scala 52:26]
      tag1_3 <= 58'h0; // @[DCache.scala 52:26]
    end else if (2'h3 == index_addr) begin // @[DCache.scala 119:26]
      if (_d1_T) begin // @[DCache.scala 119:32]
        tag1_3 <= tag_addr;
      end else if (!(2'h3 == index_addr)) begin // @[DCache.scala 60:28]
        tag1_3 <= _GEN_6;
      end
    end
    if (reset) begin // @[DCache.scala 53:26]
      block1_0 <= 128'h0; // @[DCache.scala 53:26]
    end else if (2'h0 == index_addr) begin // @[DCache.scala 118:26]
      if (_d1_T) begin // @[DCache.scala 118:32]
        block1_0 <= io_axi_rdata;
      end else if (way1write) begin // @[DCache.scala 118:72]
        block1_0 <= block1_after_write;
      end else begin
        block1_0 <= _GEN_23;
      end
    end
    if (reset) begin // @[DCache.scala 53:26]
      block1_1 <= 128'h0; // @[DCache.scala 53:26]
    end else if (2'h1 == index_addr) begin // @[DCache.scala 118:26]
      if (_d1_T) begin // @[DCache.scala 118:32]
        block1_1 <= io_axi_rdata;
      end else if (way1write) begin // @[DCache.scala 118:72]
        block1_1 <= block1_after_write;
      end else begin
        block1_1 <= _GEN_23;
      end
    end
    if (reset) begin // @[DCache.scala 53:26]
      block1_2 <= 128'h0; // @[DCache.scala 53:26]
    end else if (2'h2 == index_addr) begin // @[DCache.scala 118:26]
      if (_d1_T) begin // @[DCache.scala 118:32]
        block1_2 <= io_axi_rdata;
      end else if (way1write) begin // @[DCache.scala 118:72]
        block1_2 <= block1_after_write;
      end else begin
        block1_2 <= _GEN_23;
      end
    end
    if (reset) begin // @[DCache.scala 53:26]
      block1_3 <= 128'h0; // @[DCache.scala 53:26]
    end else if (2'h3 == index_addr) begin // @[DCache.scala 118:26]
      if (_d1_T) begin // @[DCache.scala 118:32]
        block1_3 <= io_axi_rdata;
      end else if (way1write) begin // @[DCache.scala 118:72]
        block1_3 <= block1_after_write;
      end else begin
        block1_3 <= _GEN_23;
      end
    end
    if (reset) begin // @[DCache.scala 54:26]
      v2_0 <= 1'h0; // @[DCache.scala 54:26]
    end else if (2'h0 == index_addr) begin // @[DCache.scala 123:26]
      v2_0 <= _d2_T | _GEN_19; // @[DCache.scala 123:26]
    end
    if (reset) begin // @[DCache.scala 54:26]
      v2_1 <= 1'h0; // @[DCache.scala 54:26]
    end else if (2'h1 == index_addr) begin // @[DCache.scala 123:26]
      v2_1 <= _d2_T | _GEN_19; // @[DCache.scala 123:26]
    end
    if (reset) begin // @[DCache.scala 54:26]
      v2_2 <= 1'h0; // @[DCache.scala 54:26]
    end else if (2'h2 == index_addr) begin // @[DCache.scala 123:26]
      v2_2 <= _d2_T | _GEN_19; // @[DCache.scala 123:26]
    end
    if (reset) begin // @[DCache.scala 54:26]
      v2_3 <= 1'h0; // @[DCache.scala 54:26]
    end else if (2'h3 == index_addr) begin // @[DCache.scala 123:26]
      v2_3 <= _d2_T | _GEN_19; // @[DCache.scala 123:26]
    end
    if (reset) begin // @[DCache.scala 55:26]
      d2_0 <= 1'h0; // @[DCache.scala 55:26]
    end else if (2'h0 == index_addr) begin // @[DCache.scala 107:20]
      if (update & updateway2) begin // @[DCache.scala 107:26]
        d2_0 <= 1'h0;
      end else begin
        d2_0 <= way2write | _GEN_51;
      end
    end
    if (reset) begin // @[DCache.scala 55:26]
      d2_1 <= 1'h0; // @[DCache.scala 55:26]
    end else if (2'h1 == index_addr) begin // @[DCache.scala 107:20]
      if (update & updateway2) begin // @[DCache.scala 107:26]
        d2_1 <= 1'h0;
      end else begin
        d2_1 <= way2write | _GEN_51;
      end
    end
    if (reset) begin // @[DCache.scala 55:26]
      d2_2 <= 1'h0; // @[DCache.scala 55:26]
    end else if (2'h2 == index_addr) begin // @[DCache.scala 107:20]
      if (update & updateway2) begin // @[DCache.scala 107:26]
        d2_2 <= 1'h0;
      end else begin
        d2_2 <= way2write | _GEN_51;
      end
    end
    if (reset) begin // @[DCache.scala 55:26]
      d2_3 <= 1'h0; // @[DCache.scala 55:26]
    end else if (2'h3 == index_addr) begin // @[DCache.scala 107:20]
      if (update & updateway2) begin // @[DCache.scala 107:26]
        d2_3 <= 1'h0;
      end else begin
        d2_3 <= way2write | _GEN_51;
      end
    end
    if (reset) begin // @[DCache.scala 56:26]
      age2_0 <= 1'h0; // @[DCache.scala 56:26]
    end else if (2'h0 == index_addr) begin // @[DCache.scala 79:22]
      if (_age1_T) begin // @[DCache.scala 79:28]
        age2_0 <= hit2;
      end else if (2'h3 == index_addr) begin // @[DCache.scala 79:28]
        age2_0 <= age2_3; // @[DCache.scala 79:28]
      end else begin
        age2_0 <= _GEN_38;
      end
    end
    if (reset) begin // @[DCache.scala 56:26]
      age2_1 <= 1'h0; // @[DCache.scala 56:26]
    end else if (2'h1 == index_addr) begin // @[DCache.scala 79:22]
      if (_age1_T) begin // @[DCache.scala 79:28]
        age2_1 <= hit2;
      end else if (2'h3 == index_addr) begin // @[DCache.scala 79:28]
        age2_1 <= age2_3; // @[DCache.scala 79:28]
      end else begin
        age2_1 <= _GEN_38;
      end
    end
    if (reset) begin // @[DCache.scala 56:26]
      age2_2 <= 1'h0; // @[DCache.scala 56:26]
    end else if (2'h2 == index_addr) begin // @[DCache.scala 79:22]
      if (_age1_T) begin // @[DCache.scala 79:28]
        age2_2 <= hit2;
      end else if (2'h3 == index_addr) begin // @[DCache.scala 79:28]
        age2_2 <= age2_3; // @[DCache.scala 79:28]
      end else begin
        age2_2 <= _GEN_38;
      end
    end
    if (reset) begin // @[DCache.scala 56:26]
      age2_3 <= 1'h0; // @[DCache.scala 56:26]
    end else if (2'h3 == index_addr) begin // @[DCache.scala 79:22]
      if (_age1_T) begin // @[DCache.scala 79:28]
        age2_3 <= hit2;
      end else if (!(2'h3 == index_addr)) begin // @[DCache.scala 79:28]
        age2_3 <= _GEN_38;
      end
    end
    if (reset) begin // @[DCache.scala 57:26]
      tag2_0 <= 58'h0; // @[DCache.scala 57:26]
    end else if (2'h0 == index_addr) begin // @[DCache.scala 122:26]
      if (_d2_T) begin // @[DCache.scala 122:32]
        tag2_0 <= tag_addr;
      end else if (2'h3 == index_addr) begin // @[DCache.scala 61:28]
        tag2_0 <= tag2_3; // @[DCache.scala 61:28]
      end else begin
        tag2_0 <= _GEN_14;
      end
    end
    if (reset) begin // @[DCache.scala 57:26]
      tag2_1 <= 58'h0; // @[DCache.scala 57:26]
    end else if (2'h1 == index_addr) begin // @[DCache.scala 122:26]
      if (_d2_T) begin // @[DCache.scala 122:32]
        tag2_1 <= tag_addr;
      end else if (2'h3 == index_addr) begin // @[DCache.scala 61:28]
        tag2_1 <= tag2_3; // @[DCache.scala 61:28]
      end else begin
        tag2_1 <= _GEN_14;
      end
    end
    if (reset) begin // @[DCache.scala 57:26]
      tag2_2 <= 58'h0; // @[DCache.scala 57:26]
    end else if (2'h2 == index_addr) begin // @[DCache.scala 122:26]
      if (_d2_T) begin // @[DCache.scala 122:32]
        tag2_2 <= tag_addr;
      end else if (2'h3 == index_addr) begin // @[DCache.scala 61:28]
        tag2_2 <= tag2_3; // @[DCache.scala 61:28]
      end else begin
        tag2_2 <= _GEN_14;
      end
    end
    if (reset) begin // @[DCache.scala 57:26]
      tag2_3 <= 58'h0; // @[DCache.scala 57:26]
    end else if (2'h3 == index_addr) begin // @[DCache.scala 122:26]
      if (_d2_T) begin // @[DCache.scala 122:32]
        tag2_3 <= tag_addr;
      end else if (!(2'h3 == index_addr)) begin // @[DCache.scala 61:28]
        tag2_3 <= _GEN_14;
      end
    end
    if (reset) begin // @[DCache.scala 58:26]
      block2_0 <= 128'h0; // @[DCache.scala 58:26]
    end else if (2'h0 == index_addr) begin // @[DCache.scala 121:26]
      if (_d2_T) begin // @[DCache.scala 121:32]
        block2_0 <= io_axi_rdata;
      end else if (way2write) begin // @[DCache.scala 121:72]
        block2_0 <= block2_after_write;
      end else begin
        block2_0 <= _GEN_27;
      end
    end
    if (reset) begin // @[DCache.scala 58:26]
      block2_1 <= 128'h0; // @[DCache.scala 58:26]
    end else if (2'h1 == index_addr) begin // @[DCache.scala 121:26]
      if (_d2_T) begin // @[DCache.scala 121:32]
        block2_1 <= io_axi_rdata;
      end else if (way2write) begin // @[DCache.scala 121:72]
        block2_1 <= block2_after_write;
      end else begin
        block2_1 <= _GEN_27;
      end
    end
    if (reset) begin // @[DCache.scala 58:26]
      block2_2 <= 128'h0; // @[DCache.scala 58:26]
    end else if (2'h2 == index_addr) begin // @[DCache.scala 121:26]
      if (_d2_T) begin // @[DCache.scala 121:32]
        block2_2 <= io_axi_rdata;
      end else if (way2write) begin // @[DCache.scala 121:72]
        block2_2 <= block2_after_write;
      end else begin
        block2_2 <= _GEN_27;
      end
    end
    if (reset) begin // @[DCache.scala 58:26]
      block2_3 <= 128'h0; // @[DCache.scala 58:26]
    end else if (2'h3 == index_addr) begin // @[DCache.scala 121:26]
      if (_d2_T) begin // @[DCache.scala 121:32]
        block2_3 <= io_axi_rdata;
      end else if (way2write) begin // @[DCache.scala 121:72]
        block2_3 <= block2_after_write;
      end else begin
        block2_3 <= _GEN_27;
      end
    end
    if (reset) begin // @[DCache.scala 66:24]
      state <= 2'h0; // @[DCache.scala 66:24]
    end else if (_T) begin // @[Conditional.scala 40:58]
      if (miss & ~not_en_yet) begin // @[DCache.scala 90:39]
        if (dirty) begin // @[DCache.scala 90:52]
          state <= 2'h1;
        end else begin
          state <= 2'h2;
        end
      end
    end else if (_T_3) begin // @[Conditional.scala 39:67]
      if (io_axi_wdone) begin // @[DCache.scala 94:32]
        state <= 2'h2; // @[DCache.scala 94:39]
      end
    end else if (_T_4) begin // @[Conditional.scala 39:67]
      state <= _GEN_54;
    end
    not_en_yet <= reset | _not_en_yet_T; // @[DCache.scala 71:30 DCache.scala 71:30 DCache.scala 72:21]
  end
// Register and memory initialization
`ifdef RANDOMIZE_GARBAGE_ASSIGN
`define RANDOMIZE
`endif
`ifdef RANDOMIZE_INVALID_ASSIGN
`define RANDOMIZE
`endif
`ifdef RANDOMIZE_REG_INIT
`define RANDOMIZE
`endif
`ifdef RANDOMIZE_MEM_INIT
`define RANDOMIZE
`endif
`ifndef RANDOM
`define RANDOM $random
`endif
`ifdef RANDOMIZE_MEM_INIT
  integer initvar;
`endif
`ifndef SYNTHESIS
`ifdef FIRRTL_BEFORE_INITIAL
`FIRRTL_BEFORE_INITIAL
`endif
initial begin
  `ifdef RANDOMIZE
    `ifdef INIT_RANDOM
      `INIT_RANDOM
    `endif
    `ifndef VERILATOR
      `ifdef RANDOMIZE_DELAY
        #`RANDOMIZE_DELAY begin end
      `else
        #0.002 begin end
      `endif
    `endif
`ifdef RANDOMIZE_REG_INIT
  _RAND_0 = {1{`RANDOM}};
  op = _RAND_0[0:0];
  _RAND_1 = {2{`RANDOM}};
  addr = _RAND_1[63:0];
  _RAND_2 = {2{`RANDOM}};
  wdata = _RAND_2[63:0];
  _RAND_3 = {1{`RANDOM}};
  wm = _RAND_3[7:0];
  _RAND_4 = {1{`RANDOM}};
  v1_0 = _RAND_4[0:0];
  _RAND_5 = {1{`RANDOM}};
  v1_1 = _RAND_5[0:0];
  _RAND_6 = {1{`RANDOM}};
  v1_2 = _RAND_6[0:0];
  _RAND_7 = {1{`RANDOM}};
  v1_3 = _RAND_7[0:0];
  _RAND_8 = {1{`RANDOM}};
  d1_0 = _RAND_8[0:0];
  _RAND_9 = {1{`RANDOM}};
  d1_1 = _RAND_9[0:0];
  _RAND_10 = {1{`RANDOM}};
  d1_2 = _RAND_10[0:0];
  _RAND_11 = {1{`RANDOM}};
  d1_3 = _RAND_11[0:0];
  _RAND_12 = {1{`RANDOM}};
  age1_0 = _RAND_12[0:0];
  _RAND_13 = {1{`RANDOM}};
  age1_1 = _RAND_13[0:0];
  _RAND_14 = {1{`RANDOM}};
  age1_2 = _RAND_14[0:0];
  _RAND_15 = {1{`RANDOM}};
  age1_3 = _RAND_15[0:0];
  _RAND_16 = {2{`RANDOM}};
  tag1_0 = _RAND_16[57:0];
  _RAND_17 = {2{`RANDOM}};
  tag1_1 = _RAND_17[57:0];
  _RAND_18 = {2{`RANDOM}};
  tag1_2 = _RAND_18[57:0];
  _RAND_19 = {2{`RANDOM}};
  tag1_3 = _RAND_19[57:0];
  _RAND_20 = {4{`RANDOM}};
  block1_0 = _RAND_20[127:0];
  _RAND_21 = {4{`RANDOM}};
  block1_1 = _RAND_21[127:0];
  _RAND_22 = {4{`RANDOM}};
  block1_2 = _RAND_22[127:0];
  _RAND_23 = {4{`RANDOM}};
  block1_3 = _RAND_23[127:0];
  _RAND_24 = {1{`RANDOM}};
  v2_0 = _RAND_24[0:0];
  _RAND_25 = {1{`RANDOM}};
  v2_1 = _RAND_25[0:0];
  _RAND_26 = {1{`RANDOM}};
  v2_2 = _RAND_26[0:0];
  _RAND_27 = {1{`RANDOM}};
  v2_3 = _RAND_27[0:0];
  _RAND_28 = {1{`RANDOM}};
  d2_0 = _RAND_28[0:0];
  _RAND_29 = {1{`RANDOM}};
  d2_1 = _RAND_29[0:0];
  _RAND_30 = {1{`RANDOM}};
  d2_2 = _RAND_30[0:0];
  _RAND_31 = {1{`RANDOM}};
  d2_3 = _RAND_31[0:0];
  _RAND_32 = {1{`RANDOM}};
  age2_0 = _RAND_32[0:0];
  _RAND_33 = {1{`RANDOM}};
  age2_1 = _RAND_33[0:0];
  _RAND_34 = {1{`RANDOM}};
  age2_2 = _RAND_34[0:0];
  _RAND_35 = {1{`RANDOM}};
  age2_3 = _RAND_35[0:0];
  _RAND_36 = {2{`RANDOM}};
  tag2_0 = _RAND_36[57:0];
  _RAND_37 = {2{`RANDOM}};
  tag2_1 = _RAND_37[57:0];
  _RAND_38 = {2{`RANDOM}};
  tag2_2 = _RAND_38[57:0];
  _RAND_39 = {2{`RANDOM}};
  tag2_3 = _RAND_39[57:0];
  _RAND_40 = {4{`RANDOM}};
  block2_0 = _RAND_40[127:0];
  _RAND_41 = {4{`RANDOM}};
  block2_1 = _RAND_41[127:0];
  _RAND_42 = {4{`RANDOM}};
  block2_2 = _RAND_42[127:0];
  _RAND_43 = {4{`RANDOM}};
  block2_3 = _RAND_43[127:0];
  _RAND_44 = {1{`RANDOM}};
  state = _RAND_44[1:0];
  _RAND_45 = {1{`RANDOM}};
  not_en_yet = _RAND_45[0:0];
`endif // RANDOMIZE_REG_INIT
  `endif // RANDOMIZE
end // initial
`ifdef FIRRTL_AFTER_INITIAL
`FIRRTL_AFTER_INITIAL
`endif
`endif // SYNTHESIS
endmodule
module AXI(
  input          clock,
  input          reset,
  input          io_out_aw_ready,
  output         io_out_aw_valid,
  output [63:0]  io_out_aw_bits_addr,
  input          io_out_w_ready,
  output         io_out_w_valid,
  output [63:0]  io_out_w_bits_data,
  output         io_out_w_bits_last,
  output         io_out_b_ready,
  input          io_out_b_valid,
  input          io_out_ar_ready,
  output         io_out_ar_valid,
  output [63:0]  io_out_ar_bits_addr,
  output         io_out_r_ready,
  input          io_out_r_valid,
  input  [63:0]  io_out_r_bits_data,
  input          io_out_r_bits_last,
  input          io_icacheio_req,
  input  [63:0]  io_icacheio_addr,
  output         io_icacheio_valid,
  output [127:0] io_icacheio_data,
  input          io_dcacheio_req,
  input  [63:0]  io_dcacheio_raddr,
  output         io_dcacheio_rvalid,
  output [127:0] io_dcacheio_rdata,
  input          io_dcacheio_weq,
  input  [63:0]  io_dcacheio_waddr,
  input  [127:0] io_dcacheio_wdata,
  output         io_dcacheio_wdone
);
`ifdef RANDOMIZE_REG_INIT
  reg [63:0] _RAND_0;
  reg [63:0] _RAND_1;
  reg [63:0] _RAND_2;
  reg [63:0] _RAND_3;
  reg [31:0] _RAND_4;
  reg [31:0] _RAND_5;
  reg [31:0] _RAND_6;
  reg [31:0] _RAND_7;
  reg [31:0] _RAND_8;
`endif // RANDOMIZE_REG_INIT
  reg [63:0] ibuffer_0; // @[AXI.scala 65:30]
  reg [63:0] ibuffer_1; // @[AXI.scala 65:30]
  reg [63:0] drbuffer_0; // @[AXI.scala 66:30]
  reg [63:0] drbuffer_1; // @[AXI.scala 66:30]
  reg [3:0] icnt; // @[AXI.scala 67:30]
  reg [3:0] drcnt; // @[AXI.scala 68:30]
  reg [3:0] dwcnt; // @[AXI.scala 69:30]
  reg [3:0] rstate; // @[AXI.scala 73:25]
  reg [2:0] wstate; // @[AXI.scala 74:25]
  wire  _T = 4'h0 == rstate; // @[Conditional.scala 37:30]
  wire  _T_1 = 4'h1 == rstate; // @[Conditional.scala 37:30]
  wire  _T_2 = 4'h2 == rstate; // @[Conditional.scala 37:30]
  wire [3:0] _GEN_3 = io_out_r_valid ? 4'h3 : rstate; // @[AXI.scala 87:31 AXI.scala 87:39 AXI.scala 73:25]
  wire  _T_3 = 4'h3 == rstate; // @[Conditional.scala 37:30]
  wire  _T_5 = ~io_out_r_valid | io_out_r_bits_last; // @[AXI.scala 90:42]
  wire [3:0] _GEN_4 = ~io_out_r_valid | io_out_r_bits_last ? 4'h4 : rstate; // @[AXI.scala 90:62 AXI.scala 90:70 AXI.scala 73:25]
  wire  _T_6 = 4'h4 == rstate; // @[Conditional.scala 37:30]
  wire  _T_7 = 4'h5 == rstate; // @[Conditional.scala 37:30]
  wire [3:0] _GEN_5 = io_out_ar_ready ? 4'h6 : rstate; // @[AXI.scala 97:32 AXI.scala 97:40 AXI.scala 73:25]
  wire  _T_8 = 4'h6 == rstate; // @[Conditional.scala 37:30]
  wire [3:0] _GEN_6 = io_out_r_valid ? 4'h7 : rstate; // @[AXI.scala 100:31 AXI.scala 100:39 AXI.scala 73:25]
  wire  _T_9 = 4'h7 == rstate; // @[Conditional.scala 37:30]
  wire [3:0] _GEN_7 = _T_5 ? 4'h8 : rstate; // @[AXI.scala 103:62 AXI.scala 103:70 AXI.scala 73:25]
  wire  _T_12 = 4'h8 == rstate; // @[Conditional.scala 37:30]
  wire [3:0] _GEN_8 = _T_12 ? 4'h0 : rstate; // @[Conditional.scala 39:67 AXI.scala 106:20 AXI.scala 73:25]
  wire [3:0] _GEN_9 = _T_9 ? _GEN_7 : _GEN_8; // @[Conditional.scala 39:67]
  wire [3:0] _GEN_10 = _T_8 ? _GEN_6 : _GEN_9; // @[Conditional.scala 39:67]
  wire [3:0] _GEN_11 = _T_7 ? _GEN_5 : _GEN_10; // @[Conditional.scala 39:67]
  wire [3:0] _GEN_12 = _T_6 ? 4'h0 : _GEN_11; // @[Conditional.scala 39:67 AXI.scala 93:20]
  wire [3:0] _GEN_13 = _T_3 ? _GEN_4 : _GEN_12; // @[Conditional.scala 39:67]
  wire  _T_13 = 3'h0 == wstate; // @[Conditional.scala 37:30]
  wire  _T_14 = 3'h1 == wstate; // @[Conditional.scala 37:30]
  wire  _T_15 = 3'h2 == wstate; // @[Conditional.scala 37:30]
  wire [2:0] _GEN_19 = io_out_w_bits_last ? 3'h3 : wstate; // @[AXI.scala 119:35 AXI.scala 119:43 AXI.scala 74:25]
  wire  _T_16 = 3'h3 == wstate; // @[Conditional.scala 37:30]
  wire [2:0] _GEN_20 = io_out_b_valid ? 3'h4 : wstate; // @[AXI.scala 122:31 AXI.scala 122:39 AXI.scala 74:25]
  wire  _T_17 = 3'h4 == wstate; // @[Conditional.scala 37:30]
  wire  _T_18 = ~io_out_b_valid; // @[AXI.scala 125:18]
  wire [2:0] _GEN_21 = ~io_out_b_valid ? 3'h0 : wstate; // @[AXI.scala 125:32 AXI.scala 125:40 AXI.scala 74:25]
  wire [2:0] _GEN_22 = _T_17 ? _GEN_21 : wstate; // @[Conditional.scala 39:67 AXI.scala 74:25]
  wire [2:0] _GEN_23 = _T_16 ? _GEN_20 : _GEN_22; // @[Conditional.scala 39:67]
  wire  _ibuffer_T = rstate == 4'h3; // @[AXI.scala 131:33]
  wire [3:0] _icnt_T_2 = icnt + 4'h1; // @[AXI.scala 132:42]
  wire  _drbuffer_T = rstate == 4'h7; // @[AXI.scala 133:35]
  wire [3:0] _drcnt_T_2 = drcnt + 4'h1; // @[AXI.scala 134:44]
  wire [3:0] _dwcnt_T_3 = dwcnt + 4'h1; // @[AXI.scala 135:58]
  wire  _io_out_ar_valid_T = rstate == 4'h1; // @[AXI.scala 160:35]
  wire  _io_out_ar_valid_T_1 = rstate == 4'h5; // @[AXI.scala 160:57]
  wire [63:0] _io_out_ar_bits_addr_T_2 = _io_out_ar_valid_T_1 ? io_dcacheio_raddr : 64'h0; // @[AXI.scala 161:70]
  wire [9:0] _io_out_w_bits_data_T = {dwcnt, 6'h0}; // @[AXI.scala 196:54]
  wire [127:0] _io_out_w_bits_data_T_1 = io_dcacheio_wdata >> _io_out_w_bits_data_T; // @[AXI.scala 196:44]
  assign io_out_aw_valid = wstate == 3'h1; // @[AXI.scala 183:35]
  assign io_out_aw_bits_addr = io_dcacheio_waddr; // @[AXI.scala 184:25]
  assign io_out_w_valid = wstate == 3'h2; // @[AXI.scala 195:35]
  assign io_out_w_bits_data = _io_out_w_bits_data_T_1[63:0]; // @[AXI.scala 196:60]
  assign io_out_w_bits_last = dwcnt == 4'h2; // @[AXI.scala 198:34]
  assign io_out_b_ready = wstate == 3'h4; // @[AXI.scala 200:35]
  assign io_out_ar_valid = rstate == 4'h1 | rstate == 4'h5; // @[AXI.scala 160:47]
  assign io_out_ar_bits_addr = _io_out_ar_valid_T ? io_icacheio_addr : _io_out_ar_bits_addr_T_2; // @[AXI.scala 161:31]
  assign io_out_r_ready = _ibuffer_T | _drbuffer_T; // @[AXI.scala 179:47]
  assign io_icacheio_valid = rstate == 4'h4; // @[AXI.scala 144:31]
  assign io_icacheio_data = {ibuffer_1,ibuffer_0}; // @[Cat.scala 30:58]
  assign io_dcacheio_rvalid = rstate == 4'h8; // @[AXI.scala 151:31]
  assign io_dcacheio_rdata = {drbuffer_1,drbuffer_0}; // @[Cat.scala 30:58]
  assign io_dcacheio_wdone = wstate == 3'h4 & _T_18; // @[AXI.scala 154:42]
  always @(posedge clock) begin
    if (reset) begin // @[AXI.scala 65:30]
      ibuffer_0 <= 64'h0; // @[AXI.scala 65:30]
    end else if (~icnt[0]) begin // @[AXI.scala 131:19]
      if (rstate == 4'h3) begin // @[AXI.scala 131:25]
        ibuffer_0 <= io_out_r_bits_data;
      end else if (icnt[0]) begin // @[AXI.scala 131:25]
        ibuffer_0 <= ibuffer_1; // @[AXI.scala 131:25]
      end
    end
    if (reset) begin // @[AXI.scala 65:30]
      ibuffer_1 <= 64'h0; // @[AXI.scala 65:30]
    end else if (icnt[0]) begin // @[AXI.scala 131:19]
      if (rstate == 4'h3) begin // @[AXI.scala 131:25]
        ibuffer_1 <= io_out_r_bits_data;
      end else if (!(icnt[0])) begin // @[AXI.scala 131:25]
        ibuffer_1 <= ibuffer_0;
      end
    end
    if (reset) begin // @[AXI.scala 66:30]
      drbuffer_0 <= 64'h0; // @[AXI.scala 66:30]
    end else if (~drcnt[0]) begin // @[AXI.scala 133:21]
      if (rstate == 4'h7) begin // @[AXI.scala 133:27]
        drbuffer_0 <= io_out_r_bits_data;
      end else if (drcnt[0]) begin // @[AXI.scala 133:27]
        drbuffer_0 <= drbuffer_1; // @[AXI.scala 133:27]
      end
    end
    if (reset) begin // @[AXI.scala 66:30]
      drbuffer_1 <= 64'h0; // @[AXI.scala 66:30]
    end else if (drcnt[0]) begin // @[AXI.scala 133:21]
      if (rstate == 4'h7) begin // @[AXI.scala 133:27]
        drbuffer_1 <= io_out_r_bits_data;
      end else if (!(drcnt[0])) begin // @[AXI.scala 133:27]
        drbuffer_1 <= drbuffer_0;
      end
    end
    if (reset) begin // @[AXI.scala 67:30]
      icnt <= 4'h0; // @[AXI.scala 67:30]
    end else if (_ibuffer_T) begin // @[AXI.scala 132:16]
      icnt <= _icnt_T_2;
    end else begin
      icnt <= 4'h0;
    end
    if (reset) begin // @[AXI.scala 68:30]
      drcnt <= 4'h0; // @[AXI.scala 68:30]
    end else if (_drbuffer_T) begin // @[AXI.scala 134:17]
      drcnt <= _drcnt_T_2;
    end else begin
      drcnt <= 4'h0;
    end
    if (reset) begin // @[AXI.scala 69:30]
      dwcnt <= 4'h0; // @[AXI.scala 69:30]
    end else if (wstate == 3'h2 & io_out_w_ready) begin // @[AXI.scala 135:17]
      dwcnt <= _dwcnt_T_3;
    end else begin
      dwcnt <= 4'h0;
    end
    if (reset) begin // @[AXI.scala 73:25]
      rstate <= 4'h0; // @[AXI.scala 73:25]
    end else if (_T) begin // @[Conditional.scala 40:58]
      if (io_icacheio_req) begin // @[AXI.scala 79:32]
        rstate <= 4'h1; // @[AXI.scala 79:40]
      end else if (io_dcacheio_req) begin // @[AXI.scala 80:37]
        rstate <= 4'h5; // @[AXI.scala 80:45]
      end
    end else if (_T_1) begin // @[Conditional.scala 39:67]
      if (io_out_ar_ready) begin // @[AXI.scala 84:32]
        rstate <= 4'h2; // @[AXI.scala 84:40]
      end
    end else if (_T_2) begin // @[Conditional.scala 39:67]
      rstate <= _GEN_3;
    end else begin
      rstate <= _GEN_13;
    end
    if (reset) begin // @[AXI.scala 74:25]
      wstate <= 3'h0; // @[AXI.scala 74:25]
    end else if (_T_13) begin // @[Conditional.scala 40:58]
      if (io_dcacheio_weq) begin // @[AXI.scala 113:32]
        wstate <= 3'h1; // @[AXI.scala 113:40]
      end
    end else if (_T_14) begin // @[Conditional.scala 39:67]
      if (io_out_aw_ready) begin // @[AXI.scala 116:32]
        wstate <= 3'h2; // @[AXI.scala 116:40]
      end
    end else if (_T_15) begin // @[Conditional.scala 39:67]
      wstate <= _GEN_19;
    end else begin
      wstate <= _GEN_23;
    end
  end
// Register and memory initialization
`ifdef RANDOMIZE_GARBAGE_ASSIGN
`define RANDOMIZE
`endif
`ifdef RANDOMIZE_INVALID_ASSIGN
`define RANDOMIZE
`endif
`ifdef RANDOMIZE_REG_INIT
`define RANDOMIZE
`endif
`ifdef RANDOMIZE_MEM_INIT
`define RANDOMIZE
`endif
`ifndef RANDOM
`define RANDOM $random
`endif
`ifdef RANDOMIZE_MEM_INIT
  integer initvar;
`endif
`ifndef SYNTHESIS
`ifdef FIRRTL_BEFORE_INITIAL
`FIRRTL_BEFORE_INITIAL
`endif
initial begin
  `ifdef RANDOMIZE
    `ifdef INIT_RANDOM
      `INIT_RANDOM
    `endif
    `ifndef VERILATOR
      `ifdef RANDOMIZE_DELAY
        #`RANDOMIZE_DELAY begin end
      `else
        #0.002 begin end
      `endif
    `endif
`ifdef RANDOMIZE_REG_INIT
  _RAND_0 = {2{`RANDOM}};
  ibuffer_0 = _RAND_0[63:0];
  _RAND_1 = {2{`RANDOM}};
  ibuffer_1 = _RAND_1[63:0];
  _RAND_2 = {2{`RANDOM}};
  drbuffer_0 = _RAND_2[63:0];
  _RAND_3 = {2{`RANDOM}};
  drbuffer_1 = _RAND_3[63:0];
  _RAND_4 = {1{`RANDOM}};
  icnt = _RAND_4[3:0];
  _RAND_5 = {1{`RANDOM}};
  drcnt = _RAND_5[3:0];
  _RAND_6 = {1{`RANDOM}};
  dwcnt = _RAND_6[3:0];
  _RAND_7 = {1{`RANDOM}};
  rstate = _RAND_7[3:0];
  _RAND_8 = {1{`RANDOM}};
  wstate = _RAND_8[2:0];
`endif // RANDOMIZE_REG_INIT
  `endif // RANDOMIZE
end // initial
`ifdef FIRRTL_AFTER_INITIAL
`FIRRTL_AFTER_INITIAL
`endif
`endif // SYNTHESIS
endmodule
module MMIO(
  input         clock,
  input         reset,
  input         io_dmem_en,
  input         io_dmem_op,
  input  [63:0] io_dmem_addr,
  input  [63:0] io_dmem_wdata,
  input  [7:0]  io_dmem_wmask,
  output        io_dmem_ok,
  output [63:0] io_dmem_rdata,
  output        io_mem0_en,
  output        io_mem0_op,
  output [63:0] io_mem0_addr,
  output [63:0] io_mem0_wdata,
  output [7:0]  io_mem0_wmask,
  input         io_mem0_ok,
  input  [63:0] io_mem0_rdata,
  output        io_mem1_en,
  output        io_mem1_op,
  output [63:0] io_mem1_addr,
  output [63:0] io_mem1_wdata,
  output [7:0]  io_mem1_wmask,
  input  [63:0] io_mem1_rdata
);
`ifdef RANDOMIZE_REG_INIT
  reg [31:0] _RAND_0;
`endif // RANDOMIZE_REG_INIT
  wire [1:0] _GEN_0 = io_dmem_addr == 64'h2004000 ? 2'h2 : 2'h0; // @[MMIO.scala 22:50 MMIO.scala 22:55 MMIO.scala 23:24]
  wire [1:0] _GEN_1 = 64'h2000000 <= io_dmem_addr & io_dmem_addr < 64'h200c000 ? 2'h1 : _GEN_0; // @[MMIO.scala 21:76 MMIO.scala 21:81]
  wire [1:0] sel = ~io_mem0_ok ? 2'h0 : _GEN_1; // @[MMIO.scala 16:22 MMIO.scala 16:27]
  reg [1:0] sel_r; // @[Reg.scala 27:20]
  wire  out_ok = 2'h2 == sel_r | (2'h1 == sel_r | 2'h0 == sel_r & io_mem0_ok); // @[Mux.scala 80:57]
  wire  _io_mem0_en_T = sel == 2'h0; // @[MMIO.scala 28:32]
  wire  _io_mem1_en_T = sel == 2'h1; // @[MMIO.scala 33:32]
  wire [63:0] _out_rdata_T_1 = 2'h0 == sel_r ? io_mem0_rdata : 64'h0; // @[Mux.scala 80:57]
  wire [63:0] _out_rdata_T_3 = 2'h1 == sel_r ? io_mem1_rdata : _out_rdata_T_1; // @[Mux.scala 80:57]
  assign io_dmem_ok = 2'h2 == sel_r | (2'h1 == sel_r | 2'h0 == sel_r & io_mem0_ok); // @[Mux.scala 80:57]
  assign io_dmem_rdata = 2'h2 == sel_r ? 64'h0 : _out_rdata_T_3; // @[Mux.scala 80:57]
  assign io_mem0_en = sel == 2'h0 & io_dmem_en; // @[MMIO.scala 28:27]
  assign io_mem0_op = _io_mem0_en_T & io_dmem_op; // @[MMIO.scala 29:27]
  assign io_mem0_addr = _io_mem0_en_T ? io_dmem_addr : 64'h0; // @[MMIO.scala 30:27]
  assign io_mem0_wdata = _io_mem0_en_T ? io_dmem_wdata : 64'h0; // @[MMIO.scala 31:27]
  assign io_mem0_wmask = _io_mem0_en_T ? io_dmem_wmask : 8'h0; // @[MMIO.scala 32:27]
  assign io_mem1_en = sel == 2'h1 & io_dmem_en; // @[MMIO.scala 33:27]
  assign io_mem1_op = _io_mem1_en_T & io_dmem_op; // @[MMIO.scala 34:27]
  assign io_mem1_addr = _io_mem1_en_T ? io_dmem_addr : 64'h0; // @[MMIO.scala 35:27]
  assign io_mem1_wdata = _io_mem1_en_T ? io_dmem_wdata : 64'h0; // @[MMIO.scala 36:27]
  assign io_mem1_wmask = _io_mem1_en_T ? io_dmem_wmask : 8'h0; // @[MMIO.scala 37:27]
  always @(posedge clock) begin
    if (reset) begin // @[Reg.scala 27:20]
      sel_r <= 2'h0; // @[Reg.scala 27:20]
    end else if (out_ok) begin // @[Reg.scala 28:19]
      if (~io_mem0_ok) begin // @[MMIO.scala 16:22]
        sel_r <= 2'h0; // @[MMIO.scala 16:27]
      end else if (64'h2000000 <= io_dmem_addr & io_dmem_addr < 64'h200c000) begin // @[MMIO.scala 21:76]
        sel_r <= 2'h1; // @[MMIO.scala 21:81]
      end else begin
        sel_r <= _GEN_0;
      end
    end
  end
// Register and memory initialization
`ifdef RANDOMIZE_GARBAGE_ASSIGN
`define RANDOMIZE
`endif
`ifdef RANDOMIZE_INVALID_ASSIGN
`define RANDOMIZE
`endif
`ifdef RANDOMIZE_REG_INIT
`define RANDOMIZE
`endif
`ifdef RANDOMIZE_MEM_INIT
`define RANDOMIZE
`endif
`ifndef RANDOM
`define RANDOM $random
`endif
`ifdef RANDOMIZE_MEM_INIT
  integer initvar;
`endif
`ifndef SYNTHESIS
`ifdef FIRRTL_BEFORE_INITIAL
`FIRRTL_BEFORE_INITIAL
`endif
initial begin
  `ifdef RANDOMIZE
    `ifdef INIT_RANDOM
      `INIT_RANDOM
    `endif
    `ifndef VERILATOR
      `ifdef RANDOMIZE_DELAY
        #`RANDOMIZE_DELAY begin end
      `else
        #0.002 begin end
      `endif
    `endif
`ifdef RANDOMIZE_REG_INIT
  _RAND_0 = {1{`RANDOM}};
  sel_r = _RAND_0[1:0];
`endif // RANDOMIZE_REG_INIT
  `endif // RANDOMIZE
end // initial
`ifdef FIRRTL_AFTER_INITIAL
`FIRRTL_AFTER_INITIAL
`endif
`endif // SYNTHESIS
endmodule
module ClintReg(
  input         clock,
  input         reset,
  input         io_mem_en,
  input         io_mem_op,
  input  [63:0] io_mem_addr,
  input  [63:0] io_mem_wdata,
  input  [7:0]  io_mem_wmask,
  output [63:0] io_mem_rdata
);
`ifdef RANDOMIZE_REG_INIT
  reg [31:0] _RAND_0;
  reg [31:0] _RAND_1;
  reg [63:0] _RAND_2;
  reg [63:0] _RAND_3;
  reg [31:0] _RAND_4;
  reg [63:0] _RAND_5;
  reg [63:0] _RAND_6;
`endif // RANDOMIZE_REG_INIT
  reg  en; // @[MMIO.scala 67:26]
  reg  op; // @[MMIO.scala 68:26]
  reg [63:0] addr; // @[MMIO.scala 69:26]
  reg [63:0] wdata; // @[MMIO.scala 70:26]
  reg [7:0] wm; // @[MMIO.scala 71:26]
  reg [63:0] mtime; // @[MMIO.scala 74:24]
  reg [63:0] mtimecmp; // @[MMIO.scala 75:27]
  wire [7:0] mask64_hi_hi_hi = wm[7] ? 8'hff : 8'h0; // @[Bitwise.scala 72:12]
  wire [7:0] mask64_hi_hi_lo = wm[6] ? 8'hff : 8'h0; // @[Bitwise.scala 72:12]
  wire [7:0] mask64_hi_lo_hi = wm[5] ? 8'hff : 8'h0; // @[Bitwise.scala 72:12]
  wire [7:0] mask64_hi_lo_lo = wm[4] ? 8'hff : 8'h0; // @[Bitwise.scala 72:12]
  wire [7:0] mask64_lo_hi_hi = wm[3] ? 8'hff : 8'h0; // @[Bitwise.scala 72:12]
  wire [7:0] mask64_lo_hi_lo = wm[2] ? 8'hff : 8'h0; // @[Bitwise.scala 72:12]
  wire [7:0] mask64_lo_lo_hi = wm[1] ? 8'hff : 8'h0; // @[Bitwise.scala 72:12]
  wire [7:0] mask64_lo_lo_lo = wm[0] ? 8'hff : 8'h0; // @[Bitwise.scala 72:12]
  wire [63:0] mask64 = {mask64_hi_hi_hi,mask64_hi_hi_lo,mask64_hi_lo_hi,mask64_hi_lo_lo,mask64_lo_hi_hi,mask64_lo_hi_lo,
    mask64_lo_lo_hi,mask64_lo_lo_lo}; // @[Cat.scala 30:58]
  wire [63:0] _mtime_update_T = ~mask64; // @[MMIO.scala 79:34]
  wire [63:0] _mtime_update_T_1 = mtime & _mtime_update_T; // @[MMIO.scala 79:31]
  wire [63:0] _mtime_update_T_2 = mask64 & wdata; // @[MMIO.scala 79:54]
  wire [63:0] mtime_update = _mtime_update_T_1 | _mtime_update_T_2; // @[MMIO.scala 79:44]
  wire [63:0] _mtimecmp_update_T_1 = mtimecmp & _mtime_update_T; // @[MMIO.scala 80:37]
  wire [63:0] mtimecmp_update = _mtimecmp_update_T_1 | _mtime_update_T_2; // @[MMIO.scala 80:50]
  wire  sel_hi = addr == 64'h2004000; // @[MMIO.scala 82:24]
  wire  sel_lo = addr == 64'h200bff8; // @[MMIO.scala 82:48]
  wire [1:0] sel = {sel_hi,sel_lo}; // @[Cat.scala 30:58]
  wire  _T = en & op; // @[MMIO.scala 84:13]
  wire [63:0] _mtime_T_1 = mtime + 64'h100; // @[MMIO.scala 85:31]
  wire [63:0] _io_mem_rdata_T_1 = 2'h1 == sel ? mtime : 64'h0; // @[Mux.scala 80:57]
  wire [63:0] _io_mem_rdata_T_3 = 2'h2 == sel ? mtimecmp : _io_mem_rdata_T_1; // @[Mux.scala 80:57]
  assign io_mem_rdata = en & ~op ? _io_mem_rdata_T_3 : 64'h0; // @[MMIO.scala 91:20 MMIO.scala 92:22 MMIO.scala 97:29]
  always @(posedge clock) begin
    if (reset) begin // @[MMIO.scala 67:26]
      en <= 1'h0; // @[MMIO.scala 67:26]
    end else begin
      en <= io_mem_en; // @[MMIO.scala 67:26]
    end
    if (reset) begin // @[MMIO.scala 68:26]
      op <= 1'h0; // @[MMIO.scala 68:26]
    end else begin
      op <= io_mem_op; // @[MMIO.scala 68:26]
    end
    if (reset) begin // @[MMIO.scala 69:26]
      addr <= 64'h0; // @[MMIO.scala 69:26]
    end else begin
      addr <= io_mem_addr; // @[MMIO.scala 69:26]
    end
    if (reset) begin // @[MMIO.scala 70:26]
      wdata <= 64'h0; // @[MMIO.scala 70:26]
    end else begin
      wdata <= io_mem_wdata; // @[MMIO.scala 70:26]
    end
    if (reset) begin // @[MMIO.scala 71:26]
      wm <= 8'h0; // @[MMIO.scala 71:26]
    end else begin
      wm <= io_mem_wmask; // @[MMIO.scala 71:26]
    end
    if (reset) begin // @[MMIO.scala 74:24]
      mtime <= 64'h0; // @[MMIO.scala 74:24]
    end else if (en & op & sel == 2'h1) begin // @[MMIO.scala 84:38]
      mtime <= mtime_update; // @[MMIO.scala 84:45]
    end else begin
      mtime <= _mtime_T_1; // @[MMIO.scala 85:22]
    end
    if (reset) begin // @[MMIO.scala 75:27]
      mtimecmp <= 64'h0; // @[MMIO.scala 75:27]
    end else if (_T & sel == 2'h2) begin // @[MMIO.scala 87:38]
      mtimecmp <= mtimecmp_update; // @[MMIO.scala 87:48]
    end
  end
// Register and memory initialization
`ifdef RANDOMIZE_GARBAGE_ASSIGN
`define RANDOMIZE
`endif
`ifdef RANDOMIZE_INVALID_ASSIGN
`define RANDOMIZE
`endif
`ifdef RANDOMIZE_REG_INIT
`define RANDOMIZE
`endif
`ifdef RANDOMIZE_MEM_INIT
`define RANDOMIZE
`endif
`ifndef RANDOM
`define RANDOM $random
`endif
`ifdef RANDOMIZE_MEM_INIT
  integer initvar;
`endif
`ifndef SYNTHESIS
`ifdef FIRRTL_BEFORE_INITIAL
`FIRRTL_BEFORE_INITIAL
`endif
initial begin
  `ifdef RANDOMIZE
    `ifdef INIT_RANDOM
      `INIT_RANDOM
    `endif
    `ifndef VERILATOR
      `ifdef RANDOMIZE_DELAY
        #`RANDOMIZE_DELAY begin end
      `else
        #0.002 begin end
      `endif
    `endif
`ifdef RANDOMIZE_REG_INIT
  _RAND_0 = {1{`RANDOM}};
  en = _RAND_0[0:0];
  _RAND_1 = {1{`RANDOM}};
  op = _RAND_1[0:0];
  _RAND_2 = {2{`RANDOM}};
  addr = _RAND_2[63:0];
  _RAND_3 = {2{`RANDOM}};
  wdata = _RAND_3[63:0];
  _RAND_4 = {1{`RANDOM}};
  wm = _RAND_4[7:0];
  _RAND_5 = {2{`RANDOM}};
  mtime = _RAND_5[63:0];
  _RAND_6 = {2{`RANDOM}};
  mtimecmp = _RAND_6[63:0];
`endif // RANDOMIZE_REG_INIT
  `endif // RANDOMIZE
end // initial
`ifdef FIRRTL_AFTER_INITIAL
`FIRRTL_AFTER_INITIAL
`endif
`endif // SYNTHESIS
endmodule
module SimTop(
  input         clock,
  input         reset,
  input  [63:0] io_logCtrl_log_begin,
  input  [63:0] io_logCtrl_log_end,
  input  [63:0] io_logCtrl_log_level,
  input         io_perfInfo_clean,
  input         io_perfInfo_dump,
  output        io_uart_out_valid,
  output [7:0]  io_uart_out_ch,
  output        io_uart_in_valid,
  input  [7:0]  io_uart_in_ch,
  input         io_memAXI_0_aw_ready,
  output        io_memAXI_0_aw_valid,
  output [7:0]  io_memAXI_0_aw_bits_len,
  output [2:0]  io_memAXI_0_aw_bits_size,
  output [1:0]  io_memAXI_0_aw_bits_burst,
  output        io_memAXI_0_aw_bits_lock,
  output [3:0]  io_memAXI_0_aw_bits_cache,
  output [3:0]  io_memAXI_0_aw_bits_qos,
  output [63:0] io_memAXI_0_aw_bits_addr,
  output [2:0]  io_memAXI_0_aw_bits_prot,
  output [3:0]  io_memAXI_0_aw_bits_id,
  output [3:0]  io_memAXI_0_aw_bits_user,
  input         io_memAXI_0_w_ready,
  output        io_memAXI_0_w_valid,
  output [63:0] io_memAXI_0_w_bits_data,
  output [7:0]  io_memAXI_0_w_bits_strb,
  output        io_memAXI_0_w_bits_last,
  output        io_memAXI_0_b_ready,
  input         io_memAXI_0_b_valid,
  input  [1:0]  io_memAXI_0_b_bits_resp,
  input  [3:0]  io_memAXI_0_b_bits_id,
  input  [3:0]  io_memAXI_0_b_bits_user,
  input         io_memAXI_0_ar_ready,
  output        io_memAXI_0_ar_valid,
  output [7:0]  io_memAXI_0_ar_bits_len,
  output [2:0]  io_memAXI_0_ar_bits_size,
  output [1:0]  io_memAXI_0_ar_bits_burst,
  output        io_memAXI_0_ar_bits_lock,
  output [3:0]  io_memAXI_0_ar_bits_cache,
  output [3:0]  io_memAXI_0_ar_bits_qos,
  output [63:0] io_memAXI_0_ar_bits_addr,
  output [2:0]  io_memAXI_0_ar_bits_prot,
  output [3:0]  io_memAXI_0_ar_bits_id,
  output [3:0]  io_memAXI_0_ar_bits_user,
  output        io_memAXI_0_r_ready,
  input         io_memAXI_0_r_valid,
  input  [1:0]  io_memAXI_0_r_bits_resp,
  input  [63:0] io_memAXI_0_r_bits_data,
  input         io_memAXI_0_r_bits_last,
  input  [3:0]  io_memAXI_0_r_bits_id,
  input  [3:0]  io_memAXI_0_r_bits_user
);
  wire  core_clock; // @[SimTop.scala 15:20]
  wire  core_reset; // @[SimTop.scala 15:20]
  wire [63:0] core_io_imem_addr; // @[SimTop.scala 15:20]
  wire  core_io_imem_en; // @[SimTop.scala 15:20]
  wire [31:0] core_io_imem_data; // @[SimTop.scala 15:20]
  wire  core_io_imem_ok; // @[SimTop.scala 15:20]
  wire  core_io_dmem_en; // @[SimTop.scala 15:20]
  wire  core_io_dmem_op; // @[SimTop.scala 15:20]
  wire [63:0] core_io_dmem_addr; // @[SimTop.scala 15:20]
  wire [63:0] core_io_dmem_wdata; // @[SimTop.scala 15:20]
  wire [7:0] core_io_dmem_wmask; // @[SimTop.scala 15:20]
  wire  core_io_dmem_ok; // @[SimTop.scala 15:20]
  wire [63:0] core_io_dmem_rdata; // @[SimTop.scala 15:20]
  wire  icache_clock; // @[SimTop.scala 16:22]
  wire  icache_reset; // @[SimTop.scala 16:22]
  wire [63:0] icache_io_imem_addr; // @[SimTop.scala 16:22]
  wire  icache_io_imem_en; // @[SimTop.scala 16:22]
  wire [31:0] icache_io_imem_data; // @[SimTop.scala 16:22]
  wire  icache_io_imem_ok; // @[SimTop.scala 16:22]
  wire  icache_io_axi_req; // @[SimTop.scala 16:22]
  wire [63:0] icache_io_axi_addr; // @[SimTop.scala 16:22]
  wire  icache_io_axi_valid; // @[SimTop.scala 16:22]
  wire [127:0] icache_io_axi_data; // @[SimTop.scala 16:22]
  wire  dcache_clock; // @[SimTop.scala 17:22]
  wire  dcache_reset; // @[SimTop.scala 17:22]
  wire  dcache_io_dmem_en; // @[SimTop.scala 17:22]
  wire  dcache_io_dmem_op; // @[SimTop.scala 17:22]
  wire [63:0] dcache_io_dmem_addr; // @[SimTop.scala 17:22]
  wire [63:0] dcache_io_dmem_wdata; // @[SimTop.scala 17:22]
  wire [7:0] dcache_io_dmem_wmask; // @[SimTop.scala 17:22]
  wire  dcache_io_dmem_ok; // @[SimTop.scala 17:22]
  wire [63:0] dcache_io_dmem_rdata; // @[SimTop.scala 17:22]
  wire  dcache_io_axi_req; // @[SimTop.scala 17:22]
  wire [63:0] dcache_io_axi_raddr; // @[SimTop.scala 17:22]
  wire  dcache_io_axi_rvalid; // @[SimTop.scala 17:22]
  wire [127:0] dcache_io_axi_rdata; // @[SimTop.scala 17:22]
  wire  dcache_io_axi_weq; // @[SimTop.scala 17:22]
  wire [63:0] dcache_io_axi_waddr; // @[SimTop.scala 17:22]
  wire [127:0] dcache_io_axi_wdata; // @[SimTop.scala 17:22]
  wire  dcache_io_axi_wdone; // @[SimTop.scala 17:22]
  wire  axi_clock; // @[SimTop.scala 18:19]
  wire  axi_reset; // @[SimTop.scala 18:19]
  wire  axi_io_out_aw_ready; // @[SimTop.scala 18:19]
  wire  axi_io_out_aw_valid; // @[SimTop.scala 18:19]
  wire [63:0] axi_io_out_aw_bits_addr; // @[SimTop.scala 18:19]
  wire  axi_io_out_w_ready; // @[SimTop.scala 18:19]
  wire  axi_io_out_w_valid; // @[SimTop.scala 18:19]
  wire [63:0] axi_io_out_w_bits_data; // @[SimTop.scala 18:19]
  wire  axi_io_out_w_bits_last; // @[SimTop.scala 18:19]
  wire  axi_io_out_b_ready; // @[SimTop.scala 18:19]
  wire  axi_io_out_b_valid; // @[SimTop.scala 18:19]
  wire  axi_io_out_ar_ready; // @[SimTop.scala 18:19]
  wire  axi_io_out_ar_valid; // @[SimTop.scala 18:19]
  wire [63:0] axi_io_out_ar_bits_addr; // @[SimTop.scala 18:19]
  wire  axi_io_out_r_ready; // @[SimTop.scala 18:19]
  wire  axi_io_out_r_valid; // @[SimTop.scala 18:19]
  wire [63:0] axi_io_out_r_bits_data; // @[SimTop.scala 18:19]
  wire  axi_io_out_r_bits_last; // @[SimTop.scala 18:19]
  wire  axi_io_icacheio_req; // @[SimTop.scala 18:19]
  wire [63:0] axi_io_icacheio_addr; // @[SimTop.scala 18:19]
  wire  axi_io_icacheio_valid; // @[SimTop.scala 18:19]
  wire [127:0] axi_io_icacheio_data; // @[SimTop.scala 18:19]
  wire  axi_io_dcacheio_req; // @[SimTop.scala 18:19]
  wire [63:0] axi_io_dcacheio_raddr; // @[SimTop.scala 18:19]
  wire  axi_io_dcacheio_rvalid; // @[SimTop.scala 18:19]
  wire [127:0] axi_io_dcacheio_rdata; // @[SimTop.scala 18:19]
  wire  axi_io_dcacheio_weq; // @[SimTop.scala 18:19]
  wire [63:0] axi_io_dcacheio_waddr; // @[SimTop.scala 18:19]
  wire [127:0] axi_io_dcacheio_wdata; // @[SimTop.scala 18:19]
  wire  axi_io_dcacheio_wdone; // @[SimTop.scala 18:19]
  wire  mmio_clock; // @[SimTop.scala 20:20]
  wire  mmio_reset; // @[SimTop.scala 20:20]
  wire  mmio_io_dmem_en; // @[SimTop.scala 20:20]
  wire  mmio_io_dmem_op; // @[SimTop.scala 20:20]
  wire [63:0] mmio_io_dmem_addr; // @[SimTop.scala 20:20]
  wire [63:0] mmio_io_dmem_wdata; // @[SimTop.scala 20:20]
  wire [7:0] mmio_io_dmem_wmask; // @[SimTop.scala 20:20]
  wire  mmio_io_dmem_ok; // @[SimTop.scala 20:20]
  wire [63:0] mmio_io_dmem_rdata; // @[SimTop.scala 20:20]
  wire  mmio_io_mem0_en; // @[SimTop.scala 20:20]
  wire  mmio_io_mem0_op; // @[SimTop.scala 20:20]
  wire [63:0] mmio_io_mem0_addr; // @[SimTop.scala 20:20]
  wire [63:0] mmio_io_mem0_wdata; // @[SimTop.scala 20:20]
  wire [7:0] mmio_io_mem0_wmask; // @[SimTop.scala 20:20]
  wire  mmio_io_mem0_ok; // @[SimTop.scala 20:20]
  wire [63:0] mmio_io_mem0_rdata; // @[SimTop.scala 20:20]
  wire  mmio_io_mem1_en; // @[SimTop.scala 20:20]
  wire  mmio_io_mem1_op; // @[SimTop.scala 20:20]
  wire [63:0] mmio_io_mem1_addr; // @[SimTop.scala 20:20]
  wire [63:0] mmio_io_mem1_wdata; // @[SimTop.scala 20:20]
  wire [7:0] mmio_io_mem1_wmask; // @[SimTop.scala 20:20]
  wire [63:0] mmio_io_mem1_rdata; // @[SimTop.scala 20:20]
  wire  clintreg_clock; // @[SimTop.scala 21:24]
  wire  clintreg_reset; // @[SimTop.scala 21:24]
  wire  clintreg_io_mem_en; // @[SimTop.scala 21:24]
  wire  clintreg_io_mem_op; // @[SimTop.scala 21:24]
  wire [63:0] clintreg_io_mem_addr; // @[SimTop.scala 21:24]
  wire [63:0] clintreg_io_mem_wdata; // @[SimTop.scala 21:24]
  wire [7:0] clintreg_io_mem_wmask; // @[SimTop.scala 21:24]
  wire [63:0] clintreg_io_mem_rdata; // @[SimTop.scala 21:24]
  Core core ( // @[SimTop.scala 15:20]
    .clock(core_clock),
    .reset(core_reset),
    .io_imem_addr(core_io_imem_addr),
    .io_imem_en(core_io_imem_en),
    .io_imem_data(core_io_imem_data),
    .io_imem_ok(core_io_imem_ok),
    .io_dmem_en(core_io_dmem_en),
    .io_dmem_op(core_io_dmem_op),
    .io_dmem_addr(core_io_dmem_addr),
    .io_dmem_wdata(core_io_dmem_wdata),
    .io_dmem_wmask(core_io_dmem_wmask),
    .io_dmem_ok(core_io_dmem_ok),
    .io_dmem_rdata(core_io_dmem_rdata)
  );
  ICache icache ( // @[SimTop.scala 16:22]
    .clock(icache_clock),
    .reset(icache_reset),
    .io_imem_addr(icache_io_imem_addr),
    .io_imem_en(icache_io_imem_en),
    .io_imem_data(icache_io_imem_data),
    .io_imem_ok(icache_io_imem_ok),
    .io_axi_req(icache_io_axi_req),
    .io_axi_addr(icache_io_axi_addr),
    .io_axi_valid(icache_io_axi_valid),
    .io_axi_data(icache_io_axi_data)
  );
  DCache dcache ( // @[SimTop.scala 17:22]
    .clock(dcache_clock),
    .reset(dcache_reset),
    .io_dmem_en(dcache_io_dmem_en),
    .io_dmem_op(dcache_io_dmem_op),
    .io_dmem_addr(dcache_io_dmem_addr),
    .io_dmem_wdata(dcache_io_dmem_wdata),
    .io_dmem_wmask(dcache_io_dmem_wmask),
    .io_dmem_ok(dcache_io_dmem_ok),
    .io_dmem_rdata(dcache_io_dmem_rdata),
    .io_axi_req(dcache_io_axi_req),
    .io_axi_raddr(dcache_io_axi_raddr),
    .io_axi_rvalid(dcache_io_axi_rvalid),
    .io_axi_rdata(dcache_io_axi_rdata),
    .io_axi_weq(dcache_io_axi_weq),
    .io_axi_waddr(dcache_io_axi_waddr),
    .io_axi_wdata(dcache_io_axi_wdata),
    .io_axi_wdone(dcache_io_axi_wdone)
  );
  AXI axi ( // @[SimTop.scala 18:19]
    .clock(axi_clock),
    .reset(axi_reset),
    .io_out_aw_ready(axi_io_out_aw_ready),
    .io_out_aw_valid(axi_io_out_aw_valid),
    .io_out_aw_bits_addr(axi_io_out_aw_bits_addr),
    .io_out_w_ready(axi_io_out_w_ready),
    .io_out_w_valid(axi_io_out_w_valid),
    .io_out_w_bits_data(axi_io_out_w_bits_data),
    .io_out_w_bits_last(axi_io_out_w_bits_last),
    .io_out_b_ready(axi_io_out_b_ready),
    .io_out_b_valid(axi_io_out_b_valid),
    .io_out_ar_ready(axi_io_out_ar_ready),
    .io_out_ar_valid(axi_io_out_ar_valid),
    .io_out_ar_bits_addr(axi_io_out_ar_bits_addr),
    .io_out_r_ready(axi_io_out_r_ready),
    .io_out_r_valid(axi_io_out_r_valid),
    .io_out_r_bits_data(axi_io_out_r_bits_data),
    .io_out_r_bits_last(axi_io_out_r_bits_last),
    .io_icacheio_req(axi_io_icacheio_req),
    .io_icacheio_addr(axi_io_icacheio_addr),
    .io_icacheio_valid(axi_io_icacheio_valid),
    .io_icacheio_data(axi_io_icacheio_data),
    .io_dcacheio_req(axi_io_dcacheio_req),
    .io_dcacheio_raddr(axi_io_dcacheio_raddr),
    .io_dcacheio_rvalid(axi_io_dcacheio_rvalid),
    .io_dcacheio_rdata(axi_io_dcacheio_rdata),
    .io_dcacheio_weq(axi_io_dcacheio_weq),
    .io_dcacheio_waddr(axi_io_dcacheio_waddr),
    .io_dcacheio_wdata(axi_io_dcacheio_wdata),
    .io_dcacheio_wdone(axi_io_dcacheio_wdone)
  );
  MMIO mmio ( // @[SimTop.scala 20:20]
    .clock(mmio_clock),
    .reset(mmio_reset),
    .io_dmem_en(mmio_io_dmem_en),
    .io_dmem_op(mmio_io_dmem_op),
    .io_dmem_addr(mmio_io_dmem_addr),
    .io_dmem_wdata(mmio_io_dmem_wdata),
    .io_dmem_wmask(mmio_io_dmem_wmask),
    .io_dmem_ok(mmio_io_dmem_ok),
    .io_dmem_rdata(mmio_io_dmem_rdata),
    .io_mem0_en(mmio_io_mem0_en),
    .io_mem0_op(mmio_io_mem0_op),
    .io_mem0_addr(mmio_io_mem0_addr),
    .io_mem0_wdata(mmio_io_mem0_wdata),
    .io_mem0_wmask(mmio_io_mem0_wmask),
    .io_mem0_ok(mmio_io_mem0_ok),
    .io_mem0_rdata(mmio_io_mem0_rdata),
    .io_mem1_en(mmio_io_mem1_en),
    .io_mem1_op(mmio_io_mem1_op),
    .io_mem1_addr(mmio_io_mem1_addr),
    .io_mem1_wdata(mmio_io_mem1_wdata),
    .io_mem1_wmask(mmio_io_mem1_wmask),
    .io_mem1_rdata(mmio_io_mem1_rdata)
  );
  ClintReg clintreg ( // @[SimTop.scala 21:24]
    .clock(clintreg_clock),
    .reset(clintreg_reset),
    .io_mem_en(clintreg_io_mem_en),
    .io_mem_op(clintreg_io_mem_op),
    .io_mem_addr(clintreg_io_mem_addr),
    .io_mem_wdata(clintreg_io_mem_wdata),
    .io_mem_wmask(clintreg_io_mem_wmask),
    .io_mem_rdata(clintreg_io_mem_rdata)
  );
  assign io_uart_out_valid = 1'h0; // @[SimTop.scala 60:21]
  assign io_uart_out_ch = 8'h0; // @[SimTop.scala 61:18]
  assign io_uart_in_valid = 1'h0; // @[SimTop.scala 62:20]
  assign io_memAXI_0_aw_valid = axi_io_out_aw_valid; // @[SimTop.scala 44:17]
  assign io_memAXI_0_aw_bits_len = 8'h1; // @[SimTop.scala 44:17]
  assign io_memAXI_0_aw_bits_size = 3'h3; // @[SimTop.scala 44:17]
  assign io_memAXI_0_aw_bits_burst = 2'h1; // @[SimTop.scala 44:17]
  assign io_memAXI_0_aw_bits_lock = 1'h0; // @[SimTop.scala 44:17]
  assign io_memAXI_0_aw_bits_cache = 4'h2; // @[SimTop.scala 44:17]
  assign io_memAXI_0_aw_bits_qos = 4'h0; // @[SimTop.scala 44:17]
  assign io_memAXI_0_aw_bits_addr = axi_io_out_aw_bits_addr; // @[SimTop.scala 44:17]
  assign io_memAXI_0_aw_bits_prot = 3'h0; // @[SimTop.scala 44:17]
  assign io_memAXI_0_aw_bits_id = 4'h0; // @[SimTop.scala 44:17]
  assign io_memAXI_0_aw_bits_user = 4'h0; // @[SimTop.scala 44:17]
  assign io_memAXI_0_w_valid = axi_io_out_w_valid; // @[SimTop.scala 45:17]
  assign io_memAXI_0_w_bits_data = axi_io_out_w_bits_data; // @[SimTop.scala 45:17]
  assign io_memAXI_0_w_bits_strb = 8'hff; // @[SimTop.scala 45:17]
  assign io_memAXI_0_w_bits_last = axi_io_out_w_bits_last; // @[SimTop.scala 45:17]
  assign io_memAXI_0_b_ready = axi_io_out_b_ready; // @[SimTop.scala 46:17]
  assign io_memAXI_0_ar_valid = axi_io_out_ar_valid; // @[SimTop.scala 42:17]
  assign io_memAXI_0_ar_bits_len = 8'h1; // @[SimTop.scala 42:17]
  assign io_memAXI_0_ar_bits_size = 3'h3; // @[SimTop.scala 42:17]
  assign io_memAXI_0_ar_bits_burst = 2'h1; // @[SimTop.scala 42:17]
  assign io_memAXI_0_ar_bits_lock = 1'h0; // @[SimTop.scala 42:17]
  assign io_memAXI_0_ar_bits_cache = 4'h2; // @[SimTop.scala 42:17]
  assign io_memAXI_0_ar_bits_qos = 4'h0; // @[SimTop.scala 42:17]
  assign io_memAXI_0_ar_bits_addr = axi_io_out_ar_bits_addr; // @[SimTop.scala 42:17]
  assign io_memAXI_0_ar_bits_prot = 3'h0; // @[SimTop.scala 42:17]
  assign io_memAXI_0_ar_bits_id = 4'h0; // @[SimTop.scala 42:17]
  assign io_memAXI_0_ar_bits_user = 4'h0; // @[SimTop.scala 42:17]
  assign io_memAXI_0_r_ready = axi_io_out_r_ready; // @[SimTop.scala 43:17]
  assign core_clock = clock;
  assign core_reset = reset;
  assign core_io_imem_data = icache_io_imem_data; // @[SimTop.scala 24:17]
  assign core_io_imem_ok = icache_io_imem_ok; // @[SimTop.scala 24:17]
  assign core_io_dmem_ok = mmio_io_dmem_ok; // @[SimTop.scala 25:17]
  assign core_io_dmem_rdata = mmio_io_dmem_rdata; // @[SimTop.scala 25:17]
  assign icache_clock = clock;
  assign icache_reset = reset;
  assign icache_io_imem_addr = core_io_imem_addr; // @[SimTop.scala 24:17]
  assign icache_io_imem_en = core_io_imem_en; // @[SimTop.scala 24:17]
  assign icache_io_axi_valid = axi_io_icacheio_valid; // @[SimTop.scala 39:17]
  assign icache_io_axi_data = axi_io_icacheio_data; // @[SimTop.scala 39:17]
  assign dcache_clock = clock;
  assign dcache_reset = reset;
  assign dcache_io_dmem_en = mmio_io_mem0_en; // @[SimTop.scala 26:16]
  assign dcache_io_dmem_op = mmio_io_mem0_op; // @[SimTop.scala 26:16]
  assign dcache_io_dmem_addr = mmio_io_mem0_addr; // @[SimTop.scala 26:16]
  assign dcache_io_dmem_wdata = mmio_io_mem0_wdata; // @[SimTop.scala 26:16]
  assign dcache_io_dmem_wmask = mmio_io_mem0_wmask; // @[SimTop.scala 26:16]
  assign dcache_io_axi_rvalid = axi_io_dcacheio_rvalid; // @[SimTop.scala 40:17]
  assign dcache_io_axi_rdata = axi_io_dcacheio_rdata; // @[SimTop.scala 40:17]
  assign dcache_io_axi_wdone = axi_io_dcacheio_wdone; // @[SimTop.scala 40:17]
  assign axi_clock = clock;
  assign axi_reset = reset;
  assign axi_io_out_aw_ready = io_memAXI_0_aw_ready; // @[SimTop.scala 44:17]
  assign axi_io_out_w_ready = io_memAXI_0_w_ready; // @[SimTop.scala 45:17]
  assign axi_io_out_b_valid = io_memAXI_0_b_valid; // @[SimTop.scala 46:17]
  assign axi_io_out_ar_ready = io_memAXI_0_ar_ready; // @[SimTop.scala 42:17]
  assign axi_io_out_r_valid = io_memAXI_0_r_valid; // @[SimTop.scala 43:17]
  assign axi_io_out_r_bits_data = io_memAXI_0_r_bits_data; // @[SimTop.scala 43:17]
  assign axi_io_out_r_bits_last = io_memAXI_0_r_bits_last; // @[SimTop.scala 43:17]
  assign axi_io_icacheio_req = icache_io_axi_req; // @[SimTop.scala 39:17]
  assign axi_io_icacheio_addr = icache_io_axi_addr; // @[SimTop.scala 39:17]
  assign axi_io_dcacheio_req = dcache_io_axi_req; // @[SimTop.scala 40:17]
  assign axi_io_dcacheio_raddr = dcache_io_axi_raddr; // @[SimTop.scala 40:17]
  assign axi_io_dcacheio_weq = dcache_io_axi_weq; // @[SimTop.scala 40:17]
  assign axi_io_dcacheio_waddr = dcache_io_axi_waddr; // @[SimTop.scala 40:17]
  assign axi_io_dcacheio_wdata = dcache_io_axi_wdata; // @[SimTop.scala 40:17]
  assign mmio_clock = clock;
  assign mmio_reset = reset;
  assign mmio_io_dmem_en = core_io_dmem_en; // @[SimTop.scala 25:17]
  assign mmio_io_dmem_op = core_io_dmem_op; // @[SimTop.scala 25:17]
  assign mmio_io_dmem_addr = core_io_dmem_addr; // @[SimTop.scala 25:17]
  assign mmio_io_dmem_wdata = core_io_dmem_wdata; // @[SimTop.scala 25:17]
  assign mmio_io_dmem_wmask = core_io_dmem_wmask; // @[SimTop.scala 25:17]
  assign mmio_io_mem0_ok = dcache_io_dmem_ok; // @[SimTop.scala 26:16]
  assign mmio_io_mem0_rdata = dcache_io_dmem_rdata; // @[SimTop.scala 26:16]
  assign mmio_io_mem1_rdata = clintreg_io_mem_rdata; // @[SimTop.scala 27:16]
  assign clintreg_clock = clock;
  assign clintreg_reset = reset;
  assign clintreg_io_mem_en = mmio_io_mem1_en; // @[SimTop.scala 27:16]
  assign clintreg_io_mem_op = mmio_io_mem1_op; // @[SimTop.scala 27:16]
  assign clintreg_io_mem_addr = mmio_io_mem1_addr; // @[SimTop.scala 27:16]
  assign clintreg_io_mem_wdata = mmio_io_mem1_wdata; // @[SimTop.scala 27:16]
  assign clintreg_io_mem_wmask = mmio_io_mem1_wmask; // @[SimTop.scala 27:16]
endmodule
