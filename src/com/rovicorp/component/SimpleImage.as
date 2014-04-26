package com.rovicorp.component {
	import flash.display.Sprite;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Loader;
	import flash.display.LoaderInfo;
	import flash.net.URLRequest;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.ErrorEvent;
	
	public class SimpleImage extends Sprite {
		private var _autoShow:Boolean;
		private var _bitmapData:BitmapData;
		
		public function SimpleImage() {
		}
		
		public function load(url:String, autoShow:Boolean = true) : void {
			_autoShow = autoShow;
			
			var loader:Loader = new Loader();
			loader.contentLoaderInfo.addEventListener(Event.COMPLETE, onComplete);
			loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, onError);
			loader.load(new URLRequest(url));
			
			while(this.numChildren > 0) {
				removeChildAt(0);
			}
		}
		
		function onComplete(e:Event):void
		{
			_bitmapData = Bitmap(LoaderInfo(e.target).content).bitmapData;
			
			if(_autoShow) {
				var bitmap:Bitmap = new Bitmap(_bitmapData);
				addChild(bitmap);
			}
			
			dispatchEvent(new Event(Event.COMPLETE));
		}
		
		private function onError(e:Event) : void {
			dispatchEvent(new ErrorEvent(ErrorEvent.ERROR));
		}
		
		public function resize(widthRestriction:int = 0, heightRestriction:int = 0) : void {
			// TODO
		}
	}
}
