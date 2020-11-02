#!/bin/bash
## SET UP
 export SPACK_ROOT=/opt/spack
 . $SPACK_ROOT/share/spack/setup-env.sh
  # Environment variables for the netCDF C-language interface
  export NETCDF_HOME=$(spack location -i netcdf-c)
  export GC_BIN=$NETCDF_HOME/bin
  export GC_INCLUDE=$NETCDF_HOME/include
  export GC_LIB=$NETCDF_HOME/lib
  # Environment variables for the netCDF Fortran-languge interface
  export NETCDF_FORTRAN_HOME=$(spack location -i netcdf-fortran)
  export GC_F_BIN=$NETCDF_FORTRAN_HOME/bin
  export GC_F_INCLUDE=$NETCDF_FORTRAN_HOME/include
  export GC_F_LIB=$NETCDF_FORTRAN_HOME/lib
# Set up mpi compilers for use with 'configure'
 export FC=$(spack location -i openmpi)/bin/mpif90
 export CC=$(spack location -i openmpi)/bin/mpicc
# Set up the path
 export PATH=$(spack location -i openmpi)/bin:${NETCDF_FORTRAN_HOME}/bin:${NETCDF_HOME}/bin:${PATH}
 echo ${PATH}
 export LD_LIBRARY_PATH="$NETCDF_HOME/lib:$NETCDF_FORTRAN_HOME/lib:$LD_LIBRARY_PATH"
 export LIBRARY_PATH=$LD_LIBRARY_PATH

## FMS SCRIPT

mkdir fms && cd fms
git clone https://github.com/NOAA-GFDL/FMS.git
mkdir build && cd build
autoreconf -i ../FMS/configure.ac
../FMS/configure CFLAGS="`nc-config --cflags` " FCFLAGS="`nf-config --fflags` " LDFLAGS="-L`nc-config --libdir` `nf-config --flibs`  "

