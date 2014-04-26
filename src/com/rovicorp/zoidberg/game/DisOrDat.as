package com.rovicorp.zoidberg.game {
	import flash.events.Event;
	import flash.events.KeyboardEvent;	
	
	import com.rovicorp.constant.KeyboardConstant;
	import com.rovicorp.display.ZBClip;
	import com.rovicorp.utils.Utils;
	import com.rovicorp.zoidberg.net.MetadataRequest;
	
	import com.rovicorp.utils.Utils;
	
	import com.greensock.TweenLite;
	

	public class DisOrDat extends ZBClip implements IGame {
		public static const GAME_TYPE_ID:int = 1;
		public static const GAME_NAME:String = "This or That";
		public static const GAME_INSTRUCTIONS:String = "Two movie titles will appear on the left and right.  A clue in the middle will be associated to one of the movies.  Score points by choosing the correct movie the clue is from.";
		
		private const MAX_ITEMS:int = 15;
		
		private var _assetOne:Object = new Object();
		private var _assetTwo:Object = new Object();
		private var _clueCast:Array = new Array(); 
		
		private var _inProgress:Boolean = false;
		private var _ids:Array = [4890999, 5794242, 8904844, 4002386, 62213, 8904814, 11375010, 8904876, 125613, 189456, 14379312, 8904817, 98294, 8904882, 2947129];
		
		private var _points:int;
		private var _cosmoId:String;
		
		public function DisOrDat() {
			super();
		}
		
		protected override function init() : void {
			this.x = 25;
			this.y = 50;
		}
		
		public function loadGame() : void {
			load([int(_cosmoId), _ids[Utils.randomNumber(_ids.length)]]);
		}
		
		private function load(items:Array) : void {			
			if(!Utils.isNullOrEmpty(items[0]) && !Utils.isNullOrEmpty(items[1])) {
				clue.text = "";
				title_one.text = "";
				title_two.text = "";
				
				_assetOne = new Object();
				_assetTwo = new Object();
				_assetOne.id = Utils.trim(items[0]);
				_assetTwo.id = Utils.trim(items[1]);
				_assetOne.cast = new Array();
				_assetTwo.cast = new Array();				
				
				var includes:Array = ["cast"];
				var mbRequest:MetadataRequest = new MetadataRequest();
				mbRequest.addEventListener(Event.COMPLETE, onDataLoaded);
				mbRequest.getVideos(items, includes);
			}
		}
		
		private function onKeyboardDown(e:KeyboardEvent) : void {
			stage.removeEventListener(KeyboardEvent.KEY_DOWN, onKeyboardDown);
			
			var correct:Boolean;
			switch(e.keyCode) {
				case KeyboardConstant.LEFT_ARROW:
					correct = (_assetOne.cast.indexOf(clue.text) > -1);
					break;
				case KeyboardConstant.RIGHT_ARROW:
					correct = (_assetTwo.cast.indexOf(clue.text) > -1);
					break;
			}
			
			_points += correct ? 1 : -1;
			if(_points <= 0) {
				_points = 0;
			}
			current_score.text = String(_points);
			clue.textColor = correct ? 0x00FF00 : 0xFF0000;
			TweenLite.killTweensOf(clue);
			moveOn();
		}
		
		private function onDataLoaded(e:Event) : void {
			var mbRequest:MetadataRequest = e.target as MetadataRequest;
			var data:Object = mbRequest.data;
			
			for each(var video:Object in data.videos) {
				if(_assetOne.id == video.ids.cosmoId) {
					for each(var castCredit in video.cast) {
						if(castCredit.name != null) {
							_assetOne.cast.push(castCredit.name);
						}
						if(castCredit.partName != null) {
							_assetOne.cast.push(castCredit.partName);
						}
					}
					_assetOne.title = video.masterTitle;
				}
				if(_assetTwo.id == video.ids.cosmoId) {
					for each(var castCredit2 in video.cast) {
						if(castCredit2.name != null) {
							_assetTwo.cast.push(castCredit2.name);
						}
						if(castCredit2.partName != null) {
							_assetTwo.cast.push(castCredit2.partName);
						}
					}
					_assetTwo.title = video.masterTitle;
				}
			}
			
			start();
		}
		
		private function start() : void {		
			_inProgress = true;
			_points = 0;
			
			_clueCast = _clueCast.concat(_assetOne.cast.slice(0, (_assetOne.cast.length > MAX_ITEMS) ? MAX_ITEMS-1 : _assetOne.cast.length-1));
			_clueCast = _clueCast.concat(_assetTwo.cast.slice(0, (_assetTwo.cast.length > MAX_ITEMS) ? MAX_ITEMS-1 : _assetTwo.cast.length-1));
			_clueCast = Utils.randomize(_clueCast);
			
			while(_clueCast.length > MAX_ITEMS) {
				_clueCast = _clueCast.slice(Utils.randomNumber(_clueCast.length-1));
			}
			animateBoardIntro();
		}
		
		private function animateBoardIntro() : void {
			for(var i:int=0; i<3; i++) {
				var circle:ExpandCircle = new ExpandCircle();
				circle.x = 145;
				circle.y = 283;
				circle.width = 10;
				circle.height = 10;
				circle.alpha = Math.random();
				TweenLite.to(circle, 1.5, {x:-350, y:-213, alpha: 0, width:1000, height:1000, delay:i*.2, onComplete:destroyIt, onCompleteParams:[circle]});
				addChildAt(circle, 0);
				
				var circle2:ExpandCircle = new ExpandCircle();
				circle2.x = 995;
				circle2.y = 283;
				circle2.width = 10;
				circle2.height = 10;
				circle2.alpha = Math.random();
				TweenLite.to(circle2, 1.5, {x:500, y:-213, alpha: 0, width:1000, height:1000, delay:i*.2 + .1, onComplete:destroyIt, onCompleteParams:[circle2]});
				addChildAt(circle2, 0);
				
				title_one.alpha = 0;
				title_one.x = 20;
				title_one.text = _assetOne.title;
				TweenLite.to(title_one, 2.5, {alpha: 1, x:0, delay:.25});
				
				title_two.alpha = 0;
				title_two.x = 830;
				title_two.text = _assetTwo.title;
				TweenLite.to(title_two, 2.5, {alpha: 1, x:850, delay:.25});
			}
			
			pulse();
			nextClue();
		}
		
		private function pulse() {
			var circle:ExpandCircle = new ExpandCircle();
			circle.x = 145;
			circle.y = 283;
			circle.width = 10;
			circle.height = 10;
			circle.alpha = Math.random();
			TweenLite.to(circle, Math.random()*3 + 5, {x:-350, y:-213, alpha: 0, width:1000, height:1000, delay:Math.random(), onComplete:destroyIt, onCompleteParams:[circle]});
			addChildAt(circle, 0);
			
			var circle2:ExpandCircle = new ExpandCircle();
			circle2.x = 995;
			circle2.y = 283;
			circle2.width = 10;
			circle2.height = 10;
			circle2.alpha = Math.random();
			TweenLite.to(circle2, Math.random()*3 + 5, {x:500, y:-213, alpha: 0, width:1000, height:1000, delay:Math.random(), onComplete:destroyIt, onCompleteParams:[circle2]});
			addChildAt(circle2, 0);
			
			if(_inProgress) {
				TweenLite.to(this, Math.random()*3, {onComplete:pulse});
			}
		}
		
		private function nextClue() : void {
			if(_clueCast.length > 0) {
				stage.addEventListener(KeyboardEvent.KEY_DOWN, onKeyboardDown);
				clue.alpha = 0;
				clue.text = _clueCast.shift();
				clue.textColor = 0xFFFFFF;
				
				TweenLite.to(clue, .25, {alpha:1, onComplete:startFade});
			} else {
				_inProgress = false;
				onGameComplete();
			}
		}
		
		private function startFade() : void {
			TweenLite.to(clue, 3.5, {alpha:.35, onComplete:moveOn});
		}
		
		private function moveOn() : void {
			TweenLite.to(clue, .25, {alpha:0, onComplete:nextClue});
		}
		
		private function onGameComplete() : void {
			dispatchEvent(new Event(Event.COMPLETE));
		}
		
		public function get points() : int {
			return _points;
		}
		
		public function setCosmoId(s:String) : void {
			_cosmoId = s;
		}
	}
}
