library(rgdal)     # for "readOGR"
library(maptools)  # for "thinnedSpatialPoly"

provinces_r <- readOGR("data-raw", "provinces")
districts_r <- readOGR("data-raw", "districts")
communes_r <- readOGR("data-raw", "communes")

communes_r@data$ADDRESS <- NULL
names(communes_r@data) <- c("object_id", "commune_id", "district_id",
                            "commune_vn", "commune", "district_vn", "district",
                            "province_vn", "province", "province_id",
                            "shape_length", "shape_area")
communes_r@data <- communes_r@data[, c("object_id", "commune_id", "district_id",
                                       "province_id", "commune", "district",
                                       "province", "commune_vn", "district_vn",
                                       "province_vn", "shape_length", "shape_area")]

districts_r@data$UniqueIden <- NULL
names(districts_r@data) <- c("object_id", "district_id",
                            "district_vn", "district",
                            "province", "level", "type", "province_id",
                            "shape_length", "shape_area")
districts_r@data <- districts_r@data[, c("object_id", "level", "type",
                                         "district_id", "province_id", "district",
                                         "province", "district_vn",
                                         "shape_length", "shape_area")]

communes_r@data <- communes_r@data[, c("object_id", "commune_id", "district_id",
                                       "province_id", "commune", "district",
                                       "province", "commune_vn", "district_vn",
                                       "province_vn", "shape_length", "shape_area")]

names(provinces_r@data) <- c("object_id", "province_vn", "province", "province_id",
                             "shape_length", "shape_area")
provinces_r@data <- provinces_r@data[, c("object_id", "province_id", "province",
                                         "province_vn", "shape_length", "shape_area")]

pr <- sub("Ba Ria-Vung Tau", "Ba Ria - Vung Tau", provinces_r@data$province)
provinces_r@data$province <- sub("Thua Thien Hue", "Thua Thien - Hue", pr)

pr <- sub("Ba Ria Vung Tau", "Ba Ria - Vung Tau", districts_r@data$province)
pr <- sub("Can Tho city", "Can Tho", pr)
pr <- sub("Da Nang city", "Da Nang", pr)
pr <- sub("Hai Phong city", "Hai Phong", pr)
pr <- sub("Ho Chi Minh city", "Ho Chi Minh", pr)
pr <- sub("Quang BInh", "Quang Binh", pr)
districts_r@data$province <- sub("Thua Thien Hue", "Thua Thien - Hue", pr)

pr <- sub("Thua Thien Hue", "Thua Thien - Hue", communes_r@data$province)
pr <- sub("Ninh Bình", "Ninh Binh", pr)
communes_r@data$province <- sub("Ba Ria Vung Tau", "Ba Ria - Vung Tau", pr)


provinces <- thinnedSpatialPoly(provinces_r, .01)
districts <- thinnedSpatialPoly(districts_r, .0036)
communes <- thinnedSpatialPoly(communes_r, .00145)

devtools::use_data(provinces, districts, communes, provinces_r, districts_r,
                   communes_r, overwrite = TRUE)
