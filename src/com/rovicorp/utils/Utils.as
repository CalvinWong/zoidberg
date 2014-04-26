package com.rovicorp.utils {
	
	public class Utils {
		public static function isNullOrEmpty(s:String) : Boolean {
			if(s == null || s == "") {
				return true;
			}
			return false;
		}
		
		public static function trim(s:String) : String {
			return s.replace(/^\s+|\s+$/g, '');
		}
		
		public static function randomNumber(maxValue:int) : int {
			return Math.round(Math.random()*maxValue);
		}
		
		public static function randomize(arr:Array) : Array {
			var arr2:Array = [];
			while (arr.length > 0) {
				arr2.push(arr.splice(Math.round(Math.random() * (arr.length - 1)), 1)[0]);
			}
			return arr2;
		}
	}
}
