import chisel3._
import chisel3.util._

class Clint extends Module {
    val io = IO(new Bundle {
        val dmem = new DCacheIO
        val mem0 = Flipped(new DCacheIO)
        val mem1 = Flipped(new DCacheIO)
    })
    
    val sel = WireInit(0.U(1.W))
    val out_ok = WireInit(false.B)
    val out_rdata = WireInit(0.U(64.W))

    when(!io.mem0.ok){sel := 0.U(1.W)}
    .elsewhen(!io.mem1.ok){sel := 1.U(1.W)}
    .otherwise{sel := Mux(io.dmem.addr === "h0200bff8".U, 1.U(1.W), 0.U(1.W))}

    val sel_r = RegEnable(sel, 0.U(1.W), out_ok)

    when(sel === 0.U(1.W)){
        io.mem0.en := io.dmem.en
        io.mem0.op := io.dmem.op
        io.mem0.addr := io.dmem.addr
        io.mem0.wdata := io.dmem.wdata
        io.mem0.wmask := io.dmem.wmask
        io.mem1.en := false.B
        io.mem1.op := false.B
        io.mem1.addr := 0.U
        io.mem1.wdata := 0.U
        io.mem1.wmask := 0.U
    }
    .otherwise{
        io.mem1.en := io.dmem.en
        io.mem1.op := io.dmem.op
        io.mem1.addr := io.dmem.addr
        io.mem1.wdata := io.dmem.wdata
        io.mem1.wmask := io.dmem.wmask
        io.mem0.en := false.B
        io.mem0.op := false.B
        io.mem0.addr := 0.U
        io.mem0.wdata := 0.U
        io.mem0.wmask := 0.U
    }

    out_ok := MuxLookup(sel_r, 0.U, Array(
        "b0".U -> io.mem0.ok,
        "b1".U -> io.mem1.ok,
    ))
    out_rdata := MuxLookup(sel_r, 0.U, Array(
        "b0".U -> io.mem0.rdata,
        "b1".U -> io.mem1.rdata,
    ))

    io.dmem.ok := out_ok
    io.dmem.rdata := out_rdata
}

class Mtime extends Module {
    val io = IO(new Bundle {
        val mem = new DCacheIO
    })
    val time = RegInit(0.U(64.W))
    time := time + 1.U

    io.mem.ok := true.B
    io.mem.rdata := time
}
