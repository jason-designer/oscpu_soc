import chisel3._
import chisel3.util._
import chisel3.util.experimental._
import scala.math._

trait CacheParameters {
    val OffsetWidth     = 6     // 这个大于3，因为dcache写入的最低单位是64位。
                                // 因为后面的axi的transfer大小设为了4Byte（这个条件要求它>=2）
    val IndexWidth      = 5
    val TagWidth        = 64 - OffsetWidth - IndexWidth // 三个数之和为64

    val CacheWay        = 2

    val CacheLineNum    = scala.math.pow(2, IndexWidth).toInt
    val CacheLineByte   = scala.math.pow(2, OffsetWidth).toInt
    val CacheLineWidth  = CacheLineByte * 8
    val AxiArLen        = scala.math.pow(2, (OffsetWidth - 3)).toInt
}

class ICacheIO extends Bundle{
    val addr        = Input(UInt(64.W))
    val en          = Input(Bool())
    val data        = Output(UInt(32.W))
    val data_ok     = Output(Bool())
}

class ICacheAxiIO extends Bundle with CacheParameters{
    val req     = Output(Bool())
    val addr    = Output(UInt(64.W))
    val valid   = Input(Bool())
    val data    = Input(UInt(CacheLineWidth.W))
}

// 同步ram，组合逻辑在寄存器前面，也就是延迟在idreg前面，以此减轻decode的延迟
// 虽然初始化为data_ok=true,但是此时的data是无效的，在data_ok初始化为true仅仅是为了避免复位时就stall
// icache miss后等待axi返回数据的时候，addr需要保存不变才能正确更新cache
class ICache extends Module with CacheParameters{
    val io = IO(new Bundle{
        val imem    = new ICacheIO
        val axi     = new ICacheAxiIO
    })
    // addr
    val tag_addr    = io.imem.addr(OffsetWidth + IndexWidth + TagWidth - 1, OffsetWidth + IndexWidth)
    val index_addr  = io.imem.addr(OffsetWidth + IndexWidth - 1, OffsetWidth)
    val offset_addr = io.imem.addr(OffsetWidth - 1, 0)
    // cache data
    val v1      = RegInit(VecInit(Seq.fill(CacheLineNum)(false.B)))
    val age1    = RegInit(VecInit(Seq.fill(CacheLineNum)(false.B)))
    val tag1    = RegInit(VecInit(Seq.fill(CacheLineNum)(0.U(TagWidth.W))))
    val block1  = RegInit(VecInit(Seq.fill(CacheLineNum)(0.U(CacheLineWidth.W))))
    val v2      = RegInit(VecInit(Seq.fill(CacheLineNum)(false.B)))
    val age2    = RegInit(VecInit(Seq.fill(CacheLineNum)(false.B)))
    val tag2    = RegInit(VecInit(Seq.fill(CacheLineNum)(0.U(TagWidth.W))))
    val block2  = RegInit(VecInit(Seq.fill(CacheLineNum)(0.U(CacheLineWidth.W))))
    // cacheway output
    val hit1    = tag_addr === tag1(index_addr) && v1(index_addr) === true.B
    val hit2    = tag_addr === tag2(index_addr) && v2(index_addr) === true.B
    val data1   = (block1(index_addr) >> (offset_addr << 3))(31, 0)
    val data2   = (block2(index_addr) >> (offset_addr << 3))(31, 0)
    //
    val hit     = hit1 || hit2
    val data    = Mux(hit2, data2, Mux(hit1, data1, 0.U))   // 两个都hit就随便取一个,按理说不会两个都hit
    val data_ok = io.imem.en && hit
    // update age
    // 当en且hit1和hit2的值不同时，age才需要发生改变
    age1(index_addr) := Mux(io.imem.en && (hit1 ^ hit2), hit1, age1(index_addr))
    age2(index_addr) := Mux(io.imem.en && (hit1 ^ hit2), hit2, age2(index_addr))
    // icache output
    io.imem.data    := RegNext(data)
    io.imem.data_ok := RegNext(data_ok, true.B) //data_ok初始化为true仅仅是为了避免复位时就stall


    //state machine
    val idle :: miss :: Nil = Enum(2)
    val state = RegInit(idle)

    switch(state){
        is(idle){
            when(!hit && io.imem.en) {state := miss}
        }
        is(miss){
            when(io.axi.valid) {state := idle}
        }
    }

    //axi request signals
    io.axi.req    := state === miss
    io.axi.addr   := io.imem.addr & Cat(Fill(IndexWidth + TagWidth, 1.U(1.W)), 0.U(OffsetWidth.W))

    // update cache data
    val age = Cat(age2(index_addr), age1(index_addr))
    val updateway2 = age === "b01".U    
    val updateway1 = !updateway2        // 特殊情况都默认换掉way1
    val update = state === miss && io.axi.valid
    block1(index_addr)   := Mux(update && updateway1, io.axi.data, block1(index_addr))
    tag1(index_addr)     := Mux(update && updateway1, tag_addr, tag1(index_addr))
    v1(index_addr)       := Mux(update && updateway1, true.B, v1(index_addr))
    block2(index_addr)   := Mux(update && updateway2, io.axi.data, block2(index_addr))
    tag2(index_addr)     := Mux(update && updateway2, tag_addr, tag2(index_addr))
    v2(index_addr)       := Mux(update && updateway2, true.B, v2(index_addr))
}



