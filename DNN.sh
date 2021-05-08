#!/bin/bash
clear
#set-up for single machine or cluster based execution
. ./cmd.sh
#set the paths to binaries and other executables
[ -f path.sh ] && . ./path.sh
train_cmd=run.pl
decode_cmd=run.pl

feat_nj=1
train_nj=1
decode_nj=1

#================================================
#	SET SWITCHES
#================================================

rm_files=1
dat_prep=1

lng_prep_sw=1
mfcc_extract_sw=1

mono_train_sw=1
mono_test_sw=1

tri1_train_sw=1
tri1_test_sw=1

tri2b_train_sw=1
tri2b_test_sw=1

tri3b_train_sw=1
tri3b_test_sw=1

dnn_train_sw=1
dnn_test_sw=1


#================================================
#      Set Directories
#================================================

train_dir=data/train
test_dir=data/test
dev_dir=data/test

lang_dir=data/lang

graph_dir=graph
decode_dir=decode

exp=exp

echo ============================================================================
echo "                    DNN Hybrid Training                   "
echo ============================================================================

steps/align_fmllr.sh --nj "$train_nj" --cmd "$train_cmd" $train_dir $lang_dir $exp/tri3 $exp/tri3_ali || exit 1;

# DNN hybrid system training parameters

 steps/nnet2/train_tanh.sh --mix-up 5000 --initial-learning-rate 0.015 \
 --final-learning-rate 0.002 --num-hidden-layers 3 --minibatch-size 128 --hidden-layer-dim 256 \
 --num-jobs-nnet "$train_nj" --cmd "$train_cmd" --num-epochs 15 \
  $train_dir $lang_dir $exp/tri3_ali $exp/DNN_tri3_aligned_layer3_nodes256



echo ============================================================================
echo "                    DNN Hybrid Testing                    "
echo ============================================================================

steps/nnet2/decode.sh --cmd "$decode_cmd" --nj "$decode_nj" \
 $exp/tri3/$graph_dir $test_dir \
  $exp/DNN_tri3_aligned_layer3_nodes256/$decode_dir | tee $exp/DNN_tri3_aligned_layer3_nodes256/$decode_dir/decode.log

steps/nnet2/decode.sh --cmd "$decode_cmd" --nj "$decode_nj" \
 $exp/tri3/$graph_dir $dev_dir \
  $exp/DNN_tri3_aligned_layer3_nodes256/$decode_dir | tee $exp/DNN_tri3_aligned_layer3_nodes256/$decode_dir/decode.log



echo == Script is finished ==
