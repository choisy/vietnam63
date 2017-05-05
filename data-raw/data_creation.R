library(rgdal)     # for "readOGR"
library(maptools)  # for "thinnedSpatialPoly"

provinces_r <- readOGR("data-raw", "provinces")
districts_r <- readOGR("data-raw", "districts")
communes_r <- readOGR("data-raw", "communes")

pr <- sub("Ba Ria-Vung Tau", "Ba Ria - Vung Tau", provinces_r@data$NAME_ENG)
provinces_r@data$province <- sub("Thua Thien Hue", "Thua Thien - Hue", pr)

pr <- sub("Ba Ria Vung Tau", "Ba Ria - Vung Tau", districts_r@data$name_prov)
pr <- sub("Can Tho city", "Can Tho", pr)
pr <- sub("Da Nang city", "Da Nang", pr)
pr <- sub("Hai Phong city", "Hai Phong", pr)
pr <- sub("Ho Chi Minh city", "Ho Chi Minh", pr)
pr <- sub("Quang BInh", "Quang Binh", pr)
districts_r@data$province <- sub("Thua Thien Hue", "Thua Thien - Hue", pr)

pr <- sub("Thua Thien Hue", "Thua Thien - Hue", communes_r@data$PRO_NAME_E)
pr <- sub("Ninh Bình", "Ninh Binh", pr)
communes_r@data$province <- sub("Ba Ria Vung Tau", "Ba Ria - Vung Tau", pr)

provinces <- thinnedSpatialPoly(provinces_r, .01)
districts <- thinnedSpatialPoly(districts_r, .0036)
communes <- thinnedSpatialPoly(communes_r, .00145)

devtools::use_data(provinces, districts, communes, provinces_r, districts_r,
                   communes_r, overwrite = TRUE)
