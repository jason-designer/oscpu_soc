import chisel3._
import chisel3.util.experimental._
import difftest._
import Instructions._

class ImemIO extends Bundle{
  val en = Output(Bool())
  val addr = Output(UInt(64.W))
  val data = Input(UInt(32.W))
}

class DmemIO extends Bundle{
  val ren   = Output(Bool())
  val raddr = Output(UInt(64.W))
  val rdata = Input(UInt(64.W))
  val wen   = Output(Bool())
  val waddr = Output(UInt(64.W))
  val wdata = Output(UInt(64.W))
  val wmask = Output(UInt(8.W))
}

class Core extends Module {
  val io = IO(new Bundle {
    val imem = Flipped(new ICacheIO)
    val dmem = Flipped(new DCacheIO)
  })
  // 流水线模块
  val ifu     = Module(new IFetch)
  val idu     = Module(new Decode)
  val ieu     = Module(new Execution)
  val rfu     = Module(new RegFile)
  val csru    = Module(new Csr)
  val preamu  = Module(new PreAccessMemory)
  val amu     = Module(new AccessMemory)
  val wbu     = Module(new WriteBack)

  val rfconflict  = Module(new RegfileConflict)

  val idreg   = Module(new IDReg)
  val exereg  = Module(new ExeReg)
  val memreg  = Module(new MemReg)
  val wbreg   = Module(new WBReg)
  //ifu
  ifu.io.jump_en  := idu.io.jump_en
  ifu.io.jump_pc  := idu.io.jump_pc
  ifu.io.pc       := idreg.io.pc_out
  //idreg
  io.imem.en          := idreg.io.imem.en
  io.imem.addr        := idreg.io.imem.addr
  idreg.io.imem.data  := io.imem.data

  idreg.io.pc_in  := ifu.io.next_pc
  //idu
  idu.io.pc       := idreg.io.pc_out
  idu.io.inst     := idreg.io.inst_out
  idu.io.rs1_data := rfu.io.rs1_data
  idu.io.rs2_data := rfu.io.rs2_data
  idu.io.mtvec    := csru.io.mtvec
  idu.io.mepc     := csru.io.mepc
  //exereg
  exereg.io.pc_in       := idreg.io.pc_out
  exereg.io.inst_in     := idreg.io.inst_out
  exereg.io.rd_en_in    := idu.io.rd_en
  exereg.io.rd_addr_in  := idu.io.rd_addr
  exereg.io.imm_in      := idu.io.imm
  exereg.io.op1_in      := idu.io.op1
  exereg.io.op2_in      := idu.io.op2
  exereg.io.rs1_addr_in := idu.io.rs1_addr
  exereg.io.decode_info_in <> idu.io.decode_info
  exereg.io.putch_in    := idu.io.putch
  //ieu
  ieu.io.decode_info <> exereg.io.decode_info_out
  ieu.io.op1 := exereg.io.op1_out
  ieu.io.op2 := exereg.io.op2_out
  ieu.io.pc  := exereg.io.pc_out
  ieu.io.imm := exereg.io.imm_out
  ieu.io.rs1_addr := exereg.io.rs1_addr_out

  ieu.io.csr_rdata := csru.io.rdata
  //memreg
  memreg.io.pc_in       := exereg.io.pc_out
  memreg.io.inst_in     := exereg.io.inst_out
  memreg.io.rd_en_in    := exereg.io.rd_en_out
  memreg.io.rd_addr_in  := exereg.io.rd_addr_out
  memreg.io.imm_in      := exereg.io.imm_out
  memreg.io.op1_in      := exereg.io.op1_out
  memreg.io.op2_in      := exereg.io.op2_out
  memreg.io.decode_info_in <> exereg.io.decode_info_out

  memreg.io.alu_out_in  := ieu.io.alu_out
  memreg.io.bu_out_in   := ieu.io.bu_out
  memreg.io.mdu_out_in  := ieu.io.mdu_out
  memreg.io.csru_out_in := ieu.io.csru_out

