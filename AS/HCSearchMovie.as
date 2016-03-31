package AS
{
	import fl.controls.DataGrid;
	import fl.controls.TextInput;
	import fl.controls.ComboBox;
	import fl.controls.dataGridClasses.DataGridColumn;
	import flash.display.DisplayObjectContainer;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	import flash.display.SimpleButton;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.events.Event;
	import flash.events.FocusEvent;
	import flash.display.Stage;
	import AS.HCTimer.HCLink;
	import fl.managers.StyleManager;
	import flash.display.MovieClip;
	import fl.controls.Button;
	import AS.HCTimer.HCDate;
	import AS.HCTimer.HCTimer;
	import AS.HCTimer.HCLinkEvent;
	import AS.HCTimer.HCUserInfo;
	import AS.HCTimer.HCTimeInfo;

	//import AS.HCTimer.HCSearch;


	public class HCSearchMovie extends MovieClip
	{
		var _m:MovieClip = null;
		
		static const ALL_INDEX:int = 0;
		static const NAME_INDEX:int = 1;
		static const GRADE_INDEX:int = 2;
		static const NUMBER_INDEX:int = 3;

		static const NAME:String = HCUserInfo.NAME;
		static const NUMBER:String = HCUserInfo.NUMBER;
		static const GRADE:String = HCUserInfo.GRADE;
		static const ALL_TIME:String = "allTime";
		static const AVG_TIME:String = "avgTime";

		var _grid:DataGrid = null;
		var _condition:ComboBox = null;
		var _searchText:TextInput = null;
		var _date:HCDate = null;
		var _allDay:TextField = null;
		var _noEmpty:MovieClip = null;
		var _submit:Button = null;
		var _main:MovieClip = null;
		
		public function HCSearchMovie(main:MovieClip)
		{
			_main = main;
			this.x = 100;
			this.y = 30;
			_m = this.member;
			createGrid();
			_m.addChild(_grid);
			_date = new HCDate(_m.beginYear, _m.beginMonth, _m.beginDay, _m.endYear, _m.endMonth, _m.endDay);
			_submit = _m.submit;
			_allDay = _m.allDay;
			_condition = _m.condition;
			_searchText = _m.txtSearch;
			
			_submit.addEventListener(MouseEvent.CLICK, clickSubmit);
			_searchText.addEventListener(MouseEvent.CLICK, focusInHandler);
			
			HCTimer.hcLink.addListener(HCLinkEvent.TIME_ALLUSER, showData);
			HCTimer.hcLink.addListener(HCLinkEvent.TIME_USERNAME, showData);
			HCTimer.hcLink.addListener(HCLinkEvent.TIME_USERGRADE, showData);
			HCTimer.hcLink.addListener(HCLinkEvent.TIME_USERNUMBER, showData);
		}
		
		//点击搜索输入框的时的事件处理
		private function focusInHandler(event:Event):void
		{
			if(_searchText.text == "搜索：")
			{
				_searchText.text = "";
			}
			if(_noEmpty != null)
			{
				_noEmpty.visible = false;
			}
		}
		
		//根据条件和输入的值搜索数据
		public function clickSubmit(event:Event):void
		{
			var selectedIndex:int = _condition.selectedIndex;
			if(selectedIndex != ALL_INDEX)
			{
				if(_searchText.text == "")
				{
					if(_noEmpty == null)
					{
						_noEmpty = new HCNoEmpty;
						_noEmpty.x = 130;
						_noEmpty.y = -10;
						_m.addChild(_noEmpty);
					}
					_noEmpty.visible = true;
					return;
				}
			}
			else
			{
				_submit.getFocus();
				if(_noEmpty != null)
				{
					_noEmpty.visible = false;
				}
			}
			HCTimer.checkLinkNow();
			switch (selectedIndex)
			{
				case ALL_INDEX ://所有
					{
						HCTimer.hcLink.getTimeWithAllUser(_date.beginDate, _date.endDate);
					};
					break;
				case NAME_INDEX ://姓名
					{
						HCTimer.hcLink.getTimeWith(HCUserInfo.NAME, _searchText.text, _date.beginDate, _date.endDate);
					};
					break;
				case GRADE_INDEX ://年级
					{
						HCTimer.hcLink.getTimeWith(HCUserInfo.GRADE, _searchText.text, _date.beginDate, _date.endDate);
					};
					break;
				case NUMBER_INDEX ://学号
					{
						HCTimer.hcLink.getTimeWith(HCUserInfo.NUMBER, _searchText.text, _date.beginDate, _date.endDate);
					};
					break;
				default :
					break;
			}

			if(_allDay != null)
			{
				_allDay.text =_date.deltaDay.toString()+"天";
			}
		}
		//显示搜索到的数据
		private function showData(event:HCLinkEvent):void
		{
			//清除之前的数据
			_grid.removeAll();
			var item:Object = null;
			HCTimer.showLinkState();
			if(!event.isFind || !event.isLink)
			{
				item = new Object;
				item[NAME] = "没数据";
				item[NUMBER] = "没数据";
				item[GRADE] = "没数据";
				item[ALL_TIME] = "没数据";
				item[AVG_TIME] =  "没数据";
				_grid.addItem(item);
				item = null;
				return;
			}
			
			var xml:XML = event.xml;
			var days:int = _date.deltaDay;

			var length:int = xml.children().length();
			//将xml数据转成合适的数据填入表格
			for(var i:int = 1; i < length; ++i)
			{
				
				var node:XMLList = xml.child(i);
				item = new Object;
				item[NAME] = node.attribute(HCUserInfo.NAME).toString();
				item[NUMBER] = node.attribute(HCUserInfo.NUMBER).toString();
				item[GRADE] = node.attribute(HCUserInfo.GRADE).toString();
				var allSecond:uint = uint(node.attribute(HCTimeInfo.ALL_SECOND).toString());
				var avgSecond:uint = allSecond / days;
				//统计时间
				item[ALL_TIME] = HCDate.secondFormat(allSecond);
				item[AVG_TIME] = HCDate.secondFormat(avgSecond);
				_grid.addItem(item);
				item = null;
			}

		}
		
		private function createGrid():void
		{
			_grid = new DataGrid();
			var column:DataGridColumn = _grid.addColumn(NAME);
			column.width = 70;
			column.headerText = "   姓名";
			column = _grid.addColumn(NUMBER);
			column.width = 100;
			column.headerText = "      学号";

			column = _grid.addColumn(GRADE);
			column.width = 45;
			column.headerText = "年级";

			column = _grid.addColumn(ALL_TIME);
			column.width = 125;
			column.headerText = "       总时间";

			column = _grid.addColumn(AVG_TIME);
			column.width = 100;
			column.headerText = "   平均时间 ";

			//设置表格的属性
			_grid.rowHeight = 25;
			_grid.rowCount = 7;
			_grid.headerHeight = 35;
			_grid.height = 210;
			_grid.width = 470;
			_grid.x = 10;
			_grid.y = 130;
		}
	}

}