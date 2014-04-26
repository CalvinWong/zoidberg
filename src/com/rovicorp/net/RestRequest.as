package com.rovicorp.net {
	import com.rovicorp.zoidberg.ConfigManager;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	
	public class RestRequest extends EventDispatcher {		
		private var _baseUrl:String;
		private var _apiKey:String;
		private var _urlLoader:URLLoader;
		
		public function RestRequest() {
			_baseUrl = ConfigManager.data.baseUrl;
			_apiKey = "&apikey=123";
		}
		
		public function load(endpoint:String) : void {
			var url:String = _baseUrl + endpoint + _apiKey;
			//trace("loading " + url);
			
			_urlLoader = new URLLoader();
			_urlLoader.addEventListener(Event.COMPLETE, onComplete);
			_urlLoader.load(new URLRequest(url));
		}
		
		private function onComplete(e:Event) : void {
			//trace("loaded " + _urlLoader.data);
			this.dispatchEvent(new Event(Event.COMPLETE));
		}
		
		public function get data() : Object {
			return JSON.parse(_urlLoader.data);
		}
	}	
}