  memreg.io.putch_in      := exereg.io.putch_out
  memreg.io.csr_wen_in    := ieu.io.csr_wen
  memreg.io.csr_waddr_in  := ieu.io.csr_waddr
  memreg.io.csr_wdata_in  := ieu.io.csr_wdata
  //preamu
  preamu.io.lu_code := memreg.io.decode_info_out.lu_code
  preamu.io.su_code := memreg.io.decode_info_out.su_code
  preamu.io.op1     := memreg.io.op1_out
  preamu.io.op2     := memreg.io.op2_out
  preamu.io.imm     := memreg.io.imm_out
  //dmem
  val dmem_en = preamu.io.ren || preamu.io.wen
  val dmem_op = preamu.io.wen   // 按理说ren和wen不会同时为true
  val dmem_addr = Mux(dmem_op, preamu.io.waddr, preamu.io.raddr)
  io.dmem.en    := dmem_en & memreg.io.pr.valid_out //必须是有效的流水线指令才读写
  io.dmem.op    := dmem_op
  io.dmem.addr  := dmem_addr
  io.dmem.wdata := preamu.io.wdata
  io.dmem.wmask := preamu.io.wmask
  //wbreg
  wbreg.io.pc_in        := memreg.io.pc_out
  wbreg.io.inst_in      := memreg.io.inst_out
  wbreg.io.rd_en_in     := memreg.io.rd_en_out
  wbreg.io.rd_addr_in   := memreg.io.rd_addr_out
  wbreg.io.alu_out_in   := memreg.io.alu_out_out
  wbreg.io.bu_out_in    := memreg.io.bu_out_out
  wbreg.io.mdu_out_in   := memreg.io.mdu_out_out
  wbreg.io.csru_out_in  := memreg.io.csru_out_out
  wbreg.io.fu_code_in   := memreg.io.decode_info_out.fu_code
  wbreg.io.lu_code_in   := memreg.io.decode_info_out.lu_code
  wbreg.io.csru_code_in := memreg.io.decode_info_out.csru_code
  
  wbreg.io.lu_shift_in := preamu.io.lu_shift

  wbreg.io.putch_in     := memreg.io.putch_out
  wbreg.io.csr_wen_in   := memreg.io.csr_wen_out
  wbreg.io.csr_waddr_in := memreg.io.csr_waddr_out
  wbreg.io.csr_wdata_in := memreg.io.csr_wdata_out
  //amu
  amu.io.lu_code  := wbreg.io.lu_code_out
  amu.io.lu_shift := wbreg.io.lu_shift_out
  amu.io.rdata    := io.dmem.rdata
  //wbu
  wbu.io.fu_code  := wbreg.io.fu_code_out
  wbu.io.alu_out  := wbreg.io.alu_out_out
  wbu.io.bu_out   := wbreg.io.bu_out_out
  wbu.io.mdu_out  := wbreg.io.mdu_out_out
  wbu.io.csru_out := wbreg.io.csru_out_out
  wbu.io.lu_out   := amu.io.lu_out

  //rfu
  rfu.io.rs1_addr := idu.io.rs1_addr
  rfu.io.rs2_addr := idu.io.rs2_addr

  rfu.io.rd_addr  := wbreg.io.rd_addr_out
  // rfu.io.rd_data  := Mux(wbreg.io.inst_out === "hff86b683".U, csru.io.mcycle, wbu.io.out)
  rfu.io.rd_data  := wbu.io.out

  //csru
  csru.io.raddr     := ieu.io.csr_raddr
  csru.io.waddr     := wbreg.io.csr_waddr_out
  csru.io.wdata     := wbreg.io.csr_wdata_out
  csru.io.csru_code := wbreg.io.csru_code_out
  csru.io.pc        := wbreg.io.pc_out

  
  /*********************** 相关性冲突 ***********************/
  rfconflict.io.rs_valid    := idreg.io.pr.valid_out
  rfconflict.io.rs1_en     := idu.io.rs1_en
  rfconflict.io.rs2_en     := idu.io.rs2_en
  rfconflict.io.rs1_addr   := idu.io.rs1_addr
  rfconflict.io.rs2_addr   := idu.io.rs2_addr
  rfconflict.io.rd1_valid  := exereg.io.pr.valid_out
  rfconflict.io.rd1_en     := exereg.io.rd_en_out
  rfconflict.io.rd1_addr   := exereg.io.rd_addr_out
  rfconflict.io.rd2_valid  := memreg.io.pr.valid_out
  rfconflict.io.rd2_en     := memreg.io.rd_en_out
  rfconflict.io.rd2_addr   := memreg.io.rd_addr_out
  rfconflict.io.rd3_valid  := wbreg.io.pr.valid_out
  rfconflict.io.rd3_en     := wbreg.io.rd_en_out
  rfconflict.io.rd3_addr   := wbreg.io.rd_addr_out

  //--------------------流水线控制------------------
  val imem_not_ok = !io.imem.data_ok
  val dmem_not_ok = !io.dmem.ok

  val stall = rfconflict.io.conflict || imem_not_ok  
  //熄火的时候（暂停idreg以及自前的流水线）: 
  //          1.exereg的valid要为false.B
  //          2.ifu维持原值
  //          3.idreg维持原值(en为false)
  //          其实2和3只要实现一个就能保证功能正确，这里两个都实现了，后期看情况再修改.
  val stall_all = dmem_not_ok
  //全部熄火（这时候要等待dmem加载完成,暂停整个流水线）:
  //  1.全部流水线寄存器都保持原值
  //  2.wbreg的输出valid要为false.B，也就是rfu.io.rf_en要为false
  
