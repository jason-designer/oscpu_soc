import chisel3._
import chisel3.util._

trait AxiParameters {
    val AxiAddrWidth = 64
    val AxiDataWidth = 64
    val AxiIdWidth   = 4
    val AxiUserWidth = 4
}

// object AxiParameters extends AxiParameters { }

class AxiA extends Bundle with AxiParameters{
    val len     = Output(UInt(8.W))
    val size    = Output(UInt(3.W))
    val burst   = Output(UInt(2.W))
    val lock    = Output(Bool())
    val cache   = Output(UInt(4.W))
    val qos     = Output(UInt(4.W))
    val addr    = Output(UInt(AxiAddrWidth.W))
    val prot    = Output(UInt(3.W))
    val id      = Output(UInt(AxiIdWidth.W))
    val user    = Output(UInt(AxiUserWidth.W))
}

class AxiW extends Bundle with AxiParameters{
    val data    = Output(UInt(AxiDataWidth.W))
    val strb    = Output(UInt((AxiDataWidth / 8).W))
    val last    = Output(Bool())
}

class AxiB extends Bundle with AxiParameters{
    val resp    = Output(UInt(2.W))
    val id      = Output(UInt(AxiIdWidth.W))
    val user    = Output(UInt(AxiUserWidth.W))
}

class AxiR extends Bundle with AxiParameters{
    val resp    = Output(UInt(2.W))
    val data    = Output(UInt(AxiDataWidth.W))
    val last    = Output(Bool())
    val id      = Output(UInt(AxiIdWidth.W))
    val user    = Output(UInt(AxiUserWidth.W))
}

class AxiIO extends Bundle with AxiParameters{
    val aw      = Decoupled(new AxiA)
    val w       = Decoupled(new AxiW)
    val b       = Flipped(Decoupled(new AxiB))
    val ar      = Decoupled(new AxiA)
    val r       = Flipped(Decoupled(new AxiR))
}


class AXI extends Module with CacheParameters{
    val io = IO(new Bundle{
        val out = new AxiIO
        val icacheio = Flipped(new ICacheAxiIO)
        val dcacheio = Flipped(new DCacheAxiIO)
    })
    //
    val out = io.out
    val icacheio = io.icacheio
    val dcacheio = io.dcacheio
    // buffer
    val ibuffer     = RegInit(VecInit(Seq.fill(AxiArLen)(0.U(64.W))))
    val drbuffer    = RegInit(VecInit(Seq.fill(AxiArLen)(0.U(64.W))))
    val icnt        = RegInit(0.U(OffsetWidth.W))
    val drcnt       = RegInit(0.U(OffsetWidth.W))
    val dwcnt       = RegInit(0.U(OffsetWidth.W))
    // state machine define
    val r_idle :: r_iaddr :: r_ihs :: r_idata :: r_idone :: r_daddr :: r_dhs :: r_ddata :: r_ddone :: Nil = Enum(9)
    val w_idle :: w_addr :: w_data :: w_resp :: w_done :: Nil = Enum(5)
    val rstate = RegInit(r_idle)
    val wstate = RegInit(w_idle)

    // read state machine
    switch(rstate){
        is(r_idle){
            when(icacheio.req) {rstate := r_iaddr}
            .elsewhen(dcacheio.req) {rstate := r_daddr}
        }
        // 处理 imem req 
        is(r_iaddr){
            when(out.ar.ready) {rstate := r_ihs}
        }
        is(r_ihs){
            when(out.r.valid) {rstate := r_idata}
        }
        is(r_idata){
            when(out.r.valid === false.B || out.r.bits.last) {rstate := r_idone}
        }
        is(r_idone){
            rstate := r_idle
        }
        // 处理 dmem req 
        is(r_daddr){
            when(out.ar.ready) {rstate := r_dhs}
        }
        is(r_dhs){
            when(out.r.valid) {rstate := r_ddata}
        }
        is(r_ddata){
            when(out.r.valid === false.B || out.r.bits.last) {rstate := r_ddone}
        }
        is(r_ddone){
            rstate := r_idle
        }
    }

