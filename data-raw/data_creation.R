library(rgdal)     # for "readOGR"
library(maptools)  # for "thinnedSpatialPoly"

provinces_r <- readOGR("data-raw", "provinces")
districts_r <- readOGR("data-raw", "districts")
communes_r <- readOGR("data-raw", "communes")

provinces <- thinnedSpatialPoly(provinces_r, .01)
districts <- thinnedSpatialPoly(districts_r, .0036)
communes <- thinnedSpatialPoly(communes_r, .00145)
