package AS
{
	import flash.display.MovieClip;
	import AS.HCTimer.HCTimer;
	import AS.HCTimer.HCUserInfo;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import AS.HCLogin;
	import AS.HCTimer.HCLinkEvent;
	import flash.text.TextField;

	public class HCHead
	{
		private var _head:MovieClip = null;
		private var _info:HCInfoContent = null;
		private var _clickHead:Boolean = false;
		private var _submit:MovieClip = null;
		private var _prompt:MovieClip = null;
		private var _hcLogin:HCLogin = null;
		private var _main:MovieClip = null;
		private const BEGIN_FRAME:int = 2;
		private const EXIT_INFO:int = 11;
		private const EXIT_HEAD:int = 21;
		private const ALL_HEAD:int = 16;
		private const CLICK_HEAD:int = 15;
		private var _isLogin:Boolean = false;
		private var _linkInfoMovie:MovieClip = null;
		private var _linkInfoTxt:TextField =null;
		
		public function HCHead(main:MovieClip)
		{
			_main = main;
			_head = _main.head;
			_linkInfoMovie = _main.linkInfo;
			_linkInfoTxt = _linkInfoMovie.member.linkInfo;
			
			_head.addEventListener(MouseEvent.ROLL_OVER, this.headRollOver);
			_head.addEventListener(MouseEvent.ROLL_OUT, this.headRollOut);
			_head.addEventListener(MouseEvent.CLICK, this.clickHead);

			HCTimer.hcLink.addListener(HCLinkEvent.USER_LOGIN, loginHandler);
		}
		
		private function headRollOver(event:Event):void
		{
			if (!_clickHead)
			{
				_head.gotoAndPlay(BEGIN_FRAME);
			}
		}
		private function headRollOut(event:Event):void
		{
			if (! _clickHead)
			{
				_head.gotoAndPlay(ALL_HEAD - _head.currentFrame);
			}
		}
		private function clickHead(event:Event):void
		{
			if (! _clickHead)
			{
				_head.gotoAndPlay(CLICK_HEAD);
				if(!HCTimer.isLogin)
				{
					if(_hcLogin == null)
					{
						_hcLogin = new HCLogin();
						_main.addChild(_hcLogin);
						_hcLogin.btnClose.addEventListener(MouseEvent.CLICK, this.clickClose, false, 0, true);
					}
					_hcLogin.appear();
				}
				else
				{
					if(_info == null)
					{
						_info = new HCInfoContent(this);
						_main.addChild(_info);
						_info.btnClose.addEventListener(MouseEvent.MOUSE_DOWN, this.clickClose, false, 0, true);
						_info.btnLogout.addEventListener(MouseEvent.CLICK, this.clickLogout, false, 0, true);
					}
					_info.gotoAndPlay(2);
					_info.showInfo();
				}
			}
			else
			{

				_linkInfoTxt.text = "正在处理数据中……";
				if(!_linkInfoMovie.isPlaying)
				{
					_linkInfoMovie.gotoAndPlay(2);
				}
				
			}
			_clickHead = true;
		}
		private function clickLogout(event:Event):void
		{
			_clickHead = false;
			HCTimer.logout();
			_info.gotoAndPlay(59);
		}
		private function loginHandler(event:HCLinkEvent):void
		{
			_clickHead = false;
		}
		public function set isCanClickHead(value:Boolean):void
		{
			_clickHead = !value;
		}
		private function clickClose(event:Event):void
		{
			_clickHead = false;
			if(!HCTimer.isLogin)
			{
				if(_hcLogin != null)
				{
					_hcLogin.disappear();
				}
			}
			else
			{
				if(_info != null)
				{
					_info.closeInfo();
				}
			}
			_head.gotoAndPlay(EXIT_HEAD);
			
		}
	}

}