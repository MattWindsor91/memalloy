./comparator \
    -desc "Finding a bug in a buggy OpenCL/PTX mapping (new PTX model)" \
    -arch OpenCL \
    -arch2 PTX \
    -violates models/opencl_scoped.cat \
    -satisfies models/ptx_cumul.cat \
    -mapping mappings/fences_as_relations/opencl_ptx_buggy.als \
    -events 5 \
    -events2 5 \
    -expect 1 \
    -fencerels \
    $@
