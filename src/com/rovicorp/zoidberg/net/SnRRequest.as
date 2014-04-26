package com.rovicorp.zoidberg.net {
	import com.rovicorp.net.RestRequest;
	import com.rovicorp.zoidberg.ConfigManager;
	
	public class SnRRequest extends RestRequest{

		public function SnRRequest() {
			super(ConfigManager.search.baseUrl, "&apikey=123");
		}
		
		public function searchVideo(query:String, entityTypes:Array, includes:Array) : void {
			var endpoint:String = "/video/search?query=" + query + "&entitytype=" + entityTypes.join(",") + "&include=" + includes.join(",") + "&limit=20&formatid=42&format=json";
			super.load(endpoint);
		}
	}
}