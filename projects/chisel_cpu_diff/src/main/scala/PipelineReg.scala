import chisel3._
import chisel3.util._

class PipelineRegIO extends Bundle{
    val valid_in = Input(Bool())
    val valid_out = Output(Bool())
    val en = Input(Bool())
}

class IDReg extends Module{
    val io = IO(new Bundle{
        val imem        = new ImemIO

        val pr          = new PipelineRegIO
        val pc_in       = Input(UInt(64.W))

        val pc_out      = Output(UInt(64.W))
        val inst_out    = Output(UInt(32.W))
    })
    val valid   = RegEnable(io.pr.valid_in, false.B, io.pr.en)
    val pc      = RegEnable(io.pc_in, "h7ffffffc".U(64.W), io.pr.en)
    
    val imemrh  = Module(new ImemoryReadHold)
    imemrh.io.ren   := io.pr.en
    imemrh.io.raddr := io.pc_in
    io.imem.en      := imemrh.io.imem_ren     
    io.imem.addr    := imemrh.io.imem_raddr  

    io.pr.valid_out := valid
    io.pc_out       := pc
    io.inst_out     := io.imem.data
}


class ExeReg extends Module{
    val io = IO(new Bundle{
        val pr = new PipelineRegIO
        val pc_in = Input(UInt(64.W))
        val inst_in = Input(UInt(32.W))
        val rd_en_in = Input(Bool())
        val rd_addr_in = Input(UInt(5.W))
        val imm_in = Input(UInt(64.W))
        val op1_in = Input(UInt(64.W))
        val op2_in = Input(UInt(64.W))
        val rs1_addr_in = Input(UInt(5.W))
        val decode_info_in = Flipped(new DecodeInfo)
        val putch_in = Input(Bool())
        
        //
        val pc_out = Output(UInt(64.W))
        val inst_out = Output(UInt(32.W))
        val rd_en_out = Output(Bool())
        val rd_addr_out = Output(UInt(5.W))
        val imm_out = Output(UInt(64.W))
        val op1_out = Output(UInt(64.W))
        val op2_out = Output(UInt(64.W))
        val rs1_addr_out = Output(UInt(5.W))
        val decode_info_out = new DecodeInfo
        val putch_out = Output(Bool())
    })
    val valid = RegEnable(io.pr.valid_in, false.B, io.pr.en)
    val pc = RegEnable(io.pc_in, 0.U(64.W), io.pr.en)
    val inst = RegEnable(io.inst_in, 0.U(32.W), io.pr.en)
    val rd_en = RegEnable(io.rd_en_in, false.B, io.pr.en)
    val rd_addr = RegEnable(io.rd_addr_in, 0.U(5.W), io.pr.en)
    val imm = RegEnable(io.imm_in, 0.U(64.W), io.pr.en)
    val op1 = RegEnable(io.op1_in, 0.U(64.W), io.pr.en)
    val op2 = RegEnable(io.op2_in, 0.U(64.W), io.pr.en)

    val fu_code     = RegEnable(io.decode_info_in.fu_code, 0.U, io.pr.en)
    val alu_code    = RegEnable(io.decode_info_in.alu_code, 0.U, io.pr.en)
    val bu_code     = RegEnable(io.decode_info_in.bu_code, 0.U, io.pr.en)
    val lu_code     = RegEnable(io.decode_info_in.lu_code, 0.U, io.pr.en)
    val su_code     = RegEnable(io.decode_info_in.su_code, 0.U, io.pr.en)
    val mdu_code    = RegEnable(io.decode_info_in.mdu_code, 0.U, io.pr.en)
    val csru_code   = RegEnable(io.decode_info_in.csru_code, 0.U, io.pr.en)

    io.pr.valid_out := valid
    io.pc_out := pc
    io.inst_out := inst
    io.rd_en_out := rd_en
    io.rd_addr_out := rd_addr
    io.imm_out := imm
    io.op1_out := op1
    io.op2_out := op2
    io.rs1_addr_out := RegEnable(io.rs1_addr_in, 0.U(5.W), io.pr.en)
    io.decode_info_out.fu_code := fu_code
    io.decode_info_out.alu_code := alu_code
    io.decode_info_out.bu_code := bu_code
    io.decode_info_out.lu_code := lu_code
    io.decode_info_out.su_code := su_code
    io.decode_info_out.mdu_code := mdu_code
    io.decode_info_out.csru_code := csru_code

