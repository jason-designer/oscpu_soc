import chisel3._
import chisel3.util._
import difftest._


class SimTop extends Module {
  val io = IO(new Bundle {
    val logCtrl = new LogCtrlIO
    val perfInfo = new PerfInfoIO
    val uart = new UARTIO

    val memAXI_0 = new AxiIO
  })

  val core = Module(new Core)
  val icache = Module(new ICache)
  val dcache = Module(new DCache)
  val axi = Module(new AXI)

  val immio = Module(new IMMIO)
  val icachebypass = Module(new ICacheBypass)
  val dmmio = Module(new DMMIO)
  val clintreg = Module(new ClintReg)
  val dcachebypass = Module(new DCacheBypass)

  // val mem = Module(new RamSyn)
  core.io.imem  <> immio.io.imem
  immio.io.mem0 <> icache.io.imem
  immio.io.mem1 <> icachebypass.io.imem

  core.io.dmem  <> dmmio.io.dmem
  dmmio.io.mem0 <> dcache.io.dmem
  dmmio.io.mem1 <> clintreg.io.mem
  dmmio.io.mem2 <> dcachebypass.io.dmem

  core.io.set_mtip    := clintreg.io.set_mtip
  core.io.clear_mtip  := clintreg.io.clear_mtip
  // dcache.io.dmem.en := true.B
  // dcache.io.dmem.op := false.B
  // dcache.io.dmem.addr := "h80000000".U
  // dcache.io.dmem.wdata := 0.U
  // dcache.io.dmem.wmask := 0.U

  icache.io.axi <> axi.io.icacheio
  dcache.io.axi <> axi.io.dcacheio
  icachebypass.io.axi <> axi.io.icacheBypassIO
  dcachebypass.io.axi <> axi.io.dcacheBypassIO

  //
  // axi.io.icacheBypassIO.req := false.B
  // axi.io.icacheBypassIO.addr := 0.U
  // axi.io.dcacheBypassIO.req := false.B
  // axi.io.dcacheBypassIO.raddr := 0.U
  // axi.io.dcacheBypassIO.weq := false.B
  // axi.io.dcacheBypassIO.waddr := 0.U
  // axi.io.dcacheBypassIO.wdata := 0.U
  // axi.io.dcacheBypassIO.wmask := 0.U
  //


  axi.io.out.ar <> io.memAXI_0.ar
  axi.io.out.r  <> io.memAXI_0.r
  axi.io.out.aw <> io.memAXI_0.aw
  axi.io.out.w  <> io.memAXI_0.w
  axi.io.out.b  <> io.memAXI_0.b 

  // mem.io.imem <> core.io.imem
  // mem.io.dmem <> core.io.dmem
  // mem.io.imem.en    := false.B
  // mem.io.imem.addr  := 0.U





  // val mem = Module(new Ram2r1w)
  // mem.io.imem <> core.io.imem
  // mem.io.dmem <> core.io.dmem
  io.uart.out.valid := false.B
  io.uart.out.ch := 0.U
  io.uart.in.valid := false.B
}


class RamSyn extends Module{
  val io = IO(new Bundle{
    val imem = Flipped(new ImemIO)
    val dmem = Flipped(new DmemIO)
  })
    val wm    = io.dmem.wmask
    val wmask = Cat(Fill(8,wm(7)),Fill(8,wm(6)),Fill(8,wm(5)),Fill(8,wm(4)),Fill(8,wm(3)),Fill(8,wm(2)),Fill(8,wm(1)),Fill(8,wm(0)))
    val addr  = MuxLookup(Cat(io.dmem.ren,io.dmem.wen), 0.U, Array(
        "b01".U -> io.dmem.waddr,                   
        "b10".U -> io.dmem.raddr,                    
        "b00".U -> 0.U,   
        "b11".U -> 0.U,                       
    ))

    val mem = Module(new Ram2r1w)
    mem.io.imem.en    := RegNext(io.imem.en)
    mem.io.imem.addr  := RegNext(io.imem.addr)
    io.imem.data      := mem.io.imem.rdata

    mem.io.dmem.en    := RegNext(io.dmem.ren || io.dmem.wen)
    mem.io.dmem.addr  := RegNext(addr)
    io.dmem.rdata     := mem.io.dmem.rdata 

    mem.io.dmem.wdata := RegNext(io.dmem.wdata)
    mem.io.dmem.wmask := RegNext(wmask)
    mem.io.dmem.wen   := RegNext(io.dmem.wen)
}

