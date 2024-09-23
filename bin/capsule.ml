module C = Conv
module A = Arg

let program () = Yocaml.Eff.log ~level:`Debug "Hello World"
let () = Yocaml_eio.run ~level:`Debug program
