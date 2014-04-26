package com.rovicorp.display {
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.display.DisplayObject;
	
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
		
		protected function destroyIt(displayObject:DisplayObject, nullify:Boolean = true) : void {
			if(this.contains(displayObject)) {
				removeChild(displayObject);
				if(nullify) {
					displayObject = null;
				}
			}
		}
	}
}
