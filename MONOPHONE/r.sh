#!/bin/bash

arpa2fst --disambig-symbol=#0 --read-symbol-table= data/lang/words.txt data/local/lmDir/lm.gz data/lang/G.fst

echo
echo "===== run.sh script is finished ====="
echo
