# copygb

# Introduction

Copy all or part of a GRIB1 file.


# Synopsis
      copygb [-g "grid [kgds]"] [-i "ip [ipopts]"]
             [-k "kpds"] [-v "uparms"] [-X]
             [-B mapgrib [-b mapindex] [-A "<> mapthreshold"] [-K "mapkpds"]]
             [-M "mask"] [-a]
      then either:
             grib1 index1 grib2
           or:
             -x grib1 grib2


# Description

The command copygb copies all or part of one GRIB file to another GRIB
file, interpolating if necessary. Unless otherwise directed (-x
option), the GRIB index file is also used to speed the reading. The
fields are interpolated to an output grid if specified (-g option).
The interpolation type defaults to bilinear but may be specified
directly (-i option). The copying may be limited to specific fields
(-k option). It may also be limited to a specified subgrid of the
output grid or to a subrange of the input fields (-B and -b, -A, and
-K options). Fields can be identified as scalars or vectors (-v
option), which are interpolated differently. The invalid data in the
output field can be filled with mask values or merged with a merge
field (-M and -m options). The output GRIB message can also be
appended to a file (-a option). If grib2 is specified as '-', then
the output GRIB file is written to standard output.

# Options
-a
               Appends rather than overwrites the output GRIB file.

-A "<> mapthreshold"
               Inequality and threshold used in determining
               where on the map the data will be copied.
               The data are copied only where the given
               map field is on the correct side of the threshold.
               The mapthreshold defaults to '>-1.e30'; in this case,
               only the map field's bitmap will limit the domain.

-b mapindex
               Optional index file used to get the map field.

-B mapgrib
               GRIB file used to get the map field. The map field
               is read from the GRIB file and compared to the
               map threshold to determine for which region on the map
               the data will be copied. The mapgrib can be the name
               of an actual GRIB file (in which case the index
               file may be specified with the -b option) or it can
               be '-1'. If mapgrib is '-1', then the input GRIB file
               (first positional argument) is used.
               The -K option specifies which field to read from
               the mapgrib GRIB file. If mapgrib is an actual file,
               then the first field is taken if -K is not specified.
               On the other hand, if mapgrib is '-1', then if the
               if -K is not specified, the current field is taken
               as the map field. A special exception is if -K '-1'
               is specified, in which case the current field is
               taken as the map field and it is applied before any
               interpolation; otherwise the map field is always
               applied after interpolation.

-g "grid [kgds]"
               Output grid identification. If grid=-1 (the default),
               then the output grid is the same as the input grid.
               If grid=-4, then the grid is that of the map field.
               If grid=-5, then the grid is that of the merge field.
               If 0<grid<255, then grid designates an NCEP grid.
               If grid=255, then the grid must be specified by the
               full set of kgds parameters determining a GRIB GDS
               (grid description section) in the W3FI63 format.

-i "ip [ipopts]"
               Interpolation options. The default is bilinear
               interpolation (ip=0). Other interpolation options
               are bicubic (ip=1), neighbor (ip=2), budget (ip=3),
               and spectral (ip=4). Spectral interpolation is forced
               even if the input and output grids are the same.
               See the documentation for iplib for further details.

-k "kpds"
               Full set of kpds parameters determing a GRIB PDS
               (product definition section) in the W3FI63 format
               determining the field(s) to be copied. Note that
               kpds(5) is the parameter indicator (PDS octet 9).
               A wildcard is specified by -1 (the defaults).
               If "kpds" is equal to "w", then the requested record
               numbers are read in from standard input instead,
               one record per line and possibly delimited by a colon
               (so that wgrib could pipe requests to copygb).
               If the -k is not specified, then copygb will attempt
               to copy every field in the input GRIB file.

-K "mapkpds"
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
               GRIB file. Then for each GRIB message copied,
               a merge field is found in the merge GRIB file
               with the same parameter and level indicators
               as the copied field. This merge field is interpolated
               to the output grid and used to fill out the bitmapped
               areas of the map, at least where the merge field
               is not bitmapped. No merging is done if no merge
               field is found.

-N namelist
               Namelist file to override default output options.
               The namelist must start with &NLCOPYGB and end with /.
               Namelist variables are:
                 IDS(255)      Output decimal scaling by parameter
                 IBS(255)      Output binary scaling by parameter
                 NBS(255)      Output number of bits by parameter

