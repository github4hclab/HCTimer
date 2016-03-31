package AS
{
	
	import flash.display.MovieClip;
	import flash.text.TextField;
	import flash.events.MouseEvent;
	import flash.events.FocusEvent;
	import flash.events.Event;
	import AS.HCTimer.HCTimer;
	import AS.HCTimer.HCLink;
	import AS.HCTimer.HCLinkEvent;
	import AS.HCTimer.HCUserInfo;
	import fl.controls.TextInput;
	import fl.controls.Button;
	
	
	public class HCModifyPassword extends MovieClip
	{
		
		private var _m:MovieClip = null;
		private var _account:TextInput = null;
		private var _passwordOld:TextInput = null;
		private var _passwordNew1:TextInput = null;
		private var _passwordNew2:TextInput = null;
		private var _checkAccount:TextField = null;
		private var _checkPasswordOld:TextField = null;
		private var _checkPasswordNew1:TextField = null;
		private var _checkPasswordNew2:TextField = null;
		private var _closeBtn:MovieClip = null;
		private var _submitBtn:Button = null;
		private var _isAdd:Boolean = false;
		private var _isAddUpdateEvent:Boolean = false;
		private var _accountCorrect:Boolean = false;
		private var _passwordCorrect:Boolean = false;
		private var _isCheckAccount:Boolean = false;
		private var _correctPassword:String = null;
		private var _correctId:String = null;
		const ERROR_COLOR:uint =   0xFF0000;
		const CORRECT_COLOR:uint = 0x006400;
		const NORMAL_COLOR:uint =  0x666666;
		public function HCModifyPassword() 
		{
			_m = this.member;
			
			_closeBtn = _m.closeBtn;
			_submitBtn = _m.submitBtn;
			_account = _m.account;
			_passwordOld = _m.passwordOld;
			_passwordNew1 = _m.passwordNew1;
			_passwordNew2 = _m.passwordNew2;
			
			_checkAccount = _m.checkAccount;
			_checkPasswordOld = _m.checkPasswordOld;
			_checkPasswordNew1 = _m.checkPasswordNew1;
			_checkPasswordNew2 = _m.checkPasswordNew2;
			
			_account.addEventListener(FocusEvent.FOCUS_OUT, checkAccountHandler, false, 0, true);
			_account.addEventListener(FocusEvent.FOCUS_IN, focusInAccount, false, 0, true);
			_passwordOld.addEventListener(Event.CHANGE, checkPasswordOldHandler, false, 0, true);
			
			_passwordNew1.addEventListener(Event.CHANGE, checkPasswordNew1Handler, false, 0, true);
			_passwordNew2.addEventListener(Event.CHANGE, checkPasswordNew2Handler, false, 0, true);
			_closeBtn.area.addEventListener(MouseEvent.MOUSE_UP, this.clickCloseBtn, false, 0, true);
			_closeBtn.area.addEventListener(MouseEvent.ROLL_OVER, this.rollOverClose, false, 0, true);
			_closeBtn.area.addEventListener(MouseEvent.ROLL_OUT, this.rollOutClose, false, 0, true);
			_submitBtn.addEventListener(MouseEvent.CLICK, this.ClickSubmitBtn);
		}
		private function clickCloseBtn(event:Event):void
		{
			setDefault();
			gotoAndPlay(65);
		}
		private function setDefault():void
		{
			_account.text = "";
			_passwordOld.text = "";
			_passwordNew1.text = "";
			_passwordNew2.text = "";
			
			_checkAccount.text = "6-16位英文字母或数字";
			_checkAccount.textColor = NORMAL_COLOR;
			_checkPasswordOld.text = "原来的密码";
			_checkPasswordOld.textColor = NORMAL_COLOR;
			_checkPasswordNew1.text = "6-16位英文字母或数字";
			_checkPasswordNew1.textColor = NORMAL_COLOR;
			_checkPasswordNew2.text = "再次输入新密码";
			_checkPasswordNew2.textColor = NORMAL_COLOR;
		}
		private function rollOverClose(event:Event):void
		{
			_closeBtn.gotoAndPlay(2);
		}
		private function rollOutClose(event:Event):void
		{
			_closeBtn.gotoAndPlay(16 - _closeBtn.currentFrame);
		}
		private function checkAccountHandler(event:Event):void
		{
			if(_account.text == "")
			{
				_checkAccount.text = "账号名不允许为空!";
				_checkAccount.textColor = ERROR_COLOR;
				_accountCorrect = false;
			}
			else if(_account.text.length < 6)
			{
				_checkAccount.text = "至少6位英文字母及数字";
				_checkAccount.textColor = ERROR_COLOR;
				_accountCorrect = false;
			}
			else
			{
				if(!_isAdd)
				{
					HCTimer.hcLink.addListener(HCLinkEvent.CHECK_ACCOUNT, isFindHandler);
					
					_isAdd = true;
				}
				_isCheckAccount = true;
				_checkAccount.text = "正在检测账号是否可用……";
				_checkAccount.textColor = NORMAL_COLOR;
				HCTimer.hcLink.checkAccount(_account.text);
			}
		}
		private function focusInAccount(event:Event):void
		{
			_checkAccount.text = "6-16位英文字母及数字";
			_checkAccount.textColor = NORMAL_COLOR;
		}
		private function checkPasswordOldHandler(event:Event):void
		{
			if(_passwordOld.text == _correctPassword)
			{
				_checkPasswordOld.text = "密码正确";
				_checkPasswordOld.textColor = CORRECT_COLOR;
			}
			else
			{
				_checkPasswordOld.text = "密码错误";
				_checkPasswordOld.textColor = ERROR_COLOR;
			}
		}
		private function checkPasswordNew1Handler(event:Event):void
		{
			if(_passwordNew1.text == "")
			{
				_checkPasswordNew1.text = "密码不允许为空!";
				_checkPasswordNew1.textColor = ERROR_COLOR;
				_passwordCorrect = false;
				return;
			}
			else if(_passwordNew1.text.length < 6)
			{
				_checkPasswordNew1.text = "至少6位英文字母及数字";
				_checkPasswordNew1.textColor = ERROR_COLOR;
				_passwordCorrect = false;
				return;
			}
			else
			{
				_checkPasswordNew1.text = "合法!";
				_checkPasswordNew1.textColor = CORRECT_COLOR;
			}
			if(_passwordNew1.text != _passwordNew2.text)
			{
				_checkPasswordNew2.text = "两次输入密码不相同!";
				_checkPasswordNew2.textColor = ERROR_COLOR;
				_passwordCorrect = false;
			}
			else
			{
				_checkPasswordNew2.text = "两次输入密码相同!";
				_checkPasswordNew2.textColor = CORRECT_COLOR;
				_passwordCorrect = true;
			}
		}
		private function checkPasswordNew2Handler(event:Event):void
		{
			if(_passwordNew2.text == "")
			{
				_checkPasswordNew2.text = "密码不允许为空!";
				_checkPasswordNew2.textColor = ERROR_COLOR;
				_passwordCorrect = false;
			}
			else
			{
				if(_passwordNew2.text == "")
				{
					_checkPasswordNew2.text = "请再次输入密码!";
					_checkPasswordNew2.textColor = ERROR_COLOR;
					_passwordCorrect = false;
				}
				else if(_passwordNew2.text.length < 6)
				{
					_checkPasswordNew2.text = "密码至少6位英文字母及数字!";
					_checkPasswordNew2.textColor = ERROR_COLOR;
					_passwordCorrect = false;
				}
				else if(_passwordNew1.text != _passwordNew2.text)
				{
					_checkPasswordNew2.text = "两次输入密码不相同!";
					_checkPasswordNew2.textColor = ERROR_COLOR;
					_passwordCorrect = false;
				}
				else
				{
					_checkPasswordNew2.text = "两次输入密码相同!";
					_checkPasswordNew2.textColor = CORRECT_COLOR;
					_passwordCorrect = true;
				}
			}
		}
		private function ClickSubmitBtn(event:Event):void
		{
			if(_accountCorrect && _passwordCorrect)
			{
				if(!_isAddUpdateEvent)
				{
					HCTimer.hcLink.addListener(HCLinkEvent.UPDATE_PASSWORD, this.handleUpdate);
					_isAddUpdateEvent = true;
				}
				HCTimer.hcLink.updateUserPassword(_correctId, _account.text, _passwordNew1.text);
			}
			else
			{
				gotoAndPlay(16);
			}
		}
		private function handleUpdate(event:HCLinkEvent):void
		{
			if(event.isSuccess)
			{
				gotoAndPlay(40);
			}
			else
			{
				gotoAndPlay(16);
			}
		}
		private function isFindHandler(event:HCLinkEvent):void
		{
			if(event.isFind)
			{				
				_checkAccount.text = "账号合法";
				_checkAccount.textColor = CORRECT_COLOR;
				_accountCorrect = true;
				_correctPassword = event.findData(HCUserInfo.PASSWORD);
				_correctId = event.findData(HCUserInfo.ID);
				if(_passwordOld.text == _correctPassword)
				{
					_checkPasswordOld.text = "密码正确";
					_checkPasswordOld.textColor = CORRECT_COLOR;
				}
				else
				{
					_checkPasswordOld.text = "密码错误";
					_checkPasswordOld.textColor = ERROR_COLOR;
				}
			}
			else
			{
				if(event.isLink)
				{
					_checkAccount.text = "此账号不存在";
					_checkAccount.textColor = ERROR_COLOR;
					_accountCorrect = false;
					_correctPassword = null;
					_correctId = null;
				}
				else
				{
					_checkAccount.text = "无法连接服务器";
					_checkAccount.textColor = ERROR_COLOR;
					_accountCorrect = false;
					_correctPassword = null;
					_correctId = null;
				}

				
			}
		}
	}
	
}
