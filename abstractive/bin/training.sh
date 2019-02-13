#!/bin/bash
#SBATCH --job-name=training
#SBATCH --output=training.log
#SBATCH --cpus-per-task=1
#SBATCH --gres=gpu:4
#SBATCH --mem=128G

module load CUDA/10.0.130
module load cuDNN/7.1.4.18-fosscuda-2018b
module load Python/3.6.6-foss-2018b

REPO_HOME="/home/staudfel/git/OpenNMT-py"
DATA_HOME="/home/staudfel/data"

echo "Starting venv"
source ~/modules.sh
source ${REPO_HOME}/venv/bin/activate

echo "NIVIDIA Driver Output"
nvidia-smi

echo "Export CUDA Devices"
export CUDA_VISIBLE_DEVICES=0,1,2,3

echo "Run Training"
python ${REPO_HOME}/train.py \
	        -save_model ${DATA_HOME}/results/abstractive_bottomup/model/demo_model \
                -data ${DATA_HOME}/results/abstractive_bottomup/preprocessed_cnndm/CNNDM
                -copy_attn \
                -global_attention mlp \
                -word_vec_size 128 \
                -rnn_size 512 \
                -layers 1 \
                -encoder_type brnn \
                -train_steps 200000 \
                -max_grad_norm 2 \
                -dropout 0. \
                -batch_size 16 \
                -optim adagrad \
                -learning_rate 0.15 \
                -adagrad_accumulator_init 0.1 \
                -reuse_copy_attn \
                -copy_loss_by_seqlength \
                -bridge \
                -seed 777 \
                --world_size 4 \
                --gpu_ranks "0 1 2 3"

echo "---------------- FINISHED ----------------"
