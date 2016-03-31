package AS
{
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.ui.Keyboard;
	import AS.HCTimer.*;
	import flash.display.SimpleButton;
	import flash.text.TextField;
	import flash.net.navigateToURL;
	import flash.net.URLRequest;

	public class HCNavigation
	{

		static const HOME_INDEX:int = 0;
		static const STATISTIC_INDEX:int = 1;
		static const SEARCH_INDEX:int = 2;
		static const ADVICE_INDEX:int = 3;
		static const COUNT:int = 4;
		static const BEGIN_FRAME:int = 2;
		
		static const ALL_FRAME:int = 16;
		static const CLICK_FRAME:int = ALL_FRAME - 1;
		static const EXIT_FRAME:int = 9; 
		static const SHOW_CONTENT:int = 14;
		static const EXIT_CONTENT:int = 15;
		
		var _bgContent:HCBGMovie = null;
		var _slide:MovieClip = null;
		
		var _button:Vector.<MovieClip> = null;//导航栏的按钮
		var _content:Vector.<MovieClip> = null;//相应导航栏对应的内容
		var _y:Vector.<Number> = null;
		var _lastIndex:int = HOME_INDEX;//上一次点击的导航序号
		var _nowIndex:int = HOME_INDEX;//当前点击的导航序号 
		
		var _slideFrameCount:int = 6;
		var _deltaY:Number = 0;
		var _main:MovieClip = null;
		
		var _hcLab:SimpleButton = null;

		public function HCNavigation(main:MovieClip)
		{
			_main = main;
			_hcLab = _main.hcLab;

			//_nameText = _main.nameText;
			_button =  new Vector.<MovieClip>(COUNT);
			_content = new Vector.<MovieClip>(COUNT);
			_y = new Vector.<Number>(COUNT);
			
			_bgContent = new HCBGMovie;
			_main.addChildAt(_bgContent, 1);
			_bgContent.flushPrompt = _main.flushPrompt;
			_slide = _main.slide;
			
			initHome();
			initStatistic();
			initSearch();
			initAdvice();

			_bgContent.gotoAndStop(SHOW_CONTENT);
			HCTimer.hcUser.showNameText = _main.nameText;
			HCTimer.hcUser.ipText = _bgContent.ipText;
			_slide.addEventListener(Event.ENTER_FRAME, slideFrameEvent, false, 0, true);
			
			_bgContent.btnFlush.addEventListener(MouseEvent.CLICK, clickFlush, false, 0, true);
			HCTimer.hcLink.addListener(HCLinkEvent.UPDATE_TIME, handleUpdateTime);
			_hcLab.addEventListener(MouseEvent.CLICK, clickHcLab, false, 0, true);
			
		}
		private function handleUpdateTime(event:HCLinkEvent):void
		{
			if(!event.isLink)
			{
				HCTimer.showLinkState();
			}
			else
			{
				HCTimer.showUpdateState(event.isSuccess);
			}
		}
		private function clickHcLab(event:Event):void
		{
			navigateToURL(new URLRequest("http://www.hclab.cn/"), "_blank");
		}
		private function initHome():void
		{
			_button[HOME_INDEX] = _main.home;
			_content[HOME_INDEX] = new HCHomeMovie();
			_main.addChildAt(_content[HOME_INDEX], 2);
			_y[HOME_INDEX] =  0 + _slide.y;
			var area:MovieClip = _button[HOME_INDEX].area;
			area.addEventListener(MouseEvent.ROLL_OVER, homeRollOver);
			area.addEventListener(MouseEvent.ROLL_OUT, homeRollOut);
			area.addEventListener(MouseEvent.CLICK, homeClick);
			
			//_homeContent.mcContent.bgContent.flush.addEventListener(MouseEvent.CLICK, clickFlush);
			_button[HOME_INDEX].gotoAndStop(21);
			_content[HOME_INDEX].gotoAndStop(SHOW_CONTENT);
			
			//var m:MovieClip = homeContent.mcContent;
			
			//var hcHome:HCHome = new HCHome(m.todayDate, m.todayTime, m.weekTime, m.avgTime);
		}

		private function initStatistic():void
		{
			_button[STATISTIC_INDEX] = _main.statistic;
			//_content[STATISTIC_INDEX] = statisticContent;
			_y[STATISTIC_INDEX] =  45 + _slide.y;
			
			var area:MovieClip = _button[STATISTIC_INDEX].area;
			area.addEventListener(MouseEvent.ROLL_OVER, statisticRollOver);
			area.addEventListener(MouseEvent.ROLL_OUT, statisticRollOut);
			area.addEventListener(MouseEvent.CLICK, statisticClick);
			

			//var m:MovieClip = statisticContent.mcContent;
			//_hcStat = new HCStatistics(m, m.allTime, m.avgTime, m.submit);

			//设置开始日期的文本
			//_hcStat.hcDate.setBeginDate(m.beginYear, m.beginMonth, m.beginDay);
			//设置结束日期的文本;
			//_hcStat.hcDate.setEndDate(m.endYear, m.endMonth, m.endDay);
				
		}
		
		private function initSearch():void
		{
			_button[SEARCH_INDEX] = _main.search;
			//_content[SEARCH_INDEX] = searchContent;
			_y[SEARCH_INDEX] =  90 + _slide.y;
			
			var area:MovieClip = _button[SEARCH_INDEX].area;
			area.addEventListener(MouseEvent.ROLL_OVER, searchRollOver);
			area.addEventListener(MouseEvent.ROLL_OUT, searchRollOut);
			area.addEventListener(MouseEvent.CLICK, searchClick);
			//var m:MovieClip = searchContent.mcContent;
			//_hcSearch = new HCSearch(m, m.allDay, m.condition, m.txtSearch, m.submit);
			//_hcSearch.hcDate.setBeginDate(m.beginYear, m.beginMonth, m.beginDay);
			//_hcSearch.hcDate.setEndDate(m.endYear, m.endMonth, m.endDay);
		}
		
		private function initAdvice():void
		{
			_button[ADVICE_INDEX] = _main.advice;
			//_content[ADVICE_INDEX] = adviceContent;
			_y[ADVICE_INDEX] =  135 + _slide.y;
			//_advice = advice;
			//_adviceContent = adviceContent;
			var area:MovieClip = _button[ADVICE_INDEX].area;
			area.addEventListener(MouseEvent.ROLL_OVER, adviceRollOver);
			area.addEventListener(MouseEvent.ROLL_OUT, adviceRollOut);
			area.addEventListener(MouseEvent.CLICK, adviceClick);
			
			//var m:MovieClip = adviceContent.mcContent;
			//var hcAdvice:HCAdvice = new HCAdvice(m.submit, m.prompt);
			//m.bgContent.flush.addEventListener(MouseEvent.CLICK, ClickFlush);
		}
		private function clickFlush(event:Event):void
		{
			if(HCTimer.checkLogin())
			{
				HCTimer.hcLink.updateTime();
			}
		}
		private function homeRollOver(event:Event):void
		{
			//如果当前点击的导航不是首页
			if(_nowIndex != HOME_INDEX)
			{
				_button[HOME_INDEX].gotoAndPlay(BEGIN_FRAME);
			}
		}

		private function homeRollOut(event:Event):void
		{
			//如果当前点击的导航不是首页
			if(_nowIndex != HOME_INDEX)
			{
				_button[HOME_INDEX].gotoAndPlay(ALL_FRAME - _button[HOME_INDEX].currentFrame);
			}
		}
		private function turnOn(index:int):void
		{
			_lastIndex = _nowIndex;
			_nowIndex = index;
			if(_content[_nowIndex] == null)
			{
				switch(_nowIndex)
				{
					case STATISTIC_INDEX:
					{
						_content[_nowIndex] = new HCStatisticMovie(_main);
						_main.addChildAt(_content[_nowIndex], 3);
					}
					break;
					case SEARCH_INDEX:
					{
						_content[_nowIndex] = new HCSearchMovie(_main);
						_main.addChildAt(_content[_nowIndex], 3);
					}
					break;
					case ADVICE_INDEX:
					{
						_content[_nowIndex] = new HCAdviceMovie(_main);
						_main.addChildAt(_content[_nowIndex], 3);
					}
					break;
					default:break;
				}
			}
			_button[_lastIndex].gotoAndPlay(EXIT_FRAME);
			_content[_lastIndex].gotoAndPlay(EXIT_CONTENT);

			_button[_nowIndex].gotoAndPlay(CLICK_FRAME);
			_content[_nowIndex].gotoAndPlay(BEGIN_FRAME);
			_bgContent.gotoAndPlay(BEGIN_FRAME);
			slideAction(_y[_nowIndex] - _slide.y);
		}
		private function homeClick(event:Event):void
		{
			//如果当前点击的导航不是首页
			if(_nowIndex != HOME_INDEX)
			{
				//切换到首页
				turnOn(HOME_INDEX);
			}
		}
		
		private function statisticRollOver(event:Event):void
		{
			//如果当前点击的导航栏不是统计
			if(_nowIndex != STATISTIC_INDEX)
			{
				_button[STATISTIC_INDEX].gotoAndPlay(BEGIN_FRAME);
			}
		}

		private function statisticRollOut(event:Event):void
		{
			//如果当前点击的导航栏不是统计
			if(_nowIndex != STATISTIC_INDEX)
			{
				_button[STATISTIC_INDEX].gotoAndPlay(ALL_FRAME - _button[STATISTIC_INDEX].currentFrame);
			}
		}

		private function statisticClick(event:Event):void
		{

			//如果当前点击的导航不是统计
			if(_nowIndex != STATISTIC_INDEX)
			{
				//切换到统计
				turnOn(STATISTIC_INDEX);	
			}
		}
		
		private function searchRollOver(event:Event):void
		{
			//如果当前点击的导航栏不是查询
			if(_nowIndex != SEARCH_INDEX)
			{
				_button[SEARCH_INDEX].gotoAndPlay(BEGIN_FRAME);
			}
		}

		private function searchRollOut(event:Event):void
		{
			//如果当前点击的导航栏不是查询
			if(_nowIndex != SEARCH_INDEX)
			{
				_button[SEARCH_INDEX].gotoAndPlay(ALL_FRAME - _button[SEARCH_INDEX].currentFrame);
			}
		}

		private function searchClick(event:Event):void
		{
			//如果当前点击的导航不是查询
			if(_nowIndex != SEARCH_INDEX)
			{
				//切换到查询
				turnOn(SEARCH_INDEX);
			}		
		}
		
		private function adviceRollOver(event:Event):void
		{
			//如果当前点击的导航栏不是建议
			if(_nowIndex != ADVICE_INDEX)
			{
				_button[ADVICE_INDEX].gotoAndPlay(BEGIN_FRAME);
			}
		}

		private function adviceRollOut(event:Event):void
		{
			//如果当前点击的导航栏不是建议
			if(_nowIndex != ADVICE_INDEX)
			{
				_button[ADVICE_INDEX].gotoAndPlay(ALL_FRAME - _button[ADVICE_INDEX].currentFrame);
			}
		}

		private function adviceClick(event:Event):void
		{
			//如果当前点击的导航不是建议
			if(_nowIndex != ADVICE_INDEX)
			{
				//切换到建议
				turnOn(ADVICE_INDEX);
			}		
		}
		
		
		private function slideAction(allY:Number):void
		{
			_deltaY = allY / 6.0;
			_slide.alpha = 0;
			//_slide.x = 129;
			_slide.scaleY = 0;
			_slideFrameCount = 0;
		}
		private function slideFrameEvent(event:Event):void
		{
			if(_slideFrameCount != 6)
			{
				++_slideFrameCount;
				_slide.y += _deltaY;
				_slide.alpha += 0.2;
				_slide.scaleY += 0.17;
				if(_slide.scaleY >= 1.0)
				{
					_slide.scaleY = 1.0;
				}
			}
		}
		

	}

}