#!/bin/bash
#SBATCH --job-name=preprocessing
#SBATCH --output=preprocessing.log
#SBATCH --cpus-per-task=1
#SBATCH --mem=32G

module load CUDA/9.1.85
module load cuDNN/7.0.5-CUDA-9.1.85
module load Python/3.6.6-foss-2018b

REPO_HOME="/home/staudfel/git/OpenNMT-py"
DATA_HOME="/home/staudfel/data"

echo "Starting venv"
source ${REPO_HOME}/venv/bin/activate

echo "Cleaning up"
rm ${DATA_HOME}/results/abstractive_bottomup/preprocessed_cnndm/CNNDM.valid*.pt
rm ${DATA_HOME}/results/abstractive_bottomup/preprocessed_cnndm/CNNDM.vocab*.pt
rm ${DATA_HOME}/results/abstractive_bottomup/preprocessed_cnndm/CNNDM.train*.pt



echo "Run Preprocessing"
python ${REPO_HOME}/preprocess.py -train_src ${HOME}/data/cnndm/train.txt.src \
                     -train_tgt ${DATA_HOME}/cnndm/train.txt.tgt.tagged \
                     -valid_src ${DATA_HOME}/cnndm/val.txt.src \
                     -valid_tgt ${DATA_HOME}/cnndm/val.txt.tgt.tagged \
                     -save_data ${DATA_HOME}/results/abstractive_bottomup/preprocessed_cnndm/CNNDM \
                     -src_seq_length 10000 \
                     -tgt_seq_length 10000 \
                     -src_seq_length_trunc 400 \
                     -tgt_seq_length_trunc 100 \
                     -dynamic_dict \
                     -share_vocab #\
                     #-shard_size 524288000

echo "---------------- FINISHED ----------------"
