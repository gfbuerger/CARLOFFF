#!/bin/bash
##SBATCH --exclusive            # Do not share node
##SBATCH --mail-type=FAIL       # Notify user by email in case of job failure
##SBATCH --nodes=1              # Specify number of nodes
##SBATCH --constraint=m40       # Constraint for node selection
#SBATCH --job-name=carlofff         # Specify job name
#SBATCH --partition=gpu         # Specify partition name
#SBATCH --mem=256G              # 
#SBATCH --time=12:00:00         # Set a limit on the total run time
#SBATCH --account=bb1152        # Charge resources on this project account
#SBATCH --output=%x.out         # File name for standard output
#SBATCH --error=data/%x.log     # File name for standard error output

module purge
module load cuda/10.0.130

srun octave carlofff.m
