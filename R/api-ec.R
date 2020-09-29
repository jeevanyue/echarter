
#' @export
ec_list_parse <- function (df) {
  assertthat::assert_that(is.data.frame(df))
  purrr::map_if(df, is.factor, as.character) %>%
    tibble::as_tibble() %>%
    rlist::list.parse() %>% setNames(NULL)
}

#' @export
validate_args <- function(name, lstargs) {
  lstargsnn <- lstargs[which(names(lstargs) == "")]
  lenlst <- length(lstargsnn)
  if (lenlst != 0) {
    chrargs <- lstargsnn %>%
      unlist() %>%
      as.character()
    chrargs <- paste0("'", chrargs, "'", collapse = ", ")
    txt <- ifelse(lenlst == 1, " is ", "s are ")
    stop(chrargs, " argument", txt, "not named in ", paste0("ec_", name),
         call. = FALSE)
  }
}

## set ec options
.ec_opt = function(ec, opt_name, baseoption = FALSE, add = FALSE, ...){
  assertthat::assert_that(is.echart(ec))

  validate_args(opt_name, eval(substitute(alist(...))))

  if(rlang::has_name(list(...), 'id')){
    add = TRUE
  }

  if(!baseoption){
    if (is.null(ec$x$opt[[opt_name]])) {
      if(is.null(names(c(...)))){
        ec$x$opt[[opt_name]] <- c(...)
      }else{
        ec$x$opt[[opt_name]] <- list(...)
      }
    }else{
      if(length(ec$x$opt[[opt_name]]) == 0){
        ec$x$opt[[opt_name]] <- list(...)
      }else{
        if(add == FALSE){
          # if add == FALSE, change option
          ec$x$opt[[opt_name]] <- rlist::list.merge(ec$x$opt[[opt_name]], list(...))
        }else{
          # if add == TRUE, add option
          if(is.null(names(ec$x$opt[[opt_name]]))){
            ec$x$opt[[opt_name]] <- append(ec$x$opt[[opt_name]], list(list(...)))
          }else{
            ec$x$opt[[opt_name]] <- append(list(ec$x$opt[[opt_name]]), list(list(...)))
          }
        }
      }
    }
  }else{
    if (is.null(ec$x$opt$baseOption[[opt_name]])) {
      if(is.null(names(c(...)))){
        ec$x$opt$baseOption[[opt_name]] <- list(...)
      }else{
        ec$x$opt$baseOption[[opt_name]] <- list(...)
      }
    }else{
      if(add == FALSE){
        ec$x$opt$baseOption[[opt_name]] <- rlist::list.merge(ec$x$opt$baseOption[[opt_name]], list(...))
      }else{
        if(is.null(names(ec$x$opt$baseOption[[opt_name]]))){
          ec$x$opt$baseOption[[opt_name]] <- append(ec$x$opt$baseOption[[opt_name]], list(list(...)))
        }else{
          ec$x$opt$baseOption[[opt_name]] <- append(list(ec$x$opt$baseOption[[opt_name]]), list(list(...)))
        }
      }
    }
  }

  ec %>%
    ec_add_dependency()

}

.index_add <- function(index = NULL){
  if(!is.null(index)){
    TRUE
  }else{
    FALSE
  }
}

