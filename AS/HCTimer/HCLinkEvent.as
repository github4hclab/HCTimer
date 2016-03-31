package AS.HCTimer
{
	import flash.events.Event;

	public class HCLinkEvent extends Event
	{
		//public static const FIRST_LOAD:int = 0;//第一次读取数据完成后触发
		public static const USER_LOGIN:int = 0;//获取用户信息
		public static const TIME_USERID:int = 1;//获取当前用户的时间数据完成后触发
		public static const TIME_ALLUSER:int = 2;//获取所有用户的时间数据完成后触发
		public static const TIME_USERNAME:int = 3;//获取指定姓名的用户时间数据完成后触发
		public static const TIME_USERGRADE:int = 4;//获取指定年级的用户时间数据完成后触发
		public static const TIME_USERNUMBER:int = 5;//获取指定学号的用户时间数据完成后触发
		public static const UPDATE_TIME:int = 6;//更新当前用户的时间命令
		public static const UPDATE_USER:int = 7;//更新当前用户的信息命令
		public static const CHECK_ACCOUNT:int = 8;//检查该用户名是否存在
		public static const ADD_USER:int = 9;//增加用户
		public static const USER_INFO:int = 10;//获取用户的信息
		public static const UPDATE_PASSWORD = 11;//更新用户的密码
		
		public static const IS_FIND:String = "isFind";//是否找到
		public static const IS_SUCCESS:String = "isSuccess";//执行是否成功
		public static const IS_PASS:String = "isPass";//密码是否正确
		public static const IS_LINK:String = "isLink";//是否可以连接后台

		internal static const MIN_INDEX:int = 0;//事件的最小序号
		internal static const MAX_INDEX:int = 11;//事件的最大序号
		internal static const COUNT:int = 12;//事件的数量
		private var _isFind:Boolean = false;
		private var _isSuccess:Boolean = false;
		private var _isPass:Boolean = false;
		private var _isLink:Boolean = false;
		private var _xml:XML;//保存读取完成后的xml数据


		public function HCLinkEvent()
		{
			//注册该事件
			super("HCLinkEvent");
		}
		
		internal function setData(xml:XML):void
		{
			try
			{
				_xml = xml;
				if(_xml == null)
				{
					_isFind = false;
					_isSuccess = false;
					_isPass = false;
					_isLink = false;
				}
				else
				{
					var child:XMLList = _xml.child("message");
					if(child.attribute(IS_FIND) == "true")
					{
						_isFind = true;
					}
					else
					{
						_isFind = false;
					}
					
					if(child.attribute(IS_SUCCESS) == "true")
					{
						_isSuccess = true;
					}
					else
					{
						_isSuccess = false;
					}
					
					if(child.attribute(IS_PASS) == "true")
					{
						_isPass = true;
					}
					else
					{
						_isPass = false;
					}
					
					if(child.attribute(IS_LINK) == "true")
					{
						_isLink = true;
					}
					else
					{
						_isLink = false;
					}
				}
			}
			catch(e:Error)
			{
				trace("LinkEvent" + e.message);
			}
			
		}
		public function findData(attribute:String):String
		{
			try
			{
				var child:XMLList = _xml.child("userData");
				return child.attribute(attribute);
			}
			catch(e:Error)
			{
				
			}
			return null;
		}
		//获取读取完成后的xml数据
		public function get xml():XML
		{
			return _xml;
		}
		//是否找到相应的数据
		public function get isFind():Boolean 
		{
			return _isFind;
		}
		//是否能成功获取到后台数据
		public function get isSuccess():Boolean 
		{
			return _isSuccess;
		}
		//密码是否正确
		public function get isPass():Boolean
		{
			return _isPass;
		}
		public function get isLink():Boolean
		{
			return _isLink;
		}
	}

}