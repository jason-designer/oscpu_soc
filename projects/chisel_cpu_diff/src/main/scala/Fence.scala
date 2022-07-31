import chisel3._
import chisel3.util._
import Instructions._

class FenceIO extends Bundle{
    val req = Output(Bool())
    val done = Input(Bool())
}

class Fence extends Module{
    val io = IO(new Bundle{
        val inst    = Input(UInt(32.W))
        val go      = Input(Bool())
        val ok      = Output(Bool())
        val ifence  = new FenceIO
        val dfence  = new FenceIO
    })
    // state machine
    val idle :: wait :: dcache :: icache :: done :: Nil = Enum(5)
    val state = RegInit(idle)

    switch(state){
        is(idle){
            when(io.inst === FENCEI){state := wait}
        }
        is(wait){
            when(io.go){state := dcache}
        }
        is(dcache){
            when(io.dfence.done){state := icache}
        }
        is(icache){
            when(io.ifence.done){state := done}
        }
        is(done){
            state := idle
        }
    }
    // output
    io.ok := state === idle && io.inst =/= FENCEI
    io.dfence.req := idle === dcache
    io.dfence.req := idle === icache
}