ec_get_opt_ <- function(ec, opt = NULL, index = NULL, num = NULL){
  assertthat::assert_that(is.echart(ec))

  if(is.null(opt)) stop("opt cannot be NULL")
  if(!is.character(opt)) stop("opt must be character")
  if(length(opt) != 1) stop("the length opt must be 1")
  if(nchar(opt) == 0) stop("the nchar op opt must be greater than 0")

  opt_char <- stringr::str_extract(opt, "(\\D)+")

  opt_num <- as.numeric(stringr::str_extract(opt, "(\\d)+"))

  if(!is.na(opt_num)){
    num <- opt_num
  }

  if(is.null(ec$x$opt[[opt_char]])){
    opt_ <- NULL
  }else{

    if(is.null(names(ec$x$opt[[opt_char]]))){
      opt_length <- length(ec$x$opt[[opt_char]])

      if(!is.null(index)){
        id_index <- lapply(seq(length(ec$x$opt[[opt_char]])), function(x){
          tmp <- ec$x$opt[[opt_char]][[x]][["id"]]
          if(is.null(tmp)){tmp <- 0}
          list(id_index = tmp)
        })

        id_index_ <- rlist::list.map(id_index, id_index == index)

        id_index_match <- which(id_index_ == TRUE)

        if(length(id_index_match) > 1){
          stop(paste0("opt index = ", index, " have ", length(id_index_match), " opt"))
        }else if(length(id_index_match) == 0){
          opt_ <- NULL
        }else{
          opt_ <- ec$x$opt[[opt_char]][[id_index_match]]
        }

        return(opt_)
      }
    }else{
      opt_length <- 0

      if(!is.null(index)){
        tmp <- "id" %in% names(ec$x$opt[[opt_char]])
        if(!tmp){
          opt_index = 0
        }else{
          opt_index <- ec$x$opt[[opt_char]][["id"]]
        }

        if(opt_index == index){
          opt_ <- ec$x$opt[[opt_char]]
        }else{
          opt_ <- NULL
        }
        return(opt_)
      }
    }

    if(!is.null(num)){
      if(is.null(names(ec$x$opt[[opt_char]]))){
        opt_length <- length(ec$x$opt[[opt_char]])
      }else{
        opt_length <- 1
      }

      if(num <= 0) stop("num must be greater than 0")
      if(num > opt_length) stop("num must be less than or equal to the length of opt")

      if(is.null(names(ec$x$opt[[opt_char]]))){
        opt_ <- ec$x$opt[[opt_char]][[num]]
      }else{
        opt_ <- ec$x$opt[[opt_char]]
      }
    }else{
      opt_ <- ec$x$opt[[opt_char]]
    }
  }

  return(opt_)
}


#' Get echarter options
#'
#' @description Get echarter options
#'
#' @param ec An \code{echarter} object as returned by \code{\link{echart}}.
#' @param opt Arguments, eg:series.type or series2.data
#' @param index The id of opt, if set \code{opt = series2, index = 0}, then select the opt by id.
#' @param num The num of opt. if opt = series2, then num = 2.
#'
#' @export
ec_get_opt <- function(ec, opt = NULL, index = NULL, num = NULL){
  assertthat::assert_that(is.echart(ec))

  if(is.null(opt)) stop("opt cannot be NULL")
  if(!is.character(opt)) stop("opt must be character")
  if(length(opt) != 1) stop("the length opt must be 1")
  if(nchar(opt) == 0) stop("the nchar op opt must be greater than 0")

  opt_split <- stringr::str_split(opt, "\\.")[[1]]

  if(length(opt_split) > 2) stop("The '.' opt can only have one at most.")

  if(any(nchar(opt_split) == 0)) stop("The '.' position in opt is incorrect.")

  if(length(opt_split) == 1){
    opt_ <- ec_get_opt_(ec, opt_split[1], index = index, num = num)
  }else{
    opt_1 <- ec_get_opt_(ec, opt_split[1], index = index, num = num)
    if(is.null(opt_1)){
      opt_ <- NULL
    }else{
      if(is.null(names(opt_1))){

        opt_ <- lapply(seq(length(opt_1)), function(x) {
          opt_1[[x]][[opt_split[2]]]
        })

      }else{
        opt_ <- opt_1[[opt_split[2]]]
      }
    }
  }
  return(opt_)
}


#' @export
.get_seriesindex <- function(ec, serie){

  assertthat::assert_that(is.echart(ec))

  purrr::map(ec$x$opt$series, "name") %>%
    unlist() %>%
    grep(serie, .)
}


## basic component====

