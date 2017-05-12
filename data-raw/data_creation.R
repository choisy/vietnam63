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
#communes_r@data <- communes_r@data[, c("object_id", "commune_id", "district_id",
#                                       "province_id", "commune", "district",
#                                       "province", "commune_vn", "district_vn",
#                                       "province_vn", "shape_length", "shape_area")]
communes_r@data <- communes_r@data[, c("object_id", "province_id", "district_id", "commune_id",
                                       "province", "district", "commune",
                                       "province_vn", "district_vn", "commune_vn",
                                       "shape_length", "shape_area")]


districts_r@data$UniqueIden <- NULL
names(districts_r@data) <- c("object_id", "district_id",
                            "district_vn", "district",
                            "province", "level", "type", "province_id",
                            "shape_length", "shape_area")
hash <- with(lapply(unique(communes@data[, c("province", "province_vn")]), as.character),
             setNames(province_vn, province))
districts_r@data$province_vn <- hash[districts_r@data$province]

#districts_r@data <- districts_r@data[, c("object_id", "level", "type",
#                                         "district_id", "province_id", "district",
#                                         "province", "district_vn",
#                                         "shape_length", "shape_area")]
districts_r@data <- districts_r@data[, c("object_id", "province_id", "district_id",
                                         "province", "district",
                                         "province_vn", "district_vn",
                                         "shape_length", "shape_area")]

#communes_r@data <- communes_r@data[, c("object_id", "commune_id", "district_id",
#                                       "province_id", "commune", "district",
#                                       "province", "commune_vn", "district_vn",
#                                       "province_vn", "shape_length", "shape_area")]

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

rownames(communes_r@data) <- NULL
for(i in seq_along(communes_r@polygons))
  communes_r@polygons[[i]]@ID <- as.character(as.numeric(communes_r@polygons[[i]]@ID) + 1)
rownames(districts_r@data) <- NULL
for(i in seq_along(districts_r@polygons))
  districts_r@polygons[[i]]@ID <- as.character(as.numeric(districts_r@polygons[[i]]@ID) + 1)
rownames(provinces_r@data) <- NULL
for(i in seq_along(provinces_r@polygons))
  provinces_r@polygons[[i]]@ID <- as.character(as.numeric(provinces_r@polygons[[i]]@ID) + 1)

# Fixing a commune ID:
communes_r@data[communes_r@data$district_id == 60141, "district_id"] <- 60114

# Fixing districts:
districts_to_remove <- names(which(table(communes_r$district_id) < 2))
communes_r <- subset(communes_r, !(district_id %in% districts_to_remove))
districts_r <- subset(districts_r, !(district_id %in% districts_to_remove))

tomerge <- subset(districts_r, object_id %in% c(357, 704))
merged <- maptools::unionSpatialPolygons(tomerge, c(357, 357))
attr(merged@polygons[[1]]@Polygons[[1]]@coords, "dimnames") <- NULL
sel <- which(sapply(districts_r@polygons, function(x) x@ID) == 357)
districts_r@polygons[[sel]] <- merged@polygons[[1]]
districts_r <- subset(districts_r, !(object_id %in% paste(c(385, 617, 704))))

# Checking that everything is alright:
length(communes_r)
length(unique(communes_r$district_id))
length(districts_r)
setdiff(communes_r$district_id, districts_r$district_id)
length(unique(districts_r$province_id))
length(provinces_r)
setdiff(provinces_r$province_id, districts_r$province_id)

# Thining polygons:
provinces <- thinnedSpatialPoly(provinces_r, .01)
districts <- thinnedSpatialPoly(districts_r, .0036)
communes <- thinnedSpatialPoly(communes_r, .00145)

# Saving:
devtools::use_data(provinces, districts, communes, provinces_r, districts_r,
                   communes_r, overwrite = TRUE)
