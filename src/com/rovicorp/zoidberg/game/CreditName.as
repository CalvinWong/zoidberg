package com.rovicorp.zoidberg.game {
	import com.rovicorp.display.ZBClip;
	import flash.text.TextField;
	import flash.text.TextFormat;
	
	import com.rovicorp.utils.Utils;
	import flash.events.MouseEvent;
	import flash.display.SpreadMethod;
	import flash.display.Sprite;
	
	public class CreditName extends ZBClip {
		private var _valid:Boolean;
		public var _name:String;
		private var _textfield:TextField;
		
		public function CreditName(s:String, valid:Boolean = false) {
			_name = s;
			_valid = valid;
		}
		
		protected override function init() : void {
			var fontSize:int = Utils.randomNumber(12)*2 + 14;
			var textFormat:TextFormat = new TextFormat("ZB_Arial", fontSize, 0xFFFFFF);
			_textfield = new TextField();
			_textfield.text = _name;
			_textfield.setTextFormat(textFormat);
			_textfield.width = _textfield.textWidth + 20;
			_textfield.height = _textfield.textHeight + 20;
			_textfield.selectable = false;
			addChild(_textfield);
			
			if(_valid) {
				var invisLayer:Sprite = new Sprite();
				invisLayer.graphics.beginFill(0x000000, 0);
				invisLayer.graphics.drawRect(0, 0, _textfield.width, _textfield.height);
				invisLayer.graphics.endFill();
				this.addEventListener(MouseEvent.CLICK, onCorrect);
				addChild(invisLayer);
			}
		}
		
		private function onCorrect(e:MouseEvent) : void {
			_textfield.textColor = 0x00FF00;
			this.removeEventListener(MouseEvent.CLICK, onCorrect);
		}
	}
}