    io.putch_out := RegEnable(io.putch_in, false.B, io.pr.en)
}

class MemReg extends Module{
    val io = IO(new Bundle{
        val pr = new PipelineRegIO
        val pc_in = Input(UInt(64.W))
        val inst_in = Input(UInt(32.W))
        val rd_en_in = Input(Bool())
        val rd_addr_in = Input(UInt(5.W))
        val alu_out_in = Input(UInt(64.W))
        val bu_out_in = Input(UInt(64.W))
        val mdu_out_in = Input(UInt(64.W))
        val csru_out_in = Input(UInt(64.W))

        val imm_in = Input(UInt(64.W))
        val op1_in = Input(UInt(64.W))
        val op2_in = Input(UInt(64.W))
        val decode_info_in = Flipped(new DecodeInfo)

        val putch_in = Input(Bool())
        val csr_wen_in   = Input(Bool())
        val csr_waddr_in = Input(UInt(12.W))
        val csr_wdata_in = Input(UInt(64.W))
        //
        val pc_out = Output(UInt(64.W))
        val inst_out = Output(UInt(32.W))
        val rd_en_out = Output(Bool())
        val rd_addr_out = Output(UInt(5.W))
        val alu_out_out = Output(UInt(64.W))
        val bu_out_out = Output(UInt(64.W))
        val mdu_out_out = Output(UInt(64.W))
        val csru_out_out = Output(UInt(64.W))

        val imm_out = Output(UInt(64.W))
        val op1_out = Output(UInt(64.W))
        val op2_out = Output(UInt(64.W))
        val decode_info_out = new DecodeInfo

        val putch_out = Output(Bool())
        val csr_wen_out   = Output(Bool())
        val csr_waddr_out = Output(UInt(12.W))
        val csr_wdata_out = Output(UInt(64.W))
    })
    val valid   = RegEnable(io.pr.valid_in, false.B, io.pr.en)
    val pc      = RegEnable(io.pc_in, 0.U(64.W), io.pr.en)
    val inst    = RegEnable(io.inst_in, 0.U(32.W), io.pr.en)
    val rd_en   = RegEnable(io.rd_en_in, false.B, io.pr.en)
    val rd_addr = RegEnable(io.rd_addr_in, 0.U(5.W), io.pr.en)
    val alu_out = RegEnable(io.alu_out_in, 0.U(64.W), io.pr.en)
    val bu_out  = RegEnable(io.bu_out_in, 0.U(64.W), io.pr.en)
    val mdu_out  = RegEnable(io.mdu_out_in, 0.U(64.W), io.pr.en)
    val csru_out  = RegEnable(io.csru_out_in, 0.U(64.W), io.pr.en)

    val imm = RegEnable(io.imm_in, 0.U(64.W), io.pr.en)
    val op1 = RegEnable(io.op1_in, 0.U(64.W), io.pr.en)
    val op2 = RegEnable(io.op2_in, 0.U(64.W), io.pr.en)

    val fu_code   = RegEnable(io.decode_info_in.fu_code, 0.U, io.pr.en)
    val alu_code  = RegEnable(io.decode_info_in.alu_code, 0.U, io.pr.en)
    val bu_code   = RegEnable(io.decode_info_in.bu_code, 0.U, io.pr.en)
    val lu_code   = RegEnable(io.decode_info_in.lu_code, 0.U, io.pr.en)
    val su_code   = RegEnable(io.decode_info_in.su_code, 0.U, io.pr.en)
    val mdu_code  = RegEnable(io.decode_info_in.mdu_code, 0.U, io.pr.en)
    val csru_code = RegEnable(io.decode_info_in.csru_code, 0.U, io.pr.en)

    io.pr.valid_out := valid
    io.pc_out := pc
    io.inst_out := inst
    io.rd_en_out := rd_en
    io.rd_addr_out := rd_addr
    io.alu_out_out := alu_out
    io.bu_out_out := bu_out
    io.mdu_out_out := mdu_out
    io.csru_out_out := csru_out

