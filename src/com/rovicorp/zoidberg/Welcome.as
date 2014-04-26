package com.rovicorp.zoidberg {
	import com.rovicorp.display.ZBClip;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import com.rovicorp.component.SimpleImage;
	import flash.events.Event;
	import com.greensock.TweenLite;
	
	public class Welcome extends ZBClip {
		private var _userName:TextField;
		private var _userIcon:SimpleImage;

		public function Welcome() {
		}
		
		protected override function init() : void {
			var welcomeText:TextField = new TextField();
			welcomeText.text = "Welcome";
			welcomeText.setTextFormat(new TextFormat("Arial", 28, 0xFFFFFF));
			welcomeText.height = welcomeText.textHeight + 10;
			welcomeText.width = welcomeText.textWidth + 10;
			welcomeText.x = stage.stageWidth / 2 - welcomeText.width / 2;
			welcomeText.y = 150;
			welcomeText.selectable = false;
			addChild(welcomeText);
			
			_userName = new TextField();
			addChild(_userName);
			
			_userIcon = new SimpleImage();
			addChild(_userIcon);
		}
		
		public function onUserLoaded(e:Event) : void {
			_userName.text = ConfigManager.user.fullname;
			_userName.setTextFormat(new TextFormat("Arial", 72, 0xFFFFFF));
			_userName.height = _userName.textHeight + 10;
			_userName.width = _userName.textWidth + 10;
			_userName.x = stage.stageWidth / 2 - _userName.width / 2;
			_userName.y = 190;			
			_userName.selectable = false;
			
			_userIcon.load(ConfigManager.persistence.baseUrl + "/" + ConfigManager.user.avatarUrl);
			_userIcon.addEventListener(Event.COMPLETE, onImageComplete);
		}
		
		private function onImageComplete(e:Event) : void {
			_userIcon.alpha = 0;
			_userIcon.x = stage.stageWidth/2 - _userIcon.width/2;
			_userIcon.y = 290;
			TweenLite.to(_userIcon, .15, {alpha:1});
		}

	}
	
}
