package com.rovicorp.zoidberg {
	import flash.events.Event;
	import com.rovicorp.zoidberg.game.DisOrDat;
	import com.rovicorp.zoidberg.net.ManagerRequest;
	import com.rovicorp.zoidberg.game.ScrollingCredits;
	import com.greensock.TweenLite;
	import com.rovicorp.display.ZBClip;
	
	public class Zoidberg extends ZBClip {
		private var _loginScreen:LoginScreen;
		private var _welcomeScreen:Welcome;
		private var _searchScreen:Search;

		public function Zoidberg() {
			ConfigManager.instance;
						
			this.addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
		}
		
		private function onAddedToStage(e:Event) : void {
			this.removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			
			//var disOrDat:DisOrDat = new DisOrDat();
			
			//var mgr:ManagerRequest = new ManagerRequest();
			//mgr.addEventListener(Event.COMPLETE, gameCreated);
			//mgr.createGame(1, 2, 1);
			
			//addChild(disOrDat);
			
			//var scrollingCredits:ScrollingCredits = new ScrollingCredits();
			//addChild(scrollingCredits);
			
			_loginScreen = new LoginScreen();
			_loginScreen.addEventListener(LoginScreen.USER_SELECTED, onUserSelected);
			addChild(_loginScreen);
			
			_welcomeScreen = new Welcome();
			_welcomeScreen.visible = false;
			addChild(_welcomeScreen);
			
			_searchScreen = new Search();
			_searchScreen.visible = false;
			addChild(_searchScreen);
		}
		
		private function onUserSelected(e:Event) : void {
			TweenLite.to(_loginScreen, .5, {alpha:0, onComplete:hideIt, onCompleteParams:[_loginScreen]});
			
			_welcomeScreen.alpha = 0;
			_welcomeScreen.visible = true;
			_welcomeScreen.onUserLoaded(null); // spoof event loaded
			TweenLite.to(_welcomeScreen, .75, {alpha:1, onComplete:finishWelcome});
		}
		
		private function finishWelcome() : void {
			TweenLite.to(_welcomeScreen, .75, {alpha:0, delay:5});
			
			_searchScreen.alpha = 0;
			_searchScreen.visible = true;
			TweenLite.to(_searchScreen, 1, {alpha:1, delay:5});
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
