dat <- data.frame(
  saleNum=round(runif(21,20,100), 0),
  fruit=c(rep("苹果",7), rep("梨",7), rep("香蕉",7)),
  weekDay = c(rep(c('周一','周二','周三','周四','周五','周六','周日'),3)),
  price = round(runif(21,10,20),0),
  stringsAsFactors =FALSE
)

dat_date <- data.frame(
  date = as.Date('2017-01-01') + seq(0,364),
  value = round(runif(365, 0, 1000), 0),
  stringsAsFactors = FALSE
)

mapping = ecaes(name = dat$weekDay, value = dat$saleNum, group = dat$fruit)
mapping = ecaes(name = weekDay, value = saleNum, group = fruit)
mapping = ecaes(x = dat$weekDay, y = dat$saleNum, group = fruit)
mapping = ecaes(x = weekDay, y = saleNum, group = fruit)
## 暂不支持下列方式
# mapping = ecaes(name = ~weekDay, value = ~saleNum, group = ~fruit)


mapping = ecaes(x = date, y = value)
data <- ec_mutate_mapping(head(dat_date), mapping, drop = TRUE)
data_ <- data %>%
  group_by_("group") %>%
  do(data = list_parse3(select_(., quote(-group)))) %>%
  ungroup()



mapping <- ecaes(group = fruit, name = fruit, x = weekDay, value = saleNum, size = price*2)
data <- ec_mutate_mapping(dat, mapping, drop = TRUE)

data_ <- data %>%
  group_by_("group") %>%
  do(data = list_parse3(select_(., quote(-group)))) %>%
  ungroup()

list_parse(data_)

dat_radar <- dat %>%
  select(-price) %>%
  spread(weekDay, saleNum) %>%
  unite("value", c('周一','周二','周三','周四','周五','周六','周日'))
dat_radar$value <- lapply(1:3, function(x){
  as.numeric(strsplit(dat_radar$value, "_")[[x]])})

split(select(data, -group), list(data$group))

#
library(tidyverse)
library(lubridate)
library(echarter)

# do_cbind -------------------------------
add_arg_to_df <- function(data, ...) {

  datal <- as.list(data)

  l <- map_if(list(...), function(x) is.list(x), list)

  datal <- append(datal, l)

  tibble::as_data_frame(datal)

}

add_arg_to_df(head(mtcars), algo = 4, otracosa = 1:6)
s <- add_arg_to_df(head(mtcars), algo = 4, otracosa = 1:6, l = list(a = 3, otra = TRUE))

s$l[[1]]

# ecaes -----------------------------
ecaes <- function (x, y, ...) {
  mapping <- structure(as.list(match.call()[-1]), class = "uneval")
  mapping <- mapping[names(mapping) != ""]
  class(mapping) <- c("ecaes", class(mapping))
  mapping
}

ecaes(hp)
ecaes(hp, disp)
mapping <- ecaes(hp, disp^2, color = wt)
ecaes(hp, disp, color, group = g, blue)
names(mapping)


# ec_mutate_mapping -----------------------------
ec_mutate_mapping <- function(data, mapping, drop = FALSE) {
  stopifnot(is.data.frame(data), inherits(mapping, "ecaes"), inherits(drop, "logical"))
  tran <- as.character(mapping)
  newv <- names(mapping)
  data <- dplyr::mutate_(data, .dots = setNames(tran, newv))
  if(drop)
    data <- select_(data, .dots = names(mapping))
  data
}

# data_to_series ----------------------------------------------------------
ec_data_to_series <- function(data, mapping, ...) {
  # type
  if(!has_name(list(...), 'type')){
    stop("haven't the type value of series")
  }else {
    type <- list(...)[['type']]
  }

  # group
  if (!has_name(mapping, "group")){
    data[["group"]] <- "group"
  }

  # size
  if (type %in% c("line", "scatter", "radar")) {
    if(has_name(mapping, "size"))
      data <- plyr::rename(data, c("size" = "symbolSize"))
  }

  data_ <- data %>%
    group_by_("group") %>%
    do(data = list_parse(select_(., quote(-group)))) %>%
    ungroup()

  if(length(list(...)) > 0)
    data_ <- add_arg_to_df(data_, ...)

  if (has_name(mapping, "group")){
    data_ <- plyr::rename(data_, c("group" = "name"))
  }
  series <- list_parse(data_)

  # echarts data不能有标题
  lapply(seq(1, length(series)), function(s){
    tmp <- series[[s]][["data"]]
    lapply(seq(1, length(tmp)), function(x){
      series[[s]][["data"]][[x]] <<- setNames(unlist(tmp[[x]]),NULL)
    })
  })

  series
}


