package com.rovicorp.zoidberg {
	import com.rovicorp.display.ZBClip;
	import com.rovicorp.zoidberg.net.ManagerRequest;
	import flash.events.Event;
	import flash.events.ErrorEvent;
	import com.rovicorp.zoidberg.components.UserSelect;
	import flash.events.MouseEvent;
	import flash.display.Sprite;
	import com.greensock.TweenLite;
	import flash.events.KeyboardEvent;
	import com.rovicorp.constant.KeyboardConstant;
	
	public class LoginScreen extends ZBClip {
		public static const USER_SELECTED:String = "LoginScreenEvent.USER_SELECTED";
		private var _userContainer:Sprite;

		public function LoginScreen() {
			enter_username.visible = false;
			enter_name_line.visible = false;
			invalid_username.visible = false;
		}
		
		protected override function init() : void {
			var mgr:ManagerRequest = new ManagerRequest();
			mgr.addEventListener(Event.COMPLETE, onUserList);
			mgr.loadPlayers();
			
			_userContainer = new Sprite();
			_userContainer.x = 475;
			_userContainer.y = 150;
			addChild(_userContainer);
			
			create_user.addEventListener(MouseEvent.CLICK, onCreateUser);
		}
		
		private function onCreateUser(onCreateUser) : void {
			TweenLite.to(_userContainer, .2, {alpha:0, onComplete:hideIt, onCompleteParams:[_userContainer]});
			TweenLite.to(create_user, .2, {alpha:0, onComplete:hideIt, onCompleteParams:[create_user]});
			TweenLite.to(select_user, .2, {alpha:0, onComplete:hideIt, onCompleteParams:[select_user]});
			
			enter_username.alpha = 0;
			enter_username.visible = true;
			TweenLite.to(enter_username, .2, {alpha:1, delay:.1});
			
			enter_name_line.alpha = 0;
			enter_name_line.visible = true;
			TweenLite.to(enter_name_line, .2, {alpha:1, delay:.1});
			
			user_input.visible = true;
			stage.focus = user_input;
			stage.addEventListener(KeyboardEvent.KEY_DOWN, onKeyboardEvent);
		}
		
		private function onKeyboardEvent(e:KeyboardEvent) : void {
			if(e.keyCode == KeyboardConstant.ENTER) {
				stage.removeEventListener(KeyboardEvent.KEY_DOWN, onKeyboardEvent);
				
				var request:ManagerRequest = new ManagerRequest();
				request.addEventListener(Event.COMPLETE, onUserCreated);
				request.addEventListener(ErrorEvent.ERROR, onUserCreateError);
				request.createPlayer(user_input.text);
			}
			invalid_username.visible = false;
		}
		
		private function onUserCreated(e:Event) : void {
			var request:ManagerRequest = e.target as ManagerRequest;
			ConfigManager.user = request.data;
			dispatchEvent(new Event(USER_SELECTED));
		}
		
		private function onUserCreateError(e:Event) : void {
			// error
			invalid_username.visible = true;
			stage.focus = user_input;
			
			stage.addEventListener(KeyboardEvent.KEY_DOWN, onKeyboardEvent);
		}
		
		private function onUserList(e:Event) : void {
			var mgr:ManagerRequest = e.target as ManagerRequest;
			var data:Object = mgr.data;
			
			destroyChildren(_userContainer);
			
			for(var i:int=0; i<data.length; i++) {
				var userSelect:UserSelect = new UserSelect(data[i]);
				userSelect.y = i*35;
				userSelect.mouseChildren = false;
				userSelect.addEventListener(MouseEvent.CLICK, onClick);
				_userContainer.addChild(userSelect);
			}
		}
		
		private function onClick(e:MouseEvent) : void {
			var userSelect:UserSelect = e.target as UserSelect;
			ConfigManager.user = userSelect.data;
			
			dispatchEvent(new Event(USER_SELECTED));
		}
	}
}
