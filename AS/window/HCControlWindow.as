package AS.window
{
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	import flash.events.KeyboardEvent;
	import flash.events.Event;
	import flash.events.InvokeEvent;
	import flash.events.ScreenMouseEvent;
	import flash.display.NativeWindow;
	import flash.display.Stage;
	import flash.display.StageScaleMode;
	import AS.HCTimer.HCTimer;
	import flashx.textLayout.operations.MoveChildrenOperation;
	import AS.HCSettingMovie;
	import flash.desktop.NativeApplication;
	import flash.utils.getTimer;


	//控制窗口类
	public class HCControlWindow
	{
		private var _min:MovieClip = null;
		private var _max:MovieClip = null;
		private var _setting:MovieClip = null;
		private var _close:MovieClip = null;
		private var _restore:MovieClip = null;
		private var _dragArea:MovieClip = null;
		private var _window:NativeWindow = null;
		private var _main:MovieClip = null;
		private var _stage:Stage = null;

		private var _midFrame:int = 8;
		private var _halfFrame:int = 6;
		private var _lastMouseX:Number = 0;
		private var _lastMouseY:Number = 0;
		private var _clickCount:int = 0;
		private var _trayIcon:HCTrayIcon = null;
		private var _settingMovie:HCSettingMovie = null;
		private var _application:NativeApplication;
		private static var _idleTime:int = 600;//空闲间隔时间
		
		//构造函数
		public function HCControlWindow(main:MovieClip)
		{
			_main = main;
			_min = _main.minMC;
			_max = _main.maxMC;
			_close = _main.closeMC;
			_setting = _main.setting;
			_dragArea = _main.dragAreaMC;
			
			
			_stage = main.stage;
			_stage.scaleMode = StageScaleMode.EXACT_FIT;
			_window = _stage.nativeWindow;
			_window.title = "环创计时器";
			_trayIcon = new HCTrayIcon(_window);
			_main.alpha = 1;
			

			
			var area:MovieClip = _min.area;
			area.addEventListener(MouseEvent.ROLL_OVER, minRollOver, false, 0, true);
			area.addEventListener(MouseEvent.ROLL_OUT, minRollOut, false, 0, true);
			area.addEventListener(MouseEvent.CLICK, minClick, false, 0, true);
			
			area = _max.area;
			area.addEventListener(MouseEvent.ROLL_OVER, maxRollOver, false, 0, true);
			area.addEventListener(MouseEvent.ROLL_OUT, maxRollOut, false, 0, true);
			area.addEventListener(MouseEvent.CLICK, maxClick, false, 0, true);
			
			area = _close.area;
			area.addEventListener(MouseEvent.ROLL_OVER, closeRollOver, false, 0, true);
			area.addEventListener(MouseEvent.ROLL_OUT, closeRollOut, false, 0, true);
			area.addEventListener(MouseEvent.CLICK, closeClick, false, 0, true);
			
			area = _setting.area;
			area.addEventListener(MouseEvent.ROLL_OVER, settingRollOver, false, 0, true);
			area.addEventListener(MouseEvent.ROLL_OUT, settingRollOut, false, 0, true);
			area.addEventListener(MouseEvent.CLICK, settingClick, false, 0, true);
			
			_dragArea.addEventListener(MouseEvent.MOUSE_DOWN, dragAreaDown, false, 0, true);
			_dragArea.addEventListener(MouseEvent.MOUSE_UP, dragAreaUp, false, 0, true);

			_application = NativeApplication.nativeApplication;
			
			if(NativeApplication.supportsStartAtLogin)
			{
				try
				{
					_application.startAtLogin = HCTimer.startLogin;
				}
				catch(e:Error)
				{
					
				}
			}
			//_application.addEventListener(KeyboardEvent.KEY_DOWN, this.mouseHandle);
			//_application.addEventListener(, this.mouseHandle);
			//main.stage.addEventListener(MouseEvent.MOUSE_MOVE, this.mouseHandle);
			//设置显示时间信息的文本
			//_window.stage.
			try
			{
				_application.idleThreshold = _idleTime; //设置空闲间隔时间
				_application.addEventListener(Event.USER_IDLE, this.ideHandle);//如果在指定的时间内用户没有更新鼠标或键盘信息，那么会调用该事件
				_application.addEventListener(Event.USER_PRESENT, this.persentHandle);//如果更新的话触发此事件
				_application.addEventListener(InvokeEvent.INVOKE, this.invokeHandle);
			}
			catch(e:Error)
			{
				//trace(e.message);
			}

			//HCTimer.hcUser.showNameText = _main.nameText;


			//_main.addEventListener(Event.ENTER_FRAME, enterFrameHandler);
			
		}
		private function invokeHandle(event:InvokeEvent):void
		{
			if(event.reason == "login")
			{
				_window.visible = false;
			}
			else
			{
				_window.visible = true;
			}
//			trace(event.reason);
//			HCTimer.logMessage("reason", event.reason);
//			for(var i:int = 0; i < event.arguments.length; ++i)
//			{
//				HCTimer.logMessage("arg", event.arguments[i].toString());
//			}
//			HCTimer.logMessage("dir", event.currentDirectory.url);
//			HCTimer.saveLog();
		}
		private function ideHandle(event:Event):void
		{
			HCTimer.allowTiming = false;
		}
		private function persentHandle(event:Event):void
		{
			HCTimer.allowTiming = true;
		}
		private function minClick(event:Event):void
		{
			//_stage.x = 0;
			_window.minimize();
		}
		public function set startLogin(value:Boolean):void
		{
			if(NativeApplication.supportsStartAtLogin)
			{
				try
				{
					_application.startAtLogin = value;
				}
				catch(e:Error)
				{
					
				}
			}
		}
		private function maxClick(event:Event):void
		{
			if(_restore == null)
			{
				_restore = new HCRestoreBtn;
				_main.addChild(_restore);
				var area:MovieClip = _restore.area;
				area.addEventListener(MouseEvent.ROLL_OVER, restoreRollOver, false, 0, true);
				area.addEventListener(MouseEvent.ROLL_OUT, restoreRollOut, false, 0, true);
				area.addEventListener(MouseEvent.CLICK, restoreClick, false, 0, true);
			}
			_restore.visible = true;
			_max.visible = false;
			_window.maximize();
		}
		private function closeClick(event:Event):void
		{
			if(HCTimer.minToTray)
			{
				_window.visible = false;
			}
			else
			{
				_trayIcon.exit();
			}
			
		}
		private function settingClick(event:Event):void
		{
			if(_settingMovie == null)
			{
				_settingMovie = new HCSettingMovie();
				_main.addChild(_settingMovie);
			}
			_settingMovie.show();
		}
		private function restoreClick(event:Event):void
		{
			_restore.visible = false;
			_max.visible = true;
			_window.restore();
		}
		private function dragAreaDown(event:MouseEvent):void
		{
			
			_main.alpha = 0.6;
			_window.startMove();
			
		}
		private function dragAreaUp(event:MouseEvent):void
		{
			_main.alpha = 1;
		}
		
		
		private function minRollOver(event:Event):void
		{
			_min.gotoAndPlay(_midFrame - _halfFrame);
		}
		
		private function minRollOut(event:Event):void
		{
			_min.gotoAndPlay(_midFrame + 1);
		}
		
		private function maxRollOver(event:Event):void
		{
			_max.gotoAndPlay(_midFrame - _halfFrame);
		}
		
		private function maxRollOut(event:Event):void
		{
			_max.gotoAndPlay(_midFrame + 1);
		}
		
		
		
		private function closeRollOut(event:Event):void
		{
			_close.gotoAndPlay(2 * _midFrame + _close.currentFrame);
		}
		private function settingRollOut(event:Event):void
		{
			_setting.gotoAndPlay(2 * _midFrame - _setting.currentFrame);
		}
		private function restoreRollOut(event:Event):void
		{
			_restore.gotoAndPlay(2 * _midFrame + _restore.currentFrame);
		}
		private function settingRollOver(event:Event):void
		{
			_setting.gotoAndPlay(2);
		}
		private function restoreRollOver(event:Event):void
		{
			_restore.gotoAndPlay(2);
		}
		private function closeRollOver(event:Event):void
		{
			_close.gotoAndPlay(2);
		}
		
		public function showWindow():void
		{
			_window.visible = true;
			_window.orderToFront();
		}
		
	}

}