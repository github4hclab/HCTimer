package AS
{

	import flash.display.MovieClip;
	import AS.HCTimer.HCTimer;
	import AS.HCTimer.HCUserInfo;
	import AS.HCTimer.HCLink;
	import AS.HCHead;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.display.SimpleButton;
	import fl.controls.TextInput;
	import fl.controls.RadioButton;
	import fl.controls.TextArea;
	import flash.text.TextField;
	import flash.events.TextEvent;
	import flash.events.KeyboardEvent;
	import flash.events.FocusEvent;
	import fl.controls.Button;
	import AS.HCTimer.HCLinkEvent;


	public class HCInfoContent extends MovieClip
	{

		private var _submit:Button = null;
		private var _close:MovieClip = null;
		private var _logout:Button = null;

		private var _nameText:TextInput = null;//姓名
		private var _numberText:TextInput = null;//学号
		private var _boy:RadioButton = null;//男
		private var _girl:RadioButton = null;//女
		private var _qqText:TextInput = null;//_qqText号码
		private var _longNumText:TextInput = null;//长号
		private var _shortNumText:TextInput = null;//短号
		private var _gradeText:TextInput = null;//年级
		private var _majorText:TextInput = null;//专业
		private var _studyText:TextArea = null;//研究方向
		private var _checkName:TextField = null;
		private var _checkNumber:TextField = null;
		private var _checkGrade:TextField = null;
		private var _checkQQ:TextField = null;
		private var _checkLongNum:TextField = null;
		private var _checkShortNum:TextField = null;
		private var _cntMajor:TextField = null;
		private var _cntStudy:TextField = null;
		private var _prompt:TextField = null;
		private var _isGetInfo:Boolean = false;
		
		private var _majorCnt:int = 0;
		private var _studyCnt:int = 0;
		private var _head:HCHead = null;


		public function HCInfoContent(head:HCHead)
		{
			_head = head;
			this.x = 120;
			this.y = 50;
			var m:MovieClip = this.member;
			//m.close.addEventListener(MouseEvent.CLICK, clickClose);
			_submit = m.submit;
			_logout = m.logout;
			_prompt = m.txtPrompt;
			_close = m.close;
			_nameText = m.txtName;//姓名
			_numberText = m.txtNumber;//学号
			_boy = m.rbBoy;//男
			_girl = m.rbGirl;//女
			_qqText = m.txtQQ;//_qqText号码
			_longNumText = m.txtLongNum;//长号
			_shortNumText = m.txtShortNum;//短号
			_gradeText = m.txtGrade;//年级
			_majorText = m.txtMajor;//专业
			_studyText = m.txtStudy;//研究方向
			_checkName = m.checkName;
			_checkNumber = m.checkNumber;
			_checkGrade = m.checkGrade;
			_checkQQ = m.checkQQ;
			_checkLongNum = m.checkLongNum;
			_checkShortNum = m.checkShortNum;
			_cntMajor = m.cntMajor;
			_cntStudy = m.cntStudy;
			
			_nameText.addEventListener(FocusEvent.MOUSE_FOCUS_CHANGE, nameFocusChange, false, 0, true);
			_numberText.addEventListener(FocusEvent.MOUSE_FOCUS_CHANGE, numberFocusChange, false, 0, true);
			_gradeText.addEventListener(FocusEvent.MOUSE_FOCUS_CHANGE, gradeFocusChange, false, 0, true);
			_majorText.addEventListener(Event.CHANGE, checkMojorCnt, false, 0, true);
			_studyText.addEventListener(Event.CHANGE, checkStudyCnt, false, 0, true);
			_submit.addEventListener(MouseEvent.MOUSE_DOWN, clickSubmit, false, 0, true);
			_close.addEventListener(MouseEvent.ROLL_OVER, rollOverClose, false, 0, true);
			_close.addEventListener(MouseEvent.ROLL_OUT, rollOutClose, false, 0, true);
			HCTimer.hcLink.addListener(HCLinkEvent.UPDATE_USER, updateHandler);
		}
		public function get btnLogout():Button
		{
			return _logout;
		}
		private function rollOverClose(event:Event):void
		{
			_close.gotoAndPlay(2);
		}
		private function rollOutClose(event:Event):void
		{
			_close.gotoAndPlay(16 - _close.currentFrame);
		}
		private function nameFocusChange(event:Event):void
		{
			if(_nameText.text == "")
			{
				_checkName.text = "姓名不允许为空!";
				_checkName.textColor = 0xFF0000;
			}
			else
			{
				_checkName.text = "合法!";
				_checkName.textColor = 0x666666;
			}
		}
		private function numberFocusChange(event:Event):void
		{
			if(_numberText.text == "")
			{
				_checkNumber.text = "学号不允许为空!";
				_checkNumber.textColor = 0xFF0000;			
			}
			else
			{
				_checkNumber.text = "合法!";
				_checkNumber.textColor = 0x666666;
			}
		}
		private function gradeFocusChange(event:Event):void
		{
			if(_gradeText.text == "")
			{
				_checkGrade.text = "年级不允许为空!"
				_checkGrade.textColor = 0xFF0000;			
			}
			else
			{
				_checkGrade.text = "合法!";
				_checkGrade.textColor = 0x666666;
			}
		}
		private function checkMojorCnt(event:Event):void
		{
			_cntMajor.text = _majorText.text.length.toString();
		}
		private function checkStudyCnt(event:Event):void
		{
			_cntStudy.text = _studyText.text.length.toString();
		}
		
		public function get btnClose():MovieClip
		{
			return _close;
		}
		public function showInfo():void
		{
			if(!_isGetInfo)
			{
				HCTimer.hcLink.addListener(HCLinkEvent.USER_INFO, showInfoHandler);
				_isGetInfo = true;
			}
			HCTimer.hcLink.getUserInfo();
		}
		private function setNormal():void
		{
			var user:HCUserInfo = HCTimer.hcUser;
			user.name = "";
			user.number = "";
			user.qq = "";
			user.longNum = "";
			user.shortNum = "";
			user.grade = "";
			user.major = "";
			user.study = "";
			
			_nameText.text = user.name;//姓名
			_numberText.text = user.number;//学号
			_qqText.text = user.qq;//号码
			_longNumText.text = user.longNum;//长号
			_shortNumText.text = user.shortNum;//短号
			_gradeText.text = user.grade;//年级
			_majorText.text = user.major;//专业
			_studyText.text = user.study;//研究方向
			_cntMajor.text = _majorText.text.length.toString();
			_cntStudy.text = _studyText.text.length.toString();
		}
		public function closeInfo():void
		{
			_head.isCanClickHead = true;
			gotoAndPlay(59);
		}
		private function showInfoHandler(event:HCLinkEvent):void
		{
			if(!event.isLink)
			{
				_prompt.text = "抱歉，无法连接，请连接管理员";
				_prompt.textColor = 0xFF0000;
				HCTimer.showLinkState();
				closeInfo();
				setNormal();
				return;
			}
			if(!event.isFind)
			{
				_prompt.text = "抱歉，无法找到您的信息";
				_prompt.textColor = 0xFF0000;
				setNormal();
				return;
			}
			var user:HCUserInfo = HCTimer.hcUser;
			_prompt.text = "欢迎您在环创学习：" + user.account;
			_prompt.textColor = 0x000000;
			var xml:XMLList = event.xml.child("userData");
			
			user.number = xml.attribute(HCUserInfo.NUMBER).toString();
			user.sex = xml.attribute(HCUserInfo.SEX).toString();
			user.qq = xml.attribute(HCUserInfo.QQ).toString();
			user.longNum = xml.attribute(HCUserInfo.LONG_NUM).toString();
			
			user.shortNum = xml.attribute(HCUserInfo.SHORT_NUM).toString();
			if(user.shortNum == "0")
			{
				user.shortNum = "";
			}
			user.grade = xml.attribute(HCUserInfo.GRADE).toString();
			user.major = xml.attribute(HCUserInfo.MAJOR).toString();
			user.study = xml.attribute(HCUserInfo.STUDY).toString();
			
			_nameText.text = user.name;//姓名
			_numberText.text = user.number;//学号
			if (user.sex == "女")
			{
				_girl.selected = true;
			}
			else
			{
				_boy.selected = true;
			}
			_qqText.text = user.qq;//号码
			_longNumText.text = user.longNum;//长号
			_shortNumText.text = user.shortNum;//短号
			_gradeText.text = user.grade;//年级
			_majorText.text = user.major;//专业
			_studyText.text = user.study;//研究方向
			//_majorCnt = _majorText.text.length;
			//_cntStudy = _studyText.text.length;
			_cntMajor.text = _majorText.text.length.toString();
			_cntStudy.text = _studyText.text.length.toString();
		}
		
		private function checkFormat():Boolean
		{
			if(_nameText.text == "")
			{
				_checkName.text = "姓名不允许为空!";
				_checkName.textColor = 0xFF0000;
				return false;
			}
			else
			{
				_checkName.text = "合法!";
				_checkName.textColor = 0x666666;
			}
			
			if(_numberText.text == "")
			{
				_checkNumber.text = "学号不允许为空!";
				_checkNumber.textColor = 0xFF0000;
				return false;
			}
			else
			{
				_checkNumber.text = "合法!";
				_checkNumber.textColor = 0x666666;
			}
			
			if(_gradeText.text == "")
			{
				_checkGrade.text = "年级不允许为空!"
				_checkGrade.textColor = 0xFF0000;
				return false;
			}
			else
			{
				_checkGrade.text = "合法!";
				_checkGrade.textColor = 0x666666;
			}
			return true;
		}

		private function clickSubmit(event:Event):void
		{
			if(!checkFormat())
			{
				return;
			}
			var user:HCUserInfo = HCTimer.hcUser;
			user.name = _nameText.text;
			user.number = _numberText.text;
			user.qq = _qqText.text;//_qqText号码
			user.longNum = _longNumText.text;//长号
			user.shortNum = _shortNumText.text;//短号
			user.grade = _gradeText.text;//年级
			user.major = _majorText.text;//专业
			user.study = _studyText.text;//研究方向
			if(_boy.selected)
			{
				user.sex = "男";
			}
			else
			{
				user.sex = "女";
			}
			HCTimer.hcLink.updateUser();
		}
		private function updateHandler(event:HCLinkEvent):void
		{
			if(event.isSuccess)
			{
				gotoAndPlay(36);
			}
			else
			{
				gotoAndPlay(16);
			}
		}
	}

}