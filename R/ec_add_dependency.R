
#' Add plugin dependencies to echarts objects
#'
#' @param ec A `echarter` `htmlwidget` object.
#' @param name The partial name or js file
#'
#' @examples
#'
#' @export
ec_add_dependency <- function(ec, name = NULL) {

  deps <- tibble::data_frame(
    name = c('liquidFill', 'wordCloud', 'bmap', 'china', 'world'),
    js = list(
      'echarts-liquidfill.min.js',
      'echarts-wordcloud.min.js',
      c("bmap.js", "bmapAK.js"),
      'map/china.js',
      'map/world.js'))

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
    tmp_series.type <- unique(unlist(ec_get_opt(ec, "series.type")))
    tmp_series.coord <- unique(unlist(ec_get_opt(ec, "series.coordinateSystem")))
    tmp_series.mapType <- unique(unlist(ec_get_opt(ec, "series.mapType")))
    tmp_geo.map <- ec_get_opt(ec, "geo.map")

    tmp <- unique(c(tmp_series.type, tmp_geo.map, tmp_series.type, tmp_series.mapType))

    if(any(tmp %in% deps$name)){
      tmp_ <- tmp[tmp %in% deps$name]
      if(all(tmp_ %in% ec_deps)){
        dep <- NULL
      }else{
        src <- system.file("htmlwidgets/plugins", package = "echarter")
        script <- unique(deps$js[deps$name == tmp_][[1]])
        Name_ <- tmp_

        dep <- list(htmltools::htmlDependency(Name_, "0.0.1", src = src, script = script))

      }
    }else{
      dep <- NULL
    }

  }

  ec$dependencies <- c(ec$dependencies, dep)

  ec

}
