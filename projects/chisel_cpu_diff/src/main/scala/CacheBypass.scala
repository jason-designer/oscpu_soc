import chisel3._
import chisel3.util._

class ICacheBypassAxiIO extends Bundle{
    val req     = Output(Bool())
    val addr    = Output(UInt(32.W))
    val valid   = Input(Bool())
    val data    = Input(UInt(64.W))
}

class DCacheBypassAxiIO extends Bundle{
    val req     = Output(Bool())
    val raddr   = Output(UInt(32.W))
    val rvalid  = Input(Bool())
    val rdata   = Input(UInt(64.W))

    val weq     = Output(Bool())
    val waddr   = Output(UInt(32.W))
    val wdata   = Output(UInt(64.W))
    val wmask   = Output(UInt(8.W))
    val wdone   = Input(Bool())
}

class ICacheBypass extends Module{
    val io = IO(new Bundle{
        val imem    = new ICacheIO
        val axi     = new ICacheBypassAxiIO
    })
    // buffer reg
    val addr    = RegInit(0.U(32.W))
    val data   = RegInit(0.U(32.W))
    // state machine define
    val idle :: fetch_data :: update :: Nil = Enum(3)
    val state = RegInit(idle)
    // state machine
    switch(state){
        is(idle){
            when(io.imem.en) {state := fetch_data}
        }
        is(fetch_data){
            when(io.axi.valid) {state := update}
        }
        is(update){
            state := idle
        }
    }
    // update buffer
    addr   := Mux(state === idle && io.imem.en, io.imem.addr, addr)
    data   := Mux(state === update, io.axi.data >> (addr(2, 0) << 3), data)
    // axi output signal
    io.axi.req      := state === fetch_data
    io.axi.addr     := addr & "hfffffffc".U   // 若tranfer的size为4的话，地址要求4对齐
    // dcachebypass output signal
    io.imem.data    := data
    io.imem.ok      := state === idle
}


class DCacheBypass extends Module{
    val io = IO(new Bundle{
        val dmem    = new DCacheIO
        val axi     = new DCacheBypassAxiIO
    })
    // buffer reg
    val op      = RegInit(false.B)
    val addr    = RegInit(0.U(32.W))
    val wdata   = RegInit(0.U(64.W))
    val wmask   = RegInit(0.U(8.W))
    val rdata   = RegInit(0.U(64.W))
    // state machine define
    val idle :: fetch_data :: update :: write_data :: Nil = Enum(4)
    val state = RegInit(idle)
    // state machine
    switch(state){
        is(idle){
            when(io.dmem.en && !io.dmem.op) {state := fetch_data}
            .elsewhen(io.dmem.en && io.dmem.op) {state := write_data}
        }
        is(fetch_data){
            when(io.axi.rvalid) {state := update}
        }
        is(update){
            state := idle
        }
        is(write_data){
            when(io.axi.wdone) {state := idle}
        }
    }
    // update buffer
    when(state === idle && io.dmem.en){
        op      := io.dmem.op
        addr    := io.dmem.addr
        wdata   := io.dmem.wdata
        wmask   := io.dmem.wmask
    }
    rdata := Mux(state === update, io.axi.rdata, rdata)
    // axi r output signal
    io.axi.req      := state === fetch_data
    io.axi.raddr    := addr & "hfffffffc".U     // 若tranfer的size为4的话，地址要求4对齐
    // axi w output signal
    io.axi.weq      := state === write_data
    io.axi.waddr    := addr & "hfffffffc".U     // 若tranfer的size为4的话，地址要求4对齐
    io.axi.wdata    := wdata
    io.axi.wmask    := wmask  
    // dcachebypass output signal
    io.dmem.rdata   := rdata
    io.dmem.ok      := state === idle
}







