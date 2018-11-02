HTMLWidgets.widget({

  name: 'echarter',

  type: 'output',

  factory: function(el, width, height) {
    
    var initialized = false;

    var chart;
    
    return {

      renderValue: function(x) {
        
        if(x.dispose === true){
          chart = echarts.init(document.getElementById(el.id));
          chart.dispose();
        }

        if (!initialized) {
          initialized = true;
          // alert('timeline is initialized!');
          if(x.theme === 'ec_theme'){
            echarts.registerTheme(x.theme, x.ec_theme);
          }

          if(x.registerMap === true){
            echarts.registerMap(x.mapName, x.geoJSON);
          }
        }

        chart = echarts.init(document.getElementById(el.id), x.theme, {renderer: x.renderer});
        chart.setOption(x.opt);

        if (HTMLWidgets.shinyMode) {
          // alert('Ooh, Shiny!');

          chart.on('click', function(e){
            Shiny.setInputValue(el.id + '_click_componentType' + ':echarterEvents', e.componentType, {priority: "event"});
            Shiny.setInputValue(el.id + '_click_seriesType' + ':echarterEvents', e.seriesType, {priority: "event"});
            Shiny.setInputValue(el.id + '_click_seriesIndex' + ':echarterEvents', e.seriesIndex, {priority: "event"});
            Shiny.setInputValue(el.id + '_click_seriesName' + ':echarterEvents', e.seriesName, {priority: "event"});
            Shiny.setInputValue(el.id + '_click_name' + ':echarterEvents', e.name, {priority: "event"});
            Shiny.setInputValue(el.id + '_click_dataIndex' + ':echarterEvents', e.dataIndex, {priority: "event"});
            Shiny.setInputValue(el.id + '_click_data' + ':echarterEvents', e.data, {priority: "event"});
            Shiny.setInputValue(el.id + '_click_dataType' + ':echarterEvents', e.dataType, {priority: "event"});
            Shiny.setInputValue(el.id + '_click_value' + ':echarterEvents', e.value, {priority: "event"});
            Shiny.setInputValue(el.id + '_click_color' + ':echarterEvents', e.color, {priority: "event"});
            Shiny.setInputValue(el.id + '_click_info' + ':echarterEvents', e.info, {priority: "event"});
          });
          
          chart.on('mouseover', function(e){
            Shiny.setInputValue(el.id + '_mouseover_componentType' + ':echarterEvents', e.componentType, {priority: "event"});
            Shiny.setInputValue(el.id + '_mouseover_seriesType' + ':echarterEvents', e.seriesType, {priority: "event"});
            Shiny.setInputValue(el.id + '_mouseover_seriesIndex' + ':echarterEvents', e.seriesIndex, {priority: "event"});
            Shiny.setInputValue(el.id + '_mouseover_seriesName' + ':echarterEvents', e.seriesName, {priority: "event"});
            Shiny.setInputValue(el.id + '_mouseover_name' + ':echarterEvents', e.name, {priority: "event"});
            Shiny.setInputValue(el.id + '_mouseover_dataIndex' + ':echarterEvents', e.dataIndex, {priority: "event"});
            Shiny.setInputValue(el.id + '_mouseover_data' + ':echarterEvents', e.data, {priority: "event"});
            Shiny.setInputValue(el.id + '_mouseover_dataType' + ':echarterEvents', e.dataType, {priority: "event"});
            Shiny.setInputValue(el.id + '_mouseover_value' + ':echarterEvents', e.value, {priority: "event"});
            Shiny.setInputValue(el.id + '_mouseover_color' + ':echarterEvents', e.color, {priority: "event"});
            Shiny.setInputValue(el.id + '_mouseover_info' + ':echarterEvents', e.info, {priority: "event"});
          });

          chart.on('brushselected', function(e){
            Shiny.setInputValue(el.id + '_brushselected' + ':echarterEvents', e.batch[0].selected);
          });
          
          chart.on('legendselectchanged', function(e){
            Shiny.setInputValue(el.id + '_legendselectchanged' + ':echarterEvents', e.selected);
          });

          chart.on('datazoom', function(e){
            Shiny.setInputValue(el.id + '_datazoom' + ':echarterEvents', {'startValue':chart.getOption().dataZoom[0].startValue, 'endValue':chart.getOption().dataZoom[0].endValue});
          });

          chart.on('datarangeselected', function(e){
            Shiny.setInputValue(el.id + '_datarangeselected' + ':echarterEvents', e.selected);
          });

          chart.on('updateAxisPointer', function(e){
			if (typeof e.dataIndex != 'undefined') {
				Shiny.setInputValue(el.id + '_updateAxisPointer' + ':echarterEvents', {'seriesIndex':e.seriesIndex,'dataIndex':e.dataIndex});
			}else{
				Shiny.setInputValue(el.id + '_updateAxisPointer' + ':echarterEvents', '');
			}
          });

        }

      },

      getChart: function(){
        return chart;
      },

      resize: function(width, height) {

        if(chart){
          chart.resize();
        }

      }

    };
  }
});



function get_echarts(id){

  var htmlWidgetsObj = HTMLWidgets.find('#' + id);

  var chart;

  if (typeof htmlWidgetsObj != 'undefined') {
    chart = htmlWidgetsObj.getChart();
  }

  return(chart);
}

