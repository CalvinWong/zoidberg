package com.rovicorp.zoidberg {
	
	public class ConfigManager {
		private static var _intialized:Boolean = false;
		private static var _instance:ConfigManager;
		
		private static var _data:Object;
		private static var _persistence:Object;
		private static var _user:Object;
		private static var _search:Object;
		
		public function ConfigManager() {
			_data = new Object();
			_persistence = new Object();
			_user = new Object();
			_search = new Object();
			
			_data.baseUrl = "http://rcs.rovicorp.com/v1.1";
			_persistence.baseUrl = "http://stormy-stream-2810.herokuapp.com";
			_search.baseUrl = "http://snr-g.rovicorp.com/snr/v2.1";
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
		
		public static function get user() : Object {
			return _user;
		}
		
		public static function set user(o:Object) : void {
			_user = o;
		}
		
		public static function get search() : Object {
			return _search;
		}
	}
}
