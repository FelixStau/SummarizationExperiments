#!/bin/bash
#SBATCH --job-name=train_transformer
#SBATCH --output=training_transformer.log
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

echo "Run Transformer Training"
python ${REPO_HOME}/train.py \
	        -save_model ${DATA_HOME}/results/abstractive_bottomup/model/demo_model_transformer \
                -data ${DATA_HOME}/results/abstractive_bottomup/preprocessed_cnndm/CNNDM
                -layers 4 \
                -rnn_size 512 \
                -word_vec_size 512 \
                -max_grad_norm 0 \
                -optim adam \
                -encoder_type transformer \
                -decoder_type transformer \
                -position_encoding \
                -dropout 0\.2 \
                -param_init 0 \
                -warmup_steps 8000 \
                -learning_rate 2 \
                -decay_method noam \
                -label_smoothing 0.1 \
                -adam_beta2 0.998 \
                -batch_size 4096 \
                -batch_type tokens \
                -normalization tokens \
                -max_generator_batches 2 \
                -train_steps 200000 \
                -start_checkpoint_at 8 \
                -accum_count 4 \
                -share_embeddings \
                -copy_attn \
                -param_init_glorot \
                -world_size 4 \
                -gpu_ranks 0 1 2 3

echo "---------------- FINISHED ----------------"
