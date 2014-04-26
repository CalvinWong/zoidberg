package com.rovicorp.zoidberg {
	import com.rovicorp.display.ZBClip;
	import com.rovicorp.zoidberg.net.ManagerRequest;
	import flash.events.Event;
	import com.rovicorp.zoidberg.components.UserSelect;
	import flash.events.MouseEvent;
	
	public class LoginScreen extends ZBClip {

		public function LoginScreen() {
			
		}
		
		protected override function init() : void {
			var mgr:ManagerRequest = new ManagerRequest();
			mgr.addEventListener(Event.COMPLETE, onUserList);
			mgr.loadPlayers();
		}
		
		private function onUserList(e:Event) : void {
			var mgr:ManagerRequest = e.target as ManagerRequest;
			var data:Object = mgr.data;
			for(var i:int=0; i<data.length; i++) {
				var userSelect:UserSelect = new UserSelect(data[i]);
				userSelect.y = i*35;
				userSelect.mouseChildren = false;
				userSelect.addEventListener(MouseEvent.CLICK, onClick);
				addChild(userSelect);
			}
		}
		
		private function onClick(e:MouseEvent) : void {
			var userSelect:UserSelect = e.target as UserSelect;
			ConfigManager.user = userSelect.data;
		}
	}
	
}
