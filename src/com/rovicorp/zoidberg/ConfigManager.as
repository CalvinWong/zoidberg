package com.rovicorp.zoidberg {
	
	public class ConfigManager {
		private static var _intialized:Boolean = false;
		private static var _instance:ConfigManager;
		
		private static var _data:Object;
		private static var _persistence:Object;
		
		public function ConfigManager() {
			_data = new Object();
			_persistence = new Object();
			
			_data.baseUrl = "http://rcs.rovicorp.com/v1.1";
			_persistence.baseUrl = "http://stormy-stream-2810.herokuapp.com"
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
		
		public static function get persistence() : Object {
			return _persistence;
		}
	}
}
