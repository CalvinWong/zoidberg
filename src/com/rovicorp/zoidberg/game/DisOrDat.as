package com.rovicorp.zoidberg.game {
	import flash.events.Event;
	import flash.events.KeyboardEvent;	
	
	import com.rovicorp.constant.KeyboardConstant;
	import com.rovicorp.display.ZBClip;
	import com.rovicorp.utils.Utils;
	import com.rovicorp.zoidberg.net.MovieBatchRequest;
	
	import com.rovicorp.utils.Utils;
	
	import com.greensock.TweenLite;
	

	public class DisOrDat extends ZBClip {
		private const MAX_ITEMS:int = 15;
		
		private var _assetOne:Object = new Object();
		private var _assetTwo:Object = new Object();
		private var _clueCast:Array = new Array();
		
		private var _inProgress:Boolean = false;
		private var _ids:Array = [4890999, 5794242, 8904844, 4002386, 62213, 8904814, 11375010, 8904876, 125613, 189456, 14379312, 8904817, 98294, 8904882, 2947129];
		
		public function DisOrDat() {
			super();
		}
		
		protected override function init() : void {
			this.x = 25;
			this.y = 50;
			stage.addEventListener(KeyboardEvent.KEY_DOWN, onKeyboardDown);
			
			exampleLoad();
		}
		
		public function exampleLoad() : void {
			var items:Array = Utils.randomize(_ids).slice(-2);
			load(items);
		}
		
		public function load(items:Array) : void {			
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
				var mbRequest:MovieBatchRequest = new MovieBatchRequest();
				mbRequest.addEventListener(Event.COMPLETE, onDataLoaded);
				mbRequest.loadIds(items, includes);
			}
		}
		
		private function onKeyboardDown(e:KeyboardEvent) : void {
			switch(e.keyCode) {
				case KeyboardConstant.LEFT_ARROW:
					clue.textColor = (_assetOne.cast.indexOf(clue.text) > -1) ? 0x00FF00 : 0xFF0000;
					TweenLite.killTweensOf(clue);
					moveOn();
					break;
				case KeyboardConstant.RIGHT_ARROW:
					clue.textColor = (_assetTwo.cast.indexOf(clue.text) > -1) ? 0x00FF00 : 0xFF0000;
					TweenLite.killTweensOf(clue);
					moveOn();
					break;
			}
		}
		
		private function onDataLoaded(e:Event) : void {
			var mbRequest:MovieBatchRequest = e.target as MovieBatchRequest;
			var data:Object = mbRequest.data;
			
			for each(var video:Object in data.videos) {
				if(_assetOne.id == video.ids.cosmoId) {
					for each(var castCredit in video.cast) {
						_assetOne.cast.push(castCredit.name);
						_assetOne.cast.push(castCredit.partName);
					}
					_assetOne.title = video.masterTitle;
				}
				if(_assetTwo.id == video.ids.cosmoId) {
					for each(var castCredit2 in video.cast) {
						_assetTwo.cast.push(castCredit2.name);
						_assetTwo.cast.push(castCredit2.partName);
					}
					_assetTwo.title = video.masterTitle;
				}
			}
			
			start();
		}
		
		private function start() : void {		
			_inProgress = true;
			
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
				TweenLite.to(circle, 1.5, {x:-350, y:-213, alpha: 0, width:1000, height:1000, delay:i*.2, onComplete:destroyIt, onCompleteParams:[circle]});
				addChildAt(circle, 0);
				
				var circle2:ExpandCircle = new ExpandCircle();
				circle2.x = 995;
				circle2.y = 283;
				circle2.width = 10;
				circle2.height = 10;
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
			TweenLite.to(circle, Math.random()*3 + 5, {x:-350, y:-213, alpha: 0, width:1000, height:1000, delay:Math.random(), onComplete:destroyIt, onCompleteParams:[circle]});
			addChildAt(circle, 0);
			
			var circle2:ExpandCircle = new ExpandCircle();
			circle2.x = 995;
			circle2.y = 283;
			circle2.width = 10;
			circle2.height = 10;
			TweenLite.to(circle2, Math.random()*3 + 5, {x:500, y:-213, alpha: 0, width:1000, height:1000, delay:Math.random(), onComplete:destroyIt, onCompleteParams:[circle2]});
			addChildAt(circle2, 0);
			
			if(_inProgress) {
				TweenLite.to(this, Math.random()*3, {onComplete:pulse});
			}
		}
		
		private function nextClue() : void {
			if(_clueCast.length > 0) {
				clue.alpha = 0;
				clue.text = _clueCast.shift();
				clue.textColor = 0xFFFFFF;
				
				TweenLite.to(clue, .25, {alpha:1, onComplete:startFade});
			} else {
				_inProgress = false;
			}
		}
		
		private function startFade() : void {
			TweenLite.to(clue, 3.5, {alpha:.35, onComplete:moveOn});
		}
		
		private function moveOn() : void {
			TweenLite.to(clue, .25, {alpha:0, onComplete:nextClue});
		}
	}
}
