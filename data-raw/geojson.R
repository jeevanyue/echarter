USA_geojson <- jsonlite::read_json("http://www.echartsjs.com/gallery/data/asset/geo/USA.json")

usethis::use_data(USA_geojson, overwrite = TRUE)
