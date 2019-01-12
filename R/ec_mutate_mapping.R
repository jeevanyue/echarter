
#' @export
ec_mutate_mapping <- function(data, mapping, drop = TRUE, indicator = NULL) {

  stopifnot(is.data.frame(data), inherits(mapping, "ecaes"), inherits(drop, "logical"))

  # https://stackoverflow.com/questions/45359917/dplyr-0-7-equivalent-for-deprecated-mutate
  # https://www.johnmackintosh.com/2018-02-19-theory-free-tidyeval/

  tran <- as.character(mapping)
  newv <- names(mapping)
  list_names <- setNames(tran, newv) %>% lapply(rlang::parse_quosure)

  data <- dplyr::mutate(data, !!! list_names)

  if(rlang::has_name(data, "series"))

    data <- dplyr::rename(data, "seriess" = "series")

  if(drop) {
    newv <- rlang::syms(newv)
    data <- dplyr::select(data, !!! newv)
  }

  data

}
