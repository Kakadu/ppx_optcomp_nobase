module Test_optional_variant = struct
  [%%define FOO]
  [%%undef BAR]
  [%%define BAZ 3]

  type t =
    | OK_1
    | OK_2 [@if defined FOO]
    | OK_3 [@if not (defined BAR)]
    | BAD_4 [@if BAZ < 0]
    | OK_5

  let _ : t * t * t * t = OK_1, OK_2, OK_3, OK_5
  let _ : t = BAD_4
end
