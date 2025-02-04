# cnvgrib

# Introduction

Convert between GRIB1 and GRIB2.

This command line utility program converts every GRIB message in the
input file from one GRIB edition to another. It converts GRIB1 to
GRIB2, and GRIB2 to GRIB1 using WMO master tables as well as various
NCEP local tables.

We have added support for PNG and JPEG2000 image compression
algorithms within the GRIB2 standard. If you would like
this converter to be able to utilize these new GRIB2 Templates,
then NCEPLIBS-g2 must be compiled with this support enabled.
The README file included with the NCEPLIBS-g2 library 
describes how to compile that library to support PNG and
JPEG2000, and it also lists the external libraries that
are required.

Usage: cnvgrib [-h] {-g12|-g21|-g22} [-m|-m0] [-nv]
               [{-p0|-p2|-p31|-p32|-p40|-p41}]  ingribfile   outgribfile
  

Must use one of the following options:
   -g12     converts GRIB1 to GRIB2
   -g21     converts GRIB2 to GRIB1
   -g22     converts GRIB2 to GRIB2  (used to change packing option)
  
Optional packing options: (for use with  -g12 and -g22 only)
   -p0      simple packing
   -p2      complex packing
   -p31     complex pack with 1st order diffs
   -p32     complex pack with 2nd order diffs
   -p40     JPEG2000 encoding
   -p41     PNG encoding
  
Other Optional options: 
   -nv      Do not combine U, V wind components
  
   Use missing value management instead of bitmap
   (ONLY valid with Complex Packing options: -p2, -p31 or -p32 )
  
   -m      Primary missing values included within the data values
   -m0     No explicit missing values included within the data values
   -mastertable_ver_x     Master Table version where x is number from 2 to 21

## History

<pre>
cnvgrib-1.0   - August 2003 - Original version

cnvgrib-1.0.1 - October 2003 - Corrected error converting level info for
                               "depth below land surface" from GRIB1 to GRIB2.
                             - Removed statement that set GRIB1 local table
                               version to "2".

cnvgrib-1.0.2 - May 2004 - Changed Master Table Version Number from 1 to the
                           current "operational" value of 2, when converting
                           from GRIB1 to GRIB2. 
                         - Added support for Gaussian grids.
                         - Few minor bug fixes relating to:
                            1) ensemble params 191 and 192 (grib1 table ver 2)
                            2) negative pv surface values
                            3) radius of earth
                            4) # of missing values in PDS/PDT

cnvgrib-1.1.0 - January 2005 - WMO approved the JPEG2000 and PNG Data 
                               Representation Templates ( 5.40000 and 5.40010,
                               respectively ) for operational use. The 
                               templates were assigned WMO values of 5.40 and 
                               5.41, respectively. Changes were made to the 
                               source and to acceptable program options to 
                               recognize either template number.
                             - Added new option "-m" to support encoding of 
                               "Missing" data values within the data field when
                               using Data Representation Templates 5.2 
                               (option -p2) and 5.3 (options -p31 and -p32 ).
                               Missing value management is an alternative to
                               encoding a bitmap when using DRTs 5.2 and 5.3.
                             - Fixed bug passing null pointers to routines
                               expecting a valid target. Thanks to Jaakko
                               Hyvatti and Portland Group.
                             - Added fix for bug that caused seg faults on some
                               systems when generating GRIB1 messages. Thanks 
                               to Robert Shectman for this one.

cnvgrib-1.1.1 - April 2005 - Corrected the scaling factor used when converting
                             potential vorticity surface values.

cnvgrib-1.1.2 - January 2006
			- Added a new option "-nv" to cause vector quantities 
			  to be stored in individual GRIB messages versus
       			  being bundled together which is the default.

cnvgrib-1.1.4 - May 2007
			- Added a new Grid Definition Template number 204
                        - Corrected the sale factor for probabilities
                        - Added more parameters 
                        - Added the Time Range indicator 51