#' @export
ec_title <- function (ec, ..., baseoption = FALSE, add = FALSE) {
  .ec_opt(ec, "title", baseoption = baseoption, add = add, ...)
}

#' @export
ec_legend <- function (ec, ..., baseoption = FALSE, add = FALSE) {
  .ec_opt(ec, "legend", baseoption = baseoption, add = add, ...)
}

#' @export
ec_colors <- function(ec, colors, baseoption = FALSE) {
  assertthat::assert_that(is.vector(colors))

  if (length(colors) == 1)
    colors <- list(colors)

  if(!baseoption){
    ec$x$opt$color <- colors
  }else{
    ec$x$opt$baseOption$color <- colors
  }

  ec
}

#' @export
ec_backgroundColor <- function(ec, colors, baseoption = FALSE) {
  assertthat::assert_that(is.vector(colors))

  if (length(colors) == 1)
    colors <- list(colors)

  if(!baseoption){
    ec$x$opt$backgroundColor <- colors
  }else{
    ec$x$opt$baseOption$backgroundColor <- colors
  }

  ec
}

#' @export
ec_textStyle <- function (ec, ..., baseoption = FALSE, add = FALSE) {
  .ec_opt(ec, "textStyle", baseoption = baseoption, add = add, ...)
}

#' @export
ec_axisPointer <- function (ec, ..., baseoption = FALSE, add = FALSE) {
  .ec_opt(ec, "axisPointer", baseoption = baseoption, add = add, ...)
}

## Rectangular Coordinate====

#' grid
#'
#' @description Rectangular Coordinate
#' @param ec An \code{echarter} object as returned by \code{\link{echart}}.
#' @param ... Additional arguments for the grid
#'    (\url{https://echarts.apache.org/zh/option.html#grid}).
#' @param baseoption default FALSE
#' @param add default FALSE
#'
#' @export
ec_grid <- function(ec, ..., baseoption = FALSE, add = TRUE){
  .ec_opt(ec, "grid", baseoption = baseoption, add = add, ...)
}

#' xAxis
#'
#' @description The x axis in Rectangular Coordinate
#' @param ec An \code{echarter} object as returned by \code{\link{echart}}.
#' @param ... Additional arguments for the xAxis
#'    (\url{https://echarts.apache.org/zh/option.html#xAxis}).
#' @param baseoption default FALSE
#' @param add default FALSE
#'
#' @export
ec_xAxis <- function (ec, ..., baseoption = FALSE, add = FALSE) {
  add <- .index_add(list(...)$gridIndex)
  .ec_opt(ec, "xAxis", baseoption = baseoption, add = add, ...)
}

#' yAxis
#'
#' @description The y axis in Rectangular Coordinate
#' @param ec An \code{echarter} object as returned by \code{\link{echart}}.
#' @param ... Additional arguments for the yAxis
#'    (\url{https://echarts.apache.org/zh/option.html#yAxis}).
#' @param baseoption default FALSE
#' @param add default FALSE
#'
#' @export
ec_yAxis <- function (ec, ..., baseoption = FALSE, add = FALSE) {
  add <- .index_add(list(...)$gridIndex)
  .ec_opt(ec, "yAxis", baseoption = baseoption, add = add, ...)
}

## Polar Coordinate====

#' polor
#'
#' @description Polar Coordinate.
#'
#' @param ec An \code{echarter} object as returned by \code{\link{echart}}.
#' @param ... Additional arguments for the polor.
#'    (\url{https://echarts.apache.org/zh/option.html#polar}).
#' @param baseoption default FALSE
#' @param add default FALSE
#'
#' @export
ec_polar <- function(ec, ..., baseoption = FALSE, add = FALSE){
  .ec_opt(ec, "polar", baseoption = baseoption, add = add, ...)
}

