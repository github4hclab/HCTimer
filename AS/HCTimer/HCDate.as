package AS.HCTimer 
{
	import fl.controls.TextInput;
	import flash.text.TextField;

	//操作日期的类
	public class HCDate
	{
		private static const PER_MILLSECOND_DAY:Number = 1.0 / (1000.0 * 60.0 * 60.0 * 24.0);//1毫秒对应的天数
		private static var _date:Date = null;
		//开始日期数据
		private var _beginYear:TextInput = null;
		private var _beginMonth:TextInput = null;
		private var _beginDay:TextInput = null;
		private var _beginMill:Number = 0;
		
		//结束日期数据
		private var _endYear:TextInput = null;
		private var _endMonth:TextInput = null;
		private var _endDay:TextInput = null;
		private var _endMill:Number = 0;
		

		
		public function HCDate(beginYear:TextInput, beginMonth:TextInput, beginDay:TextInput, endYear:TextInput, endMonth:TextInput, endDay:TextInput)
		{
			//创建操作时间的date实例
			_date = new Date;
			
			_beginYear = beginYear;
			_beginMonth = beginMonth;
			_beginDay = beginDay;

			_endYear = endYear;
			_endMonth = endMonth;
			_endDay = endDay;
			
			var weekDay:Number = _date.day;
			if(weekDay == 0)
			{
				weekDay = 6;
			}
			else
			{
				weekDay = weekDay - 1;
			}
			var begin:Date = new Date(_date.fullYear, _date.month , _date.date  - weekDay);
			_beginYear.text = begin.fullYear.toString();
			_beginMonth.text = (begin.month + 1).toString();
			_beginDay.text = begin.date.toString();
			
			var end:Date = new Date(begin.fullYear, begin.month , begin.date + 6);
			_endYear.text = end.fullYear.toString();
			_endMonth.text = (end.month + 1).toString();
			_endDay.text = end.date.toString();
			
			begin = null;
			end = null;
		}
		
		//获取开始时间日期的字符串
		public function get beginDate():String
		{
			//将字符串转成数字
			var year:Number = Number(_beginYear.text);
			var month:Number = Number(_beginMonth.text) - 1;//因为月份从0开始算起
			var day:Number = Number(_beginDay.text);
			
			//获取自1970年1月1日到该日期的经过的毫秒数
			_beginMill = _date.setFullYear(year, month, day);
			//将其设置为合理的日期
			_beginYear.text = _date.fullYear.toString();
			_beginMonth.text = (_date.month + 1).toString();
			_beginDay.text = _date.date.toString();
			//返回20130512日期格式的字符串
			return (int(_date.fullYear * 10000 + (_date.month + 1) * 100 + _date.date)).toString();
		}
		
		//获取结束时间日期的字符串
		public function get endDate():String
		{
			//将字符串转成数字
			var year:Number = Number(_endYear.text);
			var month:Number = Number(_endMonth.text) - 1;//因为月份从0开始算起
			var day:Number = Number(_endDay.text);
			
			//获取自1970年1月1日到该日期的经过的毫秒数
			_endMill = _date.setFullYear(year, month, day);
			//将其设置为合理的日期
			_endYear.text = _date.fullYear.toString();
			_endMonth.text = (_date.month + 1).toString();
			_endDay.text = _date.date.toString();
			//返回20130512日期格式的字符串
			return (int(_date.fullYear * 10000 + (_date.month + 1) * 100 + _date.date)).toString();
		}
		
		//获取从开始日期到结束日期经过的天数
		public function get deltaDay():int
		{
			//根据秒数差转换成天数
			if(_endMill < _beginMill)
			{
				var temp:Number = _beginMill;
				_beginMill = _endMill;
				_endMill = temp;
			}
			var days:int = (_endMill - _beginMill) * PER_MILLSECOND_DAY  + 1;
			if(days < 0)
			{
				return -days;
			}
			return days;
		}
		//转换日期格式，可以将20130512的日期格式转成合适的日期格式
		public static function dateFormat(date:uint):String
		{
			var dateStr:String = "";
			//获取年月日
			var year:uint = date / 10000;
			var month:uint = (date - year * 10000) / 100;
			var day:uint = date - year * 10000 - month *100;
			
			var temp:uint = year;
			while(year < 1000)
			{
				dateStr += "0";
				temp *= 10;
			}
			dateStr += year.toString() + "年";
			if(month < 10)
			{
				dateStr += "0";
			}
			dateStr += month.toString() + "月";
			if(day < 10)
			{
				dateStr += "0";
			}
			dateStr += day.toString() + "日";
			return dateStr;
		}
		//转换时间格式，将秒数为单位的转成合适的时分秒格式
		public static function secondFormat(time:uint):String
		{
			var timeStr:String = "";
			//时分秒
			var hour:uint = time / 3600;
			var minute:uint = (time - hour * 3600) / 60;
			var second:uint = time - hour * 3600 - minute * 60;
			if(hour < 10)
			{
				timeStr += "0";
			}
			timeStr += hour.toString() + "时";
			if(minute < 10)
			{
				timeStr += "0";
			}
			timeStr += minute.toString() + "分";
			
			if(second < 10)
			{
				timeStr += "0";
			}
			timeStr += second.toString() + "秒";
			return timeStr;
		}
	}

}