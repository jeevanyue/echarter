dnb_land_ocean_ice <- paste0(
  "data:image/png;base64,",
  base64enc::base64encode(
    'https://github.com/jeevanyue/echarter_docs/raw/master/data/gl/dnb_land_ocean_ice.2012.3600x1800.jpg'
  )
)

usethis::use_data(dnb_land_ocean_ice, overwrite = TRUE)
