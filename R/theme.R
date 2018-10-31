
themeSet <- function(theme = "default"){
  themeArray <- c("dark", "infographic", "macarons", "roma", "shine", "vintage")
  if(.is_ec_theme(theme)){
    return_theme = 'customed'
  }else{
    if(grepl(".js", basename(theme))){
      return_theme <- 'customed'
      return_theme <- tools::file_path_sans_ext(basename(theme))
    }else if(is.numeric(theme)){
      return_theme <- themeArray[theme]
    }else if(length(which(themeArray == theme)) == 1){
      return_theme <- theme
    }else{
      return_theme <- "default"
    }
  }
  return(return_theme)
}

addThemeDependencies <- function(chart, theme){
  if(.is_ec_theme(theme)){

    if(is.null(names(chart$x$opt))){
      class(theme) <- "list"
      chart$x$opt <- theme
    }else{
      chart$x$opt <- rlist::list.merge(chart$x$opt, theme)
    }

  }else{
    if(chart$x$theme != "default"){
      chart$dependencies <- c(chart$dependencies, themeDependencies(theme))
      # if(chart$x$theme != 'customed'){
      #   chart$dependencies <- c(chart$dependencies, themeDependencies(chart$x$theme))
      # }else{
      #   chart$dependencies <- c(chart$dependencies, themeDependencies(theme))
      # }
    }
  }
  return(chart)
}

themeDependencies <- function(themeName){
  if(grepl(".js", basename(themeName))){
    themeName <- tools::file_path_as_absolute(themeName)

    script <- basename(themeName)

    jsdir <- dirname(themeName)

    if(jsdir == '.'){
      jsfullpath <- file.path(getwd(), themeName)
    }else if(grepl("\\./", jsdir)){
      themeName_tmp <- str_replace(themeName, "./", "")
      jsfullpath <- file.path(getwd(), themeName_tmp)
    }else{
      jsfullpath <- themeName
    }

    src <- dirname(jsfullpath)

    themeName_ <- tools::file_path_sans_ext(script)
  }else{
    src <- system.file("htmlwidgets/themes", package = "echarter")
    script <- paste0(themeName, ".js")
    themeName_ <- themeName
  }

  list(
    htmltools::htmlDependency(
      themeName_,
      "0.0.1",
      src = src,
      script = script
    )
  )
}

.is_ec_theme <- function(ec_theme){
  assertthat::are_equal(class(ec_theme), "ec_theme")
}

#' define ec_theme object
#'
#' @param ... A `list` object containing options defined as
#'    \url{http://echarts.baidu.com/option.html}.
#'
#' @export
#'
ec_theme <- function(...){
  if (is.null(names(list(...)))) {
    structure(c(...), class = "ec_theme")
  }else{
    structure(list(...), class = "ec_theme")
  }
}

#' Add echarts theme
#'
#' @param theme A `ec_theme` object containing options defined as
#'    \url{http://echarts.baidu.com/option.html}.
#'
#' @export
#'
ec_add_theme <- function(ec, theme, series = TRUE){

  assertthat::assert_that(is.echart(ec), .is_ec_theme(theme))

  # some echarts havn't series
  if(series == FALSE){
    names <- names(theme)[!grepl("xAxis|yAxis", names(theme))]
    theme <- theme[names]
  }

  if(is.null(names(ec$x$opt))){
    class(theme) <- "list"
    ec$x$opt <- theme
  }else{
    ec$x$opt <- rlist::list.merge(ec$x$opt, theme)
  }

  ec

}
