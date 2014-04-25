﻿package com.rovicorp.zoidberg {
	import flash.display.MovieClip;
	import flash.events.Event;
	
	public class Zoidberg extends MovieClip {

		public function Zoidberg() {
			ConfigManager.instance;
			
			this.addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
		}
		
		private function onAddedToStage(e:Event) : void {
			this.removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			
			var search:Search = new Search();
			addChild(search);
		}
	}
}