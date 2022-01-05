#!/bin/bash
##SBATCH --exclusive                      # Do not share node
##SBATCH --mail-type=FAIL                 # Notify user by email in case of job failure
##SBATCH --nodes=1                        # Specify number of nodes
#SBATCH --job-name=carlofff                   # Specify job name
#SBATCH --partition=gpu                   # Specify partition name
#SBATCH --chdir=/work/gbuerger            # 
#SBATCH --gpus=2                          # 
#SBATCH --mem=256G                        # 
#SBATCH --time=12:00:00                   # Set a limit on the total run time
#SBATCH --output=%x.out                   # File name for standard output
#SBATCH --error=%x.log               # File name for standard error output

module purge

module load lib/double-conversion system/CUDA system/CUDAcore devel/CMake/3.18.4-GCCcore-10.2.0 devel/Boost devel/protobuf devel/protobuf-python numlib/ScaLAPACK devel/Qt5 devel/pkg-config devel/gflags/2.2.2-GCCcore-10.2.0 devel/glog/0.5.0-GCCcore-10.2.0 devel/Doxygen numlib/cuDNN lang/SciPy-bundle

srun octave -W ~/carlofff/carlofff.m
