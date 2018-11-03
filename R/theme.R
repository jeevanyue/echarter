
themeSet <- function(theme = "default"){
  themeArray <- c("dark", "infographic", "macarons", "roma", "shine", "vintage")
  if(.is_ec_theme(theme)){
    return_theme = 'ec_theme'
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

addThemeDependencies <- function(ec, theme){
  if(.is_ec_theme(theme)){
    class(theme) <- "list"
    ec$x[["ec_theme"]] <- jsonlite::toJSON(theme)

  }else{
    if(ec$x$theme != "default"){
      ec$dependencies <- c(ec$dependencies, themeDependencies(theme))
    }
  }
  return(ec)
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