#' angleAxis
#'
#' @description The angle axis in Polar Coordinate.
#' @param ec An \code{echarter} object as returned by \code{\link{echart}}.
#' @param ... Additional arguments for the angleAxis.
#'    (\url{https://echarts.apache.org/zh/option.html#angleAxis}).
#' @param baseoption default FALSE
#' @param add default FALSE
#'
#' @export
ec_angleAxis <- function(ec, ..., baseoption = FALSE, add = FALSE){
  add <- .index_add(list(...)$polarIndex)
  .ec_opt(ec, "angleAxis", baseoption = baseoption, add = add, ...)
}

#' radiusAxis
#'
#' @description The Radial axis in Polar Coordinate.
#' @param ec An \code{echarter} object as returned by \code{\link{echart}}.
#' @param ... Additional arguments for the radiusAxis.
#'    (\url{https://echarts.apache.org/zh/option.html#radiusAxis}).
#' @param baseoption default FALSE
#' @param add default FALSE
#'
#' @export
ec_radiusAxis <- function(ec, ..., baseoption = FALSE, add = FALSE){
  add <- .index_add(list(...)$polarIndex)
  .ec_opt(ec, "radiusAxis", baseoption = baseoption, add = add, ...)
}

## Radar Coordinate====

#' radar
#'
#' @description Radar Coordinate.
#'
#' @param ec An \code{echarter} object as returned by \code{\link{echart}}.
#' @param ... Additional arguments for the radar
#'    (\url{https://echarts.apache.org/zh/option.html#radar}).
#' @param baseoption default FALSE
#' @param add default FALSE
#'
#' @export
ec_radar <- function(ec, ..., baseoption = FALSE, add = FALSE){
  .ec_opt(ec, "radar", baseoption = baseoption, add = add, ...)
}

## Parallel Coordinates====

#' parallel
#'
#' @description Parallel Coordinates
#' @param ec An \code{echarter} object as returned by \code{\link{echart}}.
#' @param ... Additional arguments for the parallel
#'    (\url{https://echarts.apache.org/zh/option.html#parallel}).
#' @param baseoption default FALSE
#' @param add default FALSE
#'
#' @export
ec_parallel <- function(ec, ..., baseoption = FALSE, add = FALSE){
  .ec_opt(ec, "parallel", baseoption = baseoption, add = add, ...)
}

#' parallelAxis
#'
#' @description the coordinate axis for Parallel Coordinates.
#' @param ec An \code{echarter} object as returned by \code{\link{echart}}.
#' @param ... Additional arguments for the parallelAxis
#'    (\url{https://echarts.apache.org/zh/option.html#parallelAxis}).
#' @param baseoption default FALSE
#' @param add default FALSE
#'
#' @export
ec_parallelAxis <- function(ec, ..., baseoption = FALSE, add = FALSE){
  .ec_opt(ec, "parallelAxis", baseoption = baseoption, add = add, ...)
}

## Single Coordinates====

#' singleAxis
#'
#' @description An axis with a single dimension
#' @param ec An \code{echarter} object as returned by \code{\link{echart}}.
#' @param ... Additional arguments for the singleAxis
#'    (\url{https://echarts.apache.org/zh/option.html#singleAxis}).
#' @param baseoption default FALSE
#' @param add default FALSE
#'
#' @export
ec_singleAxis <- function(ec, ..., baseoption = FALSE, add = FALSE){
  .ec_opt(ec, "singleAxis", baseoption = baseoption, add = add, ...)
}

## Calendar Coordinates====

#' calendar
#'
#' @description Calendar Coordinates
#' @param ec An \code{echarter} object as returned by \code{\link{echart}}.
#' @param ... Additional arguments for the calendar
#'    (\url{https://echarts.apache.org/zh/option.html#calendar}).
#' @param baseoption default FALSE
#' @param add default FALSE
#'
#' @export
ec_calendar <- function(ec, ..., baseoption = FALSE, add = FALSE){
  .ec_opt(ec, "calendar", baseoption = baseoption, add = add, ...)
}

## Geographic Coordinates====