    // write state machine
    switch(wstate){
        is(w_idle){
            when(dcacheio.weq) {wstate := w_addr}
        }
        is(w_addr){
            when(out.aw.ready) {wstate := w_data}
        }
        is(w_data){
            when(out.w.bits.last) {wstate := w_resp}
        }
        is(w_resp){
            when(out.b.valid) {wstate := w_done}
        }
        is(w_done){
            when(!out.b.valid) {wstate := w_idle}
        }
    }


    /***********************buffer****************************/
    ibuffer(icnt) := Mux(rstate === r_idata, out.r.bits.data, ibuffer(icnt))
    icnt := Mux(rstate === r_idata, icnt + 1.U, 0.U)
    drbuffer(drcnt) := Mux(rstate === r_ddata, out.r.bits.data, drbuffer(drcnt))
    drcnt := Mux(rstate === r_ddata, drcnt + 1.U, 0.U)
    dwcnt := Mux(wstate === w_data && out.w.ready, dwcnt + 1.U, 0.U)


    /***********************CacheIO signals*******************/
    // icacheio signals---------------------------------------
    // icacheio.req
    // icacheio.addr
    var idata = ibuffer(0)
    for(i <- 1 to (AxiArLen - 1)) idata = Cat(ibuffer(i), idata)
    icacheio.valid  := rstate === r_idone
    icacheio.data   := idata
    // dcacheio signals---------------------------------------
    // dcacheio.req
    // dcacheio.raddr
    var drdata = drbuffer(0)
    for(i <- 1 to (AxiArLen - 1)) drdata = Cat(drbuffer(i), drdata)
    dcacheio.rvalid := rstate === r_ddone
    dcacheio.rdata  := drdata

    dcacheio.wdone  := wstate === w_done && !out.b.valid


    /***********************AXI signals***********************/
    // Read address channel signals --------------------------
    // out.ar.ready
    out.ar.valid        := rstate === r_iaddr || rstate === r_daddr
    out.ar.bits.addr    := Mux(rstate === r_iaddr, icacheio.addr, Mux(rstate === r_daddr, dcacheio.raddr, 0.U))
    out.ar.bits.prot    := "b000".U
    out.ar.bits.id      := 0.U
    out.ar.bits.user    := 0.U
    out.ar.bits.len     := (AxiArLen - 1).U
    out.ar.bits.size    := "b011".U             //每个beat包含8个字节
    out.ar.bits.burst   := "b01".U
    out.ar.bits.lock    := 0.U
    out.ar.bits.cache   := "b0010".U
    out.ar.bits.qos     := 0.U

    // Read data channel signals -----------------------------
    // out.r.valid
    // out.r.resp
    // out.r.data 
    // out.r.last
    // out.r.id
    // out.r.user
    out.r.ready         := rstate === r_idata || rstate === r_ddata

    // write address channel signals -------------------------
    // out.aw.ready
    out.aw.valid        := wstate === w_addr
    out.aw.bits.addr    := dcacheio.waddr
    out.aw.bits.prot    := "b000".U
    out.aw.bits.id      := 0.U
    out.aw.bits.user    := 0.U
    out.aw.bits.len     := (AxiArLen - 1).U
    out.aw.bits.size    := "b011".U             //每个beat包含8个字节
    out.aw.bits.burst   := "b01".U
    out.aw.bits.lock    := 0.U
    out.aw.bits.cache   := "b0010".U
    out.aw.bits.qos     := 0.U
    // write data channel signals ----------------------------
    out.w.valid         := wstate === w_data
    out.w.bits.data     := (dcacheio.wdata >> (dwcnt << 6))(63, 0)
    out.w.bits.strb     := "hff".U
    out.w.bits.last     := dwcnt === AxiArLen.U
    // resp channel signals ----------------------------------
    out.b.ready         := wstate === w_done
}