  idreg.io.pr.valid_in  := ifu.io.valid
  exereg.io.pr.valid_in := idreg.io.pr.valid_out && (!stall) 
  memreg.io.pr.valid_in := exereg.io.pr.valid_out
  wbreg.io.pr.valid_in  := memreg.io.pr.valid_out
  val commit_valid = wbreg.io.pr.valid_out && !stall_all
  
  idreg.io.pr.en  := !stall && !stall_all
  exereg.io.pr.en := !stall_all
  memreg.io.pr.en := !stall_all
  wbreg.io.pr.en  := !stall_all

  // 改变计算机状态的单元 
  ifu.io.en     := stall || stall_all
  rfu.io.rd_en  := wbreg.io.rd_en_out && commit_valid  //必须是有效的流水线指令才写入
  csru.io.wen   := wbreg.io.csr_wen_out && commit_valid
  csru.io.csru_code_valid := commit_valid

  
  // putch
  val regfile_a0 = WireInit(0.U(64.W))
  BoringUtils.addSink(regfile_a0, "rf_a0")
  when(wbreg.io.putch_out && commit_valid) {printf("%c",regfile_a0)}

  /* ----- Difftest ------------------------------ */
  // 注意下面有多个地方要该valid，例如dt_ic和dt_te
  // skip inst
  val inst = wbreg.io.inst_out
  val read_mcycle = (inst & "hfff0307f".U) === "hb0002073".U
  val read_mtime = inst === "hff86b683".U
  val write_mtimecmp = inst === "h00d7b023".U
  
  val dt_ic = Module(new DifftestInstrCommit)
  dt_ic.io.clock    := clock
  dt_ic.io.coreid   := 0.U
  dt_ic.io.index    := 0.U
  dt_ic.io.valid    := RegNext(commit_valid)
  dt_ic.io.pc       := RegNext(wbreg.io.pc_out)
  dt_ic.io.instr    := RegNext(wbreg.io.inst_out)
  dt_ic.io.special  := 0.U
  dt_ic.io.skip     := RegNext(wbreg.io.inst_out === PUTCH || read_mcycle || read_mtime || write_mtimecmp)
  dt_ic.io.isRVC    := false.B
  dt_ic.io.scFailed := false.B
  dt_ic.io.wen      := RegNext(wbreg.io.rd_en_out)
  dt_ic.io.wdata    := RegNext(wbu.io.out)
  dt_ic.io.wdest    := RegNext(wbreg.io.rd_addr_out)

  val dt_ae = Module(new DifftestArchEvent)
  dt_ae.io.clock        := clock
  dt_ae.io.coreid       := 0.U
  dt_ae.io.intrNO       := 0.U
  dt_ae.io.cause        := 0.U
  dt_ae.io.exceptionPC  := 0.U

  val cycle_cnt = RegInit(0.U(64.W))
  val instr_cnt = RegInit(0.U(64.W))

  cycle_cnt := cycle_cnt + 1.U
  instr_cnt := Mux(commit_valid, instr_cnt + 1.U, instr_cnt)

  val rf_a0 = WireInit(0.U(64.W))
  BoringUtils.addSink(rf_a0, "rf_a0")

  val dt_te = Module(new DifftestTrapEvent)
  dt_te.io.clock    := clock
  dt_te.io.coreid   := 0.U
  dt_te.io.valid    := (wbreg.io.inst_out === "h0000006b".U) && commit_valid
  dt_te.io.code     := rf_a0(2, 0)
  dt_te.io.pc       := wbreg.io.pc_out
  dt_te.io.cycleCnt := cycle_cnt
  dt_te.io.instrCnt := instr_cnt

  // val dt_cs = Module(new DifftestCSRState)
  // dt_cs.io.clock          := clock
  // dt_cs.io.coreid         := 0.U
  // dt_cs.io.priviledgeMode := 3.U  // Machine mode
  // dt_cs.io.mstatus        := 0.U
  // dt_cs.io.sstatus        := 0.U
  // dt_cs.io.mepc           := 0.U
  // dt_cs.io.sepc           := 0.U
  // dt_cs.io.mtval          := 0.U
  // dt_cs.io.stval          := 0.U
  // dt_cs.io.mtvec          := 0.U
  // dt_cs.io.stvec          := 0.U
  // dt_cs.io.mcause         := 0.U
  // dt_cs.io.scause         := 0.U
  // dt_cs.io.satp           := 0.U
  // dt_cs.io.mip            := 0.U
  // dt_cs.io.mie            := 0.U
  // dt_cs.io.mscratch       := 0.U
  // dt_cs.io.sscratch       := 0.U
  // dt_cs.io.mideleg        := 0.U
  // dt_cs.io.medeleg        := 0.U
}
