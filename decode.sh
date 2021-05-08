#!/bin/bash

. ./path.sh || exit 1
. ./cmd.sh || exit 1

echo 
echo "==== TRI3 DECODING ===="
echo
utils/mkgraph.sh data/lang exp/tri3b exp/tri3b/graph || exit 1
steps/decode.sh --nj $nj --cmd "$decode_cmd" exp/tri3b/graph data/test exp/tri3b/decode || exit 1
echo
echo "===== Decode.sh script is finished ====="
echo
