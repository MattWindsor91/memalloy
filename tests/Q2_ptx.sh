./comparator \
    -desc "Finding executions that become disallowed when moving from PTX_orig to PTX_cumul." \
    -satisfies models/ptx_orig.cat \
    -violates models/ptx_cumul.cat \
    -arch PTX \
    -events 5 \
    -iter \
    -satisfies models/normws.cat \
    -satisfies models/ptx_singlegl.cat \
    -fencerels \
    $@