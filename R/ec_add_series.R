
#' @export
add_arg_to_df <- function(data, ...) {

  datal <- as.list(data)

  l <- purrr::map_if(list(...), function(x) is.list(x), list)

  datal <- append(datal, l)

  tibble::as_tibble(datal)

}

#' @export
ecaes <- function (x, y, ...) {
  # taken from https://github.com/tidyverse/ggplot2/commit/d69762269787ed0799ab4fb1f35638cc46b5b7e6
  exprs <- rlang::enexprs(x = x, y = y, ...)

  is_missing <- vapply(exprs, rlang::is_missing, logical(1))

  mapping <- structure(exprs[!is_missing], class = "uneval")

  class(mapping) <- c("ecaes", class(mapping))

  mapping
}

is.ecaes <- function(x) {
  inherits(x, "ecaes")
}

#' @export
ecaes_string <- function (x, y, ...){

  mapping <- list(...)

  if (!missing(x))
    mapping["x"] <- list(x)

  if (!missing(y))
    mapping["y"] <- list(y)

  mapping <- lapply(mapping, function(x) {
    if (is.character(x)) {
      parse(text = x)[[1]]
    }else {x}
  })

  mapping <- structure(mapping, class = "uneval")

  mapping <- mapping[names(mapping) != ""]

  class(mapping) <- c("ecaes", class(mapping))

  mapping
}

#' @export
ecaes_ <- ecaes_string

#' Adding series from echarts objects
#'
#' @param ec A `echarter` object.
#' @param data An R object like list, data.frame, matrix, numeric, character, ts, forecast, etc.
#' @param ... Arguments defined in \url{https://echarts.apache.org/zh/option.html#series}.
#'
#' @name ec_add_series
#'
#' @examples
#'
#' @export
ec_add_series <- function(ec, data = NULL, ...){
  assertthat::assert_that(is.echart(ec))
  UseMethod("ec_add_series", data)
}

#' @name ec_add_series
#'
#' @export
ec_add_series.default <- function(ec, ...) {
  assertthat::assert_that(is.echart(ec))

  validate_args("add_series", eval(substitute(alist(...))))

  if(is.null(ec$x$opt$series)){
    if(length(list(...)) == 1){
      ec$x$opt$series <- c(...)
    }else{
      ec$x$opt$series <- list(...)
    }
  }else{
    if(length(list(...)) == 1){
      if(is.null(names(ec$x$opt$series))){
        if(is.null(names(...))){
          ec$x$opt$series <- append(ec$x$opt$series, c(...))
        }else{
          ec$x$opt$series <- append(ec$x$opt$series, list(...))
        }
      }else{
        if(is.null(names(...))){
          ec$x$opt$series <- append(list(ec$x$opt$series), c(...))
        }else{
          ec$x$opt$series <- append(list(ec$x$opt$series), list(...))
        }
      }
    }else{
      if(is.null(names(ec$x$opt$series))){
        ec$x$opt$series <- append(ec$x$opt$series, list(list(...)))
      }else{
        ec$x$opt$series <- append(list(ec$x$opt$series), list(list(...)))
      }
    }
  }

  ec %>%
    ec_add_dependency()

}

#' `ec_add_series.data.frame` for data.frame objects
#'
#' @param mapping a ecaes object
#'
#' @name ec_add_series
#'
#' @examples
#' weekDays <- c('Mon','Tues','Wed','Thurs','Fri','Sat','Sun')
#' dat <- data.frame(
#'   saleNum = round(runif(21, 20, 100), 0),
#'   fruit = c(rep("Apple", 7), rep("Pear", 7), rep("Banana", 7)),
#'   weekDay = c(rep(weekDays,3)),
#'   price = round(runif(21, 10, 20), 0),
#'   stringsAsFactors = FALSE)
#'
#' mapping = ecaes(x = weekDay, y = saleNum, group = fruit)
#'
#' echart() %>%
#'   ec_add_series(
#'     data = dat, type = 'bar',
#'     mapping = ecaes(x = weekDay, y = saleNum, group = fruit))
#'
#'
#' @export
ec_add_series.data.frame <- function (ec, data, mapping = ecaes(), ...) {

  assertthat::assert_that(is.echart(ec), is.ecaes(mapping))
  # type
  if(!rlang::has_name(list(...), 'type')){
    stop("haven't the type value of series")
  }else {
    type <- list(...)[['type']]
  }

  if(length(mapping) > 0){

    data <- ec_mutate_mapping(data, mapping, drop = TRUE)

    ec <- ec_data_to_axis(ec, data, mapping, ...)

    series <- ec_data_to_series(ec, data, mapping, ...)

    ec_add_series.default(ec, series)

  }else{
    if(type %in% c("boxplot", "candlestick")){
      series <- ec_data_to_series(ec, data, mapping, ...)
      ec_add_series.default(ec, series)
    }else{
      ec_add_series.default(ec, data, ...)
    }
  }
}

