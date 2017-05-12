# vietnam63

This package contains the polygons of the communes (11,163), districts (703) and
provinces (63) or Vietnam after the last major administrative border update of
2008, January 1st (essentially the merging of the provinces of Ha Tay and Ha
Noi). The package contains 6 `SpatialPolygonsDataFrame`: `communes`,
`districts`, and `provinces` for low polygons resolution and `communes_r`,
`districts_r`, and `provinces_r` for high polygons resolution. These objects can
be loaded with the base R `data` function:

```{r}
library(vietnam63)
data(communes)
data(districts)
data(provinces)
```

And can be plotted with the `sp` `plot` method:

```{r}
library(sp)
plot(communes)
plot(districts)
plot(provinces)
```

The attributes of these spatial objects are:

```{r}
head(communes@data)
head(districts@data)
head(provinces@data)
```

And we can verify the consistency between the 3 spatial objects:

```{r}
length(communes_r)
length(unique(communes_r$district_id))
length(districts_r)
setdiff(communes_r$district_id, districts_r$district_id)
length(unique(districts_r$province_id))
length(provinces_r)
setdiff(provinces_r$province_id, districts_r$province_id)
```

