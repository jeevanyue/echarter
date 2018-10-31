#' @title Create Echarts from Echarts Glaery
#' @usage
#' echartsExample = function(url = NULL,
#'    JScontent = NULL,
#'    width = NULL, height = NULL)
#'
#' @param url Links from 'https://ecomfe.github.io/echarts-examples/public/index.html'
#'  (Chinese Version: 'http://echarts.baidu.com/examples.html').
#' @param JScontent JScodes for Echarts. An object named option should be created in these codes.
#' @export
#' @examples
#' # Create from link
#' echartsExample("http://echarts.baidu.com/demo.html#effectScatter-bmap")
#'
#' # Create from JS codes
#' JScodes = "
#' var option = {
#'   title: {
#'     text: 'ECharts entry example'
#'   },
#'   tooltip: {},
#'   legend: {
#'     data:['Sales']
#'   },
#'   xAxis: {
#'     data: ['shirt','cardign','chiffon shirt','pants','heels','socks']
#'   },
#'   yAxis: {},
#'   series: [{
#'     name: 'Sales',
#'     type: 'bar',
#'     data: [5, 20, 36, 10, 10, 20]
#'   }]
#' };
#' "
#' echartsExample(JScontent=JScodes)
#'
echartsExample <- function (url = NULL, JScontent = NULL, width = NULL, height = NULL)
{
  if (is.null(url) & is.null(JScontent)) {
    url = "http://echarts.baidu.com/demo.html#effectScatter-bmap"
  }
  if (!is.null(url)) {
    echartsURL = strsplit(url, "(#|c=)")[[1]][2]
    if (is.na(echartsURL)) {
      stop("URL seems not a echarts example URL.\n Try links in http://echarts.baidu.com/examples.html")
    }
    echartsURL = paste0("http://echarts.baidu.com/data/", echartsURL, ".js")
    JScontent = readLines(echartsURL, encoding = "UTF-8", warn = FALSE)
    JScontent = paste0(JScontent, collapse = "\n")
  }
  if (grepl("$.get", JScontent)) {
    warning("Getting data from jquery is not support in this version.")
  }
  opt = list(
    xAxis = list(list()),
    yAxis = list(list())
  )
  mychart = echart(opt)
  if (grepl("(bmap|ecstat)", JScontent)) {
    mychart$dependencies <- c(mychart$dependencies, echartsDependencies_())
  }
  htmlwidgets::onRender(
    mychart,
    paste0(
      "function(el,x){", "var app={};", "myChart = echarts.getInstanceByDom(el);",
      JScontent, "myChart.setOption(option,true);}", collapse = "\n"))
}

echartsDependencies_ <- function() {
  list(
    htmltools::htmlDependency(
      "echartsWeb",
      "0.0.1",
      system.file("htmlwidgets/plugins", package = "echarter"),
      script = c("bmap.js", "ecstat.js", "bmapAK.js")
    )
  )
}
