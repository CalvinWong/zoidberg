package com.rovicorp.zoidberg {
	
	public class ConfigManager {
		private static var _intialized:Boolean = false;
		private static var _instance:ConfigManager;
		
		private static var _data:Object;

		public function ConfigManager() {
			_data = new Object();
			
			
			var api:Array = new Array();
			var videoApi:Object = new Object();
			videoApi.endpoint = "/video";
			videoApi.query = "video=";
			api.push(videoApi);
			
			_data.api = api;
			_data.baseUrl = "http://rcs.rovicorp.com/v1.1";
		}
		
		public static function get instance() : ConfigManager {
			if(!_intialized) {
				_instance = new ConfigManager();
			}
			
			return _instance;
		}
		
		public static function get data() : Object {
			return _data;
		}
	}
}
