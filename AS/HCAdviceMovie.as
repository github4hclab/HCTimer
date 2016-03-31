package AS
{

	import flash.display.MovieClip;
	import fl.controls.Button;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import AS.HCTimer.HCTimer;
	import fl.controls.TextArea;
	import flash.text.TextField;


	public class HCAdviceMovie extends MovieClip
	{
		var _m:MovieClip = null;
		var _submit:Button = null;
		var _prompt:MovieClip = null;
		var _main:MovieClip = null;
		var _textInput:TextArea = null;
		var _noEmpty:MovieClip = null;
		var _cntInput:TextField = null;
		
		public function HCAdviceMovie(main:MovieClip)
		{
			_main = main;
			this.x = 100;
			this.y = 30;
			_m = this.member;
			_submit = _m.submit;
			_textInput = _m.txtInput;
			_cntInput = _m.cntInput;
			
			_textInput.addEventListener(Event.CHANGE, changeInput, false, 0, true);
			_textInput.addEventListener(MouseEvent.CLICK, clickInput, false, 0, true);
			_submit.addEventListener(MouseEvent.CLICK, clickSubmit, false, 0, true);
		}
		private function clickInput(event:Event):void
		{
			if(_noEmpty != null)
			{
				_noEmpty.visible = false;
			}
			_textInput.getFocus();
		}
		private function changeInput(event:Event):void
		{
			_cntInput.text = _textInput.text.length.toString();
		}
		private function clickSubmit(event:Event):void
		{
			_submit.getFocus();
			if(!HCTimer.checkLogin())
			{
				return;
			}
			if(_textInput.text == "")
			{
				if(_noEmpty == null)
				{
					_noEmpty = new HCNoEmpty();
					_noEmpty.x = 45;
					_noEmpty.y = 20;
					_m.addChild(_noEmpty);
				}
				_noEmpty.visible = true;
				return;
			}
			if(_prompt == null)
			{
				_prompt = new HCSubmitSuccess();
				_prompt.x = 45;
				_prompt.y = 300;
				_m.addChild(_prompt);
			}
			_textInput.text = "";
			_prompt.visible = true;
			_prompt.gotoAndPlay(2);
		}
	}

}