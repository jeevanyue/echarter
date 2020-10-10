
# Environment that holds various global variables and settings for echarter.
echarter_global <- new.env(parent = emptyenv())

# List of all aesthetics known to echarter
echarter_global$all_aesthetics <- c()

# Aesthetic aliases
echarter_global$base_to_echarter <- c(
  "col"   = "color",
  "colour"= "color",
  "fg"    = "color",
  "pch"   = "symbol",
  "shape" = "symbol",
  "cex"   = "symbolSize",
  "size"  = "symbolSize",
  "lwd"   = "symbolSize",
  "lty"   = "borderType",
  "linetype"= "borderType",
  "srt"   = "symbolRotate",
  "angle" = "symbolRotate",
  "xalign" = "align",
  "yalign" = "verticalAlign"
)

# animation ====
echarter_global$animation <- c(
  "animation",
  "animationThreshold",
  "animationDuration",
  "animationEasing",
  "animationDelay",
  "animationDurationUpdate",
  "animationEasingUpdate",
  "animationDelayUpdate"
)

# symbol ====
echarter_global$symbol <- c(
  "symbol", # string or function. symbol. eg: symbol = "circle"
  "symbolSize", # number or array or function. symbol size. eg: symbolSize = 4, symbolSize = c(20,10) means symbol width is 20, and height is 10.
  "symbolOffset", # number or array. offset of symbol relative to original position.
  "symbolRotate", # number or function. rotate degree of line point symbol. The negative value represents clockwise. eg: symbolRotate = 45,
  "symbolKeepAspect" # boolean. Whether to keep aspect for symbols in the form of path://
)

# border ====
echarter_global$border <- c(
  "borderColor", # string. border color. eg: borderColor = "transparent", borderColor = "#ccc"
  "borderWidth", # number. border width. eg: borderColor = 0
  "borderRadius" # number or array. border radius. eg: borderRadius = 5, borderRadius = c(5,5,0,0)
)

# shadow ====
echarter_global$shadow <- c(
  "shadowColor", # string. shadow color. eg: shadowColor = "transparent"
  "shadowBlur", # number. shadow blur. eg: shadowBlur = 0
  "shadowOffsetX", # number. shadow X offset. eg: shadowOffsetX = 0
  "shadowOffsetY" # number. shadow Y offset. eg: shadowOffsetY = 0
)
# shadow style ====
echarter_global$shadowStyle <- c(
  "color",
  "opacity",
  echarter_global$shadow
)

# background style ====
echarter_global$backgroundStyle <- c(
  "color",
  "opacity",
  echarter_global$border,
  echarter_global$shadow
)

# text ====
echarter_global$font <- c(
  "fontStyle", # string. font style. eg: fontStyle = "normal"
  "fontWeight", # string or number. font thick weight eg: fontWeight = "normal", fontWeight = 100
  "fontFamily", # string. font family. eg: fontFamily = "sans-serif"
  "fontSize" # number. font size. eg: fontSize = 12
)
echarter_global$textBorder <- c(
  "textBorderColor", # string. storke color of the text. eg: textBorderColor = "transparent"
  "textBorderWidth" # number. storke line width of the text. eg: textBorderWidth = 0
)
echarter_global$textShadow <- c(
  "textShadowColor", # string. shadow color of the text. eg: textShadowColor = "transparent"
  "textShadowBlur", # number. shadow blur of the text. eg: textShadowBlur = 0
  "textShadowOffsetX", # number. shadow X offse of the text. eg: textShadowOffsetX = 0
  "textShadowOffsetY" # number. shadow Y offset of the text. eg: textShadowOffsetY = 0
)

# text style ====
echarter_global$textStyle <- c(
  "color",
  "lineHeight",
  "width",
  "height",
  echarter_global$font,
  echarter_global$textBorder,
  echarter_global$textShadow
)
echarter_global$nameTextStyle <- c(
  "align", "verticalAlign",
  "backgroundColor", "padding",
  echarter_global$textStyle,
  echarter_global$border,
  echarter_global$shadow
)
echarter_global$label <- c(
  "show",
  "position", "distance",
  "rotate", "offset", "formatter",
  echarter_global$nameTextStyle
)
echarter_global$axisLabel <- c(
  "interval", "inside",
  "margin",
  "showMinLabel", "showMaxLabel",
  echarter_global$label
)

# emphasis selectorLabel ====
echarter_global$selectorLabel <- echarter_global$label

# line style ====
echarter_global$lineStyle <- c(
  "color",
  "width",
  "type",
  "opacity",
  echarter_global$shadow
)
echarter_global$axisLine <- c(
  "show",
  "onZero", "onZeroAxisIndex",
  echarter_global$symbol
  # , echarter_global$lineStyle
)
echarter_global$splitLine <- c(
  "show",
  "interval"
  # , echarter_global$lineStyle
)
echarter_global$axisTick <- c(
  "show",
  "alignWithLabel", "interval", "inside", "length"
  # , echarter_global$lineStyle
)
echarter_global$minorSplitLine <- c(
  "show"
)
echarter_global$minorTick <- c(
  "show",
  "splitNumber", "length"
  , lineStyle = list(echarter_global$lineStyle)
  # , echarter_global$lineStyle
)

# area style ====
echarter_global$areaStyle <- c(
  "color",
  "interval",
  echarter_global$shadow
)
echarter_global$splitArea <- c(
  "show",
  "opacity"
  # , echarter_global$areaStyle
)

# item style
echarter_global$itemStyle <- c(
  "color",
  "opacity",
  echarter_global$border,
  echarter_global$shadow
)

# axis pointer ====
echarter_global$axisPointer <- c(
  "show",
  "type",
  "snap",
  "z",
  "triggerTooltip",
  "value",
  "status",
  "zlevel", "z"
  # , echarter_global$label
  # , echarter_global$lineStyle
  # , echarter_global$shadowStyle
)






# xAxis ====
echarter_global$xAxis <- c(
  "id", "show", "gridIndex", "position", "offset", "type",
  "name", "nameLocation", "nameGap", "nameRotate",
  "inverse",
  "boundaryGap",
  "min", "max", "scale",
  "splitNumber", "minInterval", "maxInterval",
  "logBase",
  "silent",
  "triggerEvent",
  "zlevel", "z"
  , echarter_global$nameTextStyle
  , echarter_global$axisLine
  , echarter_global$axisTick
  , echarter_global$axisLabel
  , echarter_global$axisPointer
  , echarter_global$splitLine
  , echarter_global$splitArea
  , echarter_global$minorTick
  , echarter_global$minorSplitLine
)

