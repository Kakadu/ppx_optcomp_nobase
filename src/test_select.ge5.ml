open Ppxlib
module List = ListLabels

let wrap ~f ~self x =
  match x with
  | Pexp_function (params, constr, Pfunction_cases (cs, loc, attr)) ->
    Pexp_function (params, constr, Pfunction_cases (Stdlib.List.filter_map f cs, loc, attr))
  | Pexp_match (e, cs) -> Pexp_match (self e, Stdlib.List.filter_map f cs)
  | Pexp_try (e, cs) -> Pexp_try (self e, Stdlib.List.filter_map f cs)
  | _ -> x