package com.rovicorp.zoidberg {
	import flash.events.Event;
	import com.rovicorp.zoidberg.game.DisOrDat;
	import com.rovicorp.zoidberg.net.ManagerRequest;
	import com.rovicorp.zoidberg.game.ScrollingCredits;
	import com.rovicorp.zoidberg.game.IGame;
	import com.greensock.TweenLite;
	import com.rovicorp.display.ZBClip;
	import com.rovicorp.events.GenericDataEvent;
	import com.rovicorp.utils.Utils;
	import flash.display.DisplayObject;
	
	public class Zoidberg extends ZBClip {
		private var _loginScreen:LoginScreen;
		private var _welcomeScreen:Welcome;
		private var _searchScreen:Search;
		
		private var _games:Array = [ScrollingCredits];
		private var _currentGame:IGame;
		private var _currentGameId:int;

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
			

			
			_loginScreen = new LoginScreen();
			_loginScreen.addEventListener(LoginScreen.USER_SELECTED, onUserSelected);
			addChild(_loginScreen);
			
			_welcomeScreen = new Welcome();
			_welcomeScreen.visible = false;
			addChild(_welcomeScreen);
			
			_searchScreen = new Search();
			_searchScreen.visible = false;
			_searchScreen.addEventListener(GenericDataEvent.DATA_SELECTED, onDataSelected);
			addChild(_searchScreen);
			
			//_loginScreen.visible = false;
			//showSearch();
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
			
			showSearch(5);
		}
		
		private function showSearch(delay:int = 0) : void {
			_searchScreen.alpha = 0;
			_searchScreen.visible = true;
			TweenLite.to(_searchScreen, 1, {alpha:1, delay:delay});
		}
		
		private function onDataSelected(e:GenericDataEvent) : void {
			TweenLite.to(_searchScreen, 1, {alpha:0, onComplete:hideIt, onCompleteParams:[_searchScreen]});
			
			var cosmoId = e.data.video.ids.cosmoId;
			
			var Game:Class = _games[Utils.randomNumber(_games.length-1)];
			_currentGame = new Game();
			
			var mgr:ManagerRequest = new ManagerRequest();
			mgr.addEventListener(Event.COMPLETE, onGameCreated);
			mgr.createSinglePlayerGame(ConfigManager.user.id, Game.GAME_TYPE_ID);
			
			addChild(_currentGame as DisplayObject);
			(_currentGame as IGame).configure(cosmoId);
			_currentGame.addEventListener(Event.COMPLETE, onGameCompleted);
		}
		
		private function onGameCompleted(e:Event) : void {
			var game = e.target;
			var mgr:ManagerRequest = new ManagerRequest();
			mgr.addEventListener(Event.COMPLETE, onScoreRecorded);
			mgr.finishSinglePlayerGame(_currentGameId, game.points);
			
			TweenLite.to(e.target, .5, {alpha:0, onComplete:destroyIt, onCompleteParams:[e.target]});
		}
		
		private function onGameCreated(e:Event) {
			_currentGameId = (e.target as ManagerRequest).data.id;
		}
		
		private function onScoreRecorded(e:Event) : void {
			showSearch();
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
