let path =
  let docv = "PATH"
  and validate str = str |> Yocaml.Path.from_string |> Result.ok
  and pp = Yocaml.Path.pp in
  Cmdliner.Arg.conv ~docv (validate, pp)
;;

let port =
  let docv = "PORT"
  and validate str =
    match int_of_string_opt str with
    | None -> Result.error (str ^ " is not a valid port")
    | Some x when x < 0 -> Result.error (str ^ " must be positive")
    | Some x when x > 9999 -> Result.error (str ^ " must be lower than 9999")
    | Some x -> Result.ok x
  and pp ppf = Format.fprintf ppf "%04d" in
  Cmdliner.Arg.conv' ~docv (validate, pp)
;;

let log_level =
  let docv = "LOG_LEVEL"
  and validate str =
    match str |> String.trim |> String.lowercase_ascii with
    | "a" | "app" -> Result.ok `App
    | "i" | "info" -> Result.ok `Info
    | "e" | "err" | "error" -> Result.ok `Error
    | "w" | "warn" | "warning" -> Result.ok `Warning
    | "d" | "debug" -> Result.ok `Debug
    | _ -> Result.error "Invalid log-level"
  and pp pf s =
    Format.fprintf
      pf
      "%s"
      (match s with
       | `App -> "app"
       | `Info -> "info"
       | `Error -> "error"
       | `Warning -> "warning"
       | `Debug -> "debug")
  in
  Cmdliner.Arg.conv' ~docv (validate, pp)
;;
