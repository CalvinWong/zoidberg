package com.rovicorp.display {
	import flash.display.MovieClip;
	import flash.events.Event;
	
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
	}
}
