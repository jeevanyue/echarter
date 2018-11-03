
# echarter

![](http://echarter.jeevanyue.com/img/echarter_logo_mini.png)

[ECharts 4](http://echarts.baidu.com)的R语言接口实现, 详细说明文档和案例请查看[echarter](http://echarter.jeevanyue.com) 。

## 简介

我之前一直使用[highcharter](http://jkunst.com/highcharter/)做交互式数据可视化，因为工作的需要开始使用echarts，期间主要使用过两个echarts包，[cosname/recharts](https://github.com/cosname/recharts)和[JohnCoene/echarts4r](https://github.com/JohnCoene/echarts4r)。因为使用`highcharter`比较久，也习惯了它的的实现方式，以及`highcharts`丰富的官方文档和社区帮助。所以我按照`highcharter`的方式，尝试开发了`echarter`。取名为`echarter`，也是为了向`highcharter`致敬。并且也参考了[cosname/recharts](https://github.com/cosname/recharts)和[JohnCoene/echarts4r](https://github.com/JohnCoene/echarts4r)的实现方式。

这是我第一次开发完整的package，不足之处欢迎大家指正。

## 安装

echarter包的源代码在分享在Github，[jeevanyue/echarter](https://github.com/jeevanyue/echarter)，可通过下列方式安装。

```
devtools::install_github("jeevanyue/echarter")
```

## 基础组件

支持官方配置项的所有组件，详细可以查看官方文档[option](http://echarts.baidu.com/option.html)和[案例](http://echarts.baidu.com/examples/)。

- [ec_title](http://echarter.jeevanyue.com/api-ec.html#ec_title)
- [ec_legend](http://echarter.jeevanyue.com/api-ec.html#ec_legend)
- [ec_backgroundColor](http://echarter.jeevanyue.com/api-ec.html#ec_backgroundColor)
- [ec_colors](http://echarter.jeevanyue.com/api-ec.html#ec_colors)
- [ec_tooltip](http://echarter.jeevanyue.com/api-ec.html#ec_tooltip)
- [ec_graphic](http://echarter.jeevanyue.com/api-ec.html#ec_graphic)
- [ec_axisPointer](http://echarter.jeevanyue.com/api-ec.html#ec_axisPointer)
- [ec_toolbox](http://echarter.jeevanyue.com/api-ec.html#ec_toolbox)
- [ec_visualMap](http://echarter.jeevanyue.com/api-ec.html#ec_visualMap)
- [ec_dataZoom](http://echarter.jeevanyue.com/api-ec.html#ec_dataZoom)
- [ec_timeline](http://echarter.jeevanyue.com/api-ec.html#ec_timeline)
- [ec_brush](http://echarter.jeevanyue.com/api-ec.html#ec_brush)
- [ec_mark](http://echarter.jeevanyue.com/api-ec.html#ec_mark)
	* [ec_markPoint](http://echarter.jeevanyue.com/api-ec.html#ec_mark)
	* [ec_markLine](http://echarter.jeevanyue.com/api-ec.html#ec_mark)
	* [ec_markArea](http://echarter.jeevanyue.com/api-ec.html#ec_mark)

## 坐标系组件

- 二维的直角坐标系grid/cartesian2d，默认为空
	* [ec_grid](http://echarter.jeevanyue.com/api-ec.html#ec_grid)
	* [ec_xAxis](http://echarter.jeevanyue.com/api-ec.html#ec_grid)
	* [ec_yAxis](http://echarter.jeevanyue.com/api-ec.html#ec_grid)
- 极坐标系polar
	* [ec_polar](http://echarter.jeevanyue.com/api-ec.html#ec_polar)
	* [ec_angleAxis](http://echarter.jeevanyue.com/api-ec.html#ec_polar)
	* [ec_radiusAxis](http://echarter.jeevanyue.com/api-ec.html#ec_polar)
- 平行坐标系parallel，只限于series.parallel
	* [ec_parallel](http://echarter.jeevanyue.com/api-ec.html#ec_parallel)
	* [ec_parallelAxis](http://echarter.jeevanyue.com/api-ec.html#ec_parallel)
- 单轴坐标系singleAxis
	* [ec_singleAxis](http://echarter.jeevanyue.com/api-ec.html#ec_singleAxis)
- 地理坐标系geo
	* [ec_geo](http://echarter.jeevanyue.com/api-ec.html#ec_geo)
- 日历坐标系calendar
	* [ec_calendar](http://echarter.jeevanyue.com/api-ec.html#ec_calendar)
- 雷达坐标系radar，只限于series.radar
	* [ec_radar](http://echarter.jeevanyue.com/api-ec.html#ec_radar)
- 不使用坐标系none

## 数据组件ec_dataset

支持的图表类型: line, bar, scatter, effectScatter, boxplot, candlestick, pictorialBar, custom

暂时只支持data.frame和json两种数据格式。

如果是data.frame，会通过`jsonlite::toJSON(setNames(data, NULL))`转为json，并默认`dimensions =  colnames(data)`。如果是json，会直接取用该数据，并默认`dimensions = NULL`。

通过ec_dataset导入数据，需要提前对数据进行预处理，后续再对这个组件进行拓展。

## 数据组件ec_add_series

目前支持的数据类型有，data.frame, matrix, numeric, character, tx, forecast. 

添加数据的方式我根据两个属性进行判断，坐标系和图表类型。

有坐标系的图表，包括line、bar、scatter、effectScatter、boxplot、candlestick、pictorialBar、lines、heatmap、themeRiver，数据添加方式的分类：

![](http://echarter.jeevanyue.com/img/add_data_coord.png)

无坐标系的图表，包括pie、map、funnel、guage、tree、treemap、sunburst、sankey、graph，数据添加方式的分类：

![](http://echarter.jeevanyue.com/img/add_data_nocoord.png)

## 图表类型

支持除了GL的所有图表类型，包括水球图liquidfill和字符云wordcloud，详见[基本图表](http://echarter.jeevanyue.com/basic.html)和[高级图表](http://echarter.jeevanyue.com/advanced.html)。

## echarter

支持[echarter](http://echarter.jeevanyue.com/echarter.html)来快速绘图。

## 主题theme

可以通过下列四种方式设置主题，详见[echarter.theme](http://echarter.jeevanyue.com/theme.html)。

- 支持自带的theme: dark, infographic, macarons, roma, shine, vintage，``echart(theme = 'dark')``
- 导入[echarts theme 构建工具](http://echarts.baidu.com/theme-builder/)的js主题文件，``echart(theme = '**.js')``
- 导入``ec_theme``构建的主题，`echart(theme = thm)`导入
- 修改全局主题``getOption("echarter.option")``，该方式目前还没有跟所有图表类型匹配，建议采用以上三种方式

## shiny案例

shiny通过``renderEcharts``和``echartsOutput``实现。

- 实时数据，[code](https://github.com/jeevanyue/echarter/tree/master/demo/realtime)，[demo](http://shiny.jeevanyue.com/realtime/)
- 鼠标事件和触发图表行为，及图表联动实例，[code](https://github.com/jeevanyue/echarter/tree/master/demo/actions)，[demo](http://shiny.jeevanyue.com/actions/)
- toolbox拓展，[code](https://github.com/jeevanyue/echarter/tree/master/demo/toolbox)，[demo](http://shiny.jeevanyue.com/toolbox/)

## 其他echarts包

- [cosname/recharts](https://github.com/cosname/recharts) - ECharts4
- [JohnCoene/echarts4r](https://github.com/JohnCoene/echarts4r) - ECharts4
- [yihui/recharts](https://github.com/yihui/recharts) - ECharts2
- [madlogos/recharts](https://github.com/madlogos/recharts) - ECharts2 forked from yihui/recharts
- [madlogos/recharts2](https://github.com/madlogos/recharts2) - ECharts3
- [ChanningWong/REcharts3](https://github.com/ChanningWong/REcharts3) - ECharts3
- [XD-DENG/ECharts2Shiny](https://github.com/XD-DENG/ECharts2Shiny) - ECharts3
