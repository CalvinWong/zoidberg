package com.rovicorp.zoidberg.net {
	import com.rovicorp.net.RestRequest;
	
	public class DisOrDatRequest extends RestRequest {

		public function DisOrDatRequest() {
			super();
		}
		
		public function loadIds(cosmoIdOne:String, cosmoIdTwo:String) : void {
			var endpoint:String = "/video/batch?cosmoid=" + cosmoIdOne + "," + cosmoIdTwo + "&include=cast";
			super.load(endpoint);
		}
	}
}
