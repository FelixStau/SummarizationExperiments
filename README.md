# Summarization Experiments

## Structure
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

