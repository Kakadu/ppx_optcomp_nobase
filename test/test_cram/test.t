  $ ./pp_optcomp.exe - -impl <<-EOF
  > [%% if not_defined_permissive abc ]
  > let _ = "abc is NOT defined"
  > [%% else]
  > let _ = "abc is defined"
  > [%%endif]
  let _ = "abc is NOT defined"

  $ ./pp_optcomp.exe -cookie ppx_optcomp.env='env ~abc:(Defined 1)' - -impl <<-EOF
  > [%%if defined abc ]
  > let _ = "abc is defined"
  > [%%else]
  > let _ = "abc is NOT defined"
  > [%%endif]
  let _ = "abc is defined"
