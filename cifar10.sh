#!/bin/bash
#SBATCH --job-name=cifar10      # Specify job name
#SBATCH --partition=gpu        # Specify partition name
##SBATCH --nodes=1              # Specify number of nodes
##SBATCH --constraint=k80       # Constraint for node selection
##SBATCH --mem=0                # Use entire memory of node
##SBATCH --exclusive            # Do not share node
##SBATCH --time=00:01:00        # Set a limit on the total run time
##SBATCH --mail-type=FAIL       # Notify user by email in case of job failure
#SBATCH --account=bb1152       # Charge resources on this project account
#SBATCH --output=cifar10.o%j    # File name for standard output
#SBATCH --error=cifar10.e%j     # File name for standard error output

module purge
module load cuda/10.0.130

srun caffe train -solver models/cifar10/NW.24/CatRaRE_solver.prototxt