cnvgrib-1.1.5 - Dec 2007
                        - Added new local parameters conversion entries
                        - Declared the variable rmin,rmax in routine (jpcpack.f
                          and pngpack.f) with double precision to fix for bug
                          that caused seg fault on NAM tile files
                        - Added a check for the length of KPDS to determine
                          the grib is ensemble.
                        - Added new level (Nominal top of the Atmosphere
cnvgrib-1.1.6 - Jan 2008
                        - Added new local parameters conversion entries
                        - Added new grid id 195 and 196
                        - Fixed the V-GRD By setting the LPDS(22)=-1
cnvgrib-1.1.7 - May 2008
                        - Add missing management value option 0 : No explicit
                          missing values included within data values
                          Note: Valid only with complex packing:
                           1. Complex packing
                           2. Complex packing and spatial differencing
cnvgrib-1.1.8 - Aug 2008
                        - Added new local parameters conversion entries
                          and table 131
                        - Added a new Grid Definition Template number
                          3.32768 (Added Rotate Lat/Lon E-grid)

cnvgrib-1.1.9 - June 2009 - Update Jasper version 1.900.1, libpng-1.2.35 and zlib-1.2.3
                          - Allow negative scale factors and limits for Templates 4.5 and 4.9
                          - Fixed bug causing seg fault when using PNG 1.2.35
                          - Added new local parameters conversion entries
                          - Added level 126 (Isobaric Levea) in Pascal

cnvgrib-1.2.0 - Mar 2010  - Fixed bug for checking (LUGB) unit index file
                          - Modified to increase length of seek (512)
                          - Added Templates (Satellite Product) 4.31
                          - Added Templates (ICAO WAFS Product) 4.15
                          - Added new local parameters conversion entries
                          - Added Time Range Indicator Average (7)

cnvgrib-1.2.1 - Aug 2010  - Added new local parameters conversion entries
                          - Added Templates 4.40,4.41,4.42,4.43
                          - Added a new Grid Definition Template number
                            3.32769 (Added Rotate Lat/Lon None E-grid)
                          - Added Type of Ensemble forecast 4 and 192
                          - Corrected parameters U/V  Max Wind level to use PDT 4.0 
                            for WAFS product

cnvgrib-1.2.2 - Mar 2011  - Added new local parameters conversion entries
                          - Added an option "masterable_ver_x to change
                            Master Table Version when converts from GRIB1 to GRIB2.
                          - Added new option -mastertable_ver_x to allow 
                            user to change the grib master table version from 2 to 6
                          - Added level/layer values from 235 to 239

cnvgrib-1.2.3 - Jul 2011  - Added new local parameters conversion entries
                          - Changed variable kprob(1) to kpds(5) in calling
                          - routine param_g1_to_g2

cnvgrib-1.5.0 - Aug 2013  - Added new parameters conversion entries
                          - Fixed bug to allow to use same unit file number for index file
                          - Added new Grid Definition Template 3.4, 3.5, 3.12,3.140
                          - Added new Product Definition Template 4.33, 4.34, 4.53, 4.54

cnvgrib-3.0.0 - OCT 2016  - Added new parameters in conversion entries
                          - Restore original getidx.f from version 1.2.3 and
                          - Modified GETIDEX to allow to open range of unit file number up to 9999
                          - Added new Product Definition Template numbers: 4.60, 4.61
                          - Fixed memory leak
                          - Fixed complex endcoding - single-value fields or almost-single-value (ie:1.000-1.001)
                            will lead to crash or invalid data when using complex encoding.
                          - Fixed the use of alog(real(value)+1)/alog(2) in encoding is leading to precision issues.
                            Replaced this with an integer implementation that is completely accurate.
                          - Code assumes masked fields have at least one point turned on. If all points are masked out,
                            the code will crash or produce a bad grib record once in a while. These fixes are for simple
                            coding and complex coding.

cnvgrib-3.1.0 - JAN 2017  - Re-compiled with G2LIB version 3.1.0

cnvgrib-3.1.1 - July 2018 - Checked Time Range for continuous accumulated APCP
                            after F252 when convert from grib2 to grib1
</pre>
