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
	import flash.events.MouseEvent;
	import com.rovicorp.events.GenericDataEvent;
	
	public class Search extends ZBClip {
		private const COLUMNS:int = 7;
		private const X_SPACING:int = 25;
		private const Y_SPACING:int = 20;
		
		private var _searchBar:SearchBar;
		private var _results:Sprite;
		
		public function Search() {
		}
		
		protected override function init() : void {
			_results = new Sprite();
			_results.x = 50;
			_results.y = 100;
			addChild(_results);			
			
			_searchBar = new SearchBar();
			_searchBar.x = 315;
			_searchBar.y = 25;
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
				
				destroyChildren(_results, true, true);
			}
		}
		
		private function onRequestComplete(e:Event) : void {
			var request:SnRRequest = e.target as SnRRequest;
			var data:Object = request.data.searchResponse;
			
			var imageResults:Array = new Array();
			for(var k:int = 0; k<data.results.length; k++) {
				if(data.results[k].video.images != null && data.results[k].video.images.length > 0) {
					imageResults.push(data.results[k]);
				}
			}
			
			var fourteenOrLess:int = (imageResults.length > 14) ? 14 : imageResults.length;
			for(var i:int = 0; i < fourteenOrLess; i++) {
				var result:Object = imageResults[i];
				var searchResult:SearchResult = new SearchResult(result);
				searchResult.x = (i%COLUMNS) * (X_SPACING + SearchResult.CARD_WIDTH);
				searchResult.y = Math.floor(i/COLUMNS) * (Y_SPACING + SearchResult.CARD_HEIGHT);
				searchResult.mouseChildren = false;
				searchResult.addEventListener(MouseEvent.CLICK, onResultSelected);
				_results.addChild(searchResult);
			}
		}
		
		private function onResultSelected(e:MouseEvent) : void {
			var searchResult:SearchResult = e.target as SearchResult;
			dispatchEvent(new GenericDataEvent(GenericDataEvent.DATA_SELECTED, searchResult.data));
		}
	}
}
