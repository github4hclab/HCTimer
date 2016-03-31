package AS
{

	import flash.display.MovieClip;
	import flash.display.SimpleButton;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.events.Event;

	public class HCBGMovie extends MovieClip
	{
		private var _m:MovieClip = null;
		private var _flush:SimpleButton = null;
		private var _flushPrompt:MovieClip = null;

		public function HCBGMovie()
		{
			this.x = 100;
			this.y = 30;
			_m = this.member;
			_flush = _m.flush;
			
			_flush.addEventListener(MouseEvent.ROLL_OVER, overHandler);
			_flush.addEventListener(MouseEvent.ROLL_OUT, outHandler);
		}
		public function set flushPrompt(value:MovieClip):void
		{
			_flushPrompt = value;
		}
		public function get ipText():TextField
		{
			return _m.ipText;
		}
		public function get btnFlush():SimpleButton
		{
			return _flush;
		}
		private function overHandler(event:Event):void
		{
			_flushPrompt.gotoAndPlay(2);
		}
		private function outHandler(event:Event):void
		{
			_flushPrompt.gotoAndPlay(12);
		}
	}

}