package ;
import flash.display.InteractiveObject;
import flash.events.MouseEvent;
import msignal.Signal;

/**
 * ...
 * @author Andy Moore
 */
class Input {
	public static var mouseIsDown:Bool;
	
	public static var mousePressed:Signal1<MouseEvent>;
	public static var mouseReleased:Signal1<MouseEvent>;
	
	public static var target:InteractiveObject;
	
	/**
	 * Initializes and turns on all the listeners.
	 * @param	target	The interactive object you want to listen to (presumably, Stage)
	 */
	public static function init(theTarget :InteractiveObject) {
		if (target != null) throw "already initialized Input, gotta turnItAllOff before calling this again";
		target = theTarget;
		
		// Reset the defaults. Can we be more smart about this? Not sure.
		mouseIsDown = false;
		
		// Add the event listeners
		target.addEventListener(MouseEvent.MOUSE_DOWN, mouseDownHandler);
		target.addEventListener(MouseEvent.MOUSE_UP, mouseUpHandler);
		
		// And let's initialize some signals so other things can listen in on these events:
		mousePressed = new Signal1<MouseEvent>();
		mouseReleased = new Signal1<MouseEvent>();		
	}
	
	static function mouseDownHandler(e:MouseEvent):Void {
		mouseIsDown = true;
		mousePressed.dispatch(e);
	}

	static function mouseUpHandler(e:MouseEvent):Void {
		mouseIsDown = false;
		mouseReleased.dispatch(e);
	}
	
	/**
	 * Unregisters all listeners and kills references. must be initialized again if you want to use it more.
	 */
	public static function turnItAllOff() {
		mousePressed.removeAll();
		mouseReleased.removeAll();
		mousePressed = null;
		mouseReleased = null;
		target.removeEventListener(MouseEvent.MOUSE_DOWN, mouseDownHandler);
		target.removeEventListener(MouseEvent.MOUSE_UP, mouseUpHandler);
		target = null;
	}
}