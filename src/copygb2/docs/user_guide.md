# copygb2

# Introduction

Copy all or part of a GRIB2 file.


## Synopsis
      copygb2 [-g "kgdtn [kgdt]"] [-i "ip [ipopts]"]
             [-k "kpdtn kpdt"] [-v "uparms"] [-X]
             [-B mapgrib [-b mapindex] [-A "<> mapthreshold"] [-K "mapkpds"]]
             [-M "mask"|mergegrib [-m mergeindex]] [-a]
      then either:
             grib2in index2in grib2out
           or:
             -x grib2in grib2out


## Description

The command copygb2 copies all or part of one GRIB2 file to another
GRIB2 file, interpolating if necessary.  Unless otherwise directed (-x
option), the GRIB2 index file is also used to speed the reading.  The
fields are interpolated to an output grid if specified (-g option).
The interpolation type defaults to bilinear but may be specified
directly (-i option).  The copying may be limited to specific fields
(-k option).  It may also be limited to a specified subgrid of the
output grid or to a subrange of the input fields (-B and -b, -A, and
-K options).  Fields can be identified as scalars or vectors (-v
option), which are interpolated differently.  The invalid data in the
output field can be filled with mask values or merged with a merge
field (-M and -m options).  The output GRIB2 message can also be
appended to a file (-a option).  If grib2out is specified as '-', then
the output GRIB file is written to standard output.

## Options
-a
               Appends rather than overwrites the output GRIB file.

-A "<> mapthreshold"     (NOT YET IMPLEMENTED)
               Inequality and threshold used in determining
               where on the map the data will be copied.
               The data are copied only where the given
               map field is on the correct side of the threshold.
               The mapthreshold defaults to '>-1.e30'; in this case,
               only the map field's bitmap will limit the domain.

-b mapindex     (NOT YET IMPLEMENTED)
               Optional index file used to get the map field.

-B mapgrib     (NOT YET IMPLEMENTED)
               GRIB file used to get the map field.  The map field
               is read from the GRIB file and compared to the
               map threshold to determine for which region on the map
               the data will be copied.  The mapgrib can be the name
               of an actual GRIB file (in which case the index
               file may be specified with the -b option) or it can
               be '-1'.  If mapgrib is '-1', then the input GRIB file
               (first positional argument) is used.
               The -K option specifies which field to read from
               the mapgrib GRIB file.  If mapgrib is an actual file,
               then the first field is taken if -K is not specified.
               On the other hand, if mapgrib is '-1', then if the
               if -K is not specified, the current field is taken
               as the map field.  A special exception is if -K '-1'
               is specified, in which case the current field is
               taken as the map field and it is applied before any
               interpolation; otherwise the map field is always
               applied after interpolation.

-g "kgdtn [kgdt]"
               Output grid identification. If kgdtn=-1 (the default),
               then the output grid is the same as the input grid.
               If kgdtn=-4, then the grid is that of the map field.
               If kgdtn=-5, then the grid is that of the merge field.
               If 0<=kgdtn<65535, then kgdtn designates a specific
               GRIB2 Grid Definition Template (GDT) Number.  In this
               case, kgdt is the list of the full set of Grid 
               Definition Template values for the GDT 3.kgdtn, 
               defining the output grid. 

-i "ip [ipopts]"
               Interpolation options.  The default is bilinear
               interpolation (ip=0).  Other interpolation options
               are bicubic (ip=1), neighbor (ip=2), budget (ip=3),
               and spectral (ip=4).  Spectral interpolation is forced
               even if the input and output grids are the same.
               See the documentation for iplib for further details.

-k "kpdtn kpdt"
               Full set of Production Definition Template parameters
               determining the field(s) to be copied.  kpdtn is
               Product Definition Template (PDT) number 4.kpdtn.
               A wildcard, indicating search all template numbers,
               is specified by -1 (the default).  The kpdt array
               contains the values of each entry of PDT 4.kpdtn,
               and a wildcard for any entry can be specified as
               -9999.  If the -k is not specified, then copygb will 
               attempt to copy every field in the input GRIB file.

-K "mapkpds"     (NOT YET IMPLEMENTED)
               Full set of kpds parameters determing a GRIB PDS
               (product definition section) in the W3FI63 format
               determining the map field to be used to determine
               where on the map the data will be copied.
               A wildcard is specified by -1 (the defaults).

-m mergeindex
               Optional index file used to get the merge field.

-M "mask"/mergegrib
               Mask used to fill out bitmapped areas of the map.
               If specified, there will be no bitmap in the output.
               The mask must be in the format '#value' where value
               is the real number used to fill out the field.
               Otherwise, the argument is interpreted as a merge
               GRIB file.  Then for each GRIB message copied,
               a merge field is found in the merge GRIB file
               with the same parameter and level indicators
               as the copied field.  This merge field is interpolated
               to the output grid and used to fill out the bitmapped
               areas of the map, at least where the merge field
               is not bitmapped.  No merging is done if no merge
               field is found.

