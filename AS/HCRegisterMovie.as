package AS {
	
	import flash.display.MovieClip;
	import flash.display.SimpleButton;
	import fl.controls.TextInput;
	import flash.events.MouseEvent;
	import flash.events.Event;
	import fl.controls.RadioButton;
	import flash.text.TextField;
	import flash.events.FocusEvent;
	import AS.HCTimer.HCTimer;
	import AS.HCTimer.HCLinkEvent;
	import fl.controls.Button;
	
	
	public class HCRegisterMovie extends MovieClip
	{
		var _close:SimpleButton = null;
		var _m:MovieClip = null;
		var _submit:Button = null;
		
		var _account:TextInput = null;
		var _password1:TextInput = null;
		var _password2:TextInput = null;
		var _name:TextInput = null;
		var _number:TextInput = null;
		var _sex:String = null;
		var _boy:RadioButton = null;
		var _girl:RadioButton = null;
		var _grade:TextInput = null;
		
		var _checkAccount:TextField = null;
		var _checkPassword1:TextField = null;
		var _checkPassword2:TextField = null;
		var _checkName:TextField = null;
		var _checkNumber:TextField = null;
		var _checkGrade:TextField = null;
		
		var _isAdd:Boolean = false;//是否增加了检查用户名的监听器
		var _isAddRegister:Boolean = false;
		var _accountCorrect:Boolean = false;
		var _passwordCorrect:Boolean = false;
		var _nameCorrect:Boolean = false;
		var _numberCorrect:Boolean = false;
		var _gradeCorrect:Boolean = false;
		var _isSuccess:Boolean = false;
		var _isCheckAccount:Boolean = false;
		const ERROR_COLOR:uint =   0xFF0000;
		const CORRECT_COLOR:uint = 0x006400;
		const NORMAL_COLOR:uint =  0x666666;
		
		
		public function HCRegisterMovie()
		{
			this.x = -21;
			this.y = -81;
			_m = this.member;
			_close = _m.close;
			_submit = _m.submit;
			
			_account = _m.txtAccount;
			_password1 = _m.txtPassword1;
			_password2 = _m.txtPassword2;
			_name = _m.txtName;
			_number = _m.txtNumber;
			_boy = _m.rbBoy;
			_girl = _m.rbGirl;
			_grade = _m.txtGrade;
			
			_checkAccount = _m.checkAccount;
			_checkPassword1 = _m.checkPassword1;
			_checkPassword2 = _m.checkPassword2;
			_checkName = _m.checkName;
			_checkNumber = _m.checkNumber;
			_checkGrade = _m.checkGrade;
			
			_account.addEventListener(FocusEvent.FOCUS_OUT, checkAccountHandler, false, 0, true);
			_account.addEventListener(FocusEvent.FOCUS_IN, focusInAccount, false, 0, true);
			_password1.addEventListener(Event.CHANGE, checkPassword1Handler, false, 0, true);
			_password2.addEventListener(Event.CHANGE, checkPassword2Handler, false, 0, true);
			_name.addEventListener(Event.CHANGE, checkNameHandler, false, 0, true);
			_number.addEventListener(Event.CHANGE, checkNumberHandler, false, 0, true);
			_grade.addEventListener(Event.CHANGE, checkGradeHandler, false, 0, true);
			
			_close.addEventListener(MouseEvent.MOUSE_UP, downClose, false, 0, true);
			_submit.addEventListener(MouseEvent.MOUSE_UP, downRegister, false, 0, true);
		}
		private function focusInAccount(event:Event):void
		{
			_checkAccount.text = "由6-16位英文字母及数字组成";
			_checkAccount.textColor = NORMAL_COLOR;
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
				_checkAccount.text = "至少6位英文字母及数字!";
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
		private function isFindHandler(event:HCLinkEvent):void
		{
			if(!event.isLink)
			{
				_checkAccount.text = "无法连接服务器……";
				_checkAccount.textColor = ERROR_COLOR;
				_accountCorrect = false;
			}
			else
			{
				if(event.isFind)
				{				
					_checkAccount.text = "此账号已存在";
					_checkAccount.textColor = ERROR_COLOR;
					_accountCorrect = false;
				}
				else
				{
					_checkAccount.text = "此账号可用";
					_checkAccount.textColor = CORRECT_COLOR;
					_accountCorrect = true;
				}
			}

		}
		private function checkPassword1Handler(event:Event):void
		{
			if(_password1.text == "")
			{
				_checkPassword1.text = "密码不允许为空!";
				_checkPassword1.textColor = ERROR_COLOR;
				_passwordCorrect = false;
			}
			else if(_password1.text.length < 6)
			{
				_checkPassword1.text = "密码至少6位英文字母及数字!";
				_checkPassword1.textColor = ERROR_COLOR;
				_passwordCorrect = false;
			}
			else
			{
				_checkPassword1.text = "合法!";
				_checkPassword1.textColor = CORRECT_COLOR;
			}
			if(_password2.text == "")
			{
				return;
			}
			if(_password1.text != _password2.text)
			{
				_checkPassword1.text = "两次输入密码不相同!";
				_checkPassword1.textColor = ERROR_COLOR;
				_passwordCorrect = false;
			}
			else
			{
				_checkPassword1.text = "合法!";
				_checkPassword1.textColor = CORRECT_COLOR;
				_checkPassword2.text = "两次输入密码相同!";
				_checkPassword2.textColor = CORRECT_COLOR;
				_passwordCorrect = true;
			}
		}
		private function checkPassword2Handler(event:Event):void
		{
			if(_password2.text == "")
			{
				_checkPassword2.text = "密码不允许为空!";
				_checkPassword2.textColor = ERROR_COLOR;
				_passwordCorrect = false;
			}
			else
			{
				if(_password2.text == "")
				{
					_checkPassword2.text = "请再次输入密码!";
					_checkPassword2.textColor = ERROR_COLOR;
					_passwordCorrect = false;
				}
				else if(_password2.text.length < 6)
				{
					_checkPassword2.text = "密码至少6位英文字母及数字!";
					_checkPassword2.textColor = ERROR_COLOR;
					_passwordCorrect = false;
				}
				else if(_password1.text != _password2.text)
				{
					_checkPassword2.text = "两次输入密码不相同!";
					_checkPassword2.textColor = ERROR_COLOR;
					_passwordCorrect = false;
				}
				else
				{
					_checkPassword1.text = "合法!";
					_checkPassword1.textColor = CORRECT_COLOR;
					_checkPassword2.text = "两次输入密码相同!";
					_checkPassword2.textColor = CORRECT_COLOR;
					_passwordCorrect = true;
				}
			}
		}
		
		private function checkGradeHandler(event:Event):void
		{
			if(_grade.text == "")
			{
				_checkGrade.text = "年级不允许为空！";
				_checkGrade.textColor = ERROR_COLOR;
				_gradeCorrect = false;
			}
			else
			{
				_checkGrade.text = "合法!";
				_checkGrade.textColor = CORRECT_COLOR;
				_gradeCorrect = true;
			}
		}
		private function checkNumberHandler(event:Event):void
		{
			if(_number.text == "")
			{
				_checkNumber.text = "学号不允许为空!";
				_checkNumber.textColor = ERROR_COLOR;
				_numberCorrect = false;
			}
			else
			{
				_checkNumber.text = "合法!";
				_checkNumber.textColor = CORRECT_COLOR;
				_numberCorrect = true;
			}
		}
		private function checkNameHandler(event:Event):void
		{
			if(_name.text == "")
			{
				_checkName.text ="姓名不允许为空!";
				_checkName.textColor = ERROR_COLOR;
				_nameCorrect = false;
			}
			else
			{
				_checkName.text ="合法!";
				_checkName.textColor = CORRECT_COLOR;
				_nameCorrect = true;
			}
		}
		private function downRegister(event:MouseEvent):void
		{
			_submit.getFocus();
			if(_account.text == "")
			{
				_checkAccount.text = "账号名不允许为空!";
				_checkAccount.textColor = ERROR_COLOR;
				_accountCorrect = false;
				gotoAndPlay(16);
				return;
			}
			else if(_account.text.length < 6)
			{
				_checkAccount.text = "至少6位英文字母及数字!";
				_checkAccount.textColor = ERROR_COLOR;
				_accountCorrect = false;
				gotoAndPlay(16);
				return;
			}
			if(!_isCheckAccount)
			{
				if(!_isAdd)
				{
					HCTimer.hcLink.addListener(HCLinkEvent.CHECK_ACCOUNT, isFindHandler);
					_isAdd = true;
				}
				_checkAccount.text = "正在检测账号是否可用……";
				_checkAccount.textColor = NORMAL_COLOR;
				HCTimer.hcLink.checkAccount(_account.text);
			}
			if(_password1.text == "")
			{
				_checkPassword1.text = "密码不允许为空!";
				_checkPassword1.textColor = ERROR_COLOR;
				_passwordCorrect = false;
				gotoAndPlay(16);
				return;
			}
			else if(_password1.text.length < 6)
			{
				_checkPassword1.text = "密码至少6位英文字母及数字!";
				_checkPassword1.textColor = ERROR_COLOR;
				_passwordCorrect = false;
				gotoAndPlay(16);
				return;
			}
			else
			{
				if(_password2.text == "")
				{
					_checkPassword2.text = "请再次输入密码!";
					_checkPassword2.textColor = ERROR_COLOR;
					_passwordCorrect = false;
					gotoAndPlay(16);
					return;
				}
				else if(_password2.text.length < 6)
				{
					_checkPassword2.text = "密码至少6位英文字母及数字!";
					_checkPassword2.textColor = ERROR_COLOR;
					_passwordCorrect = false;
				}
				else if(_password1.text != _password2.text)
				{
					_checkPassword2.text = "两次输入密码不相同!";
					_checkPassword2.textColor = ERROR_COLOR;
					_passwordCorrect = false;
					gotoAndPlay(16);
					return;
				}
				else
				{
					_checkPassword2.text = "两次输入密码相同!";
					_checkPassword2.textColor = CORRECT_COLOR;
					_passwordCorrect = true;
				}
			}
			if(_name.text == "")
			{
				_checkName.text ="姓名不允许为空!";
				_checkName.textColor = ERROR_COLOR;
				_nameCorrect = false;
				gotoAndPlay(16);
				return;
			}
			else
			{
				_checkName.text ="合法!";
				_checkName.textColor = CORRECT_COLOR;
				_nameCorrect = true;
			}
			if(_grade.text == "")
			{
				_checkGrade.text = "年级不允许为空！";
				_checkGrade.textColor = ERROR_COLOR;
				_gradeCorrect = false;
				gotoAndPlay(16);
				return;
			}
			else
			{
				_checkGrade.text = "合法!";
				_checkGrade.textColor = CORRECT_COLOR;
				_gradeCorrect = true;
			}
			if(_number.text == "")
			{
				_checkNumber.text = "学号不允许为空!";
				_checkNumber.textColor = ERROR_COLOR;
				_numberCorrect = false;
				gotoAndPlay(16);
				return;
			}
			else
			{
				_checkNumber.text = "合法!";
				_checkNumber.textColor = CORRECT_COLOR;
				_numberCorrect = true;
			}
			
			
			if(_accountCorrect && _passwordCorrect&& _nameCorrect && _numberCorrect && _gradeCorrect)
			{
				if(!_isAddRegister)
				{	
					HCTimer.hcLink.addListener(HCLinkEvent.ADD_USER, isRegisterSuccess);
					_isAddRegister = true;
				}
				var sex:String = "";
				if(_boy.selected)
				{
					sex = "男";
				}
				else
				{
					sex = "女";
				}	
				HCTimer.hcLink.addUser(_account.text, _password1.text, _name.text, _number.text, sex, _grade.text);
			}
			else
			{
				gotoAndPlay(16);
			}
		}
		private function isRegisterSuccess(event:HCLinkEvent):void
		{
			if(event.isSuccess)
			{
				gotoAndPlay(63);
				setNormal();
			}
			else
			{
				gotoAndPlay(16);
			}
		}
		public function setNormal():void
		{
			_account.text = "";
			_password1.text = "";
			_password2.text = "";
			_name.text = "";
			_number.text = "";
			_grade.text = "";
			_checkAccount.text = "由6-16位英文字母及数字组成";
			_checkAccount.textColor = NORMAL_COLOR;
			_checkPassword1.text = "由6-20位英文字母及数字组成";
			_checkPassword1.textColor = NORMAL_COLOR;
			_checkPassword2.text = "再次确认密码";
			_checkPassword2.textColor = NORMAL_COLOR;
			_checkName.text = "由最多10个汉字组成";
			_checkName.textColor = NORMAL_COLOR;
			_checkNumber.text = "由最多16位数字及英文组成";
			_checkNumber.textColor = NORMAL_COLOR;
			_checkGrade.text = "输入年份，如：2010";
			_checkGrade.textColor = NORMAL_COLOR;
			_boy.selected =  true;
		}
		private function downClose(event:Event):void
		{
			//setNormal();
			gotoAndPlay(116);
		}
	}
	
}
