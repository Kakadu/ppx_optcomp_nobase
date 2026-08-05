open Ppxlib
module List = ListLabels

let wrap ~f ~self x =
  match x with
  | Pexp_function cs -> Pexp_function (List.filter_map cs ~f)
  | Pexp_match (e, cs) -> Pexp_match (self e, List.filter_map cs ~f)
  | Pexp_try (e, cs) -> Pexp_try (self e, List.filter_map cs ~f)
  | _ -> x