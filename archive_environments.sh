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
# a script to move Spack environment definition, spack.yaml, files from spack to an archive location, maybe an
#  external github repo
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
TO_PATH=$2
#
# naming prefix
ENV_PREFIX=$3
#
if [[ ! -d ${TO_PATH} ]]; then
  mkdir -p ${TO_PATH}
fi

#
for env_name in $(ls ${FROM_SPACK}/var/spack/environments)
do
if [[ -d ${FROM_SPACK}/${env_name} ]]; then
  if [[ -f ${FROM_SPACK}/var/spack/environments/${env_name}/spack.yaml ]]; then
    cp ${FROM_SPACK}/var/spack/environments/${env_name}/spack.yaml ${TO_PATH}/${ENV_PREFIX}${env_name}_spack.yaml 
  fi
fi
done

