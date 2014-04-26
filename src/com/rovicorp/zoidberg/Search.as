package com.rovicorp.zoidberg {
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	
	import com.rovicorp.display.ZBClip;
	import com.rovicorp.zoidberg.components.SearchBar;
	import com.rovicorp.net.RestRequest;
	
	public class Search extends ZBClip {
		private const ENTER_KEY:int = 13;
		
		private var _searchBar:SearchBar;
		private var _debug:Debug;
		
		public function Search() {
			this.addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
		}
		
		private function onAddedToStage(e:Event) : void {
			this.removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			
			_debug = new Debug();
			_debug.y = 70;
			_debug.x = 10;
			addChild(_debug);
			
			_searchBar = new SearchBar();
			_searchBar.x = 115;
			_searchBar.y = 17;
			_searchBar.search_field.addEventListener(KeyboardEvent.KEY_UP, onKeyboardKeyUp);
			addChild(_searchBar);
		}

		private function onKeyboardKeyUp(e:KeyboardEvent) :void {
			if(e.charCode == ENTER_KEY) {
				var request:RestRequest = new RestRequest();
				request.load("/video/info?video="+_searchBar.search_field.text);
				request.addEventListener(Event.COMPLETE, onRequestComplete);
			}
		}
		
		private function onRequestComplete(e:Event) : void {
			var restRequest:RestRequest = e.target as RestRequest;
			trace("onRequestComplete " + restRequest.data);
			_debug.field.text = restRequest.data.toString();
		}
	}
}
