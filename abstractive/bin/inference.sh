#SBATCH --job-name=inference
#SBATCH --output=inference.log
#SBATCH --cpus-per-task=2
#SBATCH --mem=128G

module load CUDA/9.1.85
module load cuDNN/7.0.5-CUDA-9.1.85
module load Python/3.6.6-foss-2018b

REPO_HOME="/home/staudfel/git/OpenNMT-py"
DATA_HOME="/home/staudfel/data"

export LC_ALL=en_US.UTF-8

echo "NIVIDIA Driver Output"
nvidia-smi

echo "Starting venv"
source ~/modules.sh
source ${REPO_HOME}/venv/bin/activate

echo "Run Inference"
python ${REPO_HOME}/translate.py \
                    -batch_size 20 \
                    -beam_size 5 \
                    -model ${DATA_HOME}/results/abstractive_bottomup/model/pretrained_en_model.pt \
                    -src ${DATA_HOME}/cnndm/test.txt.src \
                    -output ${REPO_HOME}/run/cnndm.out \
                    -min_length 35 \
                    -stepwise_penalty \
                    -coverage_penalty summary \
                    -beta 5 \
                    -length_penalty wu \
                    -alpha 0.9 \
                    -verbose \
                    -block_ngram_repeat 3 \
                    -ignore_when_blocking "." "</t>" "<t>"

echo "---------------- FINISHED ----------------"
