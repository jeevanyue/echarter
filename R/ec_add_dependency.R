deps_js <- function(name, deps){

  name_ <- name[name %in% deps$name]

  if(length(name_) > 0){
    dep <- lapply(seq(1, length(name_)), function(x){
      src <- system.file("htmlwidgets/plugins", package = "echarter")
      script <- unique(deps$js[deps$name == name_[x]][[1]])
      Name_ <- name_[x]
      htmltools::htmlDependency(Name_, "0.0.1", src = src, script = script)
    })
  }else{
    dep <- NULL
  }

  return(dep)
}

#' Add plugin dependencies to echarts objects
#'
#' @param ec A `echarter` `htmlwidget` object.
#' @param name The partial name or js file
#'
#' @examples
#'
#' @export
ec_add_dependency <- function(ec, name = NULL) {

  deps <- tibble::tibble(
    name = c('liquidFill', 'wordCloud', 'bmap', 'china', 'world'),
    js = list(
      'echarts-liquidfill.min.js',
      'echarts-wordcloud.min.js',
      c("bmap.js", "bmapAK.js"),
      'map/china.js',
      'map/world.js'))

  series_type_deps <- tibble::tibble(
    name = c('liquidFill', 'wordCloud', 'bmap'),
    js = list(
      'echarts-liquidfill.min.js',
      'echarts-wordcloud.min.js',
      c("bmap.js", "bmapAK.js")))

  map_deps <- tibble::tibble(
    name = c('china', 'world'),
    js = list(
      'map/china.js',
      'map/world.js'))

  gl_series_type_deps <- c('scatter3D', 'bar3D', 'line3D', 'lines3D', 'map3D', 'surface', 'polygons3D', 'scatterGL', 'graphGL', 'flowGL')

  gl_opts_deps <- c('globe', 'geo3D', 'mapbox3D', 'grid3D', 'xAxis3D', 'yAxis3D', 'zAxis3D')

  ## ec dependencies
  if(!is.null(ec$dependencies)){
    ec_deps_n <- length(ec$dependencies)
    ec_deps <- lapply(seq(1,ec_deps_n), function(x){
      ec$dependencies[[x]][['name']] })
    ec_deps <- unlist(ec_deps)
  }else{
    ec_deps <- NULL
  }

  if(!is.null(name)) {

    if(grepl(".js", basename(name))){

      script <- basename(name)
      jsdir <- dirname(name)

      if(jsdir == '.'){
        jsfullpath <- file.path(getwd(), name)
      }else if(grepl("\\./", jsdir)){
        Name_tmp <- str_replace(name, "./", "")
        jsfullpath <- file.path(getwd(), Name_tmp)
      }else{
        jsfullpath <- name
      }

      src <- dirname(jsfullpath)
      Name_ <- tools::file_path_sans_ext(script)

      dep <- list(htmltools::htmlDependency(Name_, "0.0.1", src = src, script = script))

    }else{
      if(!(name %in% deps$name)){
        stop('name must in liquidFill,wordCloud,bmap,map or NULL!')
      }else{

        if(all(name %in% ec_deps)){
          dep <- NULL
        }else{

          src <- system.file("htmlwidgets/plugins", package = "echarter")
          script <- unique(deps$js[deps$name == name][[1]])
          Name_ <- name

          dep <- list(htmltools::htmlDependency(Name_, "0.0.1", src = src, script = script))

        }
      }
    }
  }else{
    ## map dependency
    series_mapType <- unique(unlist(ec_get_opt(ec, "series.mapType")))
    geo_map <- ec_get_opt(ec, "geo.map")
    geo3D_map <- ec_get_opt(ec, "geo3D.map")

    maps <- unique(c(series_mapType, geo_map, geo3D_map))
    deps_name_ <- maps[maps %in% map_deps$name]
    deps_name_ <- deps_name_[!(deps_name_ %in% ec_deps)]

    dep <- deps_js(name = deps_name_, deps = map_deps)

    ## coord dependency
    series_coord <- unique(unlist(ec_get_opt(ec, "series.coordinateSystem")))

    ## type dependency
    series_type <- unique(unlist(ec_get_opt(ec, "series.type")))
    deps_name_ <- series_type[series_type %in% series_type_deps$name]
    deps_name_ <- deps_name_[!(deps_name_ %in% ec_deps)]

    dep_type <- deps_js(name = deps_name_, deps = series_type_deps)

    dep <- append(dep, dep_type)

    ## gl dependency
    if('gl' %in% ec_deps){
      dep_gl <- NULL
    }else{
      if(any(names(ec$x$opt) %in% gl_opts_deps) | any(deps_name_ %in% gl_series_type_deps)){

        deps_name_ <- "gl"
        src <- system.file("htmlwidgets/plugins", package = "echarter")
        script <- "echarts-gl.min.js"
        Name_ <- deps_name_

        dep_gl <- list(htmltools::htmlDependency(Name_, "0.0.1", src = src, script = script))
      }else{
        dep_gl = NULL
      }
    }

    dep <- append(dep, dep_gl)

  }

  ec$dependencies <- c(ec$dependencies, dep)

  ec

}
