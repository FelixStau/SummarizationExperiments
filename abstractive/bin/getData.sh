#!/bin/bash
#SBATCH --job-name=downloadData
#SBATCH --output=getdata.log
#SBATCH --cpus-per-task=1
#SBATCH --mem=32G

DATA_HOME="$PWD/data"
CNNDM_HOME="$DATA_HOME/CNNDM"
GIGAWORD_HOME="$DATA_HOME/GIGAWORD"

CNNDM_DATASET="https://s3.amazonaws.com/opennmt-models/Summary/cnndm.tar.gz"
GIGAWORD_DATASET=""

function error {
	echo "--> ERROR: Something went terribly wrong.!"
	exit 1
}

echo "--> Download CNN-DM"
mkdir -p $CNNDM_HOME || error 
curl $CNNDM_DATASET --output $CNNDM_HOME/cnndm.tar.gz || error 
tar -C $CNNDM_HOME -zxvf $CNNDM_HOME/cnndm.tar.gz || error
rm -f $CNNDM_HOME/cnndm.tar.gz

#echo "--> Download GIGAWORD"
#mkdir -p $GIGAWORD_HOME || error
#curl $GIGAWORD_DATASET --output $GIGAWORD_HOME/gigaword.tar.gz || error
#tar -C $GIGAWORD_HOME -zxvf $GIGAWORD_HOME/gigaword.tar.gz || error
#rm -f $GIGAWORD_HOME/gigaword.tar.gz || error

echo "---------------- FINISHED ----------------"
