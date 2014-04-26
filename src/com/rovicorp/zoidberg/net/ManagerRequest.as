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
		
		public function createGame(player1_id:int, player2_id:int, game_id:int) : void {
			var endpoint:String = "/games/create/" + player1_id + "/" + player2_id + "/" + game_id;
			super.load(endpoint);
		}
	}
}