#' geo
#'
#' @description Geographic Coordinates
#' @param ec An \code{echarter} object as returned by \code{\link{echart}}.
#' @param ... Additional arguments for the geo
#'    (\url{https://echarts.apache.org/zh/option.html#geo}).
#' @param baseoption default FALSE
#' @param add default FALSE
#'
#' @export
ec_geo <- function(ec, ..., baseoption = FALSE, add = FALSE){
  .ec_opt(ec, "geo", baseoption = baseoption, add = add, ...)
}

#' Register map
#'
#' @description  Register a \href{geojson}{http://geojson.org/} map.
#'
#' @param ec An \code{echarter} object as returned by \code{\link{echart}}.
#' @param mapName Name of map
#' @param geoJson \href{Geojson}{http://geojson.org/}.
#' @param specialAreas specialAreas
#'
#' @examples
#' library(tidyverse)
#' USA_geoJson <- jsonlite::read_json("http://www.echartsjs.com/gallery/data/asset/geo/USA.json")
#'
#' USArrests_ <- USArrests %>%
#'   dplyr::mutate(states = row.names(.))
#'
#' echart() %>%
#'   ec_registerMap("USA", USA_geoJson) %>%
#'   ec_add_series(
#'     type = 'map', mapType = 'USA',
#'     data = USArrests_,
#'     mapping = ecaes(name = states, value = Murder)) %>%
#'   ec_visualMap(
#'     calculable = TRUE,
#'     min = 0, max = 20, text = c("高", "低"),
#'     color = c('#d94e5d','#eac736')) %>%
#'   ec_tooltip(trigger = 'item',formatter = '{b}: {c}')
#'
#' shanghai_geoJson <- jsonlite::read_json(
#' "https://raw.githubusercontent.com/ecomfe/echarts-www/master/asset/map/json/province/shanghai.json")
#'
#' shanghai_dat <- data.frame(
#' name = c("崇明区","静安区","宝山区","嘉定区","青浦区",
#' "虹口区","杨浦区","黄浦区","卢湾区","长宁区","浦东新区",
#' "松江区","金山区","奉贤区","普陀区","闵行区","徐汇区"),
#' n = round(runif(17,1,100),0), stringsAsFactors = FALSE)
#'
#'echart() %>%
#'  ec_registerMap("shanghai", shanghai_geoJson) %>%
#'  ec_add_series(
#'    type = 'map', mapType = 'shanghai',
#'    data = shanghai_dat,
#'    mapping = ecaes(name = name, value = n),
#'    label = list(
#'      normal = list(show = FALSE),
#'      emphasis = list(show = FALSE))) %>%
#'  ec_visualMap(
#'    calculable = TRUE,
#'    min = 0, max = 100, text = c("高", "低"),
#'    color = c('#d94e5d','#eac736')) %>%
#'  ec_tooltip(trigger = 'item',formatter = '{b}: {c}')
#'
#' @export
ec_registerMap <- function(ec, mapName, geoJson, specialAreas = NULL){
  ec$x$registerMap <- TRUE
  ec$x$mapName <- mapName
  ec$x$geoJSON <- geoJson
  ec$x$specialAreas <- specialAreas
  ec
}


## dataset====

