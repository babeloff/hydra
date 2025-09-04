 Error: nu::parser::error
 │ │   x Invalid literal
 │ │      ,-[$SRC_DIR/conda_build.nu:159:61]
 │ │  158 |     if ($pkg_conf_dir | path exists) {
 │ │  159 |         let conf_files = (ls $pkg_conf_dir | where name =~ "\.conf$" | get name)
 │ │      :                                                             ^^^^|^^^
 │ │      :                                                                 `-- unrecognized escape after '\' in string
 │ │  160 |         for conf_file in $conf_files {
