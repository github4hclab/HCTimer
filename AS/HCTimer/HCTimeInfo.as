package AS.HCTimer
{
	import flash.utils.Timer;
	import flash.events.TimerEvent;
	import flash.text.TextField;

	public class HCTimeInfo
	{
		public static const USER_ID:String = "userId";
		public static const TODAY_SECOND:String = "todaySecond";
		public static const ALL_SECOND:String = "allSecond";
		public static const BEGIN_DATE:String = "beginDate";
		public static const END_DATE:String = "endDate";
		public static const ID:String = "timeId";
		
		private var _id:String = null;
		//今天的时间信息
		//private var _todayHour:int = 0;
		//private var _todayMinute:int = 0;
		//private var _todaySecond:int = 0;
		//private var _todayAllSecond:int = 0;
		private var _updateSecond:uint = 0;
		//private var _secondWithNoLogin:int = 0;
		
		//该星期的时间信息
		//private var _weekHour:int = 0;
		//private var _weekMinute:int = 0;
		//private var _weekSecond:int = 0;
		//private var _weekAllSecond:int = 0;
		
		
		//该星期的平均时间
		//private var _avgHour:int = 0;
		//private var _avgMinute:int = 0;
		//private var _avgSecond:int = 0;
		//星期
		private const WEEK_DAY:Array = new Array("日", "一", "二", "三", "四", "五", "六");
		
		private var _timer:Timer = null;
		private var _showToday:TextField = null;
		private var _showWeek:TextField = null;
		private var _showAvg:TextField = null;
		private var _todayDate:TextField = null;
		private var _weekDate:TextField = null;
		private var _nowDate:Date = null;
		private var _allWeekDay:Number = 0;
		private var _link:HCLink = null;
		private var _userTodaySecond:int = 0;
		private var _userWeekSecond:int = 0;
		private var _aloneTodaySceond:int = 0;

		public function HCTimeInfo(link:HCLink)
		{
			_link = link;
			//创建计时器
			
			_timer = new Timer(1000,0);
			
			_timer.addEventListener(TimerEvent.TIMER, timeHandle);

			link.addListener(HCLinkEvent.USER_LOGIN, handleLogin);
			link.addListener(HCLinkEvent.UPDATE_TIME, handleUpdateTime);
			_timer.start();
			_nowDate = new Date;
			//trace(_nowDate.seconds);
			if(_nowDate.day == 0)
			{
				_allWeekDay = 7;
			}
			else 
			{
				_allWeekDay = _nowDate.day;
			}
		}
		public function get id():String
		{
			return _id;
		}
		private function setDate():void
		{
			_nowDate = null;
			_nowDate = new Date();
			if(_nowDate.day == 0)
			{
				_allWeekDay = 7;
			}
			else 
			{
				_allWeekDay = _nowDate.day;
			}
			var weekDay:Number = _nowDate.day;
			if(weekDay == 0)
			{
				weekDay = 6;
			}
			else
			{
				weekDay = weekDay - 1;
			}
			var begin:Date = new Date(_nowDate.fullYear, _nowDate.month , _nowDate.date  - weekDay);
			
			var end:Date = new Date(begin.fullYear, begin.month , begin.date + 6);

			_todayDate.text =  _nowDate.fullYear.toString() + "年" + (_nowDate.month + 1).toString() + "月" + _nowDate.date.toString() + "日 " + "(星期" + WEEK_DAY[_nowDate.day] + ")";
			_weekDate.text = begin.fullYear.toString() + "年" + (begin.month + 1).toString() + "月" + begin.date.toString() + "日 - " + end.fullYear.toString() + "年" + (end.month + 1).toString() + "月" + end.date.toString() + "日";
			
			begin = null;
			end = null;
		}
		//设置显示文本
		public function setShowText(todayDate:TextField, weekDate:TextField, today:TextField, week:TextField, avg:TextField):void
		{
			_todayDate = todayDate;
			_weekDate = weekDate;
			_showToday = today;
			_showWeek = week;
			_showAvg = avg;
			setDate();
			
		}
		////获取当前的日期 
//		public function get nowDate():String
//		{
//			return _nowDate.fullYear.toString() + " 年 - " + (_nowDate.month + 1).toString() + " 月 - " + _nowDate.date.toString() + " 日 " + "星期" + WEEK_DAY[_nowDate.day];
//		}
		//开始计时
		//internal function startTimer():void
//		{
//			_timer.start();
//		}
		private function setTimeFormat(hour:int, minute:int, second:int):String
		{
			return hour.toString() + " 时 - " + minute.toString() + " 分 - " + second.toString() + " 秒";
		}
		public function showTodayTime():void
		{
			var allSecond:int = _aloneTodaySceond + _userTodaySecond;
			var hour:int = allSecond / 3600;
			var minute:int = (allSecond - 3600 * hour) / 60;
			var second:int = allSecond - 3600 * hour - 60 * minute;
			_showToday.text = setTimeFormat(hour, minute, second);
		}
		public function showWeekTime():void
		{
			var allSecond:int = _aloneTodaySceond + _userWeekSecond;
			var hour:int = allSecond / 3600;
			var minute:int = (allSecond - 3600 * hour) / 60;
			var second:int = allSecond - 3600 * hour - 60 * minute;
			_showWeek.text = setTimeFormat(hour, minute, second);
		}
		
		private function showAvgTime():void
		{
			var avgSecond:int = (_aloneTodaySceond + _userWeekSecond) / _allWeekDay;
			var hour:int = avgSecond / 3600;
			var minute:int = (avgSecond - 3600 * hour) / 60;
			var second:int = avgSecond - 3600 * hour - 60 * minute;
			_showAvg.text = setTimeFormat(hour, minute, second);
		}
//		private function set todayAllSecond(value:int):void
//		{
//			_todayAllSecond = value;
//			_todayHour = value / 3600;
//			_todayMinute = (value - 3600 * _todayHour) / 60;
//			_todaySecond = value - 3600 * _todayHour - 60 * _todayMinute;
//		}
		public function  getTodayAllSecond():String
		{
			return (_aloneTodaySceond + _userTodaySecond).toString();
		}
//		private function set weekAllSecond(value:int):void
//		{
//			_weekAllSecond = value;
//			_weekHour = value / 3600;
//			_weekMinute = (value - 3600 * _todayHour) / 60;
//			_weekSecond = value - 3600 * _todayHour - 60 * _todayMinute;
//		}
		internal function handleLogin(event:HCLinkEvent):void
		{
			if(event.isPass)
			{
				var xml:XMLList = event.xml.child("userData");
				_userTodaySecond = int(xml.attribute(TODAY_SECOND));
				_userWeekSecond = int(xml.attribute(ALL_SECOND));
				//_userTodaySecond += _aloneTodaySceond;
				//_userWeekSecond += _aloneTodaySceond;
				//todayAllSecond = _secondWithNoLogin + int(xml.attribute(TODAY_SECOND));
				//weekAllSecond = _secondWithNoLogin + int(xml.attribute(ALL_SECOND));
				//_aloneTodaySceond = 0;
				_id = xml.attribute(ID).toString();
			}
			//startTimer();
		}
		public function logout():void
		{
			//_todaySecond = 0;
			//_todayAllSecond = 0;
			//_weekAllSecond = 0;
			//_todayMinute = 0;
			//_todayHour = 0;
			//_secondWithNoLogin = 0;
			_userTodaySecond = 0;
			_userWeekSecond = 0;
			_aloneTodaySceond = 0;
		}
		public function handleUpdateTime(event:HCLinkEvent):void
		{
			if(event.isSuccess && event.isLink)
			{
				_userTodaySecond += _aloneTodaySceond;
				_userWeekSecond += _aloneTodaySceond;
				_aloneTodaySceond = 0;
			}
		}
		
		private function timeHandle(event:TimerEvent):void
		{
			if(!HCTimer.allowTiming)
			{
				++_updateSecond;
				if(_updateSecond > HCTimer.updateTime * 60)
				{
					setDate();
					_updateSecond = 0;
				}
				return;
			}
			//++_todaySecond;
			//++_todayAllSecond;
			//++_weekAllSecond;
			++_aloneTodaySceond;
			++_updateSecond;
			//++_secondWithNoLogin;
			
			
			//if (_todaySecond > 59)
			//{
				//++_todayMinute;
				//_todaySecond = 0;
			//}
			//if (_todayMinute > 59)
			//{
				//++_todayHour;
				//_todayMinute = 0;
			//}
			if(_updateSecond > HCTimer.updateTime * 60)
			{
				if(HCTimer.isLogin)
				{
					_link.updateTime();
				}
				setDate();
				_updateSecond = 0;
			}
			showTodayTime();
			showWeekTime();
			showAvgTime()
			//event.updateAfterEvent();
		}
	}
}