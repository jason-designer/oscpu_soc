// package oscpu
import chisel3._
import chisel3.util._
// import difftest._


class SimTop extends Module{
  val io = IO(new Bundle {
    // val logCtrl = new LogCtrlIO
    // val perfInfo = new PerfInfoIO
    // val uart = new UARTIO
    val interrupt = Input(Bool())
    // val memAXI_0 = new AxiIO
    val master = new SocAXI4IO
    val slave = Flipped(new SocAXI4IO)
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

  core.io.imem  <> immio.io.imem
  immio.io.mem0 <> icache.io.imem
  immio.io.mem1 <> icachebypass.io.imem

  core.io.dmem  <> dmmio.io.dmem
  dmmio.io.mem0 <> dcache.io.dmem
  dmmio.io.mem1 <> clintreg.io.mem
  dmmio.io.mem2 <> dcachebypass.io.dmem

  core.io.set_mtip    := clintreg.io.set_mtip
  core.io.clear_mtip  := clintreg.io.clear_mtip

  icache.io.axi <> axi.io.icacheio
  dcache.io.axi <> axi.io.dcacheio
  icachebypass.io.axi <> axi.io.icacheBypassIO
  dcachebypass.io.axi <> axi.io.dcacheBypassIO

  // axi.io.out.ar <> io.memAXI_0.ar
  // axi.io.out.r  <> io.memAXI_0.r
  // axi.io.out.aw <> io.memAXI_0.aw
  // axi.io.out.w  <> io.memAXI_0.w
  // axi.io.out.b  <> io.memAXI_0.b 

  /************************ SoC-AXI *************************/
  axi.io.out.aw.ready     := io.master.awready
  io.master.awvalid       := axi.io.out.aw.valid
  io.master.awaddr        := axi.io.out.aw.bits.addr
  io.master.awid          := axi.io.out.aw.bits.id
  io.master.awlen         := axi.io.out.aw.bits.len
  io.master.awsize        := axi.io.out.aw.bits.size
  io.master.awburst       := axi.io.out.aw.bits.burst

  axi.io.out.w.ready      := io.master.wready    
  io.master.wvalid        := axi.io.out.w.valid
  io.master.wdata         := axi.io.out.w.bits.data
  io.master.wstrb         := axi.io.out.w.bits.strb
  io.master.wlast         := axi.io.out.w.bits.last

  io.master.bready        := axi.io.out.b.ready
  axi.io.out.b.valid      := io.master.bvalid
  axi.io.out.b.bits.resp  := io.master.bresp
  axi.io.out.b.bits.id    := io.master.bid

  axi.io.out.ar.ready     := io.master.arready
  io.master.arvalid       := axi.io.out.ar.valid
  io.master.araddr        := axi.io.out.ar.bits.addr
  io.master.arid          := axi.io.out.ar.bits.id
  io.master.arlen         := axi.io.out.ar.bits.len
  io.master.arsize        := axi.io.out.ar.bits.size
  io.master.arburst       := axi.io.out.ar.bits.burst

  io.master.rready        := axi.io.out.r.ready
  axi.io.out.r.valid      := io.master.rvalid
  axi.io.out.r.bits.resp  := io.master.rresp
  axi.io.out.r.bits.data  := io.master.rdata
  axi.io.out.r.bits.last  := io.master.rlast
  axi.io.out.r.bits.id    := io.master.rid

  axi.io.out.r.bits.user  := 0.U
  axi.io.out.b.bits.user  := 0.U
  // 不用的slave端口要置零
  io.slave.awready  := false.B
  // io.slave.awvalid  
  // io.slave.awaddr   
  // io.slave.awid     
  // io.slave.awlen    
  // io.slave.awsize   
  // io.slave.awburst  

  io.slave.wready   := false.B  
  // io.slave.wvalid   
  // io.slave.wdata    
  // io.slave.wstrb    
  // io.slave.wlast    

  // io.slave.bready   
  io.slave.bvalid   := false.B
  io.slave.bresp    := 0.U
  io.slave.bid      := 0.U

  io.slave.arready  := false.B
  // io.slave.arvalid
  // io.slave.araddr   
  // io.slave.arid    
  // io.slave.arlen    
  // io.slave.arsize  
  // io.slave.arburst 

  // io.slave.rready  
  io.slave.rvalid   := false.B
  io.slave.rresp    := false.B
  io.slave.rdata    := 0.U
  io.slave.rlast    := false.B
  io.slave.rid      := 0.U

  /****************************************************/
  // io.uart.out.valid := false.B
  // io.uart.out.ch := 0.U
  // io.uart.in.valid := false.B
}

