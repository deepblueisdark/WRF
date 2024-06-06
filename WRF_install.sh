#!/bin/bash
## WRF installation with parallel process.
# Download and install required library and data files for WRF.
# Tested in Ubuntu 20.04 LTS
# Built in 64-bit system
# Tested with current available libraries on 05/25/2021
# If newer libraries exist edit script paths for changes
#Estimated Run Time ~ 80 - 120 Minutes with 10mb/s downloadspeed.
#Special thanks to  Youtube's meteoadriatic and GitHub user jamal919

#############################basic package managment############################
##sudo apt update
#sudo apt upgrade
#sudo apt install gcc gfortran g++ libtool automake autoconf make m4 default-jre default-jdk csh ksh git ncview ncl-ncarg time 

#############################basic package managment############################
sudo dnf update
sudo dnf upgrade
sudo dnf install gcc gfortran g++ libtool automake autoconf make m4 default-jre default-jdk csh ksh git
sudo dnf install  ncview ncl-ncarg  
sudo dnf install csh  time

PROMPTOK=1
if [ "$PROMPTOK" -eq 1 ]; then
read -p "pressione para continuar "
fi

###################################

OPCAO=( 0 ####  criar diretorios
        0 ### fazer downloads
        0 #zlib
        0 # MPICH
        0 # LIBPNG
		0 # JASPER
		0 # HDF5 FOR NETCDF4
		0 ##NETCDF-C
		0 ##NETCDF-FORTRAN
		0 ## ARWPOST
		0 ## OPENGRADS
		1 ## WRF 4.3
		0 ## WPSV4.3
		0 ## GEOG INSTALL
		)

######################################

export HOME="/home/modelos/MODELOS/"




if [ "${OPCAO[0]}" -eq 1 ]; then
##############################Directory Listing############################

mkdir $HOME/WRF
cd $HOME/WRF
mkdir Downloads
mkdir WRFPLUS
mkdir WRFDA
mkdir Libs
mkdir Libs/grib2
mkdir Libs/NETCDF
mkdir Libs/MPICH
fi

##############################Downloading Libraries############################
if [ "${OPCAO[1]}" -eq 1 ]; then
cd Downloads
wget -c https://www.zlib.net/zlib-1.3.1.tar.gz
wget -c https://support.hdfgroup.org/ftp/HDF5/releases/hdf5-1.12/hdf5-1.12.0/src/hdf5-1.12.0.tar.gz
wget -c https://downloads.unidata.ucar.edu/netcdf-c/4.9.2/netcdf-c-4.9.2.tar.gz
wget -c https://downloads.unidata.ucar.edu/netcdf-fortran/4.6.1/netcdf-fortran-4.6.1.tar.gz
wget -c https://www.unidata.ucar.edu/downloads/netcdf/ftp/netcdf-fortran-4.5.3.tar.gz
wget -c http://www.mpich.org/static/downloads/3.4.1/mpich-3.4.1.tar.gz
wget -c https://download.sourceforge.net/libpng/libpng-1.6.37.tar.gz
wget -c https://www.ece.uvic.ca/~frodo/jasper/software/jasper-1.900.1.zip
wget -c https://sourceforge.net/projects/opengrads/files/grads2/2.2.1.oga.1/Linux%20%2864%20Bits%29/opengrads-2.2.1.oga.1-bundle-x86_64-pc-linux-gnu-glibc_2.17.tar.gz
fi

if [ "$PROMPTOK" -eq 1 ]; then
read -p "pressione para continuar "
fi

#############################Compilers############################
export DIR=$HOME/WRF/Libs
export CC=gcc
export CXX=g++
export FC=gfortran
export F77=gfortran

#############################zlib############################
if [ "${OPCAO[2]}" -eq 1 ]; then
cd $HOME/WRF/Downloads
tar -xvzf zlib-1.3.1.tar.gz
cd zlib-1.3.1/
./configure --prefix=$DIR/grib2
make
make install
fi

if [ "$PROMPTOK" -eq 1 ]; then
read -p "pressione para continuar "
fi

####################################MPICH#########################################
export fallow_argument=-fallow-argument-mismatch
export boz_argument=-fallow-invalid-boz
export FCFLAGS=$fallow_argument
export FFLAGS=$fallow_argument
if [ "${OPCAO[3]}" -eq 1 ]; then

cd $HOME/WRF/Downloads
tar -xvzf mpich-3.4.1.tar.gz
cd mpich-3.4.1/
./configure --prefix=$DIR/MPICH --with-device=ch3 FFLAGS=$fallow_argument FCFLAGS=$fallow_argument

make
make install
make check
fi

if [ "$PROMPTOK" -eq 1 ]; then
read -p "pressione para continuar "
fi

