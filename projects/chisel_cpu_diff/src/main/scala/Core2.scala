import chisel3._
import chisel3.util._
import chisel3.util.experimental._
import difftest._

class Core2 extends Module{
    val io = IO(new Bundle{
        val axi = new AxiIO
    })

    val pipeline        = Module(new Pipeline)
    val rfu             = Module(new RegFile)

    val icache          = Module(new ICache)
    val icacheaxi       = Module(new ICacheSocAxi)

    val dmmio           = Module(new DMMIO)
    val dcache          = Module(new DCache)
    val clintreg        = Module(new ClintReg)
    val dcachebypass    = Module(new DCacheBypass)
    
    val axi             = Module(new AXI)

    rfu.io.rs1_addr         := pipeline.io.rs1_addr 
    rfu.io.rs2_addr         := pipeline.io.rs2_addr
    pipeline.io.rs1_data    := rfu.io.rs1_data
    pipeline.io.rs2_data    := rfu.io.rs2_data
    rfu.io.rd_en    := pipeline.io.commit && pipeline.io.rf_rd_en
    rfu.io.rd_addr  := pipeline.io.rf_rd_addr
    rfu.io.rd_data  := pipeline.io.rf_rd_data

    pipeline.io.stall_id    := pipeline.io.rfconflict && !icache.io.imem.ok
    pipeline.io.stall_ie    := false.B
    pipeline.io.stall_mem   := false.B
    pipeline.io.stall_wb    := !dmmio.io.dmem.ok

    /*
       pipeline ->|-> dmmio -->|-> dcache ------->|-> axi
                  |            |-> clintreg       |
                  |            |-> dcachebypass ->| 
                  |                               |
                  |-> icache ----> icacheaxi ---->|      
    */                                                                    
    icache.io.imem.addr     := pipeline.io.imem.addr
    icache.io.imem.en       := pipeline.io.imem.en
    pipeline.io.imem.data   := icache.io.imem.data

    val dmem_en = pipeline.io.dmem.ren || pipeline.io.dmem.wen 
    val dmem_op = pipeline.io.dmem.wen   // 按理说ren和wen不会同时为true
    val dmem_addr = Mux(dmem_op, pipeline.io.dmem.raddr, pipeline.io.dmem.waddr)
    dmmio.io.dmem.en := dmem_en
    dmmio.io.dmem.op := dmem_op
    dmmio.io.dmem.addr := dmem_addr
    dmmio.io.dmem.wdata := pipeline.io.dmem.wdata
    dmmio.io.dmem.wmask := pipeline.io.dmem.wmask
    dmmio.io.dmem.transfer := pipeline.io.dmem_transfer
    pipeline.io.dmem.rdata := dmmio.io.dmem.rdata
    
    icache.io.axi <> icacheaxi.io.in
    icacheaxi.io.out0 <> axi.io.icacheio
    icacheaxi.io.out1 <> axi.io.icacheBypassIO

    dmmio.io.mem0 <> dcache.io.dmem
    dmmio.io.mem1 <> clintreg.io.mem
    dmmio.io.mem2 <> dcachebypass.io.dmem

    dcache.io.axi <> axi.io.dcacheio
    dcachebypass.io.axi <> axi.io.dcacheBypassIO

    axi.io.out.ar <> io.axi.ar
    axi.io.out.r  <> io.axi.r
    axi.io.out.aw <> io.axi.aw
    axi.io.out.w  <> io.axi.w
    axi.io.out.b  <> io.axi.b 

    ////////////////////////////////////////////////////////
    icache.io.fence.req := false.B
    dcache.io.fence.req := false.B


    /* ------------------------------------ use difftest ---------------------------------------- */
    val dt_ic = Module(new DifftestInstrCommit)
    dt_ic.io.clock    := clock
    dt_ic.io.coreid   := 0.U
    dt_ic.io.index    := 0.U
    dt_ic.io.valid    := RegNext(pipeline.io.commit)
    dt_ic.io.pc       := RegNext(pipeline.io.commit_pc)
    dt_ic.io.instr    := RegNext(pipeline.io.commit_inst)
    dt_ic.io.special  := 0.U
    dt_ic.io.skip     := false.B
    dt_ic.io.isRVC    := false.B
    dt_ic.io.scFailed := false.B
    dt_ic.io.wen      := RegNext(pipeline.io.rf_rd_en)
    dt_ic.io.wdata    := RegNext(pipeline.io.rf_rd_data)
    dt_ic.io.wdest    := RegNext(pipeline.io.rf_rd_addr)

    val dt_ae = Module(new DifftestArchEvent)
    dt_ae.io.clock        := clock
    dt_ae.io.coreid       := 0.U
    dt_ae.io.intrNO       := 0.U
    dt_ae.io.cause        := 0.U
    dt_ae.io.exceptionPC  := 0.U

    val cycle_cnt = RegInit(0.U(64.W))
    val instr_cnt = RegInit(0.U(64.W))

    cycle_cnt := cycle_cnt + 1.U
    instr_cnt := Mux(pipeline.io.commit, instr_cnt + 1.U, instr_cnt)

    val rf_a0 = WireInit(0.U(64.W))
    BoringUtils.addSink(rf_a0, "rf_a0")

    val dt_te = Module(new DifftestTrapEvent)
    dt_te.io.clock    := clock
    dt_te.io.coreid   := 0.U
    dt_te.io.valid    := (pipeline.io.commit_inst === "h0000006b".U || pipeline.io.commit_inst === "h00100073".U) && pipeline.io.commit
    dt_te.io.code     := rf_a0(2, 0)
    dt_te.io.pc       := pipeline.io.commit_pc
    dt_te.io.cycleCnt := cycle_cnt
    dt_te.io.instrCnt := instr_cnt
}



