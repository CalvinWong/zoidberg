package com.rovicorp.events {
	import flash.events.Event;
	
	public class GenericDataEvent extends Event {
		public static const DATA_SELECTED:String = "GenericDataEvent.DATA_SELECTED";
		
		public var data:Object;
		
		public function GenericDataEvent(type:String, myData:Object, bubbles:Boolean = false, cancelable:Boolean = false) {
			super(type, bubbles, cancelable);
			data = myData;
		}

	}
	
}
