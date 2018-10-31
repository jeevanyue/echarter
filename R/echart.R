#'
#' Create a Echarts chart widget
#'
#' This function creates a Echarts chart using \pkg{htmlwidgets}. The
#' widget can be rendered on HTML pages generated from R Markdown, Shiny, or
#' other applications.
#'
#' @param opt A `list` object containing options defined as
#'    \url{http://echarts.baidu.com/option.html}.
#' @param theme A \code{ec_theme} class object
#' @param width A numeric input in pixels.
#' @param height  A numeric input in pixels.
#' @param elementId	Use an explicit element ID for the widget.
#' @param dispose Set to \code{TRUE} to force redraw of chart, set to \code{FALSE} to update.
#' @param renderer Renderer, takes \code{canvas} (default) or \code{svg}.
#' @param ... Any other argument.
#'
#' @import htmlwidgets
#'
#' @export
echart <- function(opt = list(), theme = 'default', width = NULL, height = NULL, elementId = NULL, dispose = TRUE, renderer = "canvas", ...) {

  opts <- .join_ec_opts()

  if (identical(opt, list())){
    opt <- opts$option
  }else{
    if(!identical(opts$option, list())){
      opt <- rlist::list.merge(opts$option, opt)
    }
  }

  x = list(
    opt = opt,
    theme = themeSet(theme),
    dispose = dispose,
    renderer = tolower(renderer),
    ...
  )

  # create widget
  echart = htmlwidgets::createWidget(
    name = 'echarter',
    x,
    width = width,
    height = height,
    package = 'echarter',
    elementId = elementId,
    preRenderHook = function(instance) {
      instance
    },
    sizingPolicy = htmlwidgets::sizingPolicy(
      defaultWidth = "100%",
      knitr.figure = FALSE,
      browser.fill = TRUE,
      padding = 0
    )
  )
  # add theme dependencies
  echart <- addThemeDependencies(echart, theme)

  # add others dependencies
  echart <- ec_add_dependency(echart)

  echart
}

#' Reports whether x is a echarts object
#'
#' @param x An object to test
#'
#' @name is.echart
#'
#' @export
is.echart <- function(x) {
  inherits(x, "echarter")
}

#' @name is.echart
#'
#' @export
is.echarter <- is.echart

#' Widget output function for use in Shiny
#'
#' Output and render functions for using echarts within Shiny
#' applications and interactive Rmd documents.
#'
#' Widget output function for use in Shiny
#'
#' @param outputId The name of the input.
#' @param width,height Must be a valid CSS unit (like \code{'100\%'},
#'   \code{'400px'}, \code{'auto'}) or a number, which will be coerced to a
#'   string and have \code{'px'} appended.
#'
#' @name echarts-shiny
#'
#' @export
echartsOutput <- function(outputId, width = '100%', height = '400px'){
  htmlwidgets::shinyWidgetOutput(outputId, 'echarter', width, height, package = 'echarter')
}

#' Widget render function for use in Shiny
#'
#' @param expr A echarts expression.
#' @param env A enviorment.
#' @param quoted  A boolean value.
#'
#' @name echarts-shiny
#'
#' @export
renderEcharts <- function(expr, env = parent.frame(), quoted = FALSE) {
  if (!quoted) { expr <- substitute(expr) } # force quoted
  htmlwidgets::shinyRenderWidget(expr, echartsOutput, env, quoted = TRUE)
}
