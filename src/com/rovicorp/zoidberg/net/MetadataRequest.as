package com.rovicorp.zoidberg.net {
	import com.rovicorp.zoidberg.ConfigManager;
	import com.rovicorp.net.RestRequest;
	
	public class MetadataRequest extends RestRequest {

		public function MetadataRequest() {
			super(ConfigManager.data.baseUrl, "&apikey=123");
		}
		
		public function getVideos(cosmoIds:Array, includes:Array) : void {
			var endpoint:String = "/video/batch?cosmoid=" + cosmoIds.join(",") + "&include=" + includes.join(",");
			super.load(endpoint);
		}
	}
}
