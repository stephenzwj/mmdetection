#!/bin/bash
#PBS -P Project
#PBS -j oe
#PBS -N detecron2
#PBS -q volta_gpu
#PBS -l select=1:ncpus=10:mem=32gb:ngpus=1
#PBS -l walltime=12:00:00

cd $PBS_O_WORKDIR;
echo "Running on dir ${PBS_O_WORKDIR}";
np=$(cat ${PBS_NODEFILE} | wc -l);
find /hpctmp/zwj/ -type f -exec touch -am {} \;
image="/hpctmp/zwj/SIF/cv-pytorch-1.10.0-cuda11.3-cudnn8:v0.1.sif"
num_gpus=$(nvidia-smi -L | wc -l)
echo "Running with $num_gpus GPUs"
singularity exec -e $image bash ./scripts/get_command_outputs.sh "./scripts/run_training.sh -d ${num_gpus}" > hpc_outputs/out-$PBS_JOBID.txt 2>&1;