package com.rovicorp.zoidberg.net {
	import com.rovicorp.zoidberg.ConfigManager;
	import com.rovicorp.net.RestRequest;
	
	public class ManagerRequest extends RestRequest {

		public function ManagerRequest() {
			super(ConfigManager.persistence.baseUrl, "");
		}
		
		public function loadPlayerIds() : void {
			var endpoint:String = "/video/batch?cosmoid=" + cosmoIdOne + "," + cosmoIdTwo + "&include=cast";
			super.load(endpoint);
		}
	}
}
