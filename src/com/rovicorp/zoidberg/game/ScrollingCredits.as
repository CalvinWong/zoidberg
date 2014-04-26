package com.rovicorp.zoidberg.game {
	import flash.events.Event;
	
	import com.rovicorp.display.ZBClip;
	import com.rovicorp.utils.Utils;
	import com.rovicorp.zoidberg.net.MovieBatchRequest;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import com.greensock.TweenLite;
	
	import com.greensock.easing.Linear;
	
	public class ScrollingCredits extends ZBClip {
		private const MAX_ITEMS:int = 10;
		
		private var _assetOne:Object = new Object();
		private var _clueCast:Array = new Array();
		
		private var _inProgress:Boolean = false;
		private var _ids:Array = [4890999, 5794242, 8904844, 4002386, 62213, 8904814, 11375010, 8904876, 125613, 189456, 14379312, 8904817, 98294, 8904882, 2947129];
		
		private var _data:Object;
		private var _keywords:Array;
		private var _invalidKeywords:Array;
		
		private var _movieTitle:TextField;
		
		public function ScrollingCredits() {
			super();
		}
		
		protected override function init() : void {
			_movieTitle = new TextField();
			_movieTitle.selectable = false;
			addChild(_movieTitle);
			
			exampleLoad();
		}

		
		private function exampleLoad() : void {
			var ids:Array = Utils.randomize(_ids).slice(0,5);
			load(ids);
		}
		
		public function load(cosmoIds:Array) : void {
			_inProgress = false;
			
			_data = new Object();
			var mainId:String = cosmoIds.shift();
			_data.cosmoId = mainId;
			cosmoIds.unshift(mainId);
			
			var includes:Array = ["cast"];
			var scRequest:MovieBatchRequest = new MovieBatchRequest();
			scRequest.addEventListener(Event.COMPLETE, onDataLoaded);
			scRequest.loadIds(cosmoIds, includes);
		}
		
		private function onDataLoaded(e:Event) : void {
			var mbRequest:MovieBatchRequest = e.target as MovieBatchRequest;
			var data:Object = mbRequest.data;
			
			_data.validCredits = new Array();
			_data.invalidCredits = new Array();
			for each(var video:Object in data.videos) {
				var invalidCredits:Array = new Array();
				var validCredits:Array = new Array();
				
				if(_data.cosmoId == video.ids.cosmoId) {
					for each(var castCredit in video.cast) {
						if(castCredit.partName != null && validCredits.length < MAX_ITEMS) {
							validCredits.push(castCredit.partName);
						}
					}
					_data.title = video.masterTitle;
				}
				else {
					for each(var castCredit2 in video.cast) {
						if(castCredit2.partName != null && invalidCredits.length < MAX_ITEMS) {
							invalidCredits.push(castCredit2.partName);
						}
					}
				}
				_data.validCredits = _data.validCredits.concat(validCredits);
				_data.invalidCredits = _data.invalidCredits.concat(invalidCredits);
			}
			
			start();
		}
		
		private function start() : void {		
			_inProgress = true;
			
			_keywords = _data.validCredits.concat();
			if(_keywords.length > MAX_ITEMS) {
				_keywords = Utils.randomize(_keywords.slice(0, MAX_ITEMS));
			}
			_invalidKeywords = Utils.randomize(_data.invalidCredits);
			_invalidKeywords = _invalidKeywords.slice(0, (_keywords.length*3 > _invalidKeywords.length) ? _invalidKeywords.length : _keywords.length*3);
			
			animateBoardIntro();
		}
		
		private function animateBoardIntro() : void {
			_movieTitle.alpha = 0;
			_movieTitle.text = _data.title;
			_movieTitle.setTextFormat(new TextFormat("Arial", 72, 0xFFFFFF));
			_movieTitle.width = _movieTitle.textWidth + 20;
			_movieTitle.height = _movieTitle.textHeight;
			TweenLite.to(_movieTitle, 3, {alpha:1, onComplete:scrollKeywords});
		}
		
		private function scrollKeywords() : void {
			for(var k=0; k<_invalidKeywords.length; k++) {
				var invalidKeyword:CreditName = new CreditName(_invalidKeywords[k]);
				addChild(invalidKeyword);
				invalidKeyword.x = -invalidKeyword.width;
				invalidKeyword.y = Utils.randomNumber(550) + 75;
				invalidKeyword.alpha = .2 + Utils.randomNumber(35)/100;
				TweenLite.to(invalidKeyword, 10 + Utils.randomNumber(40), {x:1200, ease:Linear.easeNone, delay:Utils.randomNumber(45) + Utils.randomNumber(99)/100, onComplete:destroyIt, onCompleteParams:[invalidKeyword, false]})
				
			}
			
			for(var i=0; i<_keywords.length; i++) {
				var validKeyword:CreditName = new CreditName(_keywords[i], true);
				addChild(validKeyword);
				validKeyword.x = -validKeyword.width;
				validKeyword.y = Utils.randomNumber(550) + 75;
				validKeyword.alpha = .25 + Utils.randomNumber(45)/100;
				TweenLite.to(validKeyword, 10 + Utils.randomNumber(40), {x:1200, ease:Linear.easeNone, delay: Utils.randomNumber(45) + Utils.randomNumber(99)/100, onComplete:destroyIt, onCompleteParams:[validKeyword, false]})
			}
		}
	}
}
