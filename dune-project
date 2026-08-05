(lang dune 3.18)

(generate_opam_files true)

(maintainers "Dmitrii Kosarev a.k.a. Kakadu <kakadu.hafanana@gmail.com>")

(authors "Jane Street Group, LLC")

(homepage "https://github.com/janestreet/ppx_optcomp")

(bug_reports "https://github.com/janestreet/ppx_optcomp/issues")

(license MIT)

(package
 (name ppx_optcomp_nobase)
 (version 0.17.1)
 (synopsis "Optional compilation for OCaml")
 (description "Part of the Jane Street's PPX rewriters collection.")
 (depends
  (ocaml
   (>= 4.14.2))
  (ppxlib
   (>= 0.38.0))))
