#!/bin/bash

# this script is to demonstrate the differences between jp2 and cog datasets.
# For this purpose, the data sets are obtained via aws and then compared with each other.

# source item
# https://earth-search.aws.element84.com/v1/collections/sentinel-2-l2a/items/S2A_33UWP_20230209_0_L2A

# href from assets.red:
COG_URL="https://sentinel-cogs.s3.us-west-2.amazonaws.com/sentinel-s2-l2a-cogs/33/U/WP/2023/2/S2A_33UWP_20230209_0_L2A/B04.tif"

# note that the link in assets.red-jp2.href points to "s3://sentinel-s2-l2a/tiles/33/U/WP/2023/2/9/0/B04.jp2", but this directory does not exist. 
# The last subdirectory "./R10m/." is missing.
JP2_S3="s3://sentinel-s2-l2a/tiles/33/U/WP/2023/2/9/0/R10m/B04.jp2"

# fetch data from COG
gdal_translate -srcwin 1536 1536 256 256 /vsicurl/$COG_URL ./e84_b04_cog.tif

# fetch data from JP2
aws s3 cp --request-payer requester $JP2_S3 ./e84_b04_all.jp2
gdal_translate -srcwin 1536 1536 256 256 ./e84_b04_all.jp2 ./e84_b04_jp2.tif


# calculate diferenc between the two images
gdal_calc.py --calc="A-B" --outfile=diff.tif -A e84_b04_jp2.tif -B e84_b04_cog.tif

#  get min/max (should be 0)
gdalinfo -mm diff.tif

# Computed Min/Max=789.000,1000.000
