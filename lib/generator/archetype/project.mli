include Types.ARCHETYPE

val empty_project
  :  activity_url:Yocaml.Path.t
  -> project_name:string option
  -> project:Kohai_model.Described_item.t option
  -> unit
  -> Input.t

val project_without_state
  :  activity_url:Yocaml.Path.t
  -> project_name:string option
  -> project:Kohai_model.Described_item.t option
  -> Input.t
  -> Input.t

val project_without_content
  :  activity_url:Yocaml.Path.t
  -> project_name:string option
  -> project:Kohai_model.Described_item.t option
  -> Kohai_model.State.t
  -> Input.t

val project
  :  activity_url:Yocaml.Path.t
  -> project_name:string option
  -> project:Kohai_model.Described_item.t option
  -> Kohai_model.State.t
  -> Input.t
  -> Input.t
