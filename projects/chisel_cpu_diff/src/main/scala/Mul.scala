import chisel3._
import chisel3.util._
import chisel3.experimental._

class Mul extends Module{
    val io = IO(new Bundle{
        val en = Input(Bool())
        val x = Input(UInt(65.W))
        val y = Input(UInt(65.W))
        val out = Output(UInt(130.W))
        val stall = Output(Bool())
    })
    val x = RegInit(0.U(130.W))
    val y = RegInit(0.U(65.W))
    val cnt = RegInit(0.U(7.W))
    val sum = RegInit(0.U(130.W))
    // state define
    val idle :: fetch :: compute :: done :: Nil = Enum(4)
    val state = RegInit(idle)
    // state machine
    switch(state){
        is(idle){
            when(io.en){state := fetch}
        }
        is(fetch){
            state := compute
        }
        is(compute){
            when(cnt === 64.U){state := done}
        }
        is(done){
            state := idle
        }
    }
    // 
    when(state === fetch){
        x := Cat(Fill(65, io.x(64)), io.x)  // 符号位扩展
        y := io.y
        cnt := 0.U
        sum := 0.U
    }
    .elsewhen(state === compute){
        x := x << 1.U
        y := y >> 1.U
        cnt := cnt + 1.U
        sum := sum + Mux(y(0), x, 0.U)
    }
    //
    io.out := sum
    io.stall := !(state === done && (state === idle && !io.en))
}


// class mu extends Module{
//     val io = IO(new Bundle{

//     })

// }


