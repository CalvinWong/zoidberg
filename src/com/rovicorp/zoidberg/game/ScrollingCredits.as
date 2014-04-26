package com.rovicorp.zoidberg.game {
	import flash.events.Event;
	
	import com.rovicorp.display.ZBClip;
	import com.rovicorp.utils.Utils;
	import com.rovicorp.zoidberg.net.MetadataRequest;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import com.greensock.TweenLite;
	
	import com.greensock.easing.Linear;
	
	public class ScrollingCredits extends ZBClip implements IGame {
		public static const GAME_TYPE_ID:int = 2;
		private const MAX_ITEMS:int = 10;
		
		private var _assetOne:Object = new Object();
		private var _clueCast:Array = new Array();
		
		private var _inProgress:Boolean = false;
		private var _ids:Array = [4890999, 5794242, 8904844, 4002386, 62213, 8904814, 11375010, 8904876, 125613, 189456, 14379312, 8904817, 98294, 8904882, 2947129];
		
		private var _data:Object;
		private var _keywords:Array;
		private var _invalidKeywords:Array;
		
		private var _movieTitle:TextField;
		private var _totalPoints:int;
		
		public function ScrollingCredits() {
			super();
		}
		
		protected override function init() : void {
			_movieTitle = new TextField();
			_movieTitle.selectable = false;
			addChild(_movieTitle);
		}

		
		private function exampleLoad() : void {
			var ids:Array = Utils.randomize(_ids).slice(0,5);
			configure(_ids[6]);
		}
		
		public function configure(cosmoId:String) : void {
			_data = new Object();
			_data.cosmoId = cosmoId;
			load([cosmoId].concat(_ids));
		}
		
		private function load(cosmoIds:Array) : void {
			_inProgress = false;
			var includes:Array = ["cast"];
			var scRequest:MetadataRequest = new MetadataRequest();
			scRequest.addEventListener(Event.COMPLETE, onDataLoaded);
			scRequest.getVideos(cosmoIds, includes);
		}
		
		private function onDataLoaded(e:Event) : void {
			var mbRequest:MetadataRequest = e.target as MetadataRequest;
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
			_totalPoints = 0;
			
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
			var longestTime:Number = 0;
			var tweenTime:Number = 0;
			var delayTime:Number = 0;
			
			for(var k=0; k<_invalidKeywords.length; k++) {
				var invalidKeyword:CreditName = new CreditName(_invalidKeywords[k]);
				addChild(invalidKeyword);
				invalidKeyword.x = -invalidKeyword.width;
				invalidKeyword.y = Utils.randomNumber(550) + 75;
				invalidKeyword.alpha = .2 + Utils.randomNumber(35)/100;
				tweenTime = 10 + Utils.randomNumber(40);
				delayTime = Utils.randomNumber(45) + Utils.randomNumber(99)/100;
				TweenLite.to(invalidKeyword, tweenTime, {x:1200, ease:Linear.easeNone, delay:delayTime, onComplete:destroyIt, onCompleteParams:[invalidKeyword, false]})
				
				if(longestTime < tweenTime + delayTime) {
					longestTime = tweenTime + delayTime;
				}
			}
			
			for(var i=0; i<_keywords.length; i++) {
				var validKeyword:CreditName = new CreditName(_keywords[i], true);
				addChild(validKeyword);
				validKeyword.x = -validKeyword.width;
				validKeyword.y = Utils.randomNumber(550) + 75;
				validKeyword.alpha = .25 + Utils.randomNumber(45)/100;
				validKeyword.addEventListener(Event.SELECT, onPointScored);
				tweenTime = 10 + Utils.randomNumber(40);
				delayTime = Utils.randomNumber(45) + Utils.randomNumber(99)/100;
				TweenLite.to(validKeyword, 10 + Utils.randomNumber(40), {x:1200, ease:Linear.easeNone, delay: Utils.randomNumber(45) + Utils.randomNumber(99)/100, onComplete:destroyIt, onCompleteParams:[validKeyword, false]})
					
				if(longestTime < tweenTime + delayTime) {
					longestTime = tweenTime + delayTime;
				}
			}
			
			longestTime += 1;
			TweenLite.to(this, 1, {alpha:0, delay: longestTime, onComplete:onGameFinished});
		}
		
		private function onPointScored(e:Event) : void {
			_totalPoints++;
		}
		
		private function onGameFinished() : void {
			dispatchEvent(new Event(Event.COMPLETE));
		}
		
		public function get points() : int {
			return _totalPoints;
		}
	}
}
