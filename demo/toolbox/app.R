library(tidyverse)
library(echarter)
library(shiny)

toolbox_days <- "function(params) {
Shiny.setInputValue('toolbox_select', $(this).attr('featureName'));
}"

toolbox_weeks <- "function(params) {
Shiny.setInputValue('toolbox_select', $(this).attr('featureName'));
}"

toolbox_months <- "function(params) {
Shiny.setInputValue('toolbox_select', $(this).attr('featureName'));
}"

toolbox_years <- "function(params) {
Shiny.setInputValue('toolbox_select', $(this).attr('featureName'));
}"

toolbox_icon_date_days <- "path://M600 1075 l0 -725 515 0 515 0 0 725 0 725 -60 0 -60 0 0 -65 0 -65
-390 0 -390 0 0 65 0 65 -65 0 -65 0 0 -725z m910 230 l0 -245 -390 0 -390 0
0 245 0 245 390 0 390 0 0 -245z m0 -600 l0 -235 -390 0 -390 0 0 235 0 235
390 0 390 0 0 -235z"

toolbox_icon_date_weeks <- "path://M382 1762 l-43 -37 25 -62 c38 -93 73 -219 92 -335 13 -81 18 -194 21 -540 l5 -438 624 0 624 0 0 671 c0 600 -2 675 -16 705 -27 57 -60 68 -216 72 l-137 4 -15 -53 c-9 -29 -16 -56 -16 -61 0 -4 57 -9 127 -10 125 -3 128 -4 140 -28 10 -19 13 -158 13 -607 l0 -583 -504 0 -504 0 -5 407 c-5 444 -13 525 -73 713 -29 92 -83 220 -93 220 -3 0 -25 -17 -49 -38z M754 1547 c-2 -7 -3 -100 -2 -207 l3 -195 338 -3 337 -2 0 210 0 210 -335 0 c-263 0 -337 -3 -341 -13z m556 -197 l0 -100 -215 0 -215 0 0 100 0 100 215 0 215 0 0 -100z M690 965 l0 -55 175 0 175 0 0 -80 0 -80 -150 0 -150 0 0 -50 0 -50 150 0 150 0 0 -70 0 -70 60 0 60 0 0 70 0 70 150 0 150 0 0 50 0 50 -150 0 -150 0 0 80 0 80 175 0 175 0 0 55 0 55 -410 0 -410 0 0 -55z"

toolbox_icon_date_months <- "path://M542 1767 l-42 -43 26 -38 c68 -100 118 -257 134 -424 5 -53 10 -280 10 -504 l0 -408 475 0 475 0 0 675 c0 742 2 718 -60 750 -22 11 -63 15 -163 15 l-134 0 -12 -42 c-7 -24 -15 -51 -18 -61 -5 -17 2 -18 109 -12 161 10 152 22 156 -209 l3 -186 -359 0 -359 0 -6 60 c-10 91 -44 216 -83 300 -37 80 -92 170 -103 170 -4 0 -26 -19 -49 -43z m958 -752 l0 -145 -355 0 -355 0 0 145 0 145 355 0 355 0 0 -145z m0 -405 l0 -140 -355 0 -355 0 0 140 0 140 355 0 355 0 0 -140z"

toolbox_icon_date_years <- "path://M1130 1625 l0 -185 -380 0 -380 0 0 -60 0 -60 135 0 135 0 0 -235 0 -235 245 0 245 0 0 -130 0 -130 -223 0 -223 0 -18 33 c-35 60 -116 155 -178 208 l-61 53 -24 -29 c-62 -76 -63 -69 6 -131 113 -103 218 -266 257 -400 l16 -56 57 7 c31 4 59 10 64 14 6 6 -21 98 -48 164 -7 16 21 17 509 17 l516 0 0 60 0 60 -260 0 -260 0 0 130 0 130 230 0 230 0 0 60 0 60 -230 0 -230 0 0 175 0 175 288 2 287 3 3 58 3 57 -291 0 -290 0 0 185 0 185 -65 0 -65 0 0 -185z m0 -480 l0 -175 -185 0 -185 0 0 175 0 175 185 0 185 0 0 -175z"

dat_date <- data.frame(
  date = as.Date('2017-04-01') + seq(0,364),
  value = round(runif(365, 0, 1000), 0),
  stringsAsFactors = FALSE)

ui <- fluidPage(
  title = "echarter Shiny",
  fluidRow(
    echartsOutput("result"),
    verbatimTextOutput("select")
  )
)

server <- function(input, output, session){
  ec <- echart() %>%
    ec_toolbox(
      orinent = 'horizontal',
      feature = list(
        mydays = list(
          show = TRUE,
          title = 'Days',
          icon = toolbox_icon_date_days,
          onclick = htmlwidgets::JS(toolbox_days)
        ),
        myweeks = list(
          show = TRUE,
          title = 'Weeks',
          icon = toolbox_icon_date_weeks,
          onclick = htmlwidgets::JS(toolbox_weeks)
        ),
        mymonths = list(
          show = TRUE,
          title = 'Months',
          icon = toolbox_icon_date_months,
          onclick = htmlwidgets::JS(toolbox_months)
        ),
        myyears = list(
          show = TRUE,
          title = 'Years',
          icon = toolbox_icon_date_years,
          onclick = htmlwidgets::JS(toolbox_years)
        )
      )
    )

  data_toolbox <- reactive({
    if(isTruthy(input$toolbox_select)){
      if(input$toolbox_select == "mydays"){
        dat_date
      }else if(input$toolbox_select == "myweeks"){
        dat_date %>%
          group_by(date = lubridate::ceiling_date(date, "weeks")) %>%
          summarise(value = sum(value)) %>%
          ungroup()
      }else if(input$toolbox_select == "mymonths"){
        dat_date %>%
          group_by(date = format(date, "%Y-%m")) %>%
          summarise(value = sum(value)) %>%
          ungroup()
      }else if(input$toolbox_select == "myyears"){
        dat_date %>%
          group_by(date = format(date, "%Y")) %>%
          summarise(value = sum(value)) %>%
          ungroup()
      }
    }else{
      dat_date
    }
  })

  output$result <- renderEcharts({
    ec %>%
      ec_add_series(
        data = data_toolbox(), type = 'line', name = "date",
        animation = FALSE,
        mapping = ecaes(x = date, y = value))
  })


  output$select <- renderPrint({
    if(isTruthy(input$toolbox_select)){
      input$toolbox_select
    }else{
      NULL
    }
  })
}
shinyApp(ui, server)