    io.imm_out := imm
    io.op1_out := op1
    io.op2_out := op2
    io.decode_info_out.fu_code := fu_code
    io.decode_info_out.alu_code := alu_code
    io.decode_info_out.bu_code := bu_code
    io.decode_info_out.lu_code := lu_code
    io.decode_info_out.su_code := su_code
    io.decode_info_out.mdu_code := mdu_code
    io.decode_info_out.csru_code := csru_code

    io.putch_out     := RegEnable(io.putch_in, false.B, io.pr.en)
    io.csr_wen_out   := RegEnable(io.csr_wen_in, false.B, io.pr.en)
    io.csr_waddr_out := RegEnable(io.csr_waddr_in, 0.U(12.W), io.pr.en)
    io.csr_wdata_out := RegEnable(io.csr_wdata_in, 0.U(64.W), io.pr.en)
}

class WBReg extends Module{
    val io = IO(new Bundle{
        val pr = new PipelineRegIO
        val pc_in       = Input(UInt(64.W))
        val inst_in     = Input(UInt(32.W))
        val rd_en_in    = Input(Bool())
        val rd_addr_in  = Input(UInt(5.W))
        val alu_out_in = Input(UInt(64.W))
        val bu_out_in = Input(UInt(64.W))
        val mdu_out_in = Input(UInt(64.W))
        val csru_out_in = Input(UInt(64.W))

        val fu_code_in  = Input(UInt())
        val lu_code_in  = Input(UInt())
        val csru_code_in  = Input(UInt())
        val lu_shift_in = Input(UInt(6.W))

        val putch_in = Input(Bool())
        val csr_wen_in   = Input(Bool())
        val csr_waddr_in = Input(UInt(12.W))
        val csr_wdata_in = Input(UInt(64.W))
        //
        val pc_out      = Output(UInt(64.W))
        val inst_out    = Output(UInt(32.W))
        val rd_en_out   = Output(Bool())
        val rd_addr_out = Output(UInt(5.W))
        val alu_out_out = Output(UInt(64.W))
        val bu_out_out = Output(UInt(64.W))
        val mdu_out_out = Output(UInt(64.W))
        val csru_out_out = Output(UInt(64.W))

        val fu_code_out = Output(UInt())
        val lu_code_out = Output(UInt())
        val csru_code_out = Output(UInt())
        val lu_shift_out = Output(UInt(6.W))

        val putch_out = Output(Bool())
        val csr_wen_out   = Output(Bool())
        val csr_waddr_out = Output(UInt(12.W))
        val csr_wdata_out = Output(UInt(64.W))
    })

    val valid = RegEnable(io.pr.valid_in, false.B, io.pr.en)
    val pc = RegEnable(io.pc_in, 0.U(64.W), io.pr.en)
    val inst = RegEnable(io.inst_in, 0.U(32.W), io.pr.en)
    val rd_en = RegEnable(io.rd_en_in, false.B, io.pr.en)
    val rd_addr = RegEnable(io.rd_addr_in, 0.U(5.W), io.pr.en)

    val alu_out = RegEnable(io.alu_out_in, 0.U(64.W), io.pr.en)
    val bu_out  = RegEnable(io.bu_out_in, 0.U(64.W), io.pr.en)
    val mdu_out  = RegEnable(io.mdu_out_in, 0.U(64.W), io.pr.en)
    val csru_out = RegEnable(io.csru_out_in, 0.U(64.W), io.pr.en)

    val fu_code  = RegEnable(io.fu_code_in, 0.U, io.pr.en)
    val lu_code  = RegEnable(io.lu_code_in, 0.U, io.pr.en)
    val csru_code  = RegEnable(io.csru_code_in, 0.U, io.pr.en)
    val lu_shift = RegEnable(io.lu_shift_in, 0.U, io.pr.en)

    io.pr.valid_out := valid
    io.pc_out := pc
    io.inst_out := inst
    io.rd_en_out := rd_en
    io.rd_addr_out := rd_addr
    io.alu_out_out := alu_out
    io.bu_out_out := bu_out
    io.mdu_out_out := mdu_out
    io.csru_out_out := csru_out

    io.fu_code_out := fu_code
    io.lu_code_out := lu_code
    io.csru_code_out := csru_code
    io.lu_shift_out := lu_shift

