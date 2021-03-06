#!/usr/bin/env bash
if [ $# -lt 1 ]
  then
    echo "Proper usage: ./10fold_cv.sh <algorithm>"
    echo "Example: ./gpu_10fold_cv.sh SdA.py"
    exit
fi

#rm ../results/*.txt
#rm ../results/*.out

DBN_STR="DBN.py"
if [ $1 == $DBN_STR ]; then
	rm ../results/testPerfDBN.txt
else
	rm ../results/testPerfSdA.txt
fi

for i in `seq 1 9`;
do
	python pickle_data.py $i
	echo "Running fold $i..."
	THEANO_FLAGS='cuda.root=/usr/local/cuda-7.0,floatX=float32,device=gpu0,nvcc.fastmath=True' python $1 $i # >> ../results/fold0$i.out
	rm ../data/diabetes.pkl.gz
	echo ""
done

python pickle_data.py 10
echo "Running fold 10..."
THEANO_FLAGS='cuda.root=/usr/local/cuda-7.0,floatX=float32,device=gpu0,nvcc.fastmath=True' python $1 10 #>> ../results/fold10.out


if [ $1 == $DBN_STR ]; then
	python crossValMean.py DBN
else
	python crossValMean.py SdA
fi

#cat ../results/01_p_values.txt ../results/02_p_values.txt ../results/03_p_values.txt ../results/04_p_values.txt ../results/05_p_values.txt ../results/06_p_values.txt ../results/07_p_values.txt ../results/08_p_values.txt ../results/09_p_values.txt ../results/10_p_values.txt > ../results/p_values.txt

#cat ../results/01_labels.txt ../results/02_labels.txt ../results/03_labels.txt ../results/04_labels.txt ../results/05_labels.txt ../results/06_labels.txt ../results/07_labels.txt ../results/08_labels.txt ../results/09_labels.txt ../results/10_labels.txt > ../results/labels.txt
