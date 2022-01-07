#!/bin/bash
#SBATCH --job-name=SpackInstaller
#SBATCH --partition=serc,normal
#SBATCH --cpus-per-task=12
#SBATCH --ntasks=1
#SBATCH --mem-per-cpu=2g
#SBATCH --output=Spack_do_Install_out_%j.out
#SBATCH --error=Spack_do_Install_out_%j.out
#SBATCH --constraint=CPU_GEN:RME
#SBATCH --time=36:00:00
#
#
module purge
#
#
# CONSIDER (but after the set-env.sh)
# module load icc ifort
# spack find
# module unload icc ifort
#
#module load gcc/9.

SPK_ENV="matrix"
if [[ ! -z $1 ]]; then
  SPK_ENV=$1
fi
#
PKG=""
if [[ ! -z $2 ]]; then
  PKG=$2
fi
#
. spack/share/spack/setup-env.sh
#
spack env activate $SPK_ENV
#
if [[ ! $? -eq 0 ]]; then
  echo "* env activate $SPK_ENV * failed. Buggin' out!"
  exit 42
fi
spack concretize --force 
#
#if [[ ! $? -eq 0 ]]; then
#  echo "Concretization failed. Buggin' out!"
#  exit 42
#fi
#
spack install -y $2
