type t =
  { page : Page.t
  ; articles : Blog_entry.t list
  }

let make page articles = { page; articles }

let normalize { page; articles } =
  let open Yocaml.Data in
  Page.normalize page
  @ [ "articles", list_of Blog_entry.normalize (Blog_entry.sort articles)
    ; "has_articles", Model.Model_util.exists_from_list articles
    ]
;;
