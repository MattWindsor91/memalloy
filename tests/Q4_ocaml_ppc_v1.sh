./comparator \
    -desc "Searching for a miscompilation from OCaml to Power" \
    -violates models/ocaml.cat \
    -alsosatisfies models/ocaml_restrictions.cat \
    -satisfies models/ppc.cat \
    -mapping mappings/ocaml_ppc_v1.als \
    -arch OCaml \
    -events 4 \
    -arch2 PPC \
    -events2 4 \
    -expect 1 \
    $@
