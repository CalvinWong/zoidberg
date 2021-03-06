﻿package com.rovicorp.zoidberg.net {
	import com.rovicorp.zoidberg.ConfigManager;
	import com.rovicorp.net.RestRequest;
	
	public class DisOrDatRequest extends RestRequest {

		public function DisOrDatRequest() {
			super(ConfigManager.data.baseUrl, "&apikey=123");
		}
		
		public function loadIds(cosmoIdOne:String, cosmoIdTwo:String) : void {
			var endpoint:String = "/video/batch?cosmoid=" + cosmoIdOne + "," + cosmoIdTwo + "&include=cast";
			super.load(endpoint);
		}
	}
}