#' dataset
#'
#' @description dataset for echarts, brings convenience in data management
#' @param ec An \code{echarter} object as returned by \code{\link{echart}}.
#' @param data An R object like json, data.frame, matrix.
#' @param ... Additional arguments for the dataset
#'    (\url{https://echarts.apache.org/zh/option.html#dataset}).
#' @param baseoption default FALSE
#' @param add default FALSE
#'
#' @export
ec_dataset <- function (ec, data, ..., baseoption = FALSE, add = FALSE) {

  assertthat::assert_that(is.echart(ec))

  if(rlang::has_name(list(...), 'id')){
    id <- list(...)[['id']]
  }else{
    if(is.null(ec$x$opt$dataset)){
      id <- 0
    }else{
      id <- ec$x$opt$dataset$id + 1
    }
  }

  if(rlang::has_name(list(...), 'source')){
    if(class(list(...)[['source']]) == "json"){
      source <- list(...)[['source']]
      dimensions <- NULL
    }else{
      source <- jsonlite::toJSON(setNames(list(...)[['source']], NULL))

      if(rlang::has_name(list(...), 'dimensions')){
        dimensions <- list(...)[['dimensions']]
      }else{
        dimensions <- colnames(list(...)[['source']])
      }
    }
  }else{
    if(class(data) == "json"){
      source <- data
      dimensions <- NULL
    }else{
      source <- jsonlite::toJSON(setNames(data, NULL))

      if(rlang::has_name(list(...), 'dimensions')){
        dimensions <- list(...)[['dimensions']]
      }else{
        dimensions <- colnames(data)
      }
    }
  }

  if(rlang::has_name(list(...), 'sourceHeader')){
    sourceHeader <- list(...)[['sourceHeader']]
  }else{
    sourceHeader <- FALSE
  }

  .ec_opt(
    ec, "dataset", baseoption = baseoption, add = add,
    id = id, source = source, dimensions = dimensions,
    sourceHeader = sourceHeader)
}

## others component====

#' mark
#'
#' @description Mark an point, line, area in echarts
#' @param ec An \code{echarter} object as returned by \code{\link{echart}}.
#' @param markname The mark name, markPoint, markLine, markArea
#' @param ... Additional arguments for the mark.
#'    markPoint see (\url{https://echarts.apache.org/zh/option.html#series-line.markPoint}).
#'    markLine see (\url{https://echarts.apache.org/zh/option.html#series-line.markLine}).
#'    markArea see (\url{https://echarts.apache.org/zh/option.html#series-line.markArea}).
#' @param serie The serie index of ec
#'
#' @rdname ec_mark
#'
#' @export
ec_mark <- function(ec, ..., markname = 'markPoint', serie = NULL){

  assertthat::assert_that(is.echart(ec))

  markArray <- c("markPoint", "markLine", "markArea")

  if(!(markname %in% markArray)){
    stop('markname must in markPoint,markLine,markArea!')
  }

  n <- length(ec$x$opt$series)

  if(is.null(serie)){
    index <- 1
  }else{
    if(is.character(serie)){
      index <- .get_seriesindex(ec, serie)
    }else{
      if(serie > n)
        stop('Index must less than or qeual to series number!')

      index <- serie
    }
  }

  mark <- list(...)

  if(is.null(ec$x$opt$series[[index]][[markname]]))
    ec$x$opt$series[[index]][[markname]] <- append(ec$x$opt$series[[index]][[markname]], mark)
  else
    ec$x$opt$series[[index]][[markname]]$data <- append(ec$x$opt$series[[index]][[markname]], list(mark$data))

  ec
}

#'
#' @rdname ec_mark
#'
#' @export
ec_markPoint <- function(ec, ..., serie = NULL){
  ec_mark(ec, ..., markname = 'markPoint', serie = NULL)
}

#'
#' @rdname ec_mark
#'
#' @export
ec_markLine <- function(ec, ..., serie = NULL){
  ec_mark(ec, ..., markname = 'markLine', serie = NULL)
}

#'
#' @rdname ec_mark
#'
#' @export
ec_markArea <- function(ec, ..., serie = NULL){
  ec_mark(ec, ..., markname = 'markArea', serie = NULL)
}

#' tooltip
#'
#' @description tooltip component.
#' @param ec An \code{echarter} object as returned by \code{\link{echart}}.
#' @param ... Additional arguments for the tooltip
#'    (\url{https://echarts.apache.org/zh/option.html#tooltip}).
#' @param baseoption default FALSE
#' @param add default FALSE
#'
#' @export
ec_tooltip <- function (ec, ..., baseoption = FALSE, add = FALSE) {
  .ec_opt(ec, "tooltip", baseoption = baseoption, add = add, ...)
}

