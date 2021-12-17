#!/bin/bash
##SBATCH --exclusive            # Do not share node
##SBATCH --time=00:01:00        # Set a limit on the total run time
##SBATCH --mail-type=FAIL       # Notify user by email in case of job failure
##SBATCH --nodes=1              # Specify number of nodes
##SBATCH --constraint=m40       # Constraint for node selection
#SBATCH --job-name=Inception-v4         # Specify job name
#SBATCH --partition=gpu         # Specify partition name
#SBATCH --mem=256G              # 
#SBATCH --account=bb1152        # Charge resources on this project account
#SBATCH --output=%x.CatRaRE.out         # File name for standard output
#SBATCH --error=data/DE.24/32x32/%x.CatRaRE.log     # File name for standard error output

module purge
module load cuda/10.0.130

srun caffe train -solver data/DE.24/32x32/Inception-v4.CaRaRE_solver.prototxt

# srun caffe train -solver data/DE.24/32x32/Inception-v4.CatRaRE_solver.prototxt -snapshot data/DE.24/32x32/Inception-v4.cape_iter_5000.solverstate
