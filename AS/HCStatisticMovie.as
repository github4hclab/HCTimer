package AS
{

	import flash.display.MovieClip;
	import fl.controls.DataGrid;
	import fl.controls.TextInput;
	import flash.text.TextFormat;
	import flash.text.TextField;
	import flash.text.TextFormatAlign;
	import flash.display.DisplayObjectContainer;
	import fl.managers.StyleManager;
	import fl.events.ComponentEvent;
	import fl.controls.dataGridClasses.DataGridColumn;
	import fl.controls.dataGridClasses.HeaderRenderer;
	import flash.display.SimpleButton;
	import flash.events.MouseEvent;
	import flash.display.MovieClip;
	import flash.events.Event;
	import fl.controls.Button;
	import AS.HCTimer.HCTimer;
	import AS.HCTimer.HCLinkEvent;
	import AS.HCTimer.HCDate;
	



	public class HCStatisticMovie extends MovieClip
	{
		var _m:MovieClip = null;
		const DATE:String = "date";
		const TIME:String = "todaySecond";

		var _grid:DataGrid = null;//数据表格
		var _allSecond:uint = 0;//所有秒数
		var _date:HCDate = null;//日期

		var _allTime:TextField = null;//显示所有时间的文本
		var _avgTime:TextField = null;//显示平均时间的文本
		var _submitBtn:SimpleButton = null;//确定按钮
		var _firstClick:Boolean = true;
		var _submit:Button = null;
		var _cDate:DataGridColumn = null;
		var _cTime:DataGridColumn = null;
		var _main:MovieClip = null;
		public function HCStatisticMovie(main:MovieClip)
		{
			_main = main;
			this.x = 100;
			this.y = 30;
			_m = this.member;
			createDataGrid();
			_date = new HCDate(_m.beginYear, _m.beginMonth, _m.beginDay, _m.endYear, _m.endMonth, _m.endDay);
			
			_allTime = _m.allTime;
			_avgTime = _m.avgTime;
			_submit = _m.submit;

			_submit.addEventListener(MouseEvent.CLICK, clickSubmit);

			HCTimer.hcLink.addListener(HCLinkEvent.TIME_USERID, computeDataAndShow);
		}

		private function clickSubmit(event:Event):void
		{
			if(HCTimer.checkLogin())
			{
				HCTimer.hcLink.getTimeData(_date.beginDate, _date.endDate);
			}
			
		}
		//设置所有时间的文本实例;
		public function set allTimeText(value:TextField):void
		{
			_allTime = value;
		}
		//设置平均时间的文本实例
		public function set avgTimeText(value:TextField):void
		{
			_avgTime = value;
		}
		//统计存放时间数据的xml并转成合适的格式然后显示到表格中;
		public function computeDataAndShow(event:HCLinkEvent):void
		{
			_grid.removeAll();
			var item:Object = null;
			if (! event.isFind)
			{
				item = new Object;
				item[DATE] = "没数据";
				item[TIME] = "没数据";
				_grid.addItem(item);
				item = null;
				return;
			}
			var xml:XML = event.xml;
			//清除之前的数据
			
			_allSecond = 0;
			var length:int = xml.children().length();
			//将xml数据转成合适的数据填入表格
			for (var i:int = 1; i < length; ++i)
			{
				var node:XMLList = xml.child(i);
				item = new Object  ;
				var date:uint = uint(node.attribute(DATE).toString());
				var time:uint = uint(node.attribute(TIME).toString());
				//统计时间
				_allSecond +=  time;

				item[DATE] = HCDate.dateFormat(date);

				item[TIME] = HCDate.secondFormat(time);
				_grid.addItem(item);
				item = null;
			}

			//对时间列进行排序
			_grid.sortItemsOn(DATE);

			//根据秒数计算出总时间和平均时间并显示到总时间文本和平均文本
			var days:int = _date.deltaDay;
			_allTime.text = HCDate.secondFormat(_allSecond) + " ( " + "总天数为" + days.toString() + "天 ) ";
			var avgSecond:uint = _allSecond / days;
			_avgTime.text = HCDate.secondFormat(avgSecond);
		}
		//获得存放时间数据的xml中的所有秒数
		public function get allSecond():uint
		{
			return _allSecond;
		}
		//创建时间数据表格
		private function createDataGrid()
		{
			//创建表格
			_grid = new DataGrid  ;
			_cDate = _grid.addColumn(DATE);
			_grid.resizableColumns = false;


			_cTime = _grid.addColumn(TIME);
			_cDate.headerText = "日期";
			_cTime.headerText = "时间";


			//设置表格的属性
			_grid.rowHeight = 25;
			_grid.rowCount = 7;
			_grid.minColumnWidth = 200;
			_grid.headerHeight = 35;
			_grid.height = 210;
			_grid.width = 455;
			_grid.x = 20;
			_grid.y = 100;
			_m.addChild(_grid);
		}
	}

}