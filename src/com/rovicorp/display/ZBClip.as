package com.rovicorp.display {
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import com.greensock.TweenLite;
	
	public class ZBClip extends MovieClip {
		public function ZBClip() {
			super();
			this.addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
		}
		
		private function onAddedToStage(e:Event) : void {
			this.removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			init();
		}
		
		protected function init() : void {
		}
		
		protected function hideIt(displayObject:DisplayObject) : void {
			displayObject.visible = false;
		}
		
		protected function destroyIt(displayObject:DisplayObject, nullify:Boolean = true) : void {
			var parentDisplayObject:DisplayObjectContainer = displayObject.parent;
			if(parentDisplayObject.contains(displayObject)) {
				parentDisplayObject.removeChild(displayObject);
				if(nullify) {
					displayObject = null;
				}
			}
		}
		
		protected function destroyChildren(parentDisplayObject:DisplayObjectContainer, nullify:Boolean = true, fancy:Boolean = false) : void {
			for(var i:int=0; i<parentDisplayObject.numChildren; i++) {
				var displayObject:DisplayObject = parentDisplayObject.getChildAt(i);
				
				if(fancy) {
					TweenLite.to(displayObject, .15, {alpha:0, delay:i/100, onComplete:destroyIt, onCompleteParams:[displayObject]});
				} else
				{
					destroyIt(displayObject);
				}
			}
		}
	}
}
