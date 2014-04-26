package com.rovicorp.zoidberg.components {
	import com.rovicorp.display.ZBClip;
	import com.rovicorp.component.SimpleImage;
	import com.greensock.TweenLite;
	import flash.events.Event;
	import flash.display.Sprite;
	
	public class SearchResult extends ZBClip {
		public static const CARD_HEIGHT:int = 240;
		public static const CARD_WIDTH:int = 135;
		private var _data:Object;

		public function SearchResult(o:Object) {
			_data = o;
			
			this.graphics.beginFill(0x000000, 0);
			this.graphics.drawRect(0, 0, CARD_WIDTH, CARD_HEIGHT);
			this.graphics.endFill();
			
			this.mouseChildren = false;
		}
		
		protected override function init() : void {
			field.text = _data.video.masterTitle;
			
			if(_data.video.images != null && _data.video.images.length > 0) {
				var image:SimpleImage = new SimpleImage();
				image.addEventListener(Event.COMPLETE, fadeImageIn);
				image.load(_data.video.images[0].url);
			} else {
				var placeholder:Sprite = new Sprite();
				placeholder.graphics.beginFill(0xFFFFFF, .2);
				placeholder.graphics.drawRect(0, 0, 120, 180);
				placeholder.graphics.endFill();
				addChild(placeholder);
			}
		}
		
		private function fadeImageIn(e:Event) : void {
			var image:SimpleImage = e.target as SimpleImage;
			image.alpha = 0;
			TweenLite.to(image, .15, {alpha:1});
			addChild(image);
		}
		
		public function get data() : Object {
			return _data;
		}
	}
}
