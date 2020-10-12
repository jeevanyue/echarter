

ec_data_to_series <- function(ec, data, mapping, ..., dim = FALSE) {

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

  # x
  if(rlang::has_name(mapping, "x")) {
    if(lubridate::is.Date(data[["x"]])) {
      if(!is.null(coordinateSystem)){
        if(coordinateSystem == 'calendar'){
          data[["x"]] <- as.character(data[["x"]])
        }else{
          data[["x"]] <- datetime_to_timestamp(data[["x"]])
        }
      }else{
        data[["x"]] <- datetime_to_timestamp(data[["x"]])
      }
    }
  }
  # if(!rlang::has_name(mapping, "name")){
  #   data[["name"]] <- data[["x"]]
  # }

  # y
  if(rlang::has_name(mapping, "y")) {
    if(lubridate::is.Date(data[["y"]])) {
      data[["y"]] <- datetime_to_timestamp(data[["y"]])
    }
  }
  # if(!rlang::has_name(mapping, "value")){
  #   data[["value"]] <- data[["y"]]
  # }

  # group
  if(!(type %in% c('tree', 'treemap', 'sunburst', 'sankey', 'graph', 'boxplot'))){
    if (!rlang::has_name(mapping, "group")){
      # name
      if(rlang::has_name(list(...), 'name')){
        data[["group"]] <- list(...)[['name']]
      }else {
        data[["group"]] <- "group"
      }
    }
  }

  # color
  if (rlang::has_name(mapping, "color")) {
    if (type == "treemap") {
      data <- rename_(data, "colorValue" = "color")
    } else if (!all(is.hexcolor(data[["color"]]))) {
      data  <- mutate_(data, "colorv" = "color", "color" = "echarter::ec_colorize(color)")
    }
  }else if(rlang::has_name(data, "color")) {
    data <- plyr::rename(data, c("colorv" = "color"))
  }

  # size
  # c("line", "scatter", "effectScatter", "radar", "tree", "lines", "graph", "pictorialBar")
  if (rlang::has_name(mapping, "size")){
    data <- plyr::rename(data, c("size" = "symbolSize"))
  }

  # child
  if (rlang::has_name(mapping, "child")){
    data <- plyr::rename(data, c("child" = "children"))
  }


  if(type %in% c("radar", "parallel")){
    if(type == "radar"){
      if(is.null(ec$x$opt$radar$indicator)){
        stop("haven't the indicator of radar")
      }else{
        xvar <- lapply(seq(length(ec$x$opt$radar$indicator)), function(x){
          ec$x$opt$radar$indicator[[x]]$name
        }) %>% unlist()
      }
    }else if(type == "parallel"){
      if(is.null(ec$x$opt$parallelAxis)){
        stop("haven't the parallelAxis")
      }else{
        xvar <- lapply(seq(length(ec$x$opt$parallelAxis)), function(x){
          ec$x$opt$parallelAxis[[x]]$name
        }) %>% unlist()
      }
    }

    data_ <- data %>%
      select(x, y, group) %>%
      spread(x, y)
      # dplyr::select(.dots= c("group", xvar))

    data_list <- lapply(seq(nrow(data_)), function(x){
      list(list(
        name = data_$group[x],
        value = data_[x, xvar] %>% setNames(NULL)
      ))
    })
    data_ <- tibble::tibble(
      group = data_$group,
      data = data_list)

  }else if(type %in% c('pie', 'map', 'funnel', 'gauge')){
    data_ <- data %>%
      group_by(group) %>%
      do(data = ec_list_parse(select(., -group))) %>%
      ungroup()
  }else if(type %in% c('tree', 'treemap', 'sunburst')){
    data_ <- data_tree(data, type = type)
    data_ <- tibble::tibble(data = list(data_))

  }else if(type == 'boxplot'){

    # layout
    if(!rlang::has_name(list(...), 'layout')){
      if(ec$x$opt$xAxis$type == "category"){
        boxplot_layout <- "horizontal"
      }else{
        boxplot_layout <- "vertical"
      }

    }else{
      boxplot_layout <- list(...)[['layout']]
    }


    if(rlang::has_name(list(...), "group")){
      names(data)[names(data) == list(...)[['group']]] <- "group"
    }else{
      data[["group"]] <- "group"
    }

    if(length(mapping) == 0){

      # outline
      if(rlang::has_name(list(...), "outline")){
        outline <- list(...)[['outline']]
      }else{
        outline = TRUE
      }

      dat_stats <- data %>%
        group_by(group) %>%
        do(data = t(boxplot(select(., -group), plot = FALSE)[["stats"]])) %>%
        ungroup()

      if(rlang::has_name(list(...), "name")){
        dat_stats <- select(dat_stats, -group)
      }else{
        dat_stats <- plyr::rename(dat_stats, c("group" = "name"))
      }

      if(length(list(...)) > 0){
        dat_stats <- add_arg_to_df(data = dat_stats, ...)
      }

      series <- ec_list_parse(dat_stats)

      if(outline){

        dat_box <- data %>%
          group_by(group) %>%
          do(data = boxplot(select(., -group), plot = FALSE))%>%
          ungroup()

        if(rlang::has_name(list(...), "name")){
          dat_box <- select(dat_box, -group)
          dat_box[["name"]] <- list(...)[['name']]
        }else{
          dat_box <- plyr::rename(dat_box, c("group" = "name"))
        }

        if(boxplot_layout == "horizontal"){
          dat_outline <- map2_df(seq(nrow(dat_box)), dat_box$data, function(x, y){
            if (length(y$out) > 0)
              d <- tibble::tibble(name = dat_box$name[x], data = list(ec_dim(tibble::tibble(x = y$group - 1, y = y$out))))
            else
              d <- tibble::tibble()
            d
          })
        }else{
          dat_outline <- map2_df(seq(nrow(dat_box)), dat_box$data, function(x, y){
            if (length(y$out) > 0)
              d <- tibble::tibble(name = dat_box$name[x], data = list(ec_dim(tibble::tibble(x = y$out, y = y$group - 1))))
            else
              d <- tibble::tibble()
            d
          })
        }
        dat_outline <- add_arg_to_df(data = dat_outline, type = "pictorialBar", symbolPosition = "end", symbolSize = 8, barGap = "30%")

        series <- c(
          series,
          ec_list_parse(dat_outline))

      }

      return(series)

    }else{
      if (!rlang::has_name(mapping, "group")){
        # name
        if(rlang::has_name(list(...), 'name')){
          data[["group"]] <- list(...)[['name']]
        }else {
          data[["group"]] <- "group"
        }
      }

      boxplot_mapping <- c("min", "Q1", "median", "Q3", "max")
      boxplot_mapping2 <- c("min", "Q1", "Q2", "Q3", "max")
      if(all(boxplot_mapping %in% names(mapping))){
        data_ <- select(data, min, Q1, median, Q3, max, group)
      }else if(all(boxplot_mapping2 %in% names(mapping))){
        data_ <- select(data, min, Q1, median = Q2, Q3, max, group)
      }else{
        stop("maping must have min, Q1, median/Q2, Q3, max in boxplot")
      }
      data_ <- data_ %>%
        group_by(group) %>%
        do(data = ec_dim(select(., -group))) %>%
        ungroup()
    }

  }else if(type == 'candlestick'){

    candlestick_mapping <- c("open", "close", "lowest", "highest")
    if(all(candlestick_mapping %in% names(mapping))){
      data_ <- select(data, open, close, lowest, highest, group)
    }else{
      stop("maping must have open, close, lowest, highest in candlestick")
    }

    data_ <- data_ %>%
      group_by(group) %>%
      do(data = ec_dim(select(., -group))) %>%
      ungroup()

  }else if(type %in% c('sankey', 'graph')){

  }else if(type == "custom"){

  }else if(type == "themeRiver"){
    data_ <- data %>%
      select(x, y, group) %>%
      ec_list_parse_()
    data_ <- tibble::tibble(data = list(data_))

  }else if(type == 'lines'){
    dat_tmp <- data %>%
      select(start.lng, start.lat, end.lng, end.lat) %>%
      setNames(NULL)

    data_ <- apply(dat_tmp, 1, function(x){
      x <- unname(x)
      coords = list(c(x[1], x[2]), c(x[3], x[4]))})
    data_ <- tibble::tibble(data = list(data_))

  }else if(type %in% c('line','bar','scatter','effectScatter','pictorialBar','heatmap', 'liquidFill', 'wordCloud')){

    data_ <- data %>%
      group_by(group) %>%
      do(data = list_parse_data(select(., -group), coordinateSystem = coordinateSystem, dimension = dim)) %>%
      ungroup()

  }

  if(length(list(...)) > 0){
    data_ <- add_arg_to_df(data = data_, ...)
  }

  if(rlang::has_name(mapping, "group")){
    if(type != "themeRiver"){
      data_ <- plyr::rename(data_, c("group" = "name"))
    }
  }

  series <- ec_list_parse(data_)

  return(series)
}
