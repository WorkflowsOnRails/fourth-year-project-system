!function(){var Available,DEFAULT_DAYS,DEFAULT_TIMES,ESCAPE_KEYCODE,i,timeFromMinuteOfDay,twelveHourTime;ESCAPE_KEYCODE=27;DEFAULT_DAYS=[{name:"Sun",dayId:0},{name:"Mon",dayId:1},{name:"Tue",dayId:2},{name:"Wed",dayId:3},{name:"Thu",dayId:4},{name:"Fri",dayId:5},{name:"Sat",dayId:6}];DEFAULT_TIMES=function(){var _i,_results;_results=[];for(i=_i=17;_i<=33;i=++_i){_results.push(i*30)}return _results}();timeFromMinuteOfDay=function(minuteOfDay){var hour,minute;hour=Math.floor(minuteOfDay/60);minute=minuteOfDay%60;return[hour,minute]};twelveHourTime=function(hour,minute){var hourString,minuteString;minuteString=("00"+minute).slice(-2);hourString=hour%12===0?"12":""+hour%12;return""+hourString+":"+minuteString};Available=function(){function Available(options){var $parent,disabled,times;$parent=options.$parent,this.days=options.days,times=options.times,this.onChanged=options.onChanged,disabled=options.disabled;if(this.days==null){this.days=DEFAULT_DAYS}if(times==null){times=DEFAULT_TIMES}if(disabled==null){disabled=false}this.allTimes=times;this.times=times.slice(0,-1);this.lastTime=times[times.length-1];if(this.onChanged==null){this.onChanged=null}this.cells={};this.activeCell=null;this.$el=$('<table class="available"></table>');this.addHeader(this.$el);this.addBody(this.$el);this.addFooter(this.$el);if(!disabled){this.$el.addClass("enabled");this.bindEvents()}$parent.append(this.$el)}Available.prototype.addHeader=function($el){var $tr,name,_i,_len,_ref;$tr=$("<tr><th></th></tr>").appendTo($el);_ref=this.days;for(_i=0,_len=_ref.length;_i<_len;_i++){name=_ref[_i].name;$("<th>"+name+"</td>").appendTo($tr)}return null};Available.prototype.addBody=function($el){var $label,$td,$tr,column,dayId,hour,minute,startTime,_base,_i,_j,_len,_len1,_ref,_ref1,_ref2;_ref=this.times;for(_i=0,_len=_ref.length;_i<_len;_i++){startTime=_ref[_i];$tr=$("<tr></tr>").appendTo($el);_ref1=timeFromMinuteOfDay(startTime),hour=_ref1[0],minute=_ref1[1];$label=$("<td><span>"+twelveHourTime(hour,minute)+"</span></td>");$label.addClass("label hour-"+hour+" minute-"+minute);$label.appendTo($tr);_ref2=this.days;for(column=_j=0,_len1=_ref2.length;_j<_len1;column=++_j){dayId=_ref2[column].dayId;$td=$("<td></td>");$td.addClass("cell day-"+dayId+" hour-"+hour+" minute-"+minute);$td.appendTo($tr);if((_base=this.cells)[column]==null){_base[column]={}}this.cells[column][startTime]={$el:$td,column:column,startTime:startTime,isActive:false}}}return null};Available.prototype.addFooter=function($el){var $label,$tr,hour,minute,_ref;_ref=timeFromMinuteOfDay(this.lastTime),hour=_ref[0],minute=_ref[1];$tr=$('<tr class="trailing-row"></tr>').appendTo($el);$label=$("<td><span>"+twelveHourTime(hour,minute)+"</span></td>");$label.addClass("label hour-"+hour+" minute-"+minute);$label.appendTo($tr);return null};Available.prototype.bindEvents=function(){var cell,column,_,_fn,_ref,_this=this;$(document).mouseup(function(e){if(_this.activeCell!==null){_this.clearTentative();return _this.activeCell=null}});$(document).keydown(function(e){if(e.keyCode===ESCAPE_KEYCODE&&_this.activeCell!==null){_this.clearTentative();return _this.activeCell=null}});_ref=this.cells;for(_ in _ref){column=_ref[_];_fn=function(cell){cell.$el.mousedown(function(e){_this.activeCell=cell;return e.originalEvent.preventDefault()});cell.$el.mouseup(function(e){if(_this.activeCell!==null){_this.clearTentative();_this.toggleCells(_this.activeCell,cell);_this.activeCell=null;return false}});return cell.$el.mousemove(function(e){if(_this.activeCell!==null){return _this.toggleCellsTentative(_this.activeCell,cell)}})};for(_ in column){cell=column[_];_fn(cell)}}return null};Available.prototype.forCells=function(fromCell,toCell,fxn){var cell,column,fromTime,toTime,_,_i,_ref,_ref1,_ref2,_ref3,_ref4;fromTime=fromCell.startTime;toTime=toCell.startTime;if(toTime<fromTime){_ref=[toTime,fromTime],fromTime=_ref[0],toTime=_ref[1]}for(column=_i=_ref1=fromCell.column,_ref2=toCell.column;_ref1<=_ref2?_i<=_ref2:_i>=_ref2;column=_ref1<=_ref2?++_i:--_i){_ref3=this.cells[column];for(_ in _ref3){cell=_ref3[_];if(fromTime<=(_ref4=cell.startTime)&&_ref4<=toTime){fxn(cell)}}}return null};Available.prototype.clearTentative=function(){var tentativeClasses;tentativeClasses="tentative tentative-addition tentative-removal";this.$el.find(".tentative").removeClass(tentativeClasses);return null};Available.prototype.clearActive=function(){var cell,column,_,_ref;this.$el.find(".marked-interval").removeClass("marked-interval");_ref=this.cells;for(_ in _ref){column=_ref[_];for(_ in column){cell=column[_];cell.isActive=false}}return null};Available.prototype.markActive=function(cell,isNowActive){cell.isActive=isNowActive;cell.$el.toggleClass("marked-interval",isNowActive);return null};Available.prototype.toggleCells=function(fromCell,toCell){var isNowActive,_this=this;isNowActive=!fromCell.isActive;this.forCells(fromCell,toCell,function(cell){return _this.markActive(cell,isNowActive)});this.triggerChanged();return null};Available.prototype.toggleCellsTentative=function(fromCell,toCell){var isNowActive,tentativeClass,tentativeStateClass;this.clearTentative();isNowActive=!fromCell.isActive;tentativeStateClass=isNowActive?"tentative-addition":"tentative-removal";tentativeClass="tentative "+tentativeStateClass;this.forCells(fromCell,toCell,function(cell){return cell.$el.addClass(tentativeClass)});return null};Available.prototype.triggerChanged=function(){var markedIntervals;if(this.onChanged===null){return}markedIntervals=this.serialize();this.onChanged(markedIntervals);return null};Available.prototype.serialize=function(){var cell,column,dayId,endTime,lastInterval,markedIntervals,startTime,_i,_j,_len,_ref,_ref1;markedIntervals=[];_ref=this.days;for(column=_i=0,_len=_ref.length;_i<_len;column=++_i){dayId=_ref[column].dayId;lastInterval=null;for(i=_j=0,_ref1=this.allTimes.length-1;0<=_ref1?_j<_ref1:_j>_ref1;i=0<=_ref1?++_j:--_j){startTime=this.allTimes[i];endTime=this.allTimes[i+1];cell=this.cells[column][startTime];if(lastInterval===null&&cell.isActive){lastInterval={dayId:dayId,startTime:startTime,endTime:endTime}}else if(lastInterval!==null&&cell.isActive){lastInterval.endTime=endTime}else if(lastInterval!==null&&!cell.isActive){markedIntervals.push(lastInterval);lastInterval=null}}if(lastInterval!==null){markedIntervals.push(lastInterval)}}return markedIntervals};Available.prototype.deserialize=function(markedIntervals){var cell,column,columnForDayId,dayId,endTime,startTime,time,_i,_j,_k,_len,_len1,_len2,_ref,_ref1,_ref2;this.clearTentative();this.clearActive();columnForDayId={};_ref=this.days;for(column=_i=0,_len=_ref.length;_i<_len;column=++_i){dayId=_ref[column].dayId;columnForDayId[dayId]=column}for(_j=0,_len1=markedIntervals.length;_j<_len1;_j++){_ref1=markedIntervals[_j],dayId=_ref1.dayId,startTime=_ref1.startTime,endTime=_ref1.endTime;column=columnForDayId[dayId];_ref2=this.times;for(_k=0,_len2=_ref2.length;_k<_len2;_k++){time=_ref2[_k];if(startTime<=time&&time<endTime){cell=this.cells[column][time];this.markActive(cell,true)}}}return null};return Available}();window.Available=Available}.call(this);