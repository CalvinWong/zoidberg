package com.rovicorp.zoidberg.net {
	import com.rovicorp.zoidberg.ConfigManager;
	import com.rovicorp.net.RestRequest;
	
	public class MovieBatchRequest extends RestRequest {

		public function MovieBatchRequest() {
			super(ConfigManager.data.baseUrl, "&apikey=123");
		}
		
		public function loadIds(cosmoIds:Array, includes:Array) : void {
			var endpoint:String = "/video/batch?cosmoid=" + cosmoIds.join(",") + "&include=" + includes.join(",");
			super.load(endpoint);
		}
	}
}
