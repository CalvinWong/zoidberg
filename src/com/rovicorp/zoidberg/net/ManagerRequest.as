package com.rovicorp.zoidberg.net {
	import com.rovicorp.zoidberg.ConfigManager;
	import com.rovicorp.net.RestRequest;
	
	public class ManagerRequest extends RestRequest {

		public function ManagerRequest() {
			super(ConfigManager.persistence.baseUrl);
		}
		
		public function loadPlayers() : void {
			var endpoint:String = "/players";
			super.load(endpoint);
		}
		
		public function loadPlayer(id:int) : void {
			var endpoint:String = "/player/id/" + id;
			super.load(endpoint);
		}
		
		public function createPlayer(name:String) : void {
			var endpoint:String = "/player/create/" + name;
			super.load(endpoint);
		}
		
		public function loadGames() : void {
			var endpoint:String = "/games";
			super.load(endpoint);
		}
		
		public function loadGame(id:int) : void {
			var endpoint:String = "/game/" + id;
			super.load(endpoint);
		}
		/*
		public function createTwoPlayerGame(player1_id:int, player2_id:int, game_id:int) : void {
			var endpoint:String = "/game/create/" + player1_id + "/" + player2_id + "/" + game_id;
			super.load(endpoint);
		}
		*/
		
		public function finishSinglePlayerGame(gameId:int, score:int) : void {
			var endpoint:String = "/game/" + gameId + "/finish/" + score;
			super.load(endpoint);
		}
		
		public function createSinglePlayerGame(playerId:int, gameTypeId:int) : void {
			var endpoint:String = "/game/create/" + playerId + "/" + gameTypeId;
			super.load(endpoint);
		}
	}
}
