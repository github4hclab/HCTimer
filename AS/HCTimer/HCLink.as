package AS.HCTimer
{
	import flash.net.URLRequest;
	import flash.net.URLVariables;
	import flash.net.URLRequestMethod;
	import flash.net.sendToURL;
	import flash.net.URLLoader;
	import flash.events.Event;
	import flash.net.URLLoaderDataFormat;
	import flash.events.IOErrorEvent;

	public class HCLink
	{
		//静态私有数据
		//static const LINK_URL:String = "http://210.38.196.20:8080/HCHandler.ashx";//后台的连接地址
		//static const LINK_URL:String = "http://localhost:13240/TimerWeb/HCHandler.ashx";
		static const COMMAND:String = "command";//发送的命令
		var _urlRequest:URLRequest = null;//请求对象
		var _urlLoader:URLLoader = null;//发送请求对象
		var _listeners:Vector.< Vector.<Function> > = null;//监听器
		var _timeVar:URLVariables = null;//时间变量
		var _linkSuccess:Boolean = false;//是否连接成功
		var _command:int = 0;//发送到后台的命令标记
		var _linkEvent:HCLinkEvent = null;//连接到后台的事件

		

		public function HCLink()
		{
			//创建xml用于获取后台地址
			//xmlConfig = new XML();
			_urlRequest = new URLRequest(HCTimer.linkUrl);
			_urlRequest.method = URLRequestMethod.POST;
			_urlLoader = new URLLoader();
			_urlLoader.dataFormat = URLLoaderDataFormat.TEXT;
			//增加读取后台事件监听
			_urlLoader.addEventListener(Event.COMPLETE, this.loadUrlHandler);
			_urlLoader.addEventListener(IOErrorEvent.IO_ERROR, this.ioErrorHandler);
			//_urlLoader.addEventListener("securityError", this.ioErrorHandler);
			//_urlLoader.addEventListener(IOErrorEvent.STANDARD_INPUT_IO_ERROR, this.ioErrorHandler);
			//_urlLoader.addEventListener(IOErrorEvent.STANDARD_OUTPUT_IO_ERROR, this.ioErrorHandler);
			_timeVar = new URLVariables();

			_linkEvent = new HCLinkEvent();
			_listeners = new Vector.< Vector.<Function> >(HCLinkEvent.COUNT);
			
		}

		//增加监听器，eType为事件类型，有效值为HCLinkEvent枚举的值
		public function addListener(eType:int, listener:Function):void
		{
			if (HCLinkEvent.MIN_INDEX <= eType && eType <= HCLinkEvent.MAX_INDEX)
			{
				if (_listeners[eType] == null)
				{
					_listeners[eType] = new Vector.<Function>;
				}
				_listeners[eType].push(listener);
			}
		}
		//是否成功连接到后台;
		public function get linkSuccess():Boolean
		{
			return _linkSuccess;
		}
		
		public function logout():void
		{
			_linkSuccess = false;
		}
		//更新时间的信息
		public function updateTime():void
		{
			try
			{
				//获取实例
				var time:HCTimeInfo = HCTimer.hcTime;
				var user:HCUserInfo = HCTimer.hcUser;
				//设置发送到后台的命令和相关参数
				_command = HCLinkEvent.UPDATE_TIME;
				_timeVar[COMMAND] = _command.toString();
				_timeVar[HCTimeInfo.TODAY_SECOND] = time.getTodayAllSecond();
				//_timeVar[HCTimeInfo.USER_ID] = user.id;
				_timeVar[HCTimeInfo.ID] = time.id;
				loadData(_timeVar);
				
			}
			catch(e:Error)
			{
				
			}
		}
		//更新用户的信息
		public function updateUser():void
		{
			_command = HCLinkEvent.UPDATE_USER;
			var user:HCUserInfo = HCTimer.hcUser;
			var urlVar:URLVariables = new URLVariables  ;
			user.changeURLVar(urlVar);
			urlVar[COMMAND] = _command.toString();
			loadData(urlVar);
			urlVar = null;
		}
		public function updateUserPassword(userId:String, account:String, passwordNew:String):void
		{
			_command = HCLinkEvent.UPDATE_PASSWORD;
			var urlVar:URLVariables = new URLVariables;
			urlVar[HCUserInfo.ACCOUNT] = account;
			urlVar[HCUserInfo.PASSWORD] = passwordNew;
			urlVar[HCUserInfo.ID] = userId;
			urlVar[COMMAND] = _command.toString();
			loadData(urlVar);
			urlVar = null;
		}
		public function addUser(account:String, password:String, name:String, number:String, sex:String, grade:String):void
		{
			_command = HCLinkEvent.ADD_USER;
			var user:HCUserInfo = HCTimer.hcUser;
			var urlVar:URLVariables = new URLVariables;
			//user.changeURLVar(urlVar);
			urlVar[COMMAND] = _command.toString();
			urlVar[HCUserInfo.ACCOUNT] = account;
			urlVar[HCUserInfo.PASSWORD] = password;
			urlVar[HCUserInfo.NAME] = name;
			urlVar[HCUserInfo.HARDWARE] = user.hardware;
			urlVar[HCUserInfo.IP] = user.ipAddress;
			urlVar[HCUserInfo.NUMBER] = number;
			urlVar[HCUserInfo.SEX] = sex;
			urlVar[HCUserInfo.GRADE] = grade;
			loadData(urlVar);
			urlVar = null;
		}
		//获取当前用户在指定时间段的时间数据
		public function getTimeData(beginDate:String, endDate:String):void
		{
			//获取相应的实例
			var time:HCTimeInfo = HCTimer.hcTime;
			var user:HCUserInfo = HCTimer.hcUser;
			//设置发送到后台的命令和其他参数信息
			//根据当前用户的id获取该用户的时间数据
			_command = HCLinkEvent.TIME_USERID;
			var timeDataVar:URLVariables = new URLVariables  ;
			timeDataVar[COMMAND] = _command.toString();
			timeDataVar[HCTimeInfo.USER_ID] = user.id;
			if (beginDate > endDate)
			{
				timeDataVar[HCTimeInfo.BEGIN_DATE] = endDate;
				timeDataVar[HCTimeInfo.END_DATE] = beginDate;
			}
			else
			{
				timeDataVar[HCTimeInfo.BEGIN_DATE] = beginDate;
				timeDataVar[HCTimeInfo.END_DATE] = endDate;
			}

			//从后台读取数据
			loadData(timeDataVar);

		}

		//检查是否存在该用户名
		public function checkAccount(account:String):void
		{
			var urlVar:URLVariables = new URLVariables;
			
			_command = HCLinkEvent.CHECK_ACCOUNT;
			urlVar[COMMAND] = _command.toString();
			urlVar[HCUserInfo.ACCOUNT] = account;
			loadData(urlVar);
		}
//		//发送数据，但忽略任何响应
//		private function sendData(urlVar:URLVariables):void
//		{
//			if (! _linkSuccess)
//			{
//				return;
//			}
//			//设置发送到后台的请求数据
//			_urlRequest.data = urlVar;
//
//			if (_linkSuccess)
//			{
//				try
//				{
//					//将请求发送到后台，但是忽略相应，用户更新数据中的相应数据
//					sendToURL(_urlRequest);
//					//trace(_urlRequest.url + "?" + _urlRequest.data.toString());
//				}
//				catch (e:Error)
//				{
//					trace("loadUrl Failed!");
//				}
//			}
//		}
		//向后台发送数据，并获取响应
		private function loadData(urlVar:URLVariables):void
		{
			try
			{
				_linkSuccess = false;
				//设置请求数据
				_urlRequest.data = urlVar;
				//读取后台发送回的数据
				_urlLoader.load(_urlRequest);
				//trace("loadData");
			}
			catch (e:Error)
			{
				//trace("loadUrl Failed!");
				_linkSuccess = false;
				_linkEvent.setData(null);
				callListeners();
				return;
			}
		}
		public function userLogin():void
		{
			var user:HCUserInfo = HCTimer.hcUser;
			var urlVar:URLVariables = new URLVariables;
			_command = HCLinkEvent.USER_LOGIN;
			urlVar[HCUserInfo.ACCOUNT] = user.account;
			urlVar[HCUserInfo.PASSWORD] = user.password;
			urlVar[COMMAND] = _command.toString();
			loadData(urlVar);
			urlVar = null;
		}
		//读取用户的信息
		public function getUserInfo():void
		{
			try
			{
				var user:HCUserInfo = HCTimer.hcUser;
				_command = HCLinkEvent.USER_INFO;
				var userVar:URLVariables = new URLVariables;
				userVar[HCUserInfo.ID] = user.id;
				userVar[COMMAND] = _command.toString();
				
				loadData(userVar);
				userVar = null;
			}
			catch (e:Error)
			{
				_linkSuccess = false;
				_linkEvent.setData(null);
				callListeners();
			}
		}
		private function ioErrorHandler(event:Event):void
		{
			_linkSuccess = false;
			_linkEvent.setData(null);
			//trace(event.toString());
			//_command = HCLinkEvent.USER_LOGIN;
			callListeners();
		}
		//向后台发送请求后，后台相应后的事件处理
		private function loadUrlHandler(event:Event):void
		{
			try
			{
				
				//将其转为XML
				_linkEvent.setData(XML(_urlLoader.data));
				_linkSuccess = _linkEvent.isLink;
				callListeners();
			}
			catch (e:Error)
			{
				_linkSuccess = false;
				//trace("loadUrlHandler Failed!");
			}
		}
		//调用每个监听器的事件处理
		private function callListeners():void
		{
			if (HCLinkEvent.MIN_INDEX <= _command && _command <= HCLinkEvent.MAX_INDEX && _listeners[_command] != null)
			{

				for (var i:int = 0; i < _listeners[_command].length; ++i)
				{
					_listeners[_command][i](_linkEvent);
				}
			}
		}


		//获取指定时间段内所有用户的总秒数时间数据
		public function getTimeWithAllUser(beginDate:String, endDate:String):void
		{
			//设置命令
			_command = HCLinkEvent.TIME_ALLUSER;
			var urlVar:URLVariables = new URLVariables  ;
			urlVar[COMMAND] = _command.toString();
			if (beginDate > endDate)
			{
				urlVar[HCTimeInfo.BEGIN_DATE] = endDate;
				urlVar[HCTimeInfo.END_DATE] = beginDate;
			}
			else
			{
				urlVar[HCTimeInfo.BEGIN_DATE] = beginDate;
				urlVar[HCTimeInfo.END_DATE] = endDate;
			}
			loadData(urlVar);
			urlVar = null;
		}
		//获取具有指定属性的用户在开始日期到结束日期的时间段内的总秒数时间数据
		public function getTimeWith(userAttr:String, value:String, beginDate:String, endDate:String):void
		{
			//设置命令
			switch (userAttr)
			{
				case HCUserInfo.NAME :
					{
						_command = HCLinkEvent.TIME_USERNAME;

					};
					break;
				case HCUserInfo.GRADE :
					{
						_command = HCLinkEvent.TIME_USERGRADE;

					};
					break;
				case HCUserInfo.NUMBER :
					{
						_command = HCLinkEvent.TIME_USERNUMBER;

					};
					break;
				default :
					break;
			}
			//设置发送请求的信息
			var urlVar:URLVariables = new URLVariables  ;
			urlVar[COMMAND] = _command.toString();
			urlVar[userAttr] = value;
			//开始时间要小于结束时间
			if (beginDate > endDate)
			{
				urlVar[HCTimeInfo.BEGIN_DATE] = endDate;
				urlVar[HCTimeInfo.END_DATE] = beginDate;
			}
			else
			{
				urlVar[HCTimeInfo.BEGIN_DATE] = beginDate;
				urlVar[HCTimeInfo.END_DATE] = endDate;
			}
			//发送请求，并接受后台响应
			loadData(urlVar);
		}
	}
}