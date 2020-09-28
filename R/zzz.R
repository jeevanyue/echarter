.join_ec_opts <- function() {
  list(
    option = getOption("echarter.option"),
    baseOption = getOption("echarter.baseOption")
  )
}

.onAttach <- function(libname, pkgname) {
# .onAttach <- function(libname = find.package("echarter"), pkgname = "echarter") {
  shiny::registerInputHandler("echarterEvents", function(data, ...) {
    jsonlite::fromJSON(jsonlite::toJSON(data, auto_unbox = TRUE))
  }, force = TRUE)

  packageStartupMessage(
    "ECharts is a free, powerful charting and visualization library.")
}

.onLoad <- function(libname, pkgname) {
# .onLoad <- function(libname = find.package("echarter"), pkgname = "echarter") {
  shiny::registerInputHandler("echarterEvents", function(data, ...) {
    jsonlite::fromJSON(jsonlite::toJSON(data, auto_unbox = TRUE))
  }, force = TRUE)

  options(
    echarter.baseOption = list(
      legend = list(
        show = TRUE),
      tooltip = list(
        show = TRUE,
        trigger = 'axis',axisPointer = list(type = 'shadow'))
    ),
    echarter.option = list(
      legend = list(
        show = TRUE),
      tooltip = list(
        show = TRUE,
        trigger = 'axis',axisPointer = list(type = 'shadow'))
    )
  )
}
