#' Convert an object to list with identical structure
#'
#' \code{ec_list_parse} are similar to \code{rlist::list.parse} but this removes names.
#'
#' @param df A data frame to parse to list
#' @examples
#'
#' x <- data.frame(a=1:3, type=c('A','C','B'), stringsAsFactors = FALSE)
#' ec_list_parse(x)
#' ec_list_parse_(x)
#'
#' @importFrom purrr transpose
#' @importFrom rlist list.parse
#' @export
ec_list_parse <- function(df) {
  assertthat::assert_that(is.data.frame(df))

  purrr::map_if(df, is.factor, as.character) %>%
    tibble::as_tibble() %>%
    rlist::list.parse() %>%
    setNames(NULL)
}

#' \code{ec_list_parse_} set result name of ec_list_parse is null
#'
#' @rdname ec_list_parse
#' @export
ec_list_parse_ <- function(df) {
  assertthat::assert_that(is.data.frame(df))
  ## setnames is null
  ec_list_parse(df) %>%
    purrr::map(setNames, NULL)
}

#' @export
list_parse_data <- function(df, coordinateSystem = NULL, dimension = FALSE) {
  assertthat::assert_that(is.data.frame(df))

  data_opt <-  c("name", "symbol", "symbolSize", "symbolRotate", "symbolKeepAspect", "symbolOffset")
  data_opt_value <- names(df)[!(names(df) %in% data_opt)]

  if(dimension){
    tmp <- ec_json(df)
  }else{
    tmp <- ec_list_parse(df)

    if(rlang::has_name(df, "x") & rlang::has_name(df, "y")){
      invisible(
        lapply(seq(1, length(tmp)), function(m){
          tmp[[m]][["value"]] <<- lapply(data_opt_value, function(n){
            tmp[[m]][[n]]
          }) %>% unlist()
        })
      )
    }

  }

  return(tmp)
}


#' @export
list_parse2 <- function(df, axis = 2, opt = "x,y,value") {
  assertthat::assert_that(is.data.frame(df))

  opt_ <- stringr::str_split(opt, "\\,")[[1]]

  tmp <- ec_list_parse(df)

  if(axis == 0){
    lapply(seq(1, length(tmp)), function(x){
      tmp[[x]][["value"]] <<- list(tmp[[x]][[opt_[2]]])
    })
  }else if(axis == 1){
    lapply(seq(1, length(tmp)), function(x){
      tmp[[x]][["value"]] <<- list(tmp[[x]][[opt_[1]]], tmp[[x]][[opt_[2]]])
    })
  }else if(axis == 2){
    lapply(seq(1, length(tmp)), function(x){
      tmp[[x]][["value"]] <<- c(tmp[[x]][[opt_[1]]], tmp[[x]][[opt_[2]]], tmp[[x]][[opt_[3]]])
    })
  }else if(axis == 3){

  }
  return(tmp)
}

list_parse3 <- function(df) {
  assertthat::assert_that(is.data.frame(df))

  lst <- as.list(as.data.frame(t(df), stringsAsFactors = FALSE))
  setNames(lst, NULL)
}

#' @export
datetime_to_timestamp <- function(dt) {
  # http://stackoverflow.com/questions/10160822/
  assertthat::assert_that(assertthat::is.date(dt) | assertthat::is.time(dt))

  tmstmp <- as.numeric(as.POSIXct(dt))
  tmstmp <- 1000 * tmstmp
  tmstmp
}

#' @export
data_tree <- function(df, type = "tree"){

  assertthat::assert_that(is.data.frame(df))

  parents <- df$parent
  children <- df$children
  parents_name <- unique(parents)
  children_name <- unique(children)
  root_child <- unique(parents[!(parents %in% children)])

  if(rlang::has_name(df, "value")){
    tmp <- data.frame(
      parent = "tree_root_top", children = root_child, value = NA) %>%
      rbind(., df)
  }else{
    tmp <- data.frame(
      parent = "tree_root_top", children = root_child) %>%
      rbind(., df)
  }

  x <- data.tree::ToListExplicit(data.tree::FromDataFrameNetwork(tmp), unname = TRUE)

  return(x[["children"]])
}

#' @export
ec_dim <- function(df){
  # assertthat::assert_that(is.data.frame(df), is.matrix(df))

  return(as.matrix(setNames(df, NULL)))

}

#' @export
ec_json <- function(df){
  # assertthat::assert_that(is.data.frame(df), is.matrix(df))

  return(jsonlite::toJSON(setNames(df, NULL)))

}
