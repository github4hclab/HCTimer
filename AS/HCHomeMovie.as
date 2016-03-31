package AS
{

	import flash.text.TextField;
	import flash.display.MovieClip;
	import AS.HCTimer.HCTimer;
	
	public class HCHomeMovie extends MovieClip
	{
		var _m:MovieClip = null;

		public function HCHomeMovie()
		{
			this.x = 100;
			this.y = 30;
			_m = this.member;
			HCTimer.hcTime.setShowText(_m.todayDate, _m.weekDate, _m.todayTime, _m.weekTime, _m.avgTime);
		}
	}

}