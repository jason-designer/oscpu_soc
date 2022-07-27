import chisel3._
import chisel3.util._

class PreAccessMemory extends Module{
    val io = IO(new Bundle{
        val lu_code = Input(UInt())
        val su_code = Input(UInt())
        val op1 = Input(UInt(64.W))
        val op2 = Input(UInt(64.W))
        val imm = Input(UInt(64.W))

        val lu_shift = Output(UInt(6.W)) 

        val ren   = Output(Bool())
        val raddr = Output(UInt(64.W))
        val wen   = Output(Bool())
        val waddr = Output(UInt(64.W))
        val wdata = Output(UInt(64.W))
        val wmask = Output(UInt(8.W))
    })

    //lu
    val lu_offset = io.op1 + io.op2
    val lu_shift = lu_offset(2, 0) << 3
    val lu_ren = io.lu_code =/= 0.U
    val lu_raddr = lu_offset

    //su
    val su_offset = io.op1 + io.imm
    val su_shift  = su_offset(2, 0) << 3
    val su_wen    = io.su_code =/= 0.U
    val su_waddr  = su_offset & "hfffffffffffffff8".U
    val su_wdata  = io.op2 << su_shift
    val su_wmask  = MuxLookup(io.su_code, 0.U, Array(
        "b0001".U -> ("b00000001".U << su_offset(2, 0)),    //sb
        "b0010".U -> ("b00000011".U << su_offset(2, 0)),    //sh
        "b0100".U -> ("b00001111".U << su_offset(2, 0)),    //sw
        "b1000".U -> "b11111111".U ,                        //sd
    ))

    io.lu_shift := lu_shift
    io.ren      := lu_ren
    io.raddr    := lu_raddr
    io.wen      := su_wen
    io.waddr    := su_waddr
    io.wdata    := su_wdata
    io.wmask    := su_wmask
}