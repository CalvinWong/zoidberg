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
		private var _gameInstructions:GameInstructions;
		
		private var _games:Array = [DisOrDat, ScrollingCredits];
		private var _currentGame:IGame;
		private var _currentGameId:int;
		private var _gamesPlayed:int;

		public function Zoidberg() {
			ConfigManager.instance;
						
			this.addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
		}
		
		private function onAddedToStage(e:Event) : void {
			this.removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			
			_loginScreen = new LoginScreen();
			_loginScreen.addEventListener(LoginScreen.USER_SELECTED, onUserSelected);
			addChildAt(_loginScreen, 0);
			
			_welcomeScreen = new Welcome();
			_welcomeScreen.visible = false;
			addChildAt(_welcomeScreen, 0);
			
			_searchScreen = new Search();
			_searchScreen.visible = false;
			_searchScreen.addEventListener(GenericDataEvent.DATA_SELECTED, onDataSelected);
			addChildAt(_searchScreen, 0);
			
			_gameInstructions = new GameInstructions();
			_gameInstructions.alpha = 0;
			_gameInstructions.x = 83;
			_gameInstructions.y = 105;
			_gameInstructions.visible = false;
			addChild(_gameInstructions);
		}
		
		private function onUserSelected(e:Event) : void {
			intro.visible = false;
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
			TweenLite.to(_searchScreen, .25, {alpha:0, onComplete:hideIt, onCompleteParams:[_searchScreen]});
			
			var cosmoId = e.data.video.ids.cosmoId;
			
			var Game:Class = _games[_gamesPlayed%_games.length];
			_currentGame = new Game();
			_currentGame.setCosmoId(cosmoId);
			
			_gameInstructions.game_name.text = Game.GAME_NAME;
			_gameInstructions.game_instructions.text = Game.GAME_INSTRUCTIONS;
			_gameInstructions.visible = true;
			TweenLite.to(_gameInstructions, 1, {alpha:100});
			
			var mgr:ManagerRequest = new ManagerRequest();
			mgr.addEventListener(Event.COMPLETE, onGameCreated);
			mgr.createSinglePlayerGame(ConfigManager.user.id, Game.GAME_TYPE_ID);
		}
		
		private function onGameCreated(e:Event) {
			_currentGameId = (e.target as ManagerRequest).data.id;
			TweenLite.to(_gameInstructions, 1, {alpha: 0, delay: 5, onComplete:onStartGame});
		}
		
		private function onStartGame() : void {
			hideIt(_gameInstructions);
			
			addChild(_currentGame as DisplayObject);
			_currentGame.addEventListener(Event.COMPLETE, onGameCompleted);
			(_currentGame as IGame).loadGame();
		}
		
		private function onGameCompleted(e:Event) : void {
			var game = e.target;
			var mgr:ManagerRequest = new ManagerRequest();
			mgr.addEventListener(Event.COMPLETE, onScoreRecorded);
			mgr.finishSinglePlayerGame(_currentGameId, game.points);
			
			TweenLite.to(e.target, .5, {alpha:0, onComplete:destroyIt, onCompleteParams:[e.target]});
			_gamesPlayed++;
		}
		
		private function onScoreRecorded(e:Event) : void {
			showSearch();
		}
	}
}
