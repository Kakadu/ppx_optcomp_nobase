  $ echo "(lang dune 3.18)" > dune-project
  $ cat > dune <<EOF
  > (library (name lib1)
  >  (modules module1)
  >  (modes byte)
  >  (preprocessor_deps
  >    "test_imported/error/a.ml"
  >    "test_imported/error/b.ml"
  >    "test_imported/error/c.ml")
  >  (preprocess (pps ppx_optcomp_nobase)))
  > EOF
$ cat dune

  $ mv bad1.ml module1.ml
  $ dune build @all 2>&1 | grep "Big ooooooops."
  3 |   [%%error "Big ooooooops."]
  Error: Big ooooooops.


  $ mv bad2.ml module1.ml
  $ dune build @all 2>&1 | grep "Error"
  Error: This variant expression is expected to have type t

  $ rm -fr module1.ml
$ tree
  $ cat > module1.ml <<EOF
  > module Test_nested_error = struct
  >   [%% import "test_imported/error/a.ml" ]
  > end
  > EOF
  $ dune build @all 2>&1 | grep "Error"
  Error: nested error


  $ cat > module1.ml <<EOF
  > module Test_double_else = struct
  > [%% if true ]
  > let x = 1
  > [%% else ]
  > let x = 2
  > [%% else ]
  > let x = 3
  > [%% endif]
  > end
  > EOF

  $ dune build @all 2>&1 | grep "Error"
  Error: optcomp: second else clause.
  $ cat > module1.ml <<EOF
  > module Test_else_elif = struct
  >  [%% if true ]
  >  let x = 1
  >  [%% else ]
  >  let x = 2
  >  [%% elif false ]
  >  let x = 3
  >  [%% endif]
  > end
  > EOF
  $ dune build @all 2>&1 | grep "Error"
  Error: optcomp: elif after else clause.

  $ cat > module1.ml <<EOF
  > module Test_unterminated_if = struct
  > [%% if true ]
  > let x = a
  > end
  > EOF

  $ dune build @all 2>&1 | grep "Error"
  Error: optcomp: unterminated if
  $ cat > module1.ml <<EOF
  > module Test_import_nonexistent = struct
  > [%% import "non_existent_file.h"]
  > end
  > EOF

  $ dune build @all 2>&1 | grep "Error"
  Error: optcomp: cannot open imported file: ./non_existent_file.h: ./non_existent_file.h: No such file or directory
