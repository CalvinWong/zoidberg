package com.rovicorp.net {
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.events.Event;
	import flash.events.ErrorEvent;
	import flash.events.IOErrorEvent;
	import flash.events.EventDispatcher;
	
	public class RestRequest extends EventDispatcher {		
		private var _baseUrl:String;
		private var _apiKey:String;
		private var _urlLoader:URLLoader;
		
		public function RestRequest(baseUrl:String, apiKey:String = "") {
			_apiKey = apiKey
			_baseUrl = baseUrl;
		}
		
		protected function load(endpoint:String) : void {
			var url:String = _baseUrl + endpoint + _apiKey;
			
			_urlLoader = new URLLoader();
			_urlLoader.addEventListener(Event.COMPLETE, onComplete);
			_urlLoader.addEventListener(IOErrorEvent.IO_ERROR, onIOError);
			_urlLoader.load(new URLRequest(url));
		}
		
		private function onIOError(e:Event) : void {
			dispatchEvent(new ErrorEvent(ErrorEvent.ERROR));
		}
		
		private function onComplete(e:Event) : void {
			dispatchEvent(new Event(Event.COMPLETE));
		}
		
		public function get data() : Object {
			return JSON.parse(_urlLoader.data);
		}
	}	
}