# tests -------------------------------------------------------------------
dat <- data.frame(
  saleNum=round(runif(21,20,100), 0),
  fruit=c(rep("苹果",7), rep("梨",7), rep("香蕉",7)),
  weekDay = c(rep(c('周一','周二','周三','周四','周五','周六','周日'),3)),
  price = round(runif(21,10,20),0),
  stringsAsFactors =FALSE
)
mapping <- ecaes(name = fruit, x = weekDay, y = saleNum, group = fruit)
data <- ec_mutate_mapping(dat, mapping, drop = TRUE)
ec_data_to_series(data, mapping, type = "bar")
ec_data_to_series(data, mapping, type = "scatter")
## sactter
mapping <- ecaes(x = weekDay, y = fruit, group = fruit, size = price*2)
data <- ec_mutate_mapping(dat, mapping)
ec_data_to_series(data, mapping, type = "scatter")

# as.list(as.data.frame(t(data), stringsAsFactors = FALSE))
#
# split_tibble <- function(tibble, col = 'col') tibble %>% split(., .[,col])
# dflist <- split_tibble(data, 'group')

## chart
## line/bar
echart() %>%
  ec_xAxis(type = 'category', data = c('周一','周二','周三','周四','周五','周六','周日')) %>%
  ec_yAxis(type = 'value') %>%
  ec_add_series(
    data = dat, type = "bar",
    mapping = ecaes(x = weekDay, y = saleNum, group = fruit))

## pie
dat_pie_day <- dat %>%
  group_by(weekDay) %>%
  summarise(
    saleNum = sum(saleNum),
    price = round(mean(price),2))
echart() %>%
  ec_add_series(
    data = dat_pie_day, type = 'pie',
    mapping = ecaes(name=weekDay, value=saleNum))

## scatter
echart() %>%
  ec_xAxis(type = 'category', data = c('周一','周二','周三','周四','周五','周六','周日')) %>%
  ec_yAxis(type = 'value') %>%
  ec_add_series(
    data = dat, type = "scatter",
    mapping = ecaes(x = weekDay, y = saleNum, group = fruit, size = price*2))

## radar
dat_valuelist <- dat %>%
  select(-price) %>%
  spread(weekDay, saleNum) %>%
  unite("value", c('周一','周二','周三','周四','周五','周六','周日'))
dat_valuelist$value <- lapply(1:3, function(x){
  as.numeric(strsplit(dat_radar$value, "_")[[x]])})

echart() %>%
  ec_tooltip(
    trigger = 'item', formatter = '{b}: {c}') %>%
  ec_radar(
    indicator = list(
      list(name = '周一', max = 100),
      list(name = '周二', max = 100),
      list(name = '周三', max = 100),
      list(name = '周四', max = 100),
      list(name = '周五', max = 100),
      list(name = '周六', max = 100),
      list(name = '周日', max = 100))) %>%
  ec_add_series(
    data = dat_valuelist, type = "radar",
    mapping = ecaes(name = fruit, value = value, group = fruit))

## heatmap
echart() %>%
  ec_xAxis(type = 'category', data = c('周一','周二','周三','周四','周五','周六','周日')) %>%
  ec_yAxis(type = 'category', data = c('苹果','梨','香蕉')) %>%
  ec_tooltip(
    trigger = 'item',
    formatter = '{a}{b}:{c}') %>%
  ec_visualMap(
    min = 20, max = 100, type = 'piecewise',
    left = 'center', orient = 'horizontal') %>%
  ec_add_series(
    data = dat, type = "heatmap",
    mapping = ecaes(x = weekDay, y = fruit, value = saleNum))
