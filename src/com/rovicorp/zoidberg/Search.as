package com.rovicorp.zoidberg {
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	
	import com.rovicorp.display.ZBClip;
	import com.rovicorp.zoidberg.components.SearchBar;
	import com.rovicorp.net.RestRequest;
	import com.rovicorp.zoidberg.net.SnRRequest;
	import com.rovicorp.utils.Utils;
	import com.rovicorp.zoidberg.components.SearchResult;
	import com.rovicorp.constant.KeyboardConstant;
	import flash.display.Sprite;
	
	public class Search extends ZBClip {
		private const COLUMNS:int = 7;
		private const X_SPACING:int = 20;
		private const Y_SPACING:int = 20;
		private const CARD_HEIGHT:int = 240;
		private const CARD_WIDTH:int = 135;
		
		private var _searchBar:SearchBar;
		private var _results:Sprite;
		
		public function Search() {
			this.addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
		}
		
		private function onAddedToStage(e:Event) : void {
			this.removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			
			_searchBar = new SearchBar();
			_searchBar.x = 115;
			_searchBar.y = 17;
			_searchBar.search_field.addEventListener(KeyboardEvent.KEY_UP, onKeyboardKeyUp);
			addChild(_searchBar);
		}

		private function onKeyboardKeyUp(e:KeyboardEvent) :void {
			if(e.keyCode == KeyboardConstant.ENTER) {
				var entityTypes:Array = ["movie"];
				var includes:Array = ["images"];
				var searchQuery:String = Utils.trim(_searchBar.search_field.text);
				
				var request:SnRRequest = new SnRRequest();
				request.searchVideo(searchQuery, entityTypes, includes);
				request.addEventListener(Event.COMPLETE, onRequestComplete);
			}
		}
		
		private function onRequestComplete(e:Event) : void {
			var request:SnRRequest = e.target as SnRRequest;
			var data:Object = request.data.searchResponse;
			
			_results = new Sprite();
			_results.x = 40;
			_results.y = 50;
			addChild(_results);
			for(var i:int = 0; i < data.results.length; i++) {
				var result:Object = data.results[i];
				var searchResult:SearchResult = new SearchResult(result);
				searchResult.x = (i%COLUMNS) * (X_SPACING + CARD_WIDTH);
				searchResult.y = Math.floor(i/COLUMNS) * (Y_SPACING + CARD_HEIGHT);
				_results.addChild(searchResult);
			}
		}
	}
}
