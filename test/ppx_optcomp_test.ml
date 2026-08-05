[@@@ocamlformat "profile=default"]
[@@@ocaml.warnerror "-unused-type-declaration"]
[@@@ocaml.warning "-unused-type-declaration"]
[@@@ocaml.warnerror "-unused-constructor"]
[@@@ocaml.warning "-unused-constructor"]

open Printf

module Test_simple_if = struct
  [%%if true]

  let x = "OK"

  [%%else]

  let x = "BAD"

  [%%endif]

  let () = printf "%s\n" x
end

module Test_comments = struct
  [%%if (* comment *) true]

  let x = "OK"

  [%%else]

  let x = "BAD"

  (* comment
  *)
  [%%endif]

  let () = printf "%s" x
end

module Test_nested_if = struct
  [%%define ABC true]
  [%%define xyz false]
  [%%if ABC]

  let x = "OK1"

  [%%else]
  [%%if xyz]

  let x = "BAD1"

  [%%endif]

  let x = "BAD2"

  [%%endif]

  let y = "OK2"
  let () = printf "%s %s" x y
end

module Test_defined = struct
  [%%define FOO]
  [%%undef BAR]
  [%%if defined FOO]

  let x = "OK1"

  [%%else]

  let x = "BAD1"

  [%%endif]
  [%%if defined BAR]

  let y = "BAD2"

  [%%else]

  let y = "OK2"

  [%%endif]

  let () = printf "%s %s\n" x y
end

module Test_import_order = struct
  [%%define A true]
  [%%define B A]
  [%%import "test_imported/order/cd.ml"]
  [%%define E D]
end

module Test_import_config = struct
  [%%import "test_imported/config.h"]
  [%%import "test_imported/config.h"] (* try importing twice *)
  [%%if defined FOO]

  let x = "OK"

  [%%else]

  let x = "BAD"

  [%%endif]

  let () = printf "%s\n" x
end

module Test_order = struct
  let () = printf "%s" "a"
  let () = printf "%s" "b"

  [%%if true]

  let () = printf "%s" "c"
  let () = printf "%s" "d"

  [%%define ABC]

  let () = printf "%s" "e"
  let () = printf "%s" "f"

  [%%endif]
  [%%if false]
  [%%else]

  let () = printf "%s" "g"
  let () = printf "%s" "h"

  [%%define ABC]

  let () = printf "%s" "i"
  let () = printf "%s" "j"

  [%%endif]
  [%%if false]
  [%%elif true]

  let () = printf "%s" "k"
  let () = printf "%s" "l"

  [%%define ABC]

  let () = printf "%s" "m"
  let () = printf "%s" "n"

  [%%endif]

  let () = printf "%s" "o"
  let () = printf "%s" "p"

  [%%define ABC]

  let () = printf "%s" "q"
  let () = printf "%s\n" "r"
end

module Test_show = struct
  [%%if show (3 + (3 * 3)) > 0]

  let () = printf "%s\n" "OK"

  [%%endif]
  [%%define x "OK"]

  module A = struct
    [%%define y (show x)]
  end

  [%%define x "BAD"]
end

(*

[%%expect{|
File "examples.mlt", line 195, characters 9-23::
SHOW 12
File "examples.mlt", line 201, characters 17-25::
SHOW "OK"
OK
|}]
*)
module Test_optional_match = struct
  [%%define FOO]
  [%%undef BAR]

  type t =
    | OK1 of string
    | OK2 of string * int [@if defined FOO]
    | BAD of int [@if defined BAR]

  let () =
    match (OK2 ("OK", 2) : t) with
    | OK1 s -> printf "%s" s
    | ((OK2 (y, z)) [@if defined FOO]) -> printf "%s %i\n" y z
    | ((BAD _) [@if defined BAR]) ->
        printf "This will cause error if not dropped %s" undefined_ident

  let f = function OK1 _ -> "OK" | OK2 _ -> "OK" | ((BAD _) [@if defined BAR]) -> "BAD"

  let () = printf "%s" (f (OK1 "abc"))
end

[%%define FOO]

module Test_signature : sig
  [%%if defined FOO]

  type t

  [%%else]

  type s

  [%%endif]

  type u
end = struct
  [%%if defined FOO]

  type t

  [%%else]

  type s

  [%%endif]

  type u
end

module Test_drop_attr = struct
  [%%if false]

  external abc : unit -> int = "abc" [@@noalloc]

  [%%endif]

  type s
end

module Test_qualified_name = struct
  [%%optcomp.define FOO 3]

  type t = A | B [@optcomp.if FOO = 3]
end

module Test_optcomp_first = struct
  type t = A | B [@if false] [@@deriving sexp]
end

module Test_ifndef_quirk = struct
  [%%ifndef FOO_NOT_USED_BEFORE]
  [%%define FOO_NOT_USED_BEFORE]
  [%%endif]
end

module Test_scoping = struct
  [%%define x "OK"]

  module B = struct
    module A = struct
      [%%define x "BAD1"]
      [%%ifdef x]

      let () = printf "%s\n" "OK2"

      [%%endif]
    end

    [%%define y (show x)]
  end

  [%%define x "BAD2"]
end

module Test_scoping2 = struct
  [%%define x "<top>"]

  module A = struct
    [%%define x "A"]
    [%%define y (show ("in A", x))]
  end

  module B = struct
    [%%define y (show ("in B", x))]
  end

  [%%define y (show ("at toplevel", x))]
end

module Test_scoping3 = struct
  module A = struct
    [%%define x "A"]
    [%%define y (show ("in A", x))]
  end

  let () = ()

  [%%define x "top"]

  let () = ()

  [%%define y (show ("between", x))]

  let () = ()

  module B = struct
    [%%define y (show ("in B", x))]
  end
end

(* Test env is preserved in toplevel *)
[%%define x "test_toplevel"]
[%%define y x]
[%%define y (show y)]