#' `ec_add_series.matrix` for matrix objects
#'
#' @name ec_add_series
#'
#' @export
ec_add_series.matrix <- function (ec, data, ...) {
  assertthat::assert_that(is.echart(ec), is.matrix(data))

  series <- list(data = jsonlite::toJSON(data), ...)

  ec_add_series.default(ec, series) %>%
    ec_add_dependency()
}

#' `ec_add_series.numeric` for numeric objects
#'
#' @name ec_add_series
#'
#' @export
ec_add_series.numeric <- function (ec, data, ...) {
  assertthat::assert_that(is.echart(ec), is.numeric(data))

  if(is.null(ec$x$opt$xAxis)){
    series <- data %>%
      table() %>%
      as.data.frame(stringsAsFactors = FALSE) %>%
      setNames(c("x", "y"))

    ec <- ec %>%
      ec_add_series(data = series, mapping = ecaes(x = x, y = y), ...)
  }else{
    if(is.null(ec$x$opt$series)){
      ec$x$opt$series <- list(data = data, ...)
    }else{
      if(is.null(names(ec$x$opt$series))){
        ec$x$opt$series <- append(ec$x$opt$series, list(list(data = data, ...)))
      }else{
        ec$x$opt$series <- append(list(ec$x$opt$series), list(list(data = data, ...)))
      }
    }
  }

  ec
}

#' `ec_add_series.factor` for factor objects
#'
#' @name ec_add_series
#'
#' @export
ec_add_series.factor <- function(ec, data, ...) {
  assertthat::assert_that(is.echart(ec), is.factor(data))

  series <- data %>%
    table() %>%
    as.data.frame(stringsAsFactors = FALSE) %>%
    setNames(c("x", "y"))

  ec_add_series(
    ec, data = series, mapping = ecaes(x = x, y = y), ...)

}

#' `ec_add_series.character` for character objects
#'
#' @name ec_add_series
#'
#' @export
ec_add_series.character <- function(ec, data, ...) {
  assertthat::assert_that(is.echart(ec), is.character(data))

  series <- data %>%
    table() %>%
    as.data.frame(stringsAsFactors = FALSE) %>%
    setNames(c("x", "y"))

  ec_add_series(
    ec, data = series, mapping = ecaes(x = x, y = y), ...)

}

#' `ec_add_series.ts` for ts objects
#'
#' @name ec_add_series
#'
#' @export
ec_add_series.ts <- function(ec, data, ...) {

  timestamps <- data %>%
    stats::time() %>%
    zoo::as.Date()

  series <- data.frame(x = timestamps, y = as.vector(data))

  ec %>%
    ec_add_series(
      data = series, mapping = ecaes(x = x, y = y),  ...)

}

#' `ec_add_series.forecast` for numeric objects
#'
#' @param addOriginal Logical value to add the original series or not.
#' @param addLevels Logical value to show predictions bands.
#' @param fillOpacity The opacity of bands.
#' @param name The name of the series.
#'
#' @name ec_add_series
#'
#' @export
ec_add_series.forecast <- function(ec, data, addOriginal = TRUE, addLevels = TRUE, fillOpacity = 0.1, name = NULL, ...) {

  # rid <- random_id()
  method <- data$method

  if (addOriginal){
    ec <- ec %>%
      ec_add_series.ts(
        data$x, type = 'line', name = 'Original', symbolSize = 2)
  }

  ec <- ec %>%
    ec_add_series.ts(
      data$mean, type = 'line',
      name = 'Forecast Mean',
      # name = ifelse(is.null(name), method, name),
      symbolSize = 2)

  if (addLevels){

    tmf <- zoo::as.Date(time(data$mean))
    nmf <- paste(ifelse(is.null(name), method, name), "level", data$level)

    # for (m in seq(ncol(data$upper))){
    m <- 1
    dfbands <- tibble::tibble(
      t = tmf,
      l = as.vector(data$lower[, m]),
      u = as.vector(data$upper[, m])
    )

    ec <- ec %>%
      ec_add_series(
        data = dfbands,
        name = 'Upper', mapping = ecaes(x = t, y = u),
        type = "line",
        itemStyle = list(color = '#000'),
        lineStyle = list(
          color = '#000',
          width = 1, type = 'dotted', opacity = 0.8),
        symbolSize = 1) %>%
      ec_add_series(
        data = dfbands,
        name = 'Lower', mapping = ecaes(x = t, y = l),
        type = "line",
        itemStyle = list(color = '#000'),
        lineStyle = list(
          color = '#000',
          width = 1, type = 'dotted', opacity = 0.8),
        symbolSize = 1)
    # }
  }

  tooltip2 <- htmlwidgets::JS("function (params) {if(params[0].seriesIndex === 0) {return params[0].seriesName +': ' + params[0].value[1];}else{return params[0].seriesName + ': ' + params[0].value[1] + '<br />' + params[1].seriesName + ': ' + params[1].value[1] + '<br />' + params[2].seriesName + ': ' + params[2].value[1];}}")

  ec %>%
    ec_tooltip(
      trigger = 'axis',
      formatter = tooltip2)

}

