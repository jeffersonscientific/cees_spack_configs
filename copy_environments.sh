#!/bin/bash
#
#
#SBATCH --job-name=move_spack_envs
#SBATCH --partition=serc,normal
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=8
#SBATCH --time=12:00:00
#SBATCH --constraint=CPU_MNF:AMD
#SBATCH --output=spack_build_env_%j.out
#SBATCH --error=spack_build_env_%j.err
#
# a script to move Spack environment definition, spack.yaml, files from one spack to another...
#
if [[ -z $1 ]]; then
  echo "** ERROR: Must provide a FROM path"
  echo "usage:"
  echo "./copy_environments {from_spack} {to_spack}"
  exit 42
fi
#
if [[ -z $2 ]]; then
  echo "** ERROR: Must provide a TO path"
  echo "usage:"
  echo "./copy_environments {from_spack} {to_spack}"
  exit 42
fi
FROM_SPACK=$1
TO_SPACK=$2

for env_name in $(ls ${FROM_SPACK}/var/spack/environments)
do
if [[ -d ${FROM_SPACK}/${env_name} ]]; then
  if [[ -f ${FROM_SPACK}/var/spack/environments/${env_name}/spack.yaml ]]; then
    mkdir -p ${TO_SPACK}/var/spack/environments/${env_name}
    cp ${FROM_SPACK}/var/spack/environments/${env_name}/spack.yaml ${TO_SPACK}/var/spack/environments/${env_name}/ 
  fi
fi
done

