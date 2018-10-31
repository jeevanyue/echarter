
#' Check if a string vector is in hexadecimal color format
#'
#' @param x A string vectors
#'
#' @examples
#'
#' x <- c("#f0f0f0", "#FFf", "#99990000", "#00FFFFFF")
#'
#' is.hexcolor(x)
#'
#' @export
is.hexcolor <- function(x) {

  pattern <- "^#([A-Fa-f0-9]{6}|[A-Fa-f0-9]{3}|[A-Fa-f0-9]{8})$"

  stringr::str_detect(x, pattern)

}

#' Create vector of color from vector
#'
#' @param x A numeric, character or factor object.
#' @param colors A character string of colors (ordered) to colorize `x`
#' @examples
#'
#' ec_colorize(runif(10))
#'
#' ec_colorize(LETTERS[rbinom(20, 5, 0.5)], c("#FF0000", "#00FFFF"))
#'
#' @importFrom grDevices colorRampPalette
#' @importFrom stats ecdf
#' @export
ec_colorize <- function(x, colors = c('#c23531', '#2f4554', '#61a0a8', '#d48265', '#91c7ae', '#749f83', '#ca8622', '#bda29a', '#6e7074', '#546570', '#c4ccd3')) {

  nuniques <- length(unique(x))
  palcols <- grDevices::colorRampPalette(colors)(nuniques)

  if (!is.numeric(x) | nuniques < 10) {

    y <- as.numeric(as.factor(x))
    xcols <- palcols[y]

  } else {

    ecum <- ecdf(x)
    xcols <- palcols[ceiling(nuniques * ecum(x))]

  }

  xcols

}
