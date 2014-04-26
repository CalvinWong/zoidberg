package com.rovicorp.zoidberg.game {
	import flash.events.IEventDispatcher;
	public interface IGame extends IEventDispatcher {

		// Interface methods:
		function configure(id:String) : void;
	}
	
}
