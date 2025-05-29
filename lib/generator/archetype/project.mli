include Types.ARCHETYPE

val empty_project
  :  project_name:string option
  -> project:Kohai_model.Described_item.t option
  -> unit
  -> Input.t

val project_without_state
  :  project_name:string option
  -> project:Kohai_model.Described_item.t option
  -> Input.t
  -> Input.t

val project_without_content
  :  project_name:string option
  -> project:Kohai_model.Described_item.t option
  -> Kohai_model.State.t
  -> Input.t

val project
  :  project_name:string option
  -> project:Kohai_model.Described_item.t option
  -> Kohai_model.State.t
  -> Input.t
  -> Input.t
