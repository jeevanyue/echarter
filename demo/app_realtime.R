library(tidyverse)
library(echarter)
library(shiny)

dat_date <- data.frame(
  date = as.Date('2017-01-01') + seq(0,364),
  value = round(runif(365, 0, 1000), 0),
  stringsAsFactors = FALSE)

dat_date_start <- head(dat_date, 10)

jsCode <- "
Shiny.addCustomMessageHandler('add_data', function(data) {
var chart = get_echarts('data_dynamic');

chart.setOption({
title: {
text: 'value:'+ data[Object.keys(data).pop()][1]
},
series: [{
data: data
}]
});
});"

ui <- fluidPage(
  tags$head(
    tags$script(jsCode)
  ),
  column(width = 6, echartsOutput("data_dynamic")),
  column(width = 6, echartsOutput("data_dynamic2"))
)

server <- function(input, output, session) {

  data <- dat_date_start

  data_new <- reactive({
    invalidateLater(1000)
    date_last <- max(data$date)
    add_data <- head(dat_date[dat_date$date > date_last,], 1)
    data <<- rbind(data, add_data)[-1, ]
    data
  })

  datetime_to_timestamp <- function(dt) {
    tmstmp <- as.numeric(as.POSIXct(dt))
    tmstmp <- 1000 * tmstmp
    tmstmp
  }

  observe({
    invalidateLater(1000)
    data_new_ <- data_new() %>%
      mutate(date = datetime_to_timestamp(date)) %>%
      setNames(NULL) %>%
      jsonlite::toJSON()
    session$sendCustomMessage("add_data", data_new_)
  })

  output$data_dynamic <- renderEcharts({
    echart() %>%
      ec_title(text = "value") %>%
      ec_add_series(
        data = data, type = 'bar', animation = FALSE,
        mapping = ecaes(x = date, y = value)) %>%
      ec_xAxis(
        type = 'time',
        boundaryGap = c('0.1%','0.1%'),
        min = NULL, max = NULL,
        interval =  3600 * 24 * 1000,
        maxInterval = 3600 * 24 * 1000)
  })

  output$data_dynamic2 <- renderEcharts({
    session$sendCustomMessage("add_data2", paste0("value: ", tail(data$value,1)))

    echart() %>%
      ec_title(text = "value") %>%
      ec_add_series(
        data = data_new(), type = 'bar', animation = FALSE,
        mapping = ecaes(x = date, y = value)) %>%
      ec_xAxis(
        type = 'time',
        boundaryGap = c('0.1%','0.1%'),
        min = NULL, max = NULL,
        interval =  3600 * 24 * 1000,
        maxInterval = 3600 * 24 * 1000)
  })
}

shinyApp(ui, server)
