for sen in 2750; do
	for gauss in 20; do
		gauss=$(($sen * $gauss))
		steps/train_deltas.sh --cmd "$train_cmd" $sen $gauss data/train/d_dev data/lang exp/mono_ali exp/tri1_${sen}_${gauss} || exit 1;
		