#' toolbox
#'
#' @description toolbox component.
#' @param ec An \code{echarter} object as returned by \code{\link{echart}}.
#' @param ... Additional arguments for the toolbox
#'    (\url{https://echarts.apache.org/zh/option.html#toolbox}).
#' @param baseoption default FALSE
#' @param add default FALSE
#'
#' @export
ec_toolbox  <- function (ec, ..., baseoption = FALSE, add = FALSE) {
  .ec_opt(ec, "toolbox", baseoption = baseoption, add = add, ...)
}

#' visualMap
#'
#' @description visualMap component.
#' @param ec An \code{echarter} object as returned by \code{\link{echart}}.
#' @param ... Additional arguments for the visualMap
#'    (\url{https://echarts.apache.org/zh/option.html#visualMap}).
#' @param baseoption default FALSE
#' @param add default FALSE
#'
#' @export
ec_visualMap <- function (ec, ..., baseoption = FALSE, add = FALSE) {
  .ec_opt(ec, "visualMap", baseoption = baseoption, add = add, ...)
}

#' dataZoom
#'
#' @description dataZoom component.
#' @param ec An \code{echarter} object as returned by \code{\link{echart}}.
#' @param ... Additional arguments for the dataZoom
#'    (\url{https://echarts.apache.org/zh/option.html#dataZoom}).
#' @param baseoption default FALSE
#' @param add default FALSE
#'
#' @export
ec_dataZoom <- function (ec, ..., baseoption = FALSE, add = FALSE) {
  .ec_opt(ec, "dataZoom", baseoption = baseoption, add = add, ...)
}


#' graphic
#'
#' @description graphic component.
#' @param ec An \code{echarter} object as returned by \code{\link{echart}}.
#' @param ... Additional arguments for the graphic
#'    (\url{https://echarts.apache.org/zh/option.html#graphic}).
#' @param baseoption default FALSE
#' @param add default FALSE
#'
#' @export
ec_graphic <- function(ec, ..., baseoption = FALSE, add = FALSE){
  .ec_opt(ec, "graphic", baseoption = baseoption, add = add, ...)
}

#' brush
#'
#' @description brush component.
#' @param ec An \code{echarter} object as returned by \code{\link{echart}}.
#' @param ... Additional arguments for the brush
#'    (\url{https://echarts.apache.org/zh/option.html#brush}).
#' @param baseoption default FALSE
#' @param add default FALSE
#'
#' @export
ec_brush <- function(ec, ..., baseoption = FALSE, add = FALSE){
  .ec_opt(ec, "brush", baseoption = baseoption, add = add, ...)
}

#' timeline
#'
#' @description timeline component.
#' @param ec An \code{echarter} object as returned by \code{\link{echart}}.
#' @param ... Additional arguments for the timeline
#'    (\url{https://echarts.apache.org/zh/option.html#timeline}).
#' @param baseoption default TRUE
#' @param add default FALSE
#'
#' @export
ec_timeline <- function(ec, ..., baseoption = TRUE, add = FALSE){
  .ec_opt(ec, "timeline", baseoption = baseoption, add = add, ...)
}

#' options
#'
#' @description echarts options
#' @param ec An \code{echarter} object as returned by \code{\link{echart}}.
#' @param ecs An \code{echarter} object list.
#'
#' @export
ec_options <- function(ec, ecs){

  assertthat::assert_that(is.echart(ec))

  n = length(ecs)
  if(n < 2L)
    stop('At least 2 echarts object!')

  if(any(sapply(ecs, function(a){!is.echart(a)})))
    stop('All objects should be echarts object!')

  options = lapply(ecs, function(a) a$x$opt)

  ec$x$opt$options <- lapply(ecs, function(a) a$x$opt)

  ec
}

