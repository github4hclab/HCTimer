package AS
{

	import flash.display.MovieClip;
	import flash.display.DisplayObject;
	import fl.controls.TextInput;
	import fl.controls.CheckBox;
	import flash.display.SimpleButton;
	import flash.events.MouseEvent;
	import flash.events.Event;
	import fl.controls.Button;
	import flash.events.FocusEvent;
	import AS.HCTimer.HCTimer;
	import AS.HCTimer.HCLinkEvent;
	import AS.HCTimer.HCUserInfo;
	import AS.HCModifyPassword;
	import AS.HCRegisterMovie;
	import flash.text.TextField;
	import fl.events.ComponentEvent;

	public class HCLogin extends MovieClip
	{
		private var _account:TextInput = null;
		private var _password:TextInput = null;
		private var _remember:CheckBox = null;
		private var _autoLogin:CheckBox = null;
		private var _register:Button = null;
		private var _login:Button = null;
		private var _close:MovieClip = null;
		private var _m:MovieClip = null;
		private var _registerMovie:HCRegisterMovie = null;
		private var _inputPassword:MovieClip = null;
		private var _inputAccount:MovieClip = null;
		private var _noAccount:MovieClip = null;
		private var _txtPassword:TextField = null;
		private var _noAccountTxt:TextField = null;
		private var _modifyPasswordBtn:Button = null;
		private var _modifyPasswordMovie:MovieClip = null;

		public function HCLogin()
		{
			this.x = 0;
			this.y = 0;
			_m = this.member;
			

			_modifyPasswordBtn = _m.modifyPasswordBtn;
			_account = _m.account;
			_password = _m.password;
			_remember = _m.remember;
			_autoLogin = _m.autoLogin;
			_register = _m.register;
			_login = _m.login;
			_close = _m.close;
			
			_noAccount = new HCNoAccount();
			_noAccount.x = 105;
			_noAccount.y = 85;
			_noAccountTxt = _noAccount.txt;
			_m.addChild(_noAccount);
			
			_inputAccount = new HCInputAccount();
			_inputAccount.x = 105;
			_inputAccount.y = 85;
			_m.addChild(_inputAccount);
			_inputAccount.visible = false;
			
			_inputPassword = new HCInputPassword();
			_inputPassword.x = 105;
			_inputPassword.y = 125;
			_txtPassword = _inputPassword.txt;
			_m.addChild(_inputPassword);
			_inputPassword.visible = false;
	

		
			//_close.addEventListener(MouseEvent.MOUSE_DOWN, this.downClose);
			_close.area.addEventListener(MouseEvent.ROLL_OVER, this.rollOverClose, false, 0, true);
			_close.area.addEventListener(MouseEvent.ROLL_OUT, this.rollOutClose, false, 0, true);
			_register.addEventListener(MouseEvent.CLICK, this.clickRegister, false, 0, true);
			_login.addEventListener(MouseEvent.CLICK, this.clickLogin, false, 0, true);
			_account.addEventListener(MouseEvent.CLICK, this.focusInAccount, false, 0, true);
			_password.addEventListener(MouseEvent.CLICK, this.focusInPassword, false, 0, true);
			_autoLogin.addEventListener(MouseEvent.CLICK, this.downLogin, false, 0, true);
			_remember.addEventListener(MouseEvent.CLICK, this.downRemember, false, 0, true);
			_modifyPasswordBtn.addEventListener(MouseEvent.CLICK, this.clickModifyPassword, false, 0, true);
			HCTimer.hcLink.addListener(HCLinkEvent.USER_LOGIN, loadUserHandler);
			
			_remember.selected = HCTimer.remember;
			_autoLogin.selected = HCTimer.autoLogin;
			if(_remember.selected)
			{
				_account.text = HCTimer.account;
				_password.text = HCTimer.password;
			}
			if(HCTimer.autoLogin)
			{
				_remember.selected = true;
			}
		
			//_register.addEventListener(MouseEvent.ROLL_OVER, this.overRegister, false, 0, true);
			//_register.addEventListener(MouseEvent.ROLL_OVER, this.outRegister, false, 0, true);
		}
		private function clickModifyPassword(event:Event):void
		{
			if(_modifyPasswordMovie == null)
			{
				_modifyPasswordMovie = new HCModifyPassword;
				_m.addChild(_modifyPasswordMovie);
				
			}
			_modifyPasswordMovie.gotoAndPlay(2);
		}
		private function downLogin(event:Event):void
		{
			if(_autoLogin.selected)
			{
				_remember.selected = true;
				HCTimer.rememberUser(_account.text, _password.text, true, true);
			}
			else
			{
				HCTimer.autoLogin = false;
			}
			
		}
		private function downRemember(event:Event):void
		{
			if(_autoLogin.selected)
			{
				_remember.selected = true;
				
			}
			if(_remember.selected)
			{
				HCTimer.rememberUser(_account.text, _password.text, true, _autoLogin.selected);
			}
			else
			{
				HCTimer.remember = false;
			}
			
		}
		public function appear():void
		{
			gotoAndPlay(2);
			_remember.selected = HCTimer.remember;
			_autoLogin.selected = HCTimer.autoLogin;
			
			if(_remember.selected)
			{
				_account.text = HCTimer.account;
				_password.text = HCTimer.password;
			}
			else
			{
				_account.text = "";
				_password.text = "";
			}
			this._noAccount.visible = false;
			this._noAccount.visible = false;
		}
		public function disappear():void
		{
			gotoAndPlay(39);
			this._noAccount.visible = false;
			this._noAccount.visible = false;
			if(_remember.selected)
			{
				HCTimer.rememberUser(_account.text, _password.text, true, _autoLogin.selected);
			}
		}
		
		private function rollOverClose(event:Event):void
		{
			_close.gotoAndPlay(2);
		}
		
		private function rollOutClose(event:Event):void
		{
			_close.gotoAndPlay(16 - _close.currentFrame);
		}
		private function loginSuccess():void
		{
			HCTimer.hcUser.password = _password.text;
			if(_remember.selected || _autoLogin.selected)
			{
				HCTimer.rememberUser(_account.text, _password.text, _remember.selected, _autoLogin.selected);
			}
			
			
			gotoAndPlay(16);
		}
		private function cannotLink():void
		{
			_noAccountTxt.text = "抱歉，无法连接网络，请联系管理员";
			_noAccount.visible = true;
		}
		private function noThisAccount():void
		{
			_noAccountTxt.text = "抱歉，您输入的账号不存在，请重新输入";
			_noAccount.visible = true;
		}
		private function notThisPassword():void
		{
			_txtPassword.text = "密码不正确";
			_inputPassword.visible = true;
		}

		private function loadUserHandler(event:HCLinkEvent):void
		{
			if(event.isLink == false)
			{
				cannotLink();
				return;
			}
			if(event.isFind == false)
			{
				noThisAccount();
				return;
			}
			
			if(!_remember.selected)
			{
				_password.text = "";
			}
			
			if(event.isPass)
			{
				loginSuccess();
			}
			else
			{
				notThisPassword();
				
			}
			
			
		}
		private function focusInAccount(event:Event):void
		{
			_inputAccount.visible = false;
			_inputPassword.visible =false;
			_noAccount.visible = false;
			
		}
		private function focusInPassword(event:Event):void
		{
			_inputAccount.visible = false;
			_inputPassword.visible =false;
			_noAccount.visible = false;
		}

		public function get btnClose():MovieClip
		{
			return _close.area;
		}
		private function clickRegister(event:Event):void
		{
			if(_registerMovie == null)
			{
				_registerMovie = new HCRegisterMovie;
				_m.addChild(_registerMovie);
				//_m.addChild(_registerMovie);
			}
			_registerMovie.setNormal();
			_registerMovie.gotoAndPlay(2);
		}
		private function clickLogin(event:Event):void
		{
			_login.getFocus();
			if(_account.text == "")
			{
				_inputAccount.visible = true;
				return;
			}
			if(_account.text.length < 6)
			{
				_noAccountTxt.text = "抱歉，账号长度太短，至少6个英文或数字组成";
				_inputAccount.visible = true;
				return;
			}
			
			if(_password.text == "")
			{
				_txtPassword.text = "请输入密码后登录";
				_inputPassword.visible = true;
				return;
			}
			
			if(_password.text.length < 6)
			{
				_txtPassword.text = "密码至少6个字符";
				_inputPassword.visible = true;
				return;
			}
			_noAccount.visible = false;
			
			HCTimer.hcUser.account = _account.text;
			HCTimer.hcUser.password = _password.text;
			HCTimer.hcLink.userLogin();

		}
	}

}