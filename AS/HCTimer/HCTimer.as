package AS.HCTimer
{
	import flash.display.Stage;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	import fl.managers.StyleManager;
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	import flash.display.NativeWindow;
	import flash.display.MovieClip;
	import AS.HCNavigation;
	import AS.window.HCControlWindow;
	import AS.HCHead;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.desktop.NativeApplication;
	import flash.events.ProgressEvent;
	import flash.text.TextField;

	//环创计时器类，统一管理主要的功能类
	//该类应为单件，通过该类的静态属性获取主要功能类的唯一实例
	public class HCTimer
	{
		private static const CONFIG_ROOT:String = "config/config.xml";
		private var _link:HCLink = null;
		private var _userInfo:HCUserInfo = null;
		private var _timeInfo:HCTimeInfo = null;
		private var _linkUrl:String = null;
		private var _autoLogin:Boolean = false;//是否自动登录
		private var _remember:Boolean = false;//是否记住密码
		private var _startLogin:Boolean = true;//是否开机启动
		private var _minToTray:Boolean = true;
		private var _isLogin:Boolean = false;
		private var _isLinkComplete:Boolean = false;
		private var _account:String = "";//账号名
		private var _password:String = "";//密码
		private var _updateTime:uint = 5;//更新时间分为单位
		private var _navigate:HCNavigation = null;
		private var _controlWin:HCControlWindow = null;
		private var _head:HCHead = null;
		private var _main:MovieClip = null;
		private var _success:Vector.<Function> = null;
		private var _failed:Vector.<Function> = null;
		private var _allowTiming:Boolean = true;//是否可以计时
		var _linkInfoMovie:MovieClip = null;
		var _linkInfoTxt:TextField = null;
		var _headLogin:MovieClip = null;
		var _nameText:TextField = null;
		
		private var _config:XML = null;
		static var s_instance:HCTimer = null;
		
		
		public static function instance(main:MovieClip):HCTimer
		{
			if(s_instance == null)
			{
				s_instance = new HCTimer(main);
			}
			return s_instance;
		}
		
		public function HCTimer(main:MovieClip)
		{
			//如果为第一次初始化
			if(s_instance == null)
			{
				//创建
				s_instance = this;
				
				_main = main;
				var format:TextFormat = new TextFormat;
				format.font = "微软雅黑";
				format.size = 14;
				format.align = TextFormatAlign.LEFT;
				StyleManager.setStyle("textFormat", format);
				//StyleManager.setStyle("embedFonts", true);
				_success = new Vector.<Function>;
				_failed = new Vector.<Function>;
				
				readConfig();
				
				_link = new HCLink();
				_userInfo = new HCUserInfo(_link);
				_timeInfo = new HCTimeInfo(_link);
				
				_navigate = new HCNavigation(_main);
 
				_head = new HCHead(_main);

				_controlWin = new HCControlWindow(_main);
				
				_link.addListener(HCLinkEvent.USER_LOGIN, loginHandler);
				if(_autoLogin)
				{
					if(_isUserValid())
					{
						_userInfo.account = _account;
						_userInfo.password = _password;
						_link.userLogin();
					}
					else
					{
						_isLinkComplete = true;
					}
				}
				_linkInfoMovie = _main.linkInfo;
				
				_linkInfoTxt = _linkInfoMovie.member.linkInfo;
				_nameText = _main.nameText;
				_headLogin = _main.headLogin;
				_userInfo.initLinkInfo(_linkInfoMovie, _linkInfoTxt);
			}
			else
			{
				_controlWin.showWindow();
			}
		}
		private function _isUserValid():Boolean
		{
			if(_account != null && _account != "" && _password != null && _password != "")
			{
				return true;
			}
			else 
			{
				return false;
			}
		}
		static public function isUserValid():Boolean
		{
			return s_instance._isUserValid();
		}
		private function loginHandler(event:HCLinkEvent):void
		{
			if(event.isPass)
			{
				_isLogin = true;
				
			}
			if(!event.isLink)
			{
				_isLogin = false;
			}
			_isLinkComplete = true;
		}
		private function ioError(event:Event):void
		{
			
		}
		
		static public function logMessage(name:String, value:String):void
		{
			var config:XML = s_instance._config;
			if(config[name] == null)
			{
				var obj:String = "<" + name + ">" + value + "</" + name + ">";
				config.appendChild(obj);
			}
			else
			{
				config[name] = value;
			}
		}
		private function readConfig():void
		{
			var fileStream:FileStream = new FileStream();
			fileStream.addEventListener(IOErrorEvent.IO_ERROR, ioError, false, 0, true);
			fileStream.open(File.applicationDirectory.resolvePath(CONFIG_ROOT), FileMode.READ);
			_config = XML(fileStream.readUTFBytes(fileStream.bytesAvailable));
			fileStream.close();
			fileStream = null;

			_linkUrl = "http://" + _config.link + "/HCHandler.ashx";
			
			if(_config.autoLogin == "false")
			{
				_autoLogin = false;
			}
			else
			{
				_autoLogin = true;
			}
			
			if(_config.remember == "false")
			{
				_remember = false;
			}
			else
			{
				_remember = true;
			}
			
			if(_config.startLogin == "false")
			{
				_startLogin = false;
			}
			else
			{
				_startLogin = true;
			}
			
			if(_config.minToTray == "false")
			{
				_minToTray = false;
			}
			else
			{
				_minToTray = true;
			}
			
			_updateTime = uint(_config.updateTime);
			if(_updateTime <= 1)
			{
				_updateTime = 1;
			}
			_account = _config.ac;
			_password = _config.pa;
		}
		static public function saveLog():void
		{
			s_instance.writeConfig();
		}
		private function writeConfig():void
		{
			
				var fileStream:FileStream = new FileStream();
			
			
				var file:File = new File(File.applicationDirectory.resolvePath(CONFIG_ROOT).nativePath);
			
				fileStream.open(file, FileMode.WRITE);
				fileStream.position = 0;
				fileStream.writeUTFBytes('<?xml version="1.0" encoding="utf-8"?>\n' + _config.toString());
				fileStream.close();
				file = null;
				fileStream = null;
			
			
		}
		private function saveConfig(startLogin:Boolean, autoLogin:Boolean, minToTray:Boolean, updateTime:uint):void
		{
			try
			{

				_startLogin = startLogin;
				_autoLogin = autoLogin;
				_minToTray = minToTray;
				_updateTime = updateTime;
				_controlWin.startLogin = startLogin;
				_config.startLogin = _startLogin.toString();
			
				_config.autoLogin = _autoLogin.toString();

				_config.minToTray = _minToTray.toString();

				_config.updateTime = _updateTime.toString();
				writeConfig();
				callSuccess();
			}
			catch(e:Error)
			{
				callFailed();
			}
		}
		
		
		private function saveUser(account:String, password:String, remember:Boolean, autoLogin:Boolean):void
		{
			try
			{
				_account = account;
				_password = password;
				_autoLogin = autoLogin;
				_remember = remember;
				_config.remember = _remember.toString();
				_config.autoLogin = autoLogin.toString();
				_config.ac = _account;
				_config.pa = _password;
				writeConfig();
			}
			catch(e:Error)
			{
				
			}
		}
		static public function showLinkState():Boolean
		{
			return s_instance._showLinkState();
		}
		static public function checkLinkNow():void
		{
			s_instance._checkLinkNow();
		}
		static public function showUpdateState(value:Boolean):void
		{
			s_instance._showUpdateState(value);
		}
		private function _showUpdateState(value:Boolean):void
		{
			if(value)
			{
				_linkInfoTxt.text = "更新成功!"
				_linkInfoMovie.gotoAndPlay(2);
			}
			else
			{
				_linkInfoTxt.text = "更新失败!"
				_linkInfoMovie.gotoAndPlay(2);
			}
		}
		private function _checkLinkNow():void
		{
			_linkInfoTxt.text = "正在连接服务器……"
			if(!this._isLogin)
			{
				this._nameText.text = "正在连接";
			}
			if(!_linkInfoMovie.isPlaying)
			{
				_linkInfoMovie.gotoAndPlay(2);
			}
		}
		private function _showLinkState():Boolean
		{
			if(!this._link.linkSuccess)
			{
				_linkInfoTxt.text = "无法连接服务器……"
				//if(!this._isLogin)
				//{
				this._nameText.text = "无法连接";
				this._isLogin = false;
				//}
				
				_linkInfoMovie.gotoAndPlay(2);
				
				return false;
			}
			else
			{	
				if(!this._isLogin)
				{
					_linkInfoTxt.text = "成功连接服务器!"
					this._nameText.text = "连接成功";
					_linkInfoMovie.gotoAndPlay(2);
				}
				return true;
			}
		}
		static public function checkLogin():Boolean
		{
			return s_instance._checkLogin();
		}
		private function _checkLogin():Boolean
		{
			if(!this._isLogin)
			{
				_nameText.text = "请先登录"
				_headLogin.gotoAndPlay(2);
				_linkInfoTxt.text = "请先在这里登录……"
				if(!_linkInfoMovie.isPlaying)
				{
					_linkInfoMovie.gotoAndPlay(2);
				}
			}
			return this._isLogin;
		}
		private function callSuccess():void
		{
			for(var i:int = 0; i < _success.length; ++i)
			{
				_success[i].call();
			}
		}
		private function callFailed():void
		{
			for(var i:int = 0; i < _failed.length; ++i)
			{
				_failed[i].call();
			}
		}
		private function logoutHandler():void
		{
			//if(_link.linkSuccess)
			//{
				_link.updateTime();
			//}
			_isLogin = false;
			_link.logout();
			_userInfo.logout();
			_timeInfo.logout();
			
		}
		private function saveRemmber(value:Boolean):void
		{
			_remember = value;
			_config.remember = _remember.toString();
			if(!_remember)
			{
				_config.pa = "";
				_config.ac = "";
			}
			writeConfig();
		}
		private function saveAutoLogin(value:Boolean):void
		{
			_autoLogin = value;
			if(_autoLogin)
			{
				_remember = true;
				_config.remember = _remember.toString();
			}
			if(!_remember)
			{
				_config.pa = "";
				_config.ac = "";
			}
			_config.autoLogin = _autoLogin.toString();
			writeConfig();
		}
		public static function get allowTiming():Boolean
		{
			return s_instance._allowTiming;
		}
		public static function set allowTiming(value:Boolean):void
		{
			s_instance._allowTiming = value;
		}
		public static function set autoLogin(value:Boolean):void
		{
			s_instance.saveAutoLogin(value);
		}
		public static function set remember(value:Boolean):void
		{
			s_instance.saveRemmber(value);
		}
		//是否连接后台完成
		public static function get isLinkComplete():Boolean
		{
			return s_instance._isLinkComplete;
		}
		//是否登录成功
		public static function get isLogin():Boolean
		{
			return s_instance._isLogin;
		}
		//注销
		public static function logout():void
		{
			s_instance.logoutHandler();
		}
		//保存设置
		public static function saveSetting(startLogin:Boolean, autoLogin:Boolean, minToTray:Boolean, updateTime:uint):void
		{
			s_instance.saveConfig(startLogin, autoLogin, minToTray, updateTime);
		}
		//记录用户的信息
		public static function rememberUser(account:String, password:String, remember:Boolean, autoLogin:Boolean):void
		{
			s_instance.saveUser(account, password, remember, autoLogin);
		}
		//增加保存文件成功的事件处理
		public static function addSuccessHandler(handler:Function):void
		{
			s_instance._success.push(handler);
		}
		//增加保存文件失败的事件处理
		public static function addFailedHandler(handler:Function):void
		{
			s_instance._failed.push(handler);
		}
		//获取主影片剪辑
		public static function get main():MovieClip
		{
			return s_instance._main;
		}
		//是否自动登录
		public static function get autoLogin():Boolean
		{
			return s_instance._autoLogin;
		}
		
		//关闭时是否最小化到托盘
		public static function get minToTray():Boolean
		{
			return s_instance._minToTray;
		}
		
		//是否记住密码
		public static function get remember():Boolean
		{
			return s_instance._remember;
		}
		
		//是否开机启动
		public static function get startLogin():Boolean
		{
			return s_instance._startLogin;
		}
		//获取自动记住密码后的用户的账号
		public static function get account():String
		{
			return s_instance._account;
		}
		
		//获取自动记住密码后的用户的密码
		public static function get password():String
		{
			return s_instance._password;
		}
		
		//获取更新时间，秒为单位
		public static function get updateTime():uint
		{
			return s_instance._updateTime;
		}
		
		//获取后台连接地址
		public static function get linkUrl():String
		{
			return s_instance._linkUrl;
		}
		//获取连接后台的实例
		public static function get hcLink():HCLink
		{
			return s_instance._link;
		}
		
		
		//获取操作用户信息的实例
		public static function get hcUser():HCUserInfo
		{
			return s_instance._userInfo;
		}
		
		//获取操作时间信息的实例
		public static function get hcTime():HCTimeInfo
		{
			return s_instance._timeInfo;
		}
	}

}