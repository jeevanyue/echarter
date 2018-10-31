(function (root, factory) {
    if (typeof define === 'function' && define.amd) {
        // AMD. Register as an anonymous module.
        define(['exports', 'echarts'], factory);
    } else if (typeof exports === 'object' && typeof exports.nodeName !== 'string') {
        // CommonJS
        factory(exports, require('echarts'));
    } else {
        // Browser globals
        factory({}, root.echarts);
    }
}(this, function (exports, echarts) {
    var log = function (msg) {
        if (typeof console !== 'undefined') {
            console && console.error && console.error(msg);
        }
    };
    if (!echarts) {
        log('ECharts is not Loaded');
        return;
    }
    echarts.registerTheme('star', {
        "color": [
            "#247ba0",
            "#70c1b3",
            "#b2dbbf",
            "#f3ffbd",
            "#ff1654"
        ],
        "backgroundColor": "rgba(36,39,62,1)",
        "textStyle": {},
        "title": {
            "textStyle": {
                "color": "#ffffff"
            },
            "subtextStyle": {
                "color": "#dddddd"
            }
        },
        "line": {
            "itemStyle": {
                "normal": {
                    "borderWidth": "2"
                }
            },
            "lineStyle": {
                "normal": {
                    "width": "3"
                }
            },
            "symbolSize": "7",
            "symbol": "emptyCircle",
            "smooth": true
        },
        "radar": {
            "itemStyle": {
                "normal": {
                    "borderWidth": "2"
                }
            },
            "lineStyle": {
                "normal": {
                    "width": "3"
                }
            },
            "symbolSize": "7",
            "symbol": "emptyCircle",
            "smooth": true
        },
        "bar": {
            "itemStyle": {
                "normal": {
                    "barBorderWidth": 0,
                    "barBorderColor": "#dddddd"
                },
                "emphasis": {
                    "barBorderWidth": 0,
                    "barBorderColor": "#dddddd"
                }
            }
        },
        "pie": {
            "itemStyle": {
                "normal": {
                    "borderWidth": 0,
                    "borderColor": "#dddddd"
                },
                "emphasis": {
                    "borderWidth": 0,
                    "borderColor": "#dddddd"
                }
            }
        },
        "scatter": {
            "itemStyle": {
                "normal": {
                    "borderWidth": 0,
                    "borderColor": "#dddddd"
                },
                "emphasis": {
                    "borderWidth": 0,
                    "borderColor": "#dddddd"
                }
            }
        },
        "boxplot": {
            "itemStyle": {
                "normal": {
                    "borderWidth": 0,
                    "borderColor": "#dddddd"
                },
                "emphasis": {
                    "borderWidth": 0,
                    "borderColor": "#dddddd"
                }
            }
        },
        "parallel": {
            "itemStyle": {
                "normal": {
                    "borderWidth": 0,
                    "borderColor": "#dddddd"
                },
                "emphasis": {
                    "borderWidth": 0,
                    "borderColor": "#dddddd"
                }
            }
        },
        "sankey": {
            "itemStyle": {
                "normal": {
                    "borderWidth": 0,
                    "borderColor": "#dddddd"
                },
                "emphasis": {
                    "borderWidth": 0,
                    "borderColor": "#dddddd"
                }
            }
        },
        "funnel": {
            "itemStyle": {
                "normal": {
                    "borderWidth": 0,
                    "borderColor": "#dddddd"
                },
                "emphasis": {
                    "borderWidth": 0,
                    "borderColor": "#dddddd"
                }
            }
        },
        "gauge": {
            "itemStyle": {
                "normal": {
                    "borderWidth": 0,
                    "borderColor": "#dddddd"
                },
                "emphasis": {
                    "borderWidth": 0,
                    "borderColor": "#dddddd"
                }
            }
        },
        "candlestick": {
            "itemStyle": {
                "normal": {
                    "color": "#fd1050",
                    "color0": "#0cf49b",
                    "borderColor": "#fd1050",
                    "borderColor0": "#0cf49b",
                    "borderWidth": "1"
                }
            }
        },
        "graph": {
            "itemStyle": {
                "normal": {
                    "borderWidth": 0,
                    "borderColor": "#dddddd"
                }
            },
            "lineStyle": {
                "normal": {
                    "width": 1,
                    "color": "#aaaaaa"
                }
            },
            "symbolSize": "7",
            "symbol": "emptyCircle",
            "smooth": true,
            "color": [
                "#247ba0",
                "#70c1b3",
                "#b2dbbf",
                "#f3ffbd",
                "#ff1654"
            ],
            "label": {
                "normal": {
                    "textStyle": {
                        "color": "#24273e"
                    }
                }
            }
        },
        "map": {
            "itemStyle": {
                "normal": {
                    "areaColor": "#eeeeee",
                    "borderColor": "#444444",
                    "borderWidth": 0.5
                },
                "emphasis": {
                    "areaColor": "rgba(160,36,88,1)",
                    "borderColor": "#444444",
                    "borderWidth": 1
                }
            },
            "label": {
                "normal": {
                    "textStyle": {
                        "color": "#000000"
                    }
                },
                "emphasis": {
                    "textStyle": {
                        "color": "rgb(255,255,255)"
                    }
                }
            }
        },
        "geo": {
            "itemStyle": {
                "normal": {
                    "areaColor": "#eeeeee",
                    "borderColor": "#444444",
                    "borderWidth": 0.5
                },
                "emphasis": {
                    "areaColor": "rgba(160,36,88,1)",
                    "borderColor": "#444444",
                    "borderWidth": 1
                }
            },
            "label": {
                "normal": {
                    "textStyle": {
                        "color": "#000000"
                    }
                },
                "emphasis": {
                    "textStyle": {
                        "color": "rgb(255,255,255)"
                    }
                }
            }
        },
        "categoryAxis": {
            "axisLine": {
                "show": true,
                "lineStyle": {
                    "color": "#dddddd"
                }
            },
            "axisTick": {
                "show": true,
                "lineStyle": {
                    "color": "#dddddd"
                }
            },
            "axisLabel": {
                "show": true,
                "textStyle": {
                    "color": "#dddddd"
                }
            },
            "splitLine": {
                "show": false,
                "lineStyle": {
                    "color": [
                        "#eeeeee",
                        "#333333"
                    ]
                }
            },
            "splitArea": {
                "show": false,
                "areaStyle": {
                    "color": [
                        "rgba(250,250,250,0.05)",
                        "rgba(200,200,200,0.02)"
                    ]
                }
            }
        },
        "valueAxis": {
            "axisLine": {
                "show": true,
                "lineStyle": {
                    "color": "#dddddd"
                }
            },
            "axisTick": {
                "show": true,
                "lineStyle": {
                    "color": "#dddddd"
                }
            },
            "axisLabel": {
                "show": true,
                "textStyle": {
                    "color": "#dddddd"
                }
            },
            "splitLine": {
                "show": false,
                "lineStyle": {
                    "color": [
                        "#eeeeee",
                        "#333333"
                    ]
                }
            },
            "splitArea": {
                "show": false,
                "areaStyle": {
                    "color": [
                        "rgba(250,250,250,0.05)",
                        "rgba(200,200,200,0.02)"
                    ]
                }
            }
        },
        "logAxis": {
            "axisLine": {
                "show": true,
                "lineStyle": {
                    "color": "#dddddd"
                }
            },
            "axisTick": {
                "show": true,
                "lineStyle": {
                    "color": "#dddddd"
                }
            },
            "axisLabel": {
                "show": true,
                "textStyle": {
                    "color": "#dddddd"
                }
            },
            "splitLine": {
                "show": false,
                "lineStyle": {
                    "color": [
                        "#eeeeee",
                        "#333333"
                    ]
                }
            },
            "splitArea": {
                "show": false,
                "areaStyle": {
                    "color": [
                        "rgba(250,250,250,0.05)",
                        "rgba(200,200,200,0.02)"
                    ]
                }
            }
        },
        "timeAxis": {
            "axisLine": {
                "show": true,
                "lineStyle": {
                    "color": "#dddddd"
                }
            },
            "axisTick": {
                "show": true,
                "lineStyle": {
                    "color": "#dddddd"
                }
            },
            "axisLabel": {
                "show": true,
                "textStyle": {
                    "color": "#dddddd"
                }
            },
            "splitLine": {
                "show": false,
                "lineStyle": {
                    "color": [
                        "#eeeeee",
                        "#333333"
                    ]
                }
            },
            "splitArea": {
                "show": false,
                "areaStyle": {
                    "color": [
                        "rgba(250,250,250,0.05)",
                        "rgba(200,200,200,0.02)"
                    ]
                }
            }
        },
        "toolbox": {
            "iconStyle": {
                "normal": {
                    "borderColor": "#999999"
                },
                "emphasis": {
                    "borderColor": "#666666"
                }
            }
        },
        "legend": {
            "textStyle": {
                "color": "#dddddd"
            }
        },
        "tooltip": {
            "axisPointer": {
                "lineStyle": {
                    "color": "#cccccc",
                    "width": 1
                },
                "crossStyle": {
                    "color": "#cccccc",
                    "width": 1
                }
            }
        },
        "timeline": {
            "lineStyle": {
                "color": "#8fd3e8",
                "width": 1
            },
            "itemStyle": {
                "normal": {
                    "color": "#8fd3e8",
                    "borderWidth": 1
                },
                "emphasis": {
                    "color": "#8fd3e8"
                }
            },
            "controlStyle": {
                "normal": {
                    "color": "#8fd3e8",
                    "borderColor": "#8fd3e8",
                    "borderWidth": 0.5
                },
                "emphasis": {
                    "color": "#8fd3e8",
                    "borderColor": "#8fd3e8",
                    "borderWidth": 0.5
                }
            },
            "checkpointStyle": {
                "color": "#8fd3e8",
                "borderColor": "rgba(138,124,168,0.37)"
            },
            "label": {
                "normal": {
                    "textStyle": {
                        "color": "#8fd3e8"
                    }
                },
                "emphasis": {
                    "textStyle": {
                        "color": "#8fd3e8"
                    }
                }
            }
        },
        "visualMap": {
            "color": [
                "#247ba0",
                "#73abc2",
                "#70c1b3",
                "#b2dbbf",
                "#f3ffbd"
            ]
        },
        "dataZoom": {
            "backgroundColor": "rgba(0,0,0,0)",
            "dataBackgroundColor": "rgba(255,255,255,0.3)",
            "fillerColor": "rgba(167,183,204,0.4)",
            "handleColor": "#a7b7cc",
            "handleSize": "100%",
            "textStyle": {
                "color": "#333333"
            }
        },
        "markPoint": {
            "label": {
                "normal": {
                    "textStyle": {
                        "color": "#24273e"
                    }
                },
                "emphasis": {
                    "textStyle": {
                        "color": "#24273e"
                    }
                }
            }
        }
    });
}));