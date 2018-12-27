library(tidyverse)
library(echarter)
library(shiny)

dat <- data.frame(
  saleNum = round(runif(21, 20, 100), 0),
  fruit = c(rep("Apple", 7), rep("Pear", 7), rep("Banana", 7)),
  weekDay = c(rep(c('Mon','Tues','Wed','Thurs','Fri','Sat','Sun'),3)),
  price = round(runif(21, 10, 20), 0),
  stringsAsFactors = FALSE)

ui <- fluidPage(
  title = "echarter Shiny",
  fluidRow(
    column(width = 6,
           echartsOutput("scatter")
    ),
    column(width = 6,
           echartsOutput("pie")
    ),
    column(
      width = 6,
      "scatter_click_componentType:",
      verbatimTextOutput("click_componentType"),
      "scatter_click_seriesType:",
      verbatimTextOutput("click_seriesType"),
      "scatter_click_seriesIndex:",
      verbatimTextOutput("click_seriesIndex"),
      "scatter_click_seriesName:",
      verbatimTextOutput("click_seriesName"),
      "scatter_click_name:",
      verbatimTextOutput("click_name"),
      "scatter_click_dataIndex:",
      verbatimTextOutput("click_dataIndex"),
      "scatter_click_data:",
      verbatimTextOutput("click_data"),
      "scatter_click_dataType:",
      verbatimTextOutput("click_dataType"),
      "scatter_click_value:",
      verbatimTextOutput("click_value"),
      "scatter_click_color:",
      verbatimTextOutput("click_color"),
      "scatter_click_info:",
      verbatimTextOutput("click_info")
    ),
    column(
      width = 6,
      "scatter_legendselectchanged:",
      verbatimTextOutput("legendselectchanged"),
      "scatter_brushselected:",
      verbatimTextOutput("brushselected"),
      "scatter_datazoom:",
      verbatimTextOutput("datazoom"),
      "scatter_datarangeselected:",
      verbatimTextOutput("datarangeselected"),
      "scatter_updateAxisPointer:",
      verbatimTextOutput("updateAxisPointer"))
  )
)

server <- function(input, output, session){
  output$scatter <- renderEcharts({
    echart(theme = 'shine') %>%
      ec_title(text = "Fruit Sales") %>%
      ec_grid(right = "15%") %>%
      ec_legend(
        show = TRUE, orient = "vertical",
        left = "right", top = "10%") %>%
      ec_tooltip(
        trigger = 'item', axisPointer = list(type = 'cross')) %>%
      ec_toolbox(
        show = TRUE,
        orinent = 'horizontal',
        feature = list(
          dataView = list(
            show = TRUE,
            readOnly = TRUE),
          magicType = list(
            show = TRUE,
            type = c('line', 'bar', 'stack', 'tiled')),
          restore = list(
            show = TRUE),
          brush = list(),
          saveAsImage = list(
            show = TRUE))) %>%
      ec_brush(xAxisIndex = "all", yAxisIndex = "all") %>%
      ec_dataZoom(type = 'slider') %>%
      ec_visualMap(
        type = 'continuous', calculable = TRUE,
        min = 0, max = 100,
        left = 'right', bottom = '10%',
        color = c('#d94e5d','#eac736','#50a3ba')) %>%
      ec_add_series(
        dat, type = "scatter",
        mapping = ecaes(x = weekDay, y = saleNum, group = fruit)) %>%
      ec_xAxis(nameLocation = "center", nameGap = 30) %>%
      ec_yAxis(nameLocation = "center", nameGap = 30)
  })

  output$pie <- renderEcharts({
    weeks <- c('Mon','Tues','Wed','Thurs','Fri','Sat','Sun')
    if(!isTruthy(input$scatter_updateAxisPointer)){
      week_selected <- weeks
    }else{
      week_selected <- weeks[input$scatter_updateAxisPointer[["dataIndex"]]+1]
    }

    fruits <- c("Apple","Pear","Banana")
    if(!isTruthy(input$scatter_legendselectchanged)){
      fruit_selected <- fruits
    }else{
      fruit_selected <- names(unlist(input$scatter_legendselectchanged)[unlist(input$scatter_legendselectchanged)])
    }

    dat_pie_selected <- dat %>%
      filter(weekDay == week_selected, fruit %in% fruit_selected) %>%
      group_by(fruit) %>%
      summarise(
        saleNum = sum(saleNum),
        price = round(mean(price),2))

    echart() %>%
      ec_title(text = "Data From Left Echarts") %>%
      ec_legend(show = TRUE, right = "10%") %>%
      ec_add_series(
        data = dat_pie_selected, type = 'pie',
        mapping = ecaes(name = fruit, value = saleNum))

  })

  output$legendselectchanged <- renderPrint({
    input$scatter_legendselectchanged
  })
  output$brushselected <- renderPrint({
    input$scatter_brushselected
  })
  output$datazoom <- renderPrint({
    input$scatter_datazoom
  })
  output$datarangeselected <- renderPrint({
    input$scatter_datarangeselected
  })
  output$updateAxisPointer <- renderPrint({
    input$scatter_updateAxisPointer
  })

  ## click
  output$click_componentType <- renderPrint({
    input$scatter_click_componentType
  })
  output$click_seriesType <- renderPrint({
    input$scatter_click_seriesType
  })
  output$click_seriesIndex <- renderPrint({
    input$scatter_click_seriesIndex
  })
  output$click_seriesName <- renderPrint({
    input$scatter_click_seriesName
  })
  output$click_name <- renderPrint({
    input$scatter_click_name
  })
  output$click_dataIndex <- renderPrint({
    input$scatter_click_dataIndex
  })
  output$click_data <- renderPrint({
    input$scatter_click_data
  })
  output$click_dataType <- renderPrint({
    input$scatter_click_dataType
  })
  output$click_value <- renderPrint({
    input$scatter_click_value
  })
  output$click_color <- renderPrint({
    input$scatter_click_color
  })
  output$click_info <- renderPrint({
    input$scatter_click_info
  })

}
shinyApp(ui, server)
