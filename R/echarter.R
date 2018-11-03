#' Create a echarts object from a particular data type
#'
#' \code{echarter} uses `echart` to draw a particular plot for an
#' object of a particular class in a single command. This defines the S3
#' generic that other classes and packages can extend.
#'
#' Run \code{methods(echart)} to see what objects are supported.
#'
#' @param data  A data object.
#' @param ... Additional arguments for the data series
#'    (\url{http://echarts.baidu.com/option.html#series}).
#'
#' @name echarter
#'
#' @export
echarter <- function(data, ...){

  UseMethod("echarter")

}

#' @name echarter
#'
#' @export
echarter.default <- function(data, ...) {
  stop("Objects of class/type ", paste(class(data), collapse = "/"),
       " are not supported by echart (yet).", call. = FALSE)
}

#' `echarter.data.frame` for data.frame objects
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
#' echarter(
#'   data = dat, type = 'bar',
#'   mapping = ecaes(x = weekDay, y = saleNum, group = fruit))
#'
#' @export
echarter.data.frame <- function(data, mapping = ecaes(), ..., theme = 'default', width = NULL, height = NULL, elementId = NULL, dispose = TRUE, renderer = "canvas"){

  data <- as.data.frame(data)

  echart(theme = theme, width = width, height = height, elementId = elementId, dispose = dispose, renderer = renderer) %>%
    ec_add_series(
      data = data,
      mapping = mapping, ...)
}

#' `echarter.numeric` for numeric objects
#'
#' @name echarter
#'
#' @export
echarter.numeric <- function(data, ..., theme = 'default', width = NULL, height = NULL, elementId = NULL, dispose = TRUE, renderer = "canvas"){

  echart(theme = theme, width = width, height = height, elementId = elementId, dispose = dispose, renderer = renderer) %>%
    ec_add_series(
      data = data, ...)
}

#' `echarter.character` for character objects
#'
#' @name echarter
#'
#' @export
echarter.character <- function(data, ..., theme = 'default', width = NULL, height = NULL, elementId = NULL, dispose = TRUE, renderer = "canvas"){

  echart(theme = theme, width = width, height = height, elementId = elementId, dispose = dispose, renderer = renderer) %>%
    ec_add_series(
      data = data, ...)
}

#' `echarter.ts` for ts objects
#'
#' @name echarter
#'
#' @export
echarter.ts <- function(data, ..., theme = 'default', width = NULL, height = NULL, elementId = NULL, dispose = TRUE, renderer = "canvas"){

  echart(theme = theme, width = width, height = height, elementId = elementId, dispose = dispose, renderer = renderer) %>%
    ec_add_series(
      data = data, ...)
}

#' `echarter.forecast` for numeric objects
#'
#' @param addOriginal Logical value to add the original series or not.
#' @param addLevels Logical value to show predictions bands.
#' @param fillOpacity The opacity of bands.
#' @param name The name of the series.
#'
#' @name echarter
#'
#' @export
echarter.forecast <- function(data, addOriginal = TRUE, addLevels = TRUE, fillOpacity = 0.1, name = NULL, ..., theme = 'default', width = NULL, height = NULL, elementId = NULL, dispose = TRUE, renderer = "canvas"){

  echart(theme = theme, width = width, height = height, elementId = elementId, dispose = dispose, renderer = renderer) %>%
    ec_add_series(
      data = data, addOriginal = TRUE, addLevels = TRUE, fillOpacity = 0.1, name = NULL, ...)
}
