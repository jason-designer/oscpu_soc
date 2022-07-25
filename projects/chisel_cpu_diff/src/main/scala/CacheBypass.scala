import chisel3._
import chisel3.util._

class ICacheBypassAxiIO extends Bundle{
    val req     = Output(Bool())
    val addr    = Output(UInt(64.W))
    val valid   = Input(Bool())
    val data    = Input(UInt(32.W))
}

class DCacheBypassAxiIO extends Bundle{
    val req     = Output(Bool())
    val raddr   = Output(UInt(64.W))
    val rvalid  = Input(Bool())
    val rdata   = Input(UInt(32.W))

    val weq     = Output(Bool())
    val waddr   = Output(UInt(64.W))
    val wdata   = Output(UInt(32.W))
    val wdone   = Input(Bool())
}





