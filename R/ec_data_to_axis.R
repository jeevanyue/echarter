
ec_data_to_axis <- function(ec, data, mapping, ...) {

  # type
  if(!rlang::has_name(list(...), 'type')){
    stop("haven't the type value of series")
  }else {
    type <- list(...)[['type']]
  }

  # coordinateSystem
  if(rlang::has_name(list(...), 'coordinateSystem')){
    coordinateSystem <- list(...)[['coordinateSystem']]
  }else{
    coordinateSystem <- NULL
  }
  if(type == 'themeRiver'){
    coordinateSystem <- "singleAxis"
  }

  opt <- ec$x$opt

  if(type %in% c('line','bar','scatter','effectScatter','boxplot','candlestick','pictorialBar','lines','heatmap','themeRiver')){

    if(is.null(coordinateSystem)) {
      # coordinateSystem <- "cartesian2d"

      # x
      if(is.null(opt$xAxis)){
        opt$xAxis <- list()
        if (rlang::has_name(data, "x")) {
          if (lubridate::is.Date(data[["x"]])) {
            opt$xAxis$type <- "time"
          } else if (is.character(data[["x"]]) | is.factor(data[["x"]])) {
            opt$xAxis$type <- "category"
          } else {
            opt$xAxis$type <- "value"
          }
        }
      }else{
        if(!is.null(names(opt$xAxis))){
          if(is.null(opt$xAxis$type)){
            opt$xAxis$type <- list()
            if (rlang::has_name(data, "x")) {
              if (lubridate::is.Date(data[["x"]])) {
                opt$xAxis$type <- "time"
              } else if (is.character(data[["x"]]) | is.factor(data[["x"]])) {
                opt$xAxis$type <- "category"
              } else {
                opt$xAxis$type <- "value"
              }
            }
          }
        }
      }
      # y
      if(is.null(opt$yAxis)){
        opt$yAxis <- list()
        if (rlang::has_name(data, "y")) {
          if (lubridate::is.Date(data[["y"]])) {
            opt$yAxis$type <- "time"
          } else if (is.character(data[["y"]]) | is.factor(data[["y"]])) {
            opt$yAxis$type <- "category"
          } else {
            opt$yAxis$type <- "value"
          }
        }
      }else{
        if(!is.null(names(opt$yAxis))){
          if(is.null(opt$yAxis$type)){
            opt$yAxis$type <- list()
            if (rlang::has_name(data, "y")) {
              if (lubridate::is.Date(data[["y"]])) {
                opt$yAxis$type <- "time"
              } else if (is.character(data[["y"]]) | is.factor(data[["y"]])) {
                opt$yAxis$type <- "category"
              } else {
                opt$yAxis$type <- "value"
              }
            }
          }
        }
      }
    }else if(coordinateSystem == 'polar'){

      if(is.null(opt$polar)){
        opt$polar <- list()
      }

      # x -> angleAxis
      if(is.null(opt$angleAxis)){
        opt$angleAxis <- list()
        if (rlang::has_name(data, "x")) {
          if (lubridate::is.Date(data[["x"]])) {
            opt$angleAxis$type <- "time"
          } else if (is.character(data[["x"]]) | is.factor(data[["x"]])) {
            opt$angleAxis$type <- "category"
          } else {
            opt$angleAxis$type <- "value"
          }
        }
      }else{
        if(!is.null(names(opt$angleAxis))){
          if(is.null(opt$angleAxis$type)){
            opt$angleAxis$type <- list()
            if (rlang::has_name(data, "x")) {
              if (lubridate::is.Date(data[["x"]])) {
                opt$angleAxis$type <- "time"
              } else if (is.character(data[["x"]]) | is.factor(data[["x"]])) {
                opt$angleAxis$type <- "category"
              } else {
                opt$angleAxis$type <- "value"
              }
            }
          }
        }
      }
      # y -> radiusAxis
      if(is.null(opt$radiusAxis)){
        opt$radiusAxis <- list()
        if (rlang::has_name(data, "y")) {
          if (lubridate::is.Date(data[["y"]])) {
            opt$radiusAxis$type <- "time"
          } else if (is.character(data[["y"]]) | is.factor(data[["y"]])) {
            opt$radiusAxis$type <- "category"
          } else {
            opt$radiusAxis$type <- "value"
          }
        }
      }else{
        if(!is.null(names(opt$radiusAxis))){
          if(is.null(opt$radiusAxis$type)){
            opt$radiusAxis$type <- list()
            if (rlang::has_name(data, "y")) {
              if (lubridate::is.Date(data[["y"]])) {
                opt$radiusAxis$type <- "time"
              } else if (is.character(data[["y"]]) | is.factor(data[["y"]])) {
                opt$radiusAxis$type <- "category"
              } else {
                opt$radiusAxis$type <- "value"
              }
            }
          }
        }
      }

    }else if(coordinateSystem == 'geo'){
      if(is.null(opt$geo)){
        opt$geo <- list()
      }
    }else if(coordinateSystem == 'singleAxis'){
      if(is.null(opt$singleAxis)){
        opt$singleAxis <- list()
      }
    }else if(coordinateSystem == 'calendar'){
      if(is.null(opt$calendar)){
        opt$calendar <- list()
      }
    }

  }else if(type %in% c('pie', 'tree', 'treemap', 'sunburst', 'map', 'sankey', 'funnel', 'gauge', 'graph')){
    coordinateSystem <- NULL

  }else if(type == 'radar'){
    coordinateSystem <- NULL

    if(is.null(opt$radar)){
      opt$radar <- list()
    }

  }else if(type == "parallel"){
    coordinateSystem <- "parallel"

    if(is.null(opt$parallel)){
      opt$parallel <- list()
    }

    if(is.null(opt$parallelAxis)){
      opt$parallelAxis <- list()
      if (rlang::has_name(data, "y")) {
        if (lubridate::is.Date(data[["y"]])) {
          opt$parallelAxis$type <- "time"
        } else if (is.character(data[["y"]]) | is.factor(data[["y"]])) {
          opt$parallelAxis$type <- "category"
        } else {
          opt$parallelAxis$type <- "value"
        }
      }
    }

  }else if(type == "custom"){

  }

  ec$x$opt <- opt

  ec

}
