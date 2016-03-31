package AS.window
{
	import flash.display.BitmapData;
	import flash.display.Bitmap;
	import flash.display.Loader;
	import flash.net.URLRequest;
	import flash.display.NativeMenu;
	import flash.display.NativeMenuItem;
	import flash.events.Event;
	import flash.desktop.SystemTrayIcon;
	import flash.desktop.NativeApplication;
	import flash.display.NativeWindow;
	import flash.display.DisplayObject;
	import flash.display.Stage;
	import flash.events.ScreenMouseEvent;
	import AS.HCTimer.*;
	
	public class HCTrayIcon
	{
		//小图标的路径
		private const ICON_ROOT:String = "icon/icon";
		//小图标的格式
		private const FORMAT:String = ".png";
		//小图标的大小信息
		private const SIZE:Array = new Array("16","32","48","128");


		private var _iconLoader:Loader = null;
		private var _iconMenu:NativeMenu = null;
		private var _exitItem:NativeMenuItem = null;
		private var _openItem:NativeMenuItem = null;
		private var _request:URLRequest = null;
		private var _trayIcon:SystemTrayIcon = null;
		private var _application:NativeApplication = null;
		private var _bitmaps:Array = null;
		private var _window:NativeWindow = null;
		private var _isExit:Boolean = false;
		
		
		public function HCTrayIcon(window:NativeWindow)
		{
				_window = window;
			
			if(NativeApplication.supportsSystemTrayIcon)
			{
				
				_iconLoader = new Loader();
				_iconMenu = new NativeMenu();
				_exitItem = new NativeMenuItem("退出       ");
				_openItem = new NativeMenuItem("打开       ");
			
				_application = NativeApplication.nativeApplication;
				_trayIcon = _application.icon as SystemTrayIcon;
			
				_iconLoader.contentLoaderInfo.addEventListener(Event.COMPLETE, loadComplete);
				_bitmaps = new Array  ;
				_request = new URLRequest(ICON_ROOT + SIZE[_bitmaps.length] + FORMAT);
				_iconLoader.load(_request);

			
				_application.autoExit = false;
				HCTimer.hcLink.addListener(HCLinkEvent.UPDATE_TIME, updateTimeHandler);
			}
			
		}
		
		private function loadComplete(event:Event):void
		{
			_bitmaps.push((_iconLoader.content as Bitmap).bitmapData);
			if (_bitmaps.length == SIZE.length)
			{
				_iconMenu.addItem(_openItem);
				_iconMenu.addItem(new NativeMenuItem("", true));
				_iconMenu.addItem(_exitItem);
				_trayIcon.bitmaps = _bitmaps;
				_trayIcon.addEventListener(ScreenMouseEvent.RIGHT_CLICK, rightClick);
				_trayIcon.addEventListener(ScreenMouseEvent.CLICK, leftClick);
				_trayIcon.tooltip = "正在计时……";

				_exitItem.addEventListener(Event.SELECT, exitSelect);
				_openItem.addEventListener(Event.SELECT, openSelect);
				_request = null;
			}
			else
			{
				_request = new URLRequest(ICON_ROOT + SIZE[_bitmaps.length] + FORMAT);
				_iconLoader.load(_request);
			}
		}
		private function updateTimeHandler(event:HCLinkEvent):void
		{
			if(_isExit)
			{
				//_trayIcon.bitmaps = [];
				//_trayIcon.menu = null;
				//_application.exit();
			}
		}
		private function rightClick(event:Event):void
		{
			_trayIcon.menu = _iconMenu;

		}
		private function leftClick(event:Event):void
		{
			_trayIcon.menu = null;

			_window.visible = true;
			_window.orderToFront();
		}
		
		public function exit():void
		{
			_isExit = true;
		
			//如果连接成功
			//在退出之前更新时间数据
			if(HCTimer.isLogin)
			{
				HCTimer.hcLink.updateTime();
			}
			
			
			//否则直接退出
			_trayIcon.bitmaps = [];
			_trayIcon.menu = null;
			_application.exit();
			
		}
		private function exitSelect(event:Event):void
		{
			exit();
		}

		private function openSelect(event:Event):void
		{
			_window.visible = true;
			_window.orderToFront();

		}

	}

}