package AS.HCTimer
{
	import flash.net.InterfaceAddress;
	import flash.net.NetworkInfo;
	import flash.net.NetworkInterface;
	import flash.text.TextField;
	import flash.net.URLRequest;
	import flash.net.URLVariables;
	import flash.events.Event;
	import fl.controls.RadioButton;
	import flash.display.SimpleButton;
	import fl.managers.StyleManager;
	import fl.controls.TextInput;
	import fl.controls.TextArea;
	import flash.display.MovieClip;

	public class HCUserInfo
	{
		public static const HARDWARE:String = "hardware";//物理地址信息，用于发送给后台的命令
		public static const ID:String = "userId";//唯一标记
		public static const ACCOUNT:String = "account";//用户名
		public static const PASSWORD:String = "password";//密码
		public static const NUMBER:String = "number";//学号
		public static const NAME:String = "userName";//姓名
		public static const IP:String = "ip";//ip地址
		public static const SEX:String = "sex";//性别
		public static const QQ:String = "qq";//qq号码
		public static const LONG_NUM:String = "longNum";//长号
		public static const SHORT_NUM:String = "shortNum";//短号
		public static const GRADE:String = "grade";//年级
		public static const MAJOR:String = "major";//专业 
		public static const STUDY:String = "study";//学习方向
		//public static const IS_MEMBER:String = "isMember";


		private var _ipText:TextField = null;
		private var _showName:TextField = null;//姓名
		private var _linkInfoMovie:MovieClip = null;
		private var _linkInfoText:TextField = null;

		private var _hardware:String = null;//物体网卡地址
		private var _ip:String = null;//ip地址
		private var _id:String = null;//_id
		public var name:String = null;//姓名
		public var account:String = null;//账号名
		public var password:String = null;
		public var number:String = null;//学号
		public var sex:String = null;//性别
		public var qq:String = null;//_qqText号码
		public var longNum:String = null;//长号
		public var shortNum:String = null;//短号
		public var grade:String = null;//年级
		public var major:String = null;//专业
		public var study:String = null;//研究方向

		public function HCUserInfo(link:HCLink)
		{
			//获取本地的物理网卡地址和IP地址
			var netInfo:NetworkInfo = NetworkInfo.networkInfo;
			var netInterfaces:Vector.<NetworkInterface >  = netInfo.findInterfaces();
			if (netInterfaces != null)
			{
				_hardware = netInterfaces[0].hardwareAddress;
				_ip = netInterfaces[0].addresses[0].address;
			}
			link.addListener(HCLinkEvent.USER_LOGIN, userLoginHandler);
		}
		public function set ipText(value:TextField):void
		{
			_ipText = value;
			_ipText.text = _ip;
		}
		public function set showNameText(value:TextField):void
		{
			_showName = value;
		}
		public function get showNameText():TextField
		{
			return _showName;
		}
		public function  initLinkInfo(movie:MovieClip, txt:TextField):void
		{
			_linkInfoMovie = movie;
			_linkInfoText = txt;
			if(HCTimer.autoLogin)
			{
				if(HCTimer.isUserValid())
				{
					_linkInfoText.text = "正在登录……";
				}
				else
				{
					_linkInfoText.text = "账号密码不能为空";
				}
			}
			else
			{
				_linkInfoText.text = "请先在这里登录……";
			}
			_linkInfoMovie.gotoAndPlay(2);
		}
		//获取ip地址
		public function get ipAddress():String
		{
			return _ip;
		}
		//获取物理网卡地址
		public function get hardware():String
		{
			return _hardware;
		}
		public function get id():String
		{
			return _id;
		}
		//转换数据格式
		public function changeURLVar(urlVar:URLVariables):void
		{
			urlVar[ID] = _id;
			urlVar[HARDWARE] = _hardware;
			urlVar[IP] = _ip;
			urlVar[NAME] = name;
			urlVar[NUMBER] = number;
			urlVar[GRADE] = grade;
			urlVar[SEX] = sex;
			urlVar[QQ] = qq;
			urlVar[LONG_NUM] = longNum;
			urlVar[SHORT_NUM] = shortNum;
			urlVar[GRADE] = grade;
			urlVar[MAJOR] = major;
			urlVar[STUDY] = study;
			_showName.text = name;
		}
		public function logout():void
		{
			_showName.text = "请先登录";
		}
		private function userLoginHandler(event:HCLinkEvent):void
		{
			if (! event.isLink)
			{
				_showName.text = "连接失败";
				_linkInfoText.text = "连接失败……";
				if(!_linkInfoMovie.isPlaying)
				{
					
					_linkInfoMovie.gotoAndPlay(2);
				}
				
				return;
			}
			if(! event.isFind)
			{
				_showName.text = "用户不存在";
				_linkInfoText.text = "用户不存在……";
				if(!_linkInfoMovie.isPlaying)
				{
					_linkInfoMovie.gotoAndPlay(2);
				}
				return;
			}
			if(! event.isPass)
			{
				_showName.text = "密码错误";
				_linkInfoText.text = "密码错误……";
				if(!_linkInfoMovie.isPlaying)
				{
					_linkInfoMovie.gotoAndPlay(2);
				}
				return;
			}
			var xml:XMLList = event.xml.child("userData");
			_id = xml.attribute(ID).toString();
			name = xml.attribute(NAME).toString();
			_showName.text = name;
			_linkInfoText.text = "登录成功!";
			if(!_linkInfoMovie.isPlaying)
			{
				//if(_linkInfoMovie.currentFrame == 1)
				//{
				_linkInfoMovie.gotoAndPlay(2);
				//}
				//else
				//{
					//_linkInfoMovie.gotoAndPlay(33);
				//}
				
			}
		}
	}

}