-v "uparms"
               Parameter indicator(s) for the u-component of vectors.
               The parameter indicator for the v-component is assumed
               to be one more than that of the u-component.
               If the -v option is not specified, then the wind
               components (parameters 33 and 34) are the only fields
               assumed to be vector components in the GRIB file.

-x
               Turns off the use of an index file. The index records
               are then extracted from the GRIB file, which
               will increase the time taken by copygb.

-X
               Turns on verbose printout. This option is
               incompatible with GRIB output to standard output.

# Examples


1. Interpolate an entire GRIB file to the 2.5 x 2.5 global grid.

<pre>
   day=960716
   g1=/com/fnl/PROD/fnl.$day/gdas1.T00Z.PGrbF00
   x1=/com/fnl/PROD/fnl.$day/gdas1.T00Z.PGrbiF00

   copygb -g2 $g1 $x1 gribout1
</pre>

2. Copy precipitation using budget interpolation to the AWIPS 212 grid.

<pre>
   day=960716
   g1=/com/avn/PROD/avn.$day/gblav.T00Z.PGrbF24
   x1=/com/avn/PROD/avn.$day/gblav.T00Z.PGrbiF24

   copygb -g212 -i3 -k'4*-1 61' $g1 $x1 gribout2
</pre>

3. Copy precipitation, interpolating rain and no-rain domains separately.

<pre>
   day=960716
   g1=/com/avn/PROD/avn.$day/gblav.T00Z.PGrbF24
   x1=/com/avn/PROD/avn.$day/gblav.T00Z.PGrbiF24

   copygb -g212 -i3 -k'4*-1 61' -B-1 -K-1 -A\>0 -M\#0 $g1 $x1 gribout3
</pre>

4. Copy precipitation again, but with no index file and only over land.

<pre>
   day=960716
   g1=/com/avn/PROD/avn.$day/gblav.T00Z.PGrbF24

   copygb -xg212 -i3 -k'4*-1 61' -B-1 -K'4*-1 81' -A\>0.5 $g1 gribout4
</pre>

5. Copy momentum flux as a vector to a user-defined grid, specifically
   a 0.1 x 0.1 degree grid from 25N to 45N and from 90W to 70W.

<pre>
   day=960716
   g1=/com/avn/PROD/avn.$day/gblav.T00Z.PGrbF24
   grid='255 0 201 201 25000 270000 128 45000 290000 100 100 64'

   copygb -g"$grid" -i3 -k'4*-1 124' -v124 $g1 $x1 gribout5
</pre>

6. Interpolate 250 mb height from staggered eta grid to AWIPS 212 grid.

<pre>
   day=960716
   g1=/com/eta/PROD/meso.$day/meso.T12Z.EGRD3D09.tm00

   copygb -xg212 -k'4*-1 7 100 250' $g1 gribout6
</pre>

7. Verbosely extract 500 mb height from ECMWF file.

<pre>
   day=960716
   g1=/scom/mrf/prod/ecmwf.$day/ecmgrb25.T12Z
   x1=/scom/mrf/prod/ecmwf.$day/ecmgrbi25.T12Z

   copygb -X -k'4*-1,7,100,500' $g1 $x1 gribout7
</pre>

8. Use wgrib to extract 1000 and 500 mb heights to grid 2
   and append output to the pre-existing file gribarch8.

<pre>
   day=19991005
   g1=/com/fnl/prod/fnl.$day/gdas1.t00z.pgrbf00

   wgrib $g1|grep :HGT:|grep -E ':1000 mb:|:500 mb:'|\
   copygb -xg2 -kw -a $g1 gribarch8
</pre>

9. Use wgrib to merge two WAFS files onto grid 212.

<pre>
   copygb -xg212 -M wafs39 wafs40 wafs212
</pre>

10. Force vertical velocity to have a decimal scaling of 3.

<pre>
   day=20000119
   g1=/com/eta/prod/eta.$day/eta.t12z.awip3224.tm00
   echo ' &NLCOPYGB IDS(039)=3, /' >tmpnlcopygb
   copygb -N tmpnlcopygb -g3 -x $g1 gribout10
   rm tmpnlcopygb
</pre>


