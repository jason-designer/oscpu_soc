import chisel3._
import chisel3.util._

class Clint extends Module {
    val io = IO(new Bundle {
        val dmem = new DCacheIO
        val mem0 = Flipped(new DCacheIO)
        val mem1 = Flipped(new DCacheIO)
        val mem2 = Flipped(new DCacheIO)
    })
    
    val sel = WireInit(0.U)
    val out_ok = WireInit(false.B)
    val out_rdata = WireInit(0.U(64.W))

    when(!io.mem0.ok){sel := 0.U}
    .elsewhen(!io.mem1.ok){sel := 1.U}
    .elsewhen(!io.mem1.ok){sel := 2.U}
    .otherwise{
        when(io.dmem.addr === "h0200bff8".U){sel := 1.U}
        .elsewhen(io.dmem.addr === "h02004000".U){sel := 2.U}
        .otherwise{sel := 0.U}
    }

    val sel_r = RegEnable(sel, 0.U, out_ok)

    io.mem0.en      := Mux(sel === 0.U, io.dmem.en, false.B)
    io.mem0.op      := Mux(sel === 0.U, io.dmem.op, false.B)
    io.mem0.addr    := Mux(sel === 0.U, io.dmem.addr, 0.U)
    io.mem0.wdata   := Mux(sel === 0.U, io.dmem.wdata, 0.U)
    io.mem0.wmask   := Mux(sel === 0.U, io.dmem.wmask, 0.U)
    io.mem1.en      := Mux(sel === 1.U, io.dmem.en, false.B)
    io.mem1.op      := Mux(sel === 1.U, io.dmem.op, false.B)
    io.mem1.addr    := Mux(sel === 1.U, io.dmem.addr, 0.U)
    io.mem1.wdata   := Mux(sel === 1.U, io.dmem.wdata, 0.U)
    io.mem1.wmask   := Mux(sel === 1.U, io.dmem.wmask, 0.U)
    io.mem2.en      := Mux(sel === 2.U, io.dmem.en, false.B)
    io.mem2.op      := Mux(sel === 2.U, io.dmem.op, false.B)
    io.mem2.addr    := Mux(sel === 2.U, io.dmem.addr, 0.U)
    io.mem2.wdata   := Mux(sel === 2.U, io.dmem.wdata, 0.U)
    io.mem2.wmask   := Mux(sel === 2.U, io.dmem.wmask, 0.U)


    out_ok := MuxLookup(sel_r, 0.U, Array(
        0.U -> io.mem0.ok,
        1.U -> io.mem1.ok,
        2.U -> io.mem2.ok,
    ))
    out_rdata := MuxLookup(sel_r, 0.U, Array(
        0.U -> io.mem0.rdata,
        1.U -> io.mem1.rdata,
        2.U -> io.mem2.rdata,
    ))

    io.dmem.ok := out_ok
    io.dmem.rdata := out_rdata
}

class Mtime extends Module {
    val io = IO(new Bundle {
        val mem = new DCacheIO
    })
    val mtime = RegInit(0.U(64.W))
    mtime := mtime + 1.U

    io.mem.ok := true.B
    io.mem.rdata := mtime
}

class Mtimecmp extends Module{
    val io = IO(new Bundle {
        val mem = new DCacheIO
    })
    val mtimecmp = RegInit(0.U(64.W))

    val wm = io.mem.wmask
    val mask64 = Cat(Fill(8,wm(7)),Fill(8,wm(6)),Fill(8,wm(5)),Fill(8,wm(4)),Fill(8,wm(3)),Fill(8,wm(2)),Fill(8,wm(1)),Fill(8,wm(0)))
    val mtimecmp_update = (mtimecmp & (~mask64)) | (mask64 & io.mem.wdata)

    when(io.mem.en && io.mem.op){mtimecmp := mtimecmp_update}
    .otherwise{mtimecmp := mtimecmp}

    io.mem.rdata := mtimecmp
    io.mem.ok := true.B
}
