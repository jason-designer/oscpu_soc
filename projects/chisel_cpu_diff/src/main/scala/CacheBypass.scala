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
class ICacheBypass extends Module{
    val io = IO(new Bundle{
        val imem = new ICacheIO
        val axi = new ICacheBypassAxiIO
    })
    // addr reg
    val addr    = RegEnable(io.imem.addr, 0.U(32.W), io.imem.en && io.imem.ok)
    // cachebypass data
    val v       = RegInit(false.B)
    val tag     = RegInit(0.U(32.W))
    val block   = RegInit(0.U(32.W))
    // hit info
    val hit = addr === tag &&  v === true.B
    //state machine define
    val idle :: miss :: update :: Nil = Enum(3)
    val state = RegInit(idle)
    // icachebypass output
    val not_en_yet  = RegInit(true.B)                       // 用于复位后让icache输出ok，避免进入stall
    not_en_yet      := Mux(io.imem.en, false.B, not_en_yet) // 复位后在en没来前还需要保持state的idle状态

    io.imem.data    := block
    io.imem.ok      := (hit || not_en_yet) && state === idle 
    // state machine
    switch(state){
        is(idle){
            when(!hit && !not_en_yet) {state := miss}
        }
        is(miss){
            when(io.axi.valid) {state := update}
        }
        is(update){
            state := idle
        }
    }
    // axi request signals
    io.axi.req  := state === miss
    io.axi.addr := addr // 如果axi的size为4B的话，这里addr要求4整除
    // update cachebypass data
    block   := Mux(state === update, io.axi.data >> (addr(2, 0) << 3), block) 
    tag     := Mux(state === update, addr, block)
    v       := Mux(state === update, false.B, v)
}



