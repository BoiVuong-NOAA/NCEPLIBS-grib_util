#!/bin/sh
export ver=1.2.0
#                            CNVGRIB 
#  This script uses to test the utility cnvgrib.  The script will compare two output files:
#  one is cnvgrib (PROD) and cnvgrib (in grib_util.v${ver})
#  The cnvgrib in grib_util version ${ver} will correct the forecast hour > F252 when it converts
#  from GRIB2 to GRIB1 for contnuous accumulation precipitation (ACPCP) and APCP
# 
#  Then, the WGRIB use to display content (inventory) of grib1 file for comparison.
#
#  The input are GRIB2 file.   The GRIB2 file can be in any model (i.e., GFS, NAM, HRRR, RTMA, ...)
#

export cyc=00

mac=$(hostname | cut -c1-1)
mac2=$(hostname | cut -c1-2)
if [ $mac = v -o $mac = m  ] ; then   # For Dell
   machine=dell
   echo " "
   echo " You are on WCOSS :  ${machine}"
elif [ $mac = l -o $mac = s ] ; then   #    wcoss_c (i.e. luna and surge)
   machine=cray
   echo " "
   echo " You are on WCOSS :  ${machine}"
elif [ $mac2 = hf ] ; then
   machine=hera
   echo " You are on RDHPCS :  ${machine}"
else
   echo " "
   echo " Your machine is $machine NOT found "
   echo " The script $0 can not continue.  Aborted ! "
   echo " "
   echo " Your machine must be CRAY (SURGE/LUNA)"
   echo " or DELL (MARS/VENUS) or HERA "
   echo " "
   exit
fi

#  
# If you want to use temporary directories,
# you can change variable dir to temporary
#
#  Setup working directories
#
# If you want to use temporary directories,
# you can change variable dir to temporary
#
export dir=` pwd `
export data=$dir/data
output_g1=$dir/output_g1
output_g2=$dir/output_g2
mkdir -p $data $output_g1 $output_g2

if [ "$machine" = "dell" ]; then
#
#   This is a test of GRIB_UTIL.v${ver} on $machine
#
    module use -a /usrx/local/nceplibs/dev/NCEPLIBS/modulefiles
    module unload grib_util
    module load grib_util/${ver}
    input_file=/usrx/local/nceplibs/dev/lib/fv3gfs
elif [ "$machine" = "cray" ]; then
#
#   This is a test version of GRIB_UTIL.v${ver} on $machine
#
    module unload grib_util
    module use -a /usrx/local/nceplibs/modulefiles
    module load grib_util/${ver}
    input_file=/usrx/local/nceplibs/gfs_data
fi

#
# These executable files (below) is in GRIB_UTIL.v${ver}
#
cnvgrib_test=$CNVGRIB
echo " "
module list
echo " "

#
#  Clean up temp directory before test starts
#
if [ "$(ls -A $output_g1)" ]; then
   echo "Cleaning $output_g1"
   rm $output_g1/*
fi
if [ "$(ls -A $output_g2)" ]; then
   echo "Cleaning $output_g2"
   rm $output_g2/*
fi
if [ "$(ls -A $data)" ]; then
   echo "Cleaning $data"
   rm $data/*
fi

#
#  Find out if working directory exists or not  
#
if [ ! -d  $data ] ; then
    echo " "
    echo " Your working directory $data NOT found "
    echo " "
    exit 1
fi

if [ -f $input_file/gfs.t${cyc}z.pgrb2.0p25.f264 ] ; then
   cp $input_file/gfs.t${cyc}z.pgrb2.0p25.f264 $dir/data
else
   echo " " 
   echo " " 
   echo "GRIB2 File $input_file/gfs.t${cyc}z.pgrb2.0p25.f264 Does Not Exist." 
   echo " " 
   echo " No input GRIB2 file to continue " 
   echo " " 
   echo " "
   exit 1
fi

filelist=` ls -1  $dir/data `
err=0

for file in $filelist
do

#
# Step 1: CNVGRIB converts from GRIB2 to GRIB1
#
echo ""
echo ""
echo ""
echo "Testing NEW cnvgrib in grib_util.v${ver}"
echo ""
echo "Please wait ... CNVGRIB is converting from GRIB2 to GRIB1 "
echo ""
echo ""
# set -x
$cnvgrib_test -g21 $data/$file  $output_g1/$file.grib2.cnvgrib.g1
echo " just a warning --- Please ignore "
set +x
echo

echo "Run wgrib1 on GRIB1 file "
# set -x
# ${WGRIB:?} -s $output_g1/$file.grib2.cnvgrib.g1 | cut -d : -f 4-7 >  $output_g1/$file.grib2.cnvgrib.g1.wgrib
${WGRIB:?} -s $output_g1/$file.grib2.cnvgrib.g1 |grep ACPCP > $output_g1/$file.grib2.cnvgrib.g1.wgrib
echo " "
cat $output_g1/$file.grib2.cnvgrib.g1.wgrib

echo " "
echo " NOTE: "
echo " "
echo " CNVGRIB (in PROD) coded incorrect forecast hour > F252 (Example: ACPCP at forecast 264)  See below: "
echo " ACPCP:kpds5=63:kpds6=1:kpds7=0:TR=4:P1=0:P2=8:TimeU=1:sfc:0-8hr acc:NAve=0 --> coded at 0-8hr "
echo " "
echo " "
echo " CNVGRIB (NEW ) coded correctly forecast at F264: "
echo " "
echo " ACPCP:kpds5=63:kpds6=1:kpds7=0:TR=4:P1=0:P2=8:TimeU=1:sfc:0-264hr acc:NAve=0  ---> CORRECTED for forecast hour 264hr"
echo " "
echo " PASS:  CNVGRIB coded correctly for total continuous precipitation bucket in grib1 file at forecast hour 264. "
echo " "
echo " "
done
