package com.rovicorp.zoidberg.game {
	import flash.events.Event;
	import flash.events.KeyboardEvent;	
	
	import com.rovicorp.constant.KeyboardConstant;
	import com.rovicorp.display.ZBClip;
	import com.rovicorp.utils.Utils;
	import com.rovicorp.zoidberg.net.DisOrDatRequest;
	
	import com.rovicorp.utils.Utils;
	

	public class DisOrDat extends ZBClip {
		private const MAX_ITEMS = 15;
		
		private var _assetOne:Object = new Object();
		private var _assetTwo:Object = new Object();
		private var _clueCast:Array = new Array();
		
		public function DisOrDat() {
			super();
			
			this.x = 25;
			this.y = 50;
		}
		
		protected override function init() : void {
			lookUpIds();			
			
			stage.addEventListener(KeyboardEvent.KEY_DOWN, onKeyboardDown);
		}
		
		private function onKeyboardDown(e:KeyboardEvent) : void {
			switch(e.keyCode) {
				case KeyboardConstant.ENTER:
					if(_clueCast.length <= 0) {
						lookUpIds();
					}
					else {
						nextClue();
					}
					break;
				case KeyboardConstant.LEFT_ARROW:
					clue.textColor = (_assetOne.cast.indexOf(clue.text) > -1) ? 0x00FF00 : 0xFF0000;
					break;
				case KeyboardConstant.RIGHT_ARROW:
					clue.textColor = (_assetTwo.cast.indexOf(clue.text) > -1) ? 0x00FF00 : 0xFF0000;
					break;
			}
		}
		
		private function lookUpIds() : void {
			clue.text = "";
			
			_assetOne = new Object();
			_assetTwo = new Object();
			_assetOne.id = Utils.trim(cosmo_id_one.text);
			_assetTwo.id = Utils.trim(cosmo_id_two.text);
			_assetOne.cast = new Array();
			_assetTwo.cast = new Array();
			
			if(!Utils.isNullOrEmpty(_assetOne.id) && !Utils.isNullOrEmpty(_assetTwo.id)) {
				var dodRequest:DisOrDatRequest = new DisOrDatRequest();
				dodRequest.addEventListener(Event.COMPLETE, dataLoaded);
				dodRequest.lookUp(_assetOne.id, _assetTwo.id);
			}
		}
		
		private function dataLoaded(e:Event) : void {
			var dodRequest:DisOrDatRequest = e.target as DisOrDatRequest;
			
			var data:Object = dodRequest.data;			
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
			clue.text = "";
			title_one.text = _assetOne.title;
			title_two.text = _assetTwo.title;
			
			_clueCast = Utils.randomize(_assetTwo.cast.concat(_assetOne.cast));
			
			
			while(_clueCast.length > MAX_ITEMS) {
				_clueCast = _clueCast.slice(Utils.randomNumber(_clueCast.length-1));
			}
			nextClue();
		}
		
		private function nextClue() : void {
			if(_clueCast.length > 0) {
				clue.textColor = 0x000000;
				clue.text = _clueCast.shift();
			}
		}
	}
}