    io.putch_out := RegEnable(io.putch_in, false.B, io.pr.en)
    io.csr_wen_out   := RegEnable(io.csr_wen_in, false.B, io.pr.en)
    io.csr_waddr_out := RegEnable(io.csr_waddr_in, 0.U(12.W), io.pr.en)
    io.csr_wdata_out := RegEnable(io.csr_wdata_in, 0.U(64.W), io.pr.en)
}


class ImemoryReadHold extends Module{
  val io = IO(new Bundle{
    val ren         = Input(Bool())
    val raddr       = Input(UInt(64.W))
    val imem_ren    = Output(Bool())
    val imem_raddr  = Output(UInt(64.W))
  })
  val raddr = RegEnable(io.raddr, 0.U, io.ren)
  io.imem_raddr := Mux(io.ren, io.raddr, raddr)
  io.imem_ren := true.B
}


class CorrelationConflict extends Module{
    val io = IO(new Bundle{
        val rs_valid    = Input(Bool())
        val rd_valid    = Input(Bool())
        val rs1_en      = Input(Bool())
        val rs2_en      = Input(Bool())
        val rs1_addr    = Input(UInt(5.W))
        val rs2_addr    = Input(UInt(5.W))
        val rd_en       = Input(Bool())
        val rd_addr     = Input(UInt(5.W))

        val conflict    = Output(Bool())
    })
    val inst_valid      = io.rs_valid && io.rd_valid
    val rs1_conflict    = io.rs1_en && (io.rs1_addr === io.rd_addr)
    val rs2_conflict    = io.rs2_en && (io.rs2_addr === io.rd_addr)
    val rd_valid        = (io.rd_addr =/= 0.U) && io.rd_en

    io.conflict := inst_valid && rd_valid && (rs1_conflict || rs2_conflict)
}

class RegfileConflict extends Module{
    val io = IO(new Bundle{
        val rs_valid    = Input(Bool())
        val rs1_en      = Input(Bool())
        val rs2_en      = Input(Bool())
        val rs1_addr    = Input(UInt(5.W))
        val rs2_addr    = Input(UInt(5.W))
        //
        val rd1_valid   = Input(Bool())
        val rd1_en      = Input(Bool())
        val rd1_addr    = Input(UInt(5.W))
        val rd2_valid   = Input(Bool())
        val rd2_en      = Input(Bool())
        val rd2_addr    = Input(UInt(5.W))
        val rd3_valid   = Input(Bool())
        val rd3_en      = Input(Bool())
        val rd3_addr    = Input(UInt(5.W))
        //
        val conflict    = Output(Bool())
    })
    val cconflict1 = Module(new CorrelationConflict)
    val cconflict2 = Module(new CorrelationConflict)
    val cconflict3 = Module(new CorrelationConflict)

    cconflict1.io.rs_valid  := io.rs_valid
    cconflict1.io.rd_valid  := io.rd1_valid
    cconflict1.io.rs1_en    := io.rs1_en
    cconflict1.io.rs2_en    := io.rs2_en
    cconflict1.io.rs1_addr  := io.rs1_addr
    cconflict1.io.rs2_addr  := io.rs2_addr
    cconflict1.io.rd_en     := io.rd1_en
    cconflict1.io.rd_addr   := io.rd1_addr

    cconflict2.io.rs_valid  := io.rs_valid
    cconflict2.io.rd_valid  := io.rd2_valid
    cconflict2.io.rs1_en    := io.rs1_en
    cconflict2.io.rs2_en    := io.rs2_en
    cconflict2.io.rs1_addr  := io.rs1_addr
    cconflict2.io.rs2_addr  := io.rs2_addr
    cconflict2.io.rd_en     := io.rd2_en
    cconflict2.io.rd_addr   := io.rd2_addr

    cconflict3.io.rs_valid  := io.rs_valid
    cconflict3.io.rd_valid  := io.rd3_valid
    cconflict3.io.rs1_en    := io.rs1_en
    cconflict3.io.rs2_en    := io.rs2_en
    cconflict3.io.rs1_addr  := io.rs1_addr
    cconflict3.io.rs2_addr  := io.rs2_addr
    cconflict3.io.rd_en     := io.rd3_en
    cconflict3.io.rd_addr   := io.rd3_addr

    io.conflict := cconflict1.io.conflict || cconflict2.io.conflict || cconflict3.io.conflict
}

