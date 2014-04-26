package com.rovicorp.zoidberg.game {
	import com.rovicorp.display.ZBClip;
	import flash.text.TextField;
	import flash.text.TextFormat;
	
	import com.rovicorp.utils.Utils;
	import flash.events.MouseEvent;
	import flash.display.SpreadMethod;
	import flash.display.Sprite;
	import flash.events.Event;
	
	public class CreditName extends ZBClip {
		public static const WRONG:String = "CreditName.WRONG";
		public static const RIGHT:String = "CreditName.RIGHT";
		private var _valid:Boolean;
		private var _name:String;
		private var _textfield:TextField;
		
		public function CreditName(s:String, valid:Boolean = false) {
			_name = s;
			_valid = valid;
		}
		
		protected override function init() : void {
			var fontSize:int = Utils.randomNumber(10)*2 + 18;
			var textFormat:TextFormat = new TextFormat("Arial", fontSize, 0xFFFFFF);
			_textfield = new TextField();
			_textfield.text = _name;
			_textfield.setTextFormat(textFormat);
			_textfield.width = _textfield.textWidth + 20;
			_textfield.height = _textfield.textHeight + 20;
			_textfield.selectable = false;
			addChild(_textfield);
			
			var invisLayer:Sprite = new Sprite();
			invisLayer.graphics.beginFill(0x000000, 0);
			invisLayer.graphics.drawRect(0, 0, _textfield.width, _textfield.height);
			invisLayer.graphics.endFill();
			this.addEventListener(MouseEvent.CLICK, onCorrect);
			addChild(invisLayer);
		}
		
		private function onCorrect(e:MouseEvent) : void {
			this.removeEventListener(MouseEvent.CLICK, onCorrect);
			_textfield.textColor = _valid ? 0x00FF00 : 0xFF0000;
			dispatchEvent(new Event(_valid ? RIGHT : WRONG));
		}
	}
}