#' timeline2
#'
#' @description timeline component.
#' @param ecs An \code{echarter} object list.
#' @param ... Additional arguments for the timeline
#'    (\url{https://echarts.apache.org/zh/option.html#timeline}).
#'
#' @export
ec_timeline2 <- function(ecs, ...){

  timeline_opt = list(...)

  n = length(ecs)
  if(n < 2L)
    stop('At least 2 echarts object!')
  if(any(sapply(ecs,function(a){!is.echart(a)})))
    stop('All objects should be echarts object!')

  options = lapply(ecs, function(a) a$x$opt)

  if(is.null(timeline_opt$data)){
    timeline_opt$data = 1:n
  }

  x = list(
    opt = list(
      baseOption = list(timeline = timeline_opt),
      options = options),
    theme = ecs[[1]]$x$theme,
    dispose = ecs[[1]]$x$dispose,
    renderer = ecs[[1]]$x$renderer)

  ec = htmlwidgets::createWidget(
    'echarter', x,
    package = 'echarter', width = NULL, height = NULL
  )
  ec
}

#' media
#'
#' @description media component for responsive.
#' @param ec An \code{echarter} object as returned by \code{\link{echart}}.
#' @param query query
#' @param option default FALSE
#' @param add default TRUE
#'
#' @export
ec_media <- function(ec, query, option, baseoption = FALSE, add = TRUE){
  .ec_opt(ec, "media", baseoption = FALSE, add = add, ...)
}


#' aria
#'
#' @description generating description for charts automatically.
#' @param ec An \code{echarter} object as returned by \code{\link{echart}}.
#' @param ... Additional arguments for the aria
#'    (\url{https://echarts.apache.org/zh/option.html#aria}).
#' @param baseoption default FALSE
#' @param add default FALSE
#'
#' @export
ec_aria <- function(ec, ..., baseoption = FALSE, add = TRUE){
  .ec_opt(ec, "aria", baseoption = FALSE, add = add, ...)
}

## series ====

#' series
#'
#' @description series.
#' @param ec An \code{echarter} object as returned by \code{\link{echart}}.
#' @param ... Additional arguments for the series
#'    (\url{https://echarts.apache.org/zh/option.html#series}).
#' @example
#' library(dplyr)
#' library(echarter)
#' echart() %>%
#'   ec_xAxis(type = 'category', data = weekDays) %>%
#'   ec_yAxis(type = 'value') %>%
#'   ec_series(
#'     type = 'line',
#'     name = 'Apple',
#'     data = as.integer(runif(7, 20,100)))
#'
#' echart() %>%
#'   ec_xAxis(type = 'category', data = weekDays) %>%
#'   ec_yAxis(type = 'value') %>%
#'   ec_add_series(
#'     type = 'line',
#'     name = 'Apple',
#'     data = as.integer(runif(7, 20,100)))
#'
#' dat <- data.frame(
#'   saleNum = round(runif(21, 20, 100), 0),
#'   fruit = c(rep("Apple", 7), rep("Pear", 7), rep("Banana", 7)),
#'   weekDay = c(rep(weekDays,3)),
#'   price = round(runif(21, 10, 20), 0),
#'   stringsAsFactors = FALSE)
#'
#' dat_sp <- dat %>%
#'   select(fruit, weekDay, saleNum) %>%
#'   spread(fruit, saleNum) %>%
#'   arrange(match(weekDay, weekDays))
#'
#' echart() %>%
#'   ec_xAxis(type = 'category', data = weekDays) %>%
#'   ec_yAxis(type = 'value') %>%
#'   ec_dataset(data = dat_sp) %>%
#'   ec_series(
#'     name = "Apple",
#'     datasetIndex = 0,
#'     type = 'line', encode = list(y = "Apple")) %>%
#'   ec_series(
#'     name = "Banana",
#'     datasetIndex = 0,
#'     type = 'line', encode = list(y = 2, tooltip = c(0, 3)))
#'
#' @export
ec_series <- function (ec, ..., baseoption = FALSE, add = TRUE) {
  .ec_opt(ec, "series", baseoption = FALSE, add = TRUE, ...)
}
