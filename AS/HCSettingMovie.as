package AS
{

	import flash.display.MovieClip;
	import fl.controls.CheckBox;
	import fl.controls.NumericStepper;
	import fl.controls.Button;
	import flash.events.MouseEvent;
	import flash.events.Event;
	import AS.HCTimer.HCTimer;


	public class HCSettingMovie extends MovieClip
	{
		var _m:MovieClip = null;
		var _startLogin:CheckBox = null;
		var _autoLogin:CheckBox = null;
		var _minToTray:CheckBox = null;
		var _updateTime:NumericStepper = null;
		var _submit:Button = null;
		var _close:MovieClip = null;
		var _isAddHandler:Boolean = false;
		
		public function HCSettingMovie()
		{
			this.x  = 176.25;
			this.y = 100;
			_m = this.member;
			_startLogin = _m.startLogin;
			_autoLogin = _m.autoLogin;
			_minToTray = _m.minToTray;
			_updateTime = _m.updateTime;
			_submit = _m.submit;
			_close = _m.close;
			
			_startLogin.selected = HCTimer.startLogin;
			_autoLogin.selected = HCTimer.autoLogin;
			_minToTray.selected = HCTimer.minToTray;
			_updateTime.value = Number(HCTimer.updateTime);
			
			_submit.addEventListener(MouseEvent.CLICK, clickSubmit, false, 0, true);
			
			var area:MovieClip = _close.area;
			area.addEventListener(MouseEvent.ROLL_OVER, closeRollOver, false, 0, true);
			area.addEventListener(MouseEvent.ROLL_OUT, closeRollOut, false, 0, true);
			area.addEventListener(MouseEvent.MOUSE_UP, closeClick, false, 0, true);
		}
		public function show():void
		{
			_startLogin.selected = HCTimer.startLogin;
			_autoLogin.selected = HCTimer.autoLogin;
			_minToTray.selected = HCTimer.minToTray;
			gotoAndPlay(2);
		}
		private function clickSubmit(event:Event):void
		{
			if(!_isAddHandler)
			{
				HCTimer.addSuccessHandler(this.saveSuccess);
				HCTimer.addFailedHandler(this.saveFailed);
				_isAddHandler = true;
			}
			HCTimer.saveSetting(_startLogin.selected, _autoLogin.selected, _minToTray.selected, (uint)(_updateTime.value));
		}
		private function saveSuccess():void
		{
			gotoAndPlay(39);
		}
		private function saveFailed():void
		{
			gotoAndPlay(16);
		}
		private function closeClick(event:Event):void
		{
			gotoAndPlay(66);
		}
		private function closeRollOver(event:Event):void
		{
			_close.gotoAndPlay(2);
		}
		private function closeRollOut(event:Event):void
		{
			_close.gotoAndPlay(16 - _close.currentFrame);
		}
	
	}

}