let as_static
      (type a)
      (module R : Intf.RESOLVER)
      (module A : Yocaml.Required.DATA_INJECTABLE with type t = a)
      templates
  =
  List.fold_left
    (fun task template ->
       let open Yocaml.Task in
       task
       >>> Yocaml_jingoo.Pipeline.as_template
             (module A)
             (R.Source.template template))
    (Yocaml.Task.lift ~has_dynamic_dependencies:false (fun x -> x))
    templates
;;

let as_dynamic
      (type a)
      (module R : Intf.RESOLVER)
      (module A : Yocaml.Required.DATA_INJECTABLE with type t = a)
      templates
  =
  let open Yocaml.Task in
  Dynamic.on_static @@ as_static (module R) (module A) templates
;;