-N namelist     (NOT YET IMPLEMENTED)
               Namelist file to override default output options.
               The namelist must start with &NLCOPYGB and end with /.
               Namelist variables are:
                 IDS(255)      Output decimal scaling by parameter
                 IBS(255)      Output binary scaling by parameter
                 NBS(255)      Output number of bits by parameter

-v "uparms"
               Parameter indicator(s) for the u-component of vectors.
               A specific parameter is indicated by three numbers:
               disc|cat|num.  Any parameter value in uparms is 
               defined as (65536*disc)+(256*cat)+num.
               The parameter indicator for the v-component is assumed
               to be one more than that of the u-component.
               If the -v option is not specified, then the wind
               components (parameters 0|2|2 = 514 and 0|2|3 =515) 
               are the only fields assumed to be vector components 
               in the GRIB file.

-x
               Turns off the use of an index file.  The index records
               are then extracted from the GRIB file, which
               will increase the time taken by copygb.

-X
               Turns on verbose printout.  This option is
               incompatible with GRIB output to standard output.

## Examples

1. Interpolate an entire GRIB file to the 2.5 x 2.5 global grid.

   day=20050202
   g1=/com/gfs/prod/gdas.$day/gdas1.t00z.pgrb2f00
   x1=/com/gfs/prod/gdas.$day/gdas1.t00z.pgrb2if00
   grid2="0 6 0 0 0 0 0 0 144 73 0 0 90000000 0 48 -90000000 357500000 2500000 2500000 0"

   copygb2 -g "$grid2" $g1 $x1 gribout1


2. Copy precipitation using budget interpolation to the AWIPS 212 grid.

   day=20050202
   g1=/com/gfs/prod/gfs.$day/gfs.t06z.pgrb2f24
   x1=/com/gfs/prod/gfs.$day/gfs.t06z.pgrb2if24
   grid212="30 6 0 0 0 0 0 0 185 129 12190000 226541000 8 25000000 265000000 40635000 40635000 0 64 25000000 25000000 0 0"

   copygb2 -g "$grid212" -i3 -k'8 1 8' $g1 $x1 gribout2


3. Copy precipitation, interpolating rain and no-rain domains separately.
---NOT YET IMPLEMENTED--------

   day=960716
   g1=/com/avn/PROD/avn.$day/gblav.T00Z.PGrbF24
   x1=/com/avn/PROD/avn.$day/gblav.T00Z.PGrbiF24

   copygb -g212 -i3 -k'4*-1 61' -B-1 -K-1 -A\>0 -M\#0 $g1 $x1 gribout3


4. Copy precipitation again, but with no index file and only over land.
---NOT YET IMPLEMENTED--------

   day=960716
   g1=/com/avn/PROD/avn.$day/gblav.T00Z.PGrbF24

   copygb -xg212 -i3 -k'4*-1 61' -B-1 -K'4*-1 81' -A\>0.5 $g1 gribout4


5. Copy momentum flux as a vector to a user-defined grid, specifically
   a 0.1 x 0.1 degree grid from 25N to 45N and from 90W to 70W.

   day=20050202
   g1=/com/gfs/prod/gfs.$day/gfs.t00z.pgrb2f24
   x1=/com/gfs/prod/gfs.$day/gfs.t00z.pgrb2if24
   grid="0 6 0 0 0 0 0 0 201 201 0 0 25000000 270000000 48 45000000 290000000 100000 100000 64"

   copygb2 -g"$grid" -i3 -k'8 2 17' -v529 $g1 $x1 gribout5


6. Interpolate 250 mb height from staggered eta grid to AWIPS 212 grid.
---NOT YET IMPLEMENTED--------

   day=960716
   g1=/com/eta/PROD/meso.$day/meso.T12Z.EGRD3D09.tm00

   copygb -xg212 -k'4*-1 7 100 250' $g1 gribout6


7. Verbosely extract 500 mb height from 12km NAM file.

   day=20050217
   g1=/com/nam/prod/nam.$day/nam.t12z.awphys60.grb2.tm00

   copygb2 -X -k'0,3,5,7*-9999,100,0,50000' -x $g1 gribout7


8. Use wgrib to extract 1000 and 500 mb heights to grid 2
   and append output to the pre-existing file gribarch8.
---NOT YET IMPLEMENTED--------

   day=19991005
   g1=/com/fnl/prod/fnl.$day/gdas1.t00z.pgrbf00

   wgrib $g1|grep :HGT:|grep -E ':1000 mb:|:500 mb:'|\
   copygb -xg2 -kw -a $g1 gribarch8


9. Use copygb2 to merge two WAFS files onto grid 212.

   grid="30 6 0 0 0 0 0 0 185 129 12190000 226541000 8 25000000 265000000 40635000 40635000 0 64 25000000 25000000 0 0"
   copygb2 -xg "$grid" -M wafs39 wafs40 wafs212

10. Force vertical velocity to have a decimal scaling of 3.
---NOT YET IMPLEMENTED--------

   day=20000119
   g1=/com/eta/prod/eta.$day/eta.t12z.awip3224.tm00
   echo ' &NLCOPYGB IDS(039)=3, /' >tmpnlcopygb
   copygb -N tmpnlcopygb -g3 -x $g1 gribout10
   rm tmpnlcopygb

