object Config{
  val soc = false
}

object TopMain extends App {
  // if(Config.soc){
  //   (new chisel3.stage.ChiselStage).execute(args, Seq(
  //   chisel3.stage.ChiselGeneratorAnnotation(() => new SocTop()),
  //   firrtl.stage.RunFirrtlTransformAnnotation(new AddModulePrefix()),
  //   ModulePrefixAnnotation("ysyx_210888_")
  //   ))
  // }else{
    (new chisel3.stage.ChiselStage).execute(args, Seq(
    chisel3.stage.ChiselGeneratorAnnotation(() => new SimTop())
    ))
  // }
}
