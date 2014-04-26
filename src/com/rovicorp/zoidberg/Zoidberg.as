package com.rovicorp.zoidberg {
	import flash.display.MovieClip;
	import flash.events.Event;
	import com.rovicorp.zoidberg.game.DisOrDat;
	import com.rovicorp.zoidberg.net.ManagerRequest;
	import com.rovicorp.zoidberg.game.ScrollingCredits;
	
	public class Zoidberg extends MovieClip {

		public function Zoidberg() {
			ConfigManager.instance;
						
			this.addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
		}
		
		private function onAddedToStage(e:Event) : void {
			this.removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			
			//var search:Search = new Search();
			//addChild(search);
			
			//var disOrDat:DisOrDat = new DisOrDat();
			
			var mgr:ManagerRequest = new ManagerRequest();
			mgr.addEventListener(Event.COMPLETE, gameCreated);
			mgr.createGame(1, 2, 1);
			
			//addChild(disOrDat);
			
			var scrollingCredits:ScrollingCredits = new ScrollingCredits();
			addChild(scrollingCredits);
		}
		
		private function gameCreated(e:Event) {
			var mgr:ManagerRequest = new ManagerRequest();
			mgr.addEventListener(Event.COMPLETE, gameLoaded);
			mgr.loadGames();
		}
		
		private function gameLoaded(e:Event) {
			var mgrRequest:ManagerRequest = e.target as ManagerRequest;
			for each(var game:Object in mgrRequest.data) {
				trace("Player1: " + game.player1.fullname);
				trace("Player2: " + game.player2.fullname);
			}
		}
	}
}
