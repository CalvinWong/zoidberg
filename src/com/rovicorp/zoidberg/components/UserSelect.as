package com.rovicorp.zoidberg.components {
	import flash.text.TextField;
	import com.rovicorp.display.ZBClip;
	
	public class UserSelect extends ZBClip {
		public var data:Object;

		public function UserSelect(o:Object) {
			super();
			
			data = o;
		}
		
		protected override function init() : void {
			field.text = data.fullname;
		}
	}
}
