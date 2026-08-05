(lang dune 3.18)

(generate_opam_files true)

(name ppx_optcomp_nobase)

(maintainers "Dmitrii Kosarev a.k.a. Kakadu <kakadu.hafanana@gmail.com>")

(authors "Jane Street Group, LLC")

(homepage "https://github.com/Kakadu/ppx_optcomp_nobase")

(bug_reports "https://github.com/Kakadu/ppx_optcomp_nobase/issues")

(source
 (github Kakadu/ppx_optcomp_nobase))

(license MIT)

(package
 (name ppx_optcomp_nobase)
 (version 0.17.1)
 (synopsis "Optional compilation for OCaml")
 (description
  "A variant of ppx_optcomp with lesser dependecies. Original ppx_optcomp is a part the Jane Street's PPX rewriters collection.")
 (depends
  (ocaml
   (>= 4.14.2))
  (ppxlib
   (>= 0.38.0))))
