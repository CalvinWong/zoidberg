package com.rovicorp.zoidberg.components {
	import com.rovicorp.display.ZBClip;
	import com.rovicorp.component.SimpleImage;
	
	public class SearchResult extends ZBClip {
		private var _data:Object;

		public function SearchResult(o:Object) {
			_data = o;
		}
		
		protected override function init() : void {
			field.text = _data.video.masterTitle;
			
			if(_data.video.images != null && _data.video.images.length > 0) {
				var image:SimpleImage = new SimpleImage();
				addChild(image);
				image.load(_data.video.images[0].url);
			}
		}
	}
}