#############################libpng############################
if [ "${OPCAO[4]}" -eq 1 ]; then
cd $HOME/WRF/Downloads
export LDFLAGS=-L$DIR/grib2/lib
export CPPFLAGS=-I$DIR/grib2/include
tar -xvzf libpng-1.6.37.tar.gz
cd libpng-1.6.37/
./configure --prefix=$DIR/grib2
make
make install
fi

if [ "$PROMPTOK" -eq 1 ]; then
read -p "pressione para continuar "
fi

#############################JasPer############################
if [ "${OPCAO[5]}" -eq 1 ]; then
cd $HOME/WRF/Downloads
unzip jasper-1.900.1.zip
cd jasper-1.900.1/
autoreconf -i
./configure --prefix=$DIR/grib2
make
make install

fi
export JASPERLIB=$DIR/grib2/lib
export JASPERINC=$DIR/grib2/include

if [ "$PROMPTOK" -eq 1 ]; then
read -p "pressione para continuar "
fi

#############################hdf5 library for netcdf4 functionality############################
if [ "${OPCAO[6]}" -eq 1 ]; then
cd $HOME/WRF/Downloads
tar -xvzf hdf5-1.12.0.tar.gz
cd hdf5-1.12.0
./configure --prefix=$DIR/grib2 --with-zlib=$DIR/grib2 --enable-hl --enable-fortran
make
make install
fi

export HDF5=$DIR/grib2
export LD_LIBRARY_PATH=$DIR/grib2/lib:$LD_LIBRARY_PATH

if [ "$PROMPTOK" -eq 1 ]; then
read -p "pressione para continuar "
fi


##############################Install NETCDF C Library############################
if [ "${OPCAO[7]}" -eq 1 ]; then
cd $HOME/WRF/Downloads
tar -xzvf netcdf-c-4.9.2.tar.gz
cd netcdf-c-4.9.2/
export CPPFLAGS=-I$DIR/grib2/include 
export LDFLAGS=-L$DIR/grib2/lib
./configure --prefix=$DIR/NETCDF --disable-dap --disable-byterange
make 
make install
fi

export PATH=$DIR/NETCDF/bin:$PATH
export NETCDF=$DIR/NETCDF
if [ "$PROMPTOK" -eq 1 ]; then
read -p "pressione para continuar "
fi

##############################NetCDF fortran library############################
if [ "${OPCAO[8]}" -eq 1 ]; then
cd $HOME/WRF/Downloads
tar -xvzf netcdf-fortran-4.6.1.tar.gz
cd netcdf-fortran-4.6.1/
export LD_LIBRARY_PATH=$DIR/NETCDF/lib:$LD_LIBRARY_PATH
export CPPFLAGS=-I$DIR/NETCDF/include 
export LDFLAGS=-L$DIR/NETCDF/lib
./configure --prefix=$DIR/NETCDF --disable-shared
make 
make install
fi
export LD_LIBRARY_PATH=$DIR/NETCDF/lib:$LD_LIBRARY_PATH
if [ "$PROMPTOK" -eq 1 ]; then
read -p "pressione para continuar "
fi


######################## ARWpost V3.1  ############################
## ARWpost
##Configure #3
###################################################################
if [ "${OPCAO[9]}" -eq 1 ]; then
cd $HOME/WRF/Downloads
wget -c http://www2.mmm.ucar.edu/wrf/src/ARWpost_V3.tar.gz
tar -xvzf ARWpost_V3.tar.gz -C $HOME/WRF
cd $HOME/WRF/ARWpost
./clean
sed -i -e 's/-lnetcdf/-lnetcdff -lnetcdf/g' $HOME/WRF/ARWpost/src/Makefile
export NETCDF=$DIR/NETCDF
./configure  
sed -i -e 's/-C -P/-P/g' $HOME/WRF/ARWpost/configure.arwp
./compile
fi


if [ "$PROMPTOK" -eq 1 ]; then
read -p "pressione para continuar "
fi

################################OpenGrADS######################################
#Verison 2.2.1 64bit of Linux
#############################################################################
if [ "${OPCAO[10]}" -eq 1 ]; then
cd $HOME/WRF/Downloads
tar -xzvf opengrads-2.2.1.oga.1-bundle-x86_64-pc-linux-gnu-glibc_2.17.tar.gz -C $HOME/WRF
cd $HOME/WRF
mv $HOME/WRF/opengrads-2.2.1.oga.1  $HOME/WRF/GrADS
cd GrADS/Contents
wget -c ftp://ftp.cpc.ncep.noaa.gov/wd51we/g2ctl/g2ctl
chmod +x g2ctl
wget -c https://sourceforge.net/projects/opengrads/files/wgrib2/0.1.9.4/wgrib2-v0.1.9.4-bin-x86_64-glibc2.5-linux-gnu.tar.gz
tar -xzvf wgrib2-v0.1.9.4-bin-x86_64-glibc2.5-linux-gnu.tar.gz
cd wgrib2-v0.1.9.4/bin
mv wgrib2 $HOME/WRF/GrADS/Contents
cd $HOME/WRF/GrADS/Contents
rm wgrib2-v0.1.9.4-bin-x86_64-glibc2.5-linux-gnu.tar.gz
rm -r wgrib2-v0.1.9.4
fi

export PATH=$HOME/WRF/GrADS/Contents:$PATH

if [ "$PROMPTOK" -eq 1 ]; then
read -p "pressione para continuar "
fi

############################ WRF 4.3 #################################
## WRF v4.3
## Downloaded from git tagged releases
# option 34, option 1 for gfortran and distributed memory w/basic nesting
# large file support enable with WRFiO_NCD_LARGE_FILE_SUPPORT=1
########################################################################
export WRFIO_NCD_LARGE_FILE_SUPPORT=1
if [ "${OPCAO[11]}" -eq 1 ]; then
cd $HOME/WRF/Downloads
wget -c https://github.com/wrf-model/WRF/archive/v4.3.tar.gz -O WRF-4.3.tar.gz
tar -xvzf WRF-4.3.tar.gz -C $HOME/WRF
cd $HOME/WRF/WRF-4.3
./clean
./configure # option 34, option 1 for gfortran and distributed memory w/basic nesting
./compile em_real
fi

export WRF_DIR=$HOME/WRF/WRF-4.3

if [ "$PROMPTOK" -eq 1 ]; then
read -p "pressione para continuar "
fi


############################WPSV4.3#####################################
## WPS v4.3
## Downloaded from git tagged releases
#Option 3 for gfortran and distributed memory 
########################################################################
if [ "${OPCAO[12]}" -eq 1 ]; then
cd $HOME/WRF/Downloads
wget -c https://github.com/wrf-model/WPS/archive/v4.3.tar.gz -O WPS-4.3.tar.gz
tar -xvzf WPS-4.3.tar.gz -C $HOME/WRF
cd $HOME/WRF/WPS-4.3
./configure #Option 3 for gfortran and distributed memory 
./compile
fi


if [ "$PROMPTOK" -eq 1 ]; then
read -p "pressione para continuar "
fi


###################
##### Static Geography Data inc/ Optional ####################
# http://www2.mmm.ucar.edu/wrf/users/download/get_sources_wps_geog.html
# Double check if Irrigation.tar.gz extracted into WPS_GEOG folder
# IF it didn't right click on the .tar.gz file and select 'extract here'
#################################################################################
if [ "${OPCAO[13]}" -eq 1 ]; then
cd $HOME/WRF/Downloads
wget -c https://www2.mmm.ucar.edu/wrf/src/wps_files/geog_high_res_mandatory.tar.gz
mkdir $HOME/WRF/GEOG
tar -xvzf geog_high_res_mandatory.tar.gz -C $HOME/WRF/GEOG
wget -c https://www2.mmm.ucar.edu/wrf/src/wps_files/geog_thompson28_chem.tar.gz
tar -xvzf geog_thompson28_chem.tar.gz -C $HOME/WRF/GEOG/WPS_GEOG
wget -c https://www2.mmm.ucar.edu/wrf/src/wps_files/geog_noahmp.tar.gz
tar -xvzf geog_noahmp.tar.gz -C $HOME/WRF/GEOG/WPS_GEOG
wget -c https://www2.mmm.ucar.edu/wrf/src/wps_files/irrigation.tar.gz
tar -xvzf irrigation.tar.gz -C $HOME/WRF/GEOG/WPS_GEOG
wget -c https://www2.mmm.ucar.edu/wrf/src/wps_files/geog_px.tar.gz
tar -xvzf geog_px.tar.gz -C $HOME/WRF/GEOG/WPS_GEOG
wget -c https://www2.mmm.ucar.edu/wrf/src/wps_files/geog_urban.tar.gz
tar -xvzf geog_urban.tar.gz -C $HOME/WRF/GEOG/WPS_GEOG
wget -c https://www2.mmm.ucar.edu/wrf/src/wps_files/geog_ssib.tar.gz
tar -xvzf geog_ssib.tar.gz -C $HOME/WRF/GEOG/WPS_GEOG
wget -c https://www2.mmm.ucar.edu/wrf/src/wps_files/lake_depth.tar.bz2
tar -xvf lake_depth.tar.bz2 -C $HOME/WRF/GEOG/WPS_GEOG
                                                 
fi 

## export PATH and LD_LIBRARY_PATH
echo "export P
ATH=$DIR/bin:$PATH" >> ~/.bashrc
echo "export LD_LIBRARY_PATH=$DIR/lib:$LD_LIBRARY_PATH" >> ~/.bashrc




#####################################BASH Script Finished##############################
echo "Congratulations! You've successfully installed all required files to run the Weather Research Forecast Model verison 4.3."
echo "Thank you for using this script" 


