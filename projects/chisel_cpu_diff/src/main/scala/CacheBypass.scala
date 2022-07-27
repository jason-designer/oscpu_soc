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

// ICacheBypass 可以看作是只有一个block的cache
// class ICacheBypass extends Module{
//     val io = IO(new Bundle{
//         val imem = new ICacheIO
//         val axi = new ICacheBypassAxiIO
//     })
//     // addr reg
//     val addr    = RegEnable(io.imem.addr, 0.U(32.W), io.imem.en && io.imem.ok)
//     // cachebypass data
//     val v       = RegInit(false.B)
//     val tag     = RegInit(0.U(32.W))
//     val block   = RegInit(0.U(32.W))
//     // hit info
//     val hit = addr === tag &&  v === true.B
//     //state machine define
//     val idle :: miss :: update :: Nil = Enum(3)
//     val state = RegInit(idle)
//     // icachebypass output
//     val not_en_yet  = RegInit(true.B)                       // 用于复位后让icache输出ok，避免进入stall
//     not_en_yet      := Mux(io.imem.en, false.B, not_en_yet) // 复位后在en没来前还需要保持state的idle状态

//     io.imem.data    := block
//     io.imem.ok      := (hit || not_en_yet) && state === idle 
//     // state machine
//     switch(state){
//         is(idle){
//             when(!hit && !not_en_yet) {state := miss}
//         }
//         is(miss){
//             when(io.axi.valid) {state := update}
//         }
//         is(update){
//             state := idle
//         }
//     }
//     // axi request signals
//     io.axi.req  := state === miss
//     io.axi.addr := addr & "hfffffff8".U// 如果axi的size为4B的话，这里addr要求4整除
//     // update cachebypass data
//     block   := Mux(state === update, io.axi.data >> (addr(2, 0) << 3), block) 
//     tag     := Mux(state === update, addr, tag)
//     v       := Mux(state === update, true.B, v)
// }
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
    io.axi.addr     := addr & "hfffffff8".U   // 若tranfer的size为4的话，地址要求4对齐
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
    io.axi.raddr    := addr & "hfffffff8".U     // 若tranfer的size为4的话，地址要求4对齐
    // axi w output signal
    io.axi.weq      := state === write_data
    io.axi.waddr    := addr & "hfffffff8".U     // 若tranfer的size为4的话，地址要求4对齐
    io.axi.wdata    := wdata
    io.axi.wmask    := wmask  
    // dcachebypass output signal
    io.dmem.rdata   := rdata
    io.dmem.ok      := state === idle
}







