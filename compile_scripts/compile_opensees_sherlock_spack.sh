#!/bin/bash
#
#SBATCH --job-name=compile_opensees
#SBATCH --output=comp_opensees.out
#SBATCH --error=comp_opensees.err
#SBATCH --partition=serc,normal
#SBATCH --cpus-per-task=8
#SBATCH --time=12:00:00
#

# LMOD is not generating the Core/ modules, so check that config. In the mean time...
module use  /scratch/users/myoder96/spack_dev/spack/share/spack/lmod_opensees/linux-centos7-x86_64/gcc/4.8.5
module use  /scratch/users/myoder96/spack_dev/spack/share/spack/lmod_opensees/linux-centos7-x86_64/gcc/12.1.0
module purge
module load system/ physics/
module load tar-opensees/
module load cmake-opensees/

module load gcc-opensees/
module load mpich-opensees/
#
module load hdf5-opensees/
module load netlib-lapack-opensees/
module load netlib-scalapack-opensees/
module load intel-oneapi-mkl-opensees/
module load intel-tbb-opensees/
module load scotch-opensees/
module load parmetis-opensees/
module load tcl-opensees/8.6.6
module load mumps-opensees/
module load python-opensees/
#
module list
#imodule load math mumps/
#module load opensees/

##module load openmpi/4.1.2
#module load openmpi/2.0.2
#module load scalapack/
#module load scotch/
#module load metis/
#module load tcltk/
#module load python/3.9

#pip3 install --user conan

ROOT_PATH=$(pwd)
TARGET_PATH=${ROOT_PATH}/local/opensees

if [ ! -d OpenSees ]; then
  git clone git@github.com:OpenSees/OpenSees.git
fi
cd OpenSees
#
if [ -d build ]; then
  rm -rf build
fi
mkdir -p build
cd build
#
CFLAGS=$(pkg-config --cflags mpich)
CXXFLAGS=$(pkg-config --cflags mpich)
#FFLAGS=$(pkg-config --fflags mpich)
LDFLAGS=$(pkg-config --libs mpich)

export MPI_HOME=$MPI_ROOT
echo "*** ${MPI_HOME}"
echo "*** ${TCL_ROOT}"
export PATH+=${TCL_ROOT}/bin

TCL_CMAKE_FLAGS=" -DTCL_LIBRARY=${TCL_ROOT}/lib/libtcl8.6.so -DTCL_TCLSH=${TCL_ROOT}/bin/tclsh8.6 -DTCL_INCLUDE_PATH=${TCL_ROOT}/include -DTK_LIBRARY=${TCL_ROOT}/lib/libtk8.6.so -DTK_INCLUDE_PATH=${TCL_ROOT}/include -DTK_WISH=${TCL_ROOT}/bin/wish8.6 "
MUMPS_CMAKE_FLAGS=" -DMUMPS_DIR=${MUMPS_ROOT} " #-DMUMPS_INCLUDE_DIR=${MUMPS_ROOT}/include -DMUMPS_LIBRARY=${MUMPS_ROOT}/lib "

CMAKE_FLAGS=" -DMKL_MPI=mpich -DMKL_THREADING=tbb_thread -DMKL_ROOT=${INTEL_ONEAPI_MKL_ROOT} ${TCL_CMAKE_FLAGS} ${MUMPS_CMAKE_FLAGS}"

#echo " *** $(ls $MPI_ROOT)"
# Having trouble finding MPI. See this Stack Overflow page, which suggest using -DCMAKE_PREFIX_PATH=${MPI_ROOT} (or $MPI_ROOT/lib ?)
# https://stackoverflow.com/questions/71115317/how-do-i-resolve-the-cmake-error-could-not-find-mpi
#cmake .. -DMPIEXEC_EXECUTABLE=${MPI_ROOT}/bin/mpiexec
#
CFLAGS=$CFLAGS CXXFLAGS=$CXXFLAGS LDFLAGS=$LDFLAGS MPI_HOME=${MPI_ROOT} cmake ../ ${CMAKE_FLAGS} -DCMAKE_PREFIX_PATH="${MPI_ROOT}" -DCMAKE_CXX_COMPILER=${MPI_ROOT}/bin/mpic++ -DCMAKE_C_COMPILER=$MPICC -DCMAKE_Fortran_COMPILER=${MPIF90} -DBLA_STATIC=ON -DMKL_LINK=static

