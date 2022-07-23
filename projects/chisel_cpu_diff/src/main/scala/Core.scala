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
    // val imem = new ImemIO
    // val dmem = new DmemIO
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
  ifu.io.pc       := idreg.io.out.pc
  //idreg
  idreg.io.imem <> io.imem
  idreg.io.in.pc  := ifu.io.next_pc
  //idu
  idu.io.pc       := idreg.io.out.pc
  idu.io.inst     := idreg.io.inst
  idu.io.rs1_data := rfu.io.rs1_data
  idu.io.rs2_data := rfu.io.rs2_data
  idu.io.mtvec    := csru.io.mtvec
  idu.io.mepc     := csru.io.mepc
  //exereg
  exereg.io.in.pc       := idreg.io.out.pc
  exereg.io.in.inst     := idreg.io.inst
  exereg.io.in.rd_en    := idu.io.rd_en
  exereg.io.in.rd_addr  := idu.io.rd_addr
  exereg.io.in.imm      := idu.io.imm
  exereg.io.in.op1      := idu.io.op1
  exereg.io.in.op2      := idu.io.op2
  exereg.io.in.rs1_addr := idu.io.rs1_addr
  exereg.io.in.fu_code  := idu.io.decode_info.fu_code
  exereg.io.in.alu_code := idu.io.decode_info.alu_code
  exereg.io.in.bu_code  := idu.io.decode_info.bu_code
  exereg.io.in.mdu_code := idu.io.decode_info.mdu_code
  exereg.io.in.lu_code  := idu.io.decode_info.lu_code
  exereg.io.in.su_code  := idu.io.decode_info.su_code
  exereg.io.in.csru_code    := idu.io.decode_info.csru_code
  exereg.io.in.putch    := idu.io.putch
  //ieu
  ieu.io.decode_info.fu_code  := exereg.io.out.fu_code
  ieu.io.decode_info.alu_code := exereg.io.out.alu_code
  ieu.io.decode_info.bu_code  := exereg.io.out.bu_code
  ieu.io.decode_info.mdu_code := exereg.io.out.mdu_code
  ieu.io.decode_info.lu_code  := exereg.io.out.lu_code
  ieu.io.decode_info.su_code  := exereg.io.out.su_code
  ieu.io.decode_info.csru_code := exereg.io.out.csru_code
  ieu.io.op1 := exereg.io.out.op1
  ieu.io.op2 := exereg.io.out.op2
  ieu.io.pc  := exereg.io.out.pc
  ieu.io.imm := exereg.io.out.imm
  ieu.io.rs1_addr := exereg.io.out.rs1_addr
  ieu.io.csr_rdata := csru.io.rdata
  //memreg
  memreg.io.in.pc       := exereg.io.out.pc
  memreg.io.in.inst     := exereg.io.out.inst
  memreg.io.in.rd_en    := exereg.io.out.rd_en
  memreg.io.in.rd_addr  := exereg.io.out.rd_addr
  memreg.io.in.imm      := exereg.io.out.imm
  memreg.io.in.op1      := exereg.io.out.op1
  memreg.io.in.op2      := exereg.io.out.op2
  memreg.io.in.fu_code  := exereg.io.out.fu_code
  memreg.io.in.alu_code := exereg.io.out.alu_code
  memreg.io.in.bu_code  := exereg.io.out.bu_code
  memreg.io.in.mdu_code := exereg.io.out.mdu_code
  memreg.io.in.lu_code  := exereg.io.out.lu_code
  memreg.io.in.su_code  := exereg.io.out.su_code
  memreg.io.in.csru_code := exereg.io.out.csru_code

  memreg.io.in.alu_out  := ieu.io.alu_out
  memreg.io.in.bu_out   := ieu.io.bu_out
  memreg.io.in.mdu_out  := ieu.io.mdu_out
  memreg.io.in.csru_out := ieu.io.csru_out

  memreg.io.in.putch      := exereg.io.out.putch
  memreg.io.in.csr_wen    := ieu.io.csr_wen
  memreg.io.in.csr_waddr  := ieu.io.csr_waddr
  memreg.io.in.csr_wdata  := ieu.io.csr_wdata
  //preamu
  preamu.io.lu_code := memreg.io.out.lu_code
  preamu.io.su_code := memreg.io.out.su_code
  preamu.io.op1     := memreg.io.out.op1
  preamu.io.op2     := memreg.io.out.op2
  preamu.io.imm     := memreg.io.out.imm
  //dmem
  val dmem_en = preamu.io.ren || preamu.io.wen
  val dmem_op = preamu.io.wen   // 按理说ren和wen不会同时为true
  val dmem_addr = Mux(dmem_op, preamu.io.waddr, preamu.io.raddr)
  io.dmem.en    := dmem_en & memreg.io.out.valid //必须是有效的流水线指令才读写
  io.dmem.op    := dmem_op
  io.dmem.addr  := dmem_addr
  io.dmem.wdata := preamu.io.wdata
  io.dmem.wmask := preamu.io.wmask
  // io.dmem.ren   := preamu.io.ren & memreg.io.pr.valid_out //必须是有效的流水线指令才读取
  // io.dmem.raddr := preamu.io.raddr
  // io.dmem.wen   := preamu.io.wen & memreg.io.pr.valid_out //必须是有效的流水线指令才写入
  // io.dmem.waddr := preamu.io.waddr
  // io.dmem.wdata := preamu.io.wdata
  // io.dmem.wmask := preamu.io.wmask
  //wbreg
  wbreg.io.in.pc        := memreg.io.out.pc
  wbreg.io.in.inst      := memreg.io.out.inst
  wbreg.io.in.rd_en     := memreg.io.out.rd_en
  wbreg.io.in.rd_addr   := memreg.io.out.rd_addr
  wbreg.io.in.alu_out   := memreg.io.out.alu_out
  wbreg.io.in.bu_out    := memreg.io.out.bu_out
  wbreg.io.in.mdu_out   := memreg.io.out.mdu_out
  wbreg.io.in.csru_out  := memreg.io.out.csru_out
  wbreg.io.in.fu_code   := memreg.io.out.fu_code
  wbreg.io.in.lu_code   := memreg.io.out.lu_code
  wbreg.io.in.csru_code := memreg.io.out.csru_code
  
  wbreg.io.in.lu_shift  := preamu.io.lu_shift

  wbreg.io.in.putch     := memreg.io.out.putch
  wbreg.io.in.csr_wen   := memreg.io.out.csr_wen
  wbreg.io.in.csr_waddr := memreg.io.out.csr_waddr
  wbreg.io.in.csr_wdata := memreg.io.out.csr_wdata
  //amu
  amu.io.lu_code  := wbreg.io.out.lu_code
  amu.io.lu_shift := wbreg.io.out.lu_shift
  amu.io.rdata    := io.dmem.rdata
  //wbu
  wbu.io.fu_code  := wbreg.io.out.fu_code
  wbu.io.alu_out  := wbreg.io.out.alu_out
  wbu.io.bu_out   := wbreg.io.out.bu_out
  wbu.io.mdu_out  := wbreg.io.out.mdu_out
  wbu.io.csru_out := wbreg.io.out.csru_out
  wbu.io.lu_out   := amu.io.lu_out

  //rfu
  // rfu.io.rs1_en   := idu.io.rs1_en
  // rfu.io.rs2_en   := idu.io.rs2_en
  rfu.io.rs1_addr := idu.io.rs1_addr
  rfu.io.rs2_addr := idu.io.rs2_addr

  rfu.io.rd_addr  := wbreg.io.out.rd_addr
  // rfu.io.rd_data  := Mux(wbreg.io.inst_out === "hff86b683".U, csru.io.mcycle, wbu.io.out)
  rfu.io.rd_data  := wbu.io.out

  //csru
  csru.io.raddr     := ieu.io.csr_raddr
  csru.io.waddr     := wbreg.io.out.csr_waddr
  csru.io.wdata     := wbreg.io.out.csr_wdata
  csru.io.csru_code := wbreg.io.out.csru_code
  csru.io.pc        := wbreg.io.out.pc

  
  /*********************** 相关性冲突 ***********************/
  rfconflict.io.rs_valid   := idreg.io.out.valid
  rfconflict.io.rs1_en     := idu.io.rs1_en
  rfconflict.io.rs2_en     := idu.io.rs2_en
  rfconflict.io.rs1_addr   := idu.io.rs1_addr
  rfconflict.io.rs2_addr   := idu.io.rs2_addr
  rfconflict.io.rd1_valid  := exereg.io.out.valid
  rfconflict.io.rd1_en     := exereg.io.out.rd_en
  rfconflict.io.rd1_addr   := exereg.io.out.rd_addr
  rfconflict.io.rd2_valid  := memreg.io.out.valid
  rfconflict.io.rd2_en     := memreg.io.out.rd_en
  rfconflict.io.rd2_addr   := memreg.io.out.rd_addr
  rfconflict.io.rd3_valid  := wbreg.io.out.valid
  rfconflict.io.rd3_en     := wbreg.io.out.rd_en
  rfconflict.io.rd3_addr   := wbreg.io.out.rd_addr

  //--------------------流水线控制------------------
  val imem_not_ok = !io.imem.ok
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
  
  idreg.io.in.valid  := ifu.io.valid
  exereg.io.in.valid := idreg.io.out.valid && (!stall) 
  memreg.io.in.valid := exereg.io.out.valid
  wbreg.io.in.valid  := memreg.io.out.valid
  val commit_valid = wbreg.io.out.valid && !stall_all
  
  idreg.io.en  := !stall && !stall_all
  exereg.io.en := !stall_all
  memreg.io.en := !stall_all
  wbreg.io.en  := !stall_all

  // 改变计算机状态的单元 
  //ifu.io.en     := stall || stall_all
  rfu.io.rd_en  := wbreg.io.out.rd_en && commit_valid  //必须是有效的流水线指令才写入
  csru.io.wen   := wbreg.io.out.csr_wen && commit_valid
  csru.io.csru_code_valid := commit_valid

  
  // putch
  val regfile_a0 = WireInit(0.U(64.W))
  BoringUtils.addSink(regfile_a0, "rf_a0")
  when(wbreg.io.out.putch && commit_valid) {printf("%c",regfile_a0)}


  /* ----- Debug ------------------------------ */
  // io.dmem.en 
  // io.dmem.op   
  // io.dmem.addr
  // io.dmem.wdata
  // io.dmem.wmask 
  // when(io.dmem.en && io.dmem.addr >= "h02000000".U && io.dmem.addr < "h0200c000".U){
  //   printf("pc=%x addr=%x op=%d \n", memreg.io.out.pc, io.dmem.addr, io.dmem.op)
  // }

  /* ----- Difftest ------------------------------ */
  // 注意下面有多个地方要该valid，例如dt_ic和dt_te
  // skip inst
  val inst = wbreg.io.out.inst
  val skip_putch = wbreg.io.out.inst === PUTCH
  val read_mcycle = (inst & "hfff0307f".U) === "hb0002073".U
  val read_mtime = inst === "hff86b683".U
  val write_mtimecmp = inst === "h00d7b023".U
  
  val dt_ic = Module(new DifftestInstrCommit)
  dt_ic.io.clock    := clock
  dt_ic.io.coreid   := 0.U
  dt_ic.io.index    := 0.U
  dt_ic.io.valid    := RegNext(commit_valid)
  dt_ic.io.pc       := RegNext(wbreg.io.out.pc)
  dt_ic.io.instr    := RegNext(wbreg.io.out.inst)
  dt_ic.io.special  := 0.U
  dt_ic.io.skip     := RegNext(skip_putch || read_mcycle || read_mtime || write_mtimecmp || inst === "h0007b703".U)
  dt_ic.io.isRVC    := false.B
  dt_ic.io.scFailed := false.B
  dt_ic.io.wen      := RegNext(wbreg.io.out.rd_en)
  dt_ic.io.wdata    := RegNext(wbu.io.out)
  dt_ic.io.wdest    := RegNext(wbreg.io.out.rd_addr)

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
  dt_te.io.valid    := (wbreg.io.out.inst === "h0000006b".U) && commit_valid
  dt_te.io.code     := rf_a0(2, 0)
  dt_te.io.pc       := wbreg.io.out.pc
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
