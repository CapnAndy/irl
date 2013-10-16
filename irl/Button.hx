package irl;
import flash.events.MouseEvent;
import msignal.Signal;

/**
 * Basic Button Class, fires a signal any time the element is clicked on.
 * 
 * Requires haxelib msignal
 * 
 * @author Andy Moore
 */

class Button extends WSprite {
	public var pressed:Signal0;
	
	public function new() {
		super();
		pressed = new Signal0();
		addEventListener(MouseEvent.CLICK, clickHandler);
	}
	
	function clickHandler(e:MouseEvent) {
		pressed.dispatch();
	}

	public override function removeAndKill() {
		pressed.removeAll();
		pressed = null;
		removeEventListener(MouseEvent.CLICK, clickHandler);
		super.removeAndKill();
	}
	
}