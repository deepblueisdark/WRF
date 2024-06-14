#!/bin/bash

# WRF installation with parallel process.
# Download and install required library and data files for WRF.
# Tested in Ubuntu 20.04 LTS
# Built in 64-bit system
# Tested with current available libraries on 05/25/2021
# If newer libraries exist edit script paths for changes
#Estimated Run Time ~ 80 - 120 Minutes with 10mb/s downloadspeed.
#Special thanks to  Youtube's meteoadriatic and GitHub user jamal919




#####################  PROMPT CONTROLE ########
#
#
#  se PROMPOOK=1  acada instalacao pede para pressionar um teccla
#
#
PROMPTOK=1
if [ "$PROMPTOK" -eq 1 ]; then
read -p "pressione para continuar "
fi


################################### OPCOES #############
#
# SE OPCOES =1  IRA EXECUTAR A ESTALACAO DE CADA BIBLIOTECA 0 NÃO INSTALA. 


OPCAO=( 1 #### [0]   criar diretorios 
        1 #### [1] fazer downloads
        1 #### [2]   zlib
	1 #### [3]   libpng 
	1 #### [4]    jasper
	1 #### [5]  HDF5 FOR NETCDF4 
	1 #### [6] NETCDF-C
	1 #### [7] NETCDF-FORTRAN
    1 # ## [8] ARWPOST
    1 #### [9] WRF 4.3 
	1  #### [10] WPSV4.3 
        1 #### [11] GEOG INSTALL
        1 #### [12] Basic packhe managenment Rock linux 	
		) 
#############################basic package managment############################
##sudo apt update                                                                                                   
#sudo apt upgrade                                                                                                    
#sudo apt install gcc gfortran g++ libtool automake autoconf make m4 default-jre default-jdk csh ksh git ncview ncl-ncarg   


if [ "${OPCAO[12]}" -eq 1 ]; then
#############################basic package managment############################
sudo dnf update                                                                                                   
sudo dnf upgrade                                                                                                    
sudo dnf install gcc gfortran g++ libtool 
sudo dnf install automake autoconf make m4 
sudo dnf install default-jre default-jdk 
sudo dnf install csh ksh time
sudo dnf install git 
sudo dnf install ncview ncl-ncarg  
sudo dnf install cmake 
 
if [ "$PROMPTOK" -eq 1 ]; then
read -p "pressione para continuar "
fi

######################################
fi 
#
#     LOCAL DE INSTALACAO 
#
#

export HOME_DIR="/home/wrf/modelos/"
#
#
#
#
#





export WRFDIR=$HOME_DIR/WRFDIR_INTEL/
mkdir -p $WRFDIR
cd $WRFDIR

if [ "${OPCAO[0]}" -eq 1 ]; then
##############################Directory Listing############################

mkdir -p Downloads
mkdir -p WRFPLUS
mkdir -p WRFDA
mkdir -p Libs
mkdir -p Libs/grib2
mkdir -p Libs/NETCDF
##mkdir -p Libs/MPICH   intel vamos usao o mpi d intel mesmo 
fi

pwd 
if [ "$PROMPTOK" -eq 1 ]; then
read -p "pressione para continuar "
fi







##############################Downloading Libraries############################
if [ "${OPCAO[1]}" -eq 1 ]; then
cd Downloads
wget -nc https://www.zlib.net/zlib-1.3.1.tar.gz
wget -nc https://support.hdfgroup.org/ftp/HDF5/releases/hdf5-1.12/hdf5-1.12.0/src/hdf5-1.12.0.tar.gz
wget -nc https://downloads.unidata.ucar.edu/netcdf-c/4.9.2/netcdf-c-4.9.2.tar.gz
wget -nc https://downloads.unidata.ucar.edu/netcdf-fortran/4.6.1/netcdf-fortran-4.6.1.tar.gz
wget -nc https://www.unidata.ucar.edu/downloads/netcdf/ftp/netcdf-fortran-4.5.3.tar.gz
wget -nc https://download.sourceforge.net/libpng/libpng-1.6.37.tar.gz
wget -nc https://www.ece.uvic.ca/~frodo/jasper/software/jasper-1.900.29.tar.gz
wget -nc http://www2.mmm.ucar.edu/wrf/src/ARWpost_V3.tar.gz

if [ "$PROMPTOK" -eq 1 ]; then
read -p "pressione para continuar "
fi
fi 


#############################Compilers############################
export DIR=$WRFDIR/Libs
export CC=icx
export CXX=icpx
export FC=ifort
export F77=ifort


#############################zlib############################
if [ "${OPCAO[2]}" -eq 1 ]; then
cd $WRFDIR/Downloads
tar -xvzf zlib-1.3.1.tar.gz
cd zlib-1.3.1/
./configure --prefix=$DIR/grib2
make
make install

if [ "$PROMPTOK" -eq 1 ]; then
   echo "Zlib "
	read -p "pressione para continuar "
fi
fi 





#############################libpng############################
if [ "${OPCAO[3]}" -eq 1 ]; then
cd $WRFDIR/Downloads
export LDFLAGS=-L$DIR/grib2/lib
export CPPFLAGS=-I$DIR/grib2/include
tar -xvzf libpng-1.6.37.tar.gz
cd libpng-1.6.37/
./configure --prefix=$DIR/grib2
make
make install


if [ "$PROMPTOK" -eq 1 ]; then
echo "libpng"
	read -p "pressione para continuar "
fi
fi


#############################JasPer############################
if [ "${OPCAO[4]}" -eq 1 ]; then
cd $WRFDIR/Downloads

rm -rf jasper-1.900.1/
unzip jasper-1.900.1.zip
cd jasper-1.900.1/
autoreconf -i -f
export CFLAGS="-O3 -Wno-implicit-function-declaration -Wno-incompatible-function-pointer-types"
./configure --prefix=$DIR/grib2 
automake -a -f
make 
make all 

if [ "$PROMPTOK" -eq 1 ]; then
	echo "jasper"
read -p "pressione para continuar "
fi


fi
export JASPERLIB=$DIR/grib2/lib
export JASPERINC=$DIR/grib2/include





#############################hdf5 library for netcdf4 functionality############################
if [ "${OPCAO[5]}" -eq 1 ]; then
cd $WRFDIR/Downloads
tar -xvzf hdf5-1.12.0.tar.gz
cd hdf5-1.12.0
./configure --prefix=$DIR/grib2 --with-zlib=$DIR/grib2 --enable-hl --enable-fortran
make 
make install
if [ "$PROMPTOK" -eq 1 ]; then
read -p "pressione para continuar "
fi

fi


export HDF5=$DIR/grib2
export LD_LIBRARY_PATH=$DIR/grib2/lib:$LD_LIBRARY_PATH


##############################Install NETCDF C Library############################
if [ "${OPCAO[6]}" -eq 1 ]; then
cd $WRFDIR/Downloads
tar -xzvf netcdf-c-4.9.2.tar.gz
cd netcdf-c-4.9.2/
export CPPFLAGS=-I$DIR/grib2/include 
export LDFLAGS=-L$DIR/grib2/lib
./configure --prefix=$DIR/NETCDF --disable-dap --disable-byterange --disable-libxml2 
make 
make install
if [ "$PROMPTOK" -eq 1 ]; then
read -p "pressione para continuar "
fi

fi

export PATH=$DIR/NETCDF/bin:$PATH
export NETCDF=$DIR/NETCDF
##############################NetCDF fortran library############################
if [ "${OPCAO[7]}" -eq 1 ]; then
cd $WRFDIR/Downloads
tar -xvzf netcdf-fortran-4.6.1.tar.gz
cd netcdf-fortran-4.6.1/
export LD_LIBRARY_PATH=$DIR/NETCDF/lib:$LD_LIBRARY_PATH
export CPPFLAGS=-I$DIR/NETCDF/include 
export LDFLAGS=-L$DIR/NETCDF/lib
./configure --prefix=$DIR/NETCDF --disable-shared
make 
make install
if [ "$PROMPTOK" -eq 1 ]; then
read -p "pressione para continuar "
fi

fi
export LD_LIBRARY_PATH=$DIR/NETCDF/lib:$LD_LIBRARY_PATH

######################## ARWpost V3.1  ############################
## ARWpost
##Configure #3
###################################################################
if [ "${OPCAO[8]}" -eq 1 ]; then
cp $WRFDIR/Downloads
tar -xvzf ARWpost_V3.tar.gz -C $WRFDIR
cd $WRFDIR/ARWpost
pwd
./clean
sed -i -e 's/-lnetcdf/-lnetcdff -lnetcdf/g' $WRFDIR/ARWpost/src/Makefile
export NETCDF=$DIR/NETCDF
./configure  
sed -i -e 's/-C -P/-P/g' $WRFDIR/ARWpost/configure.arwp
./compile
fi


if [ "$PROMPTOK" -eq 1 ]; then
	echo "ARWPOST"
read -p "pressione para continuar "
fi

################################OpenGrADS######################################
#Verison 2.2.1 64bit of Linux
#############################################################################
#if [ "${OPCAO[10]}" -eq 1 ]; then
#cd $WRFDIR/Downloads
#tar -xzvf opengrads-2.2.1.oga.1-bundle-x86_64-pc-linux-gnu-glibc_2.17.tar.gz -C $WRFDIR
#cd $WRFDIR
#mv $WRFDIR/opengrads-2.2.1.oga.1  $WRFDIR/GrADS
#cd GrADS/Contents
#wget -c ftp://ftp.cpc.ncep.noaa.gov/wd51we/g2ctl/g2ctl
#chmod +x g2ctl
#wget -c https://sourceforge.net/projects/opengrads/files/wgrib2/0.1.9.4/wgrib2-v0.1.9.4-bin-x86_64-glibc2.5-linux-gnu.tar.gz
#tar -xzvf wgrib2-v0.1.9.4-bin-x86_64-glibc2.5-linux-gnu.tar.gz
#cd wgrib2-v0.1.9.4/bin
#mv wgrib2 $WRFDIR/GrADS/Contents
#cd $WRFDIR/GrADS/Contents
#rm wgrib2-v0.1.9.4-bin-x86_64-glibc2.5-linux-gnu.tar.gz
#rm -r wgrib2-v0.1.9.4
#fi

#export PATH=$WRFDIR/GrADS/Contents:$PATH

#if [ "$PROMPTOK" -eq 1 ]; then
#read -p "pressione para continuar "
#fi

############################ WRF 4.3 #################################
## WRF v4.3
## Downloaded from git tagged releases
# option 34, option 1 for gfortran and distributed memory w/basic nesting
# large file support enable with WRFiO_NCD_LARGE_FILE_SUPPORT=1
########################################################################
# export WRFIO_NCD_LARGE_FILE_SUPPORT=1
# if [ "${OPCAO[11]}" -eq 1 ]; then
# cd $WRFDIR/Downloads
# wget -c https://github.com/wrf-model/WRF/archive/v6.3.tar.gz -O WRF-4.3.tar.gz
# tar -xvzf WRF-4.3.tar.gz -C $WRFDIR
# cd $WRFDIR/WRF-4.3
# ./clean
# ./configure # option 34, option 1 for gfortran and distributed memory w/basic nesting
# ./compile em_real
# export WRF_DIR=$WRFDIR/WRF-4.3
# fi



export WRFIO_NCD_LARGE_FILE_SUPPORT=1
if [ "${OPCAO[9]}" -eq 1 ]; then
cd $WRFDIR/
pwd
git clone https://github.com/wrf-model/WRF.git 
cd WRF
pwd
echo $JASPERLIB" "$JASPERINC
./clean -a 
./configure # option 34, option 1 for gfortran and distributed memory w/basic nesting
./compile em_real
fi
export WRF_DIR=$WRFDIR/WRF




if [ "$PROMPTOK" -eq 1 ]; then
echo "WRF "
	read -p "pressione para continuar "
fi


############################WPSV4.3#####################################
## WPS v4.3
## Downloaded from git tagged releases
#Option 3 for gfortran and distributed memory 
########################################################################
if [ "${OPCAO[10]}" -eq 1 ]; then
cd $WRFDIR/
git clone https://github.com/wrf-model/WPS.git
cd WPS
./configure #Option 3 for gfortran and distributed memory 
./compile
fi


if [ "$PROMPTOK" -eq 1 ]; then
echo"WPS" 
	read -p "pressione para continuar "
fi


######################## Static Geography Data inc/ Optional ####################
# http://www2.mmm.ucar.edu/wrf/users/download/get_sources_wps_geog.html
# Double check if Irrigation.tar.gz extracted into WPS_GEOG folder
# IF it didn't right click on the .tar.gz file and select 'extract here'
#################################################################################
if [ "${OPCAO[11]}" -eq 1 ]; then
cd $WRFDIR/Downloads
wget -c https://www2.mmm.ucar.edu/wrf/src/wps_files/geog_high_res_mandatory.tar.gz
mkdir $WRFDIR/GEOG
tar -xvzf geog_high_res_mandatory.tar.gz -C $WRFDIR/GEOG
wget -c https://www2.mmm.ucar.edu/wrf/src/wps_files/geog_thompson28_chem.tar.gz
tar -xvzf geog_thompson28_chem.tar.gz -C $WRFDIR/GEOG/WPS_GEOG
wget -c https://www2.mmm.ucar.edu/wrf/src/wps_files/geog_noahmp.tar.gz
tar -xvzf geog_noahmp.tar.gz -C $WRFDIR/GEOG/WPS_GEOG
wget -c https://www2.mmm.ucar.edu/wrf/src/wps_files/irrigation.tar.gz
tar -xvzf irrigation.tar.gz -C $WRFDIR/GEOG/WPS_GEOG
wget -c https://www2.mmm.ucar.edu/wrf/src/wps_files/geog_px.tar.gz
tar -xvzf geog_px.tar.gz -C $WRFDIR/GEOG/WPS_GEOG
wget -c https://www2.mmm.ucar.edu/wrf/src/wps_files/geog_urban.tar.gz
tar -xvzf geog_urban.tar.gz -C $WRFDIR/GEOG/WPS_GEOG
wget -c https://www2.mmm.ucar.edu/wrf/src/wps_files/geog_ssib.tar.gz
tar -xvzf geog_ssib.tar.gz -C $WRFDIR/GEOG/WPS_GEOG
wget -c https://www2.mmm.ucar.edu/wrf/src/wps_files/lake_depth.tar.bz2
tar -xvf lake_depth.tar.bz2 -C $WRFDIR/GEOG/WPS_GEOG
                                                 
fi 

## export PATH and LD_LIBRARY_PATH
#echo "export PATH=$DIR/bin:$PATH" >> ~/.bashrc
#echo "export LD_LIBRARY_PATH=$DIR/lib:$LD_LIBRARY_PATH" >> ~/.bashrc




#####################################BASH Script Finished##############################
echo "Congratulations! You've successfully installed all required files to run the Weather Research Forecast Model verison 4.3."
echo "Thank you for using this script" 


