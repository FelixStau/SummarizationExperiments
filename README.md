# Summarization Experiments

## Structure
```
├── README.md
├── abstractive
│   ├── OpenNMT
│   └── bin
│       ├── getData.sh
│       ├── inference.sh
│       ├── preprocessing.sh
│       ├── train_transformers.sh
│       └── training.sh
└── unsupervised
    └── UnsupervisedMT
```
## Usage
First of all, we need to update/checkout all further submodules to fetch the
required code.
```
git submodule update --init --recursive
```
After this step you should be able to see the fetched code within the
`abstractive/OpenNMT/` and the `unsupervised/UnsupervisedMT` directory.
Now, we need to download the required test and trainings data sets. Therefore,
we are using the given `getData.sh` script within the `abstractive/OpenNMT/bin/` directory.
You can choose within this script which of the available datasets you would
like to download (CNN or Gigaword).
```
 19 echo "--> Download CNN-DM"
 20 mkdir -p $CNNDM_HOME || error
 21 curl $CNNDM_DATASET --output $CNNDM_HOME/cnndm.tar.gz || error
 22 tar -C $CNNDM_HOME -zxvf $CNNDM_HOME/cnndm.tar.gz || error
 23 rm -f $CNNDM_HOME/cnndm.tar.gz
 24
 25 #echo "--> Download GIGAWORD"
 26 #mkdir -p $GIGAWORD_HOME || error
 27 #curl $GIGAWORD_DATASET --output $GIGAWORD_HOME/gigaword.tar.gz || error
 28 #tar -C $GIGAWORD_HOME -zxvf $GIGAWORD_HOME/gigaword.tar.gz || error
 29 #rm -f $GIGAWORD_HOME/gigaword.tar.gz || error
```
If you are working on the CVUT-CIIRC Cluster you should run this script through
calling the SLURM job manager.
```
sbatch getData.sh
```
This command submits the script in form of a job to the cluster. SLURM will
schedule the job asap. You can verify that with the `squeue` command, which
will print out the current overview over all scheduled jobs.
### Preprocessing
Next, we can start the dataset preprocessing. Therefore, we need to update the
root paths within the `preprocessing.sh` scripts, so that it can find the
downloaded datasets.
```
REPO_HOME="/path/to/repo/home"
DATA_HOME="/path/to/datasets"

echo "Starting venv"
source ${REPO_HOME}/venv/bin/activate

echo "Cleaning up"
rm ${DATA_HOME}/results/abstractive_bottomup/preprocessed_cnndm/CNNDM.valid*.pt
rm ${DATA_HOME}/results/abstractive_bottomup/preprocessed_cnndm/CNNDM.vocab*.pt
rm ${DATA_HOME}/results/abstractive_bottomup/preprocessed_cnndm/CNNDM.train*.pt
```
We can submit now the job to the cluster with the following command.
```
sbatch Preprocessing.sh
```
### Training
Before we can start the training, we also need to change the paths so that they
are fitting to the given structure. Change the following paths respectively.
```

12 REPO_HOME="/path/to/git/OpenNMT-py"
13 DATA_HOME="/path/to/data"

...

27 -save_model ${DATA_HOME}/results/abstractive_bottomup/model/demo_model \
28 -data ${DATA_HOME}/results/abstractive_bottomup/preprocessed_cnndm/CNNDM
```
Finally, we can start the training by submitting the job to the cluster.
```
sbatch training.sh
```
This time the scheduler will need some time, because the training script uses
four GPUs and a whole bunch of RAM. 
### Inference
Again, change the paths so that they are fitting to your directory structure.
```
10 REPO_HOME="/path/to/git/OpenNMT-py"
11 DATA_HOME="/path/to/data"

...
26 -model ${DATA_HOME}/results/abstractive_bottomup/model/pretrained_en_model.pt \
27 -src ${DATA_HOME}/cnndm/test.txt.src \
28 -output ${REPO_HOME}/run/cnndm.out \
```
Finally, we can start the inference by submitting the job to the cluster.
```
sbatch inference.sh
```





