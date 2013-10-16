package irl;

import flash.display.DisplayObjectContainer;
import flash.events.Event;
import flash.Lib;
import flash.text.TextField;
import flash.text.TextFieldAutoSize;

/**
 * Adds a basic FPS Counter to the top left of the screen.
 * @author Andy Moore
 */
class FPSCounter {
	static var textField:TextField;
	static var fpsHistory:Array<Float>;
	static var tickSmoothing:Float = 0;
	static var lastTickTimestamp:Float = 0;
	
	/**
	 * Adds an FPS Counter to the screen.
	 * @param	drawTarget	Where to draw the FPS counter (presumably "stage"). Note that the target should be on the display list at the very least before calling this.
	 * @param	smoothing	How many ticks to smooth/average the results over (minimum 1)
	 */
	public static function init(drawTarget:DisplayObjectContainer, smoothing:Int = 30) {
		textField = new TextField();
		textField.background = true;
		textField.backgroundColor = 0x333333;
		textField.autoSize = TextFieldAutoSize.LEFT;
		textField.textColor = 0xFFFFFF;
		fpsHistory = new Array<Float>();
		
		tickSmoothing = Math.max(1, smoothing);
		
		drawTarget.addChild(textField);
		drawTarget.addEventListener(Event.ENTER_FRAME, tick);
	}
	
	/**
	 * Removes the FPS Counter.
	 */
	public static function remove() {
		if (textField != null) {
			if (textField.parent != null) {
				textField.parent.removeEventListener(Event.ENTER_FRAME, tick);
				textField.parent.removeChild(textField);
			}
			textField = null;
			fpsHistory = null;
		}
	}
	
	/**
	 * Internal event to track the ticks.
	 * @param	e
	 */
	static function tick(e:Event) {
		if (textField == null || textField.parent == null) {
			// Whatever we added this to got removed, so might as well clean up after ourselves.
			remove();
			return;
		}

		var currentTimeStamp = Lib.getTimer() / 1000;
		var delta = currentTimeStamp - lastTickTimestamp;
		lastTickTimestamp = currentTimeStamp;
		
		fpsHistory.push(delta);
		while (fpsHistory.length > tickSmoothing) fpsHistory.shift();
		var totalD:Float = 0;
		for (d in fpsHistory) {
			totalD += d;
		}
		var avg = totalD / fpsHistory.length;
		avg = Math.round(1 / avg);
		textField.text = "FPS: " + avg + " of " + textField.parent.stage.frameRate;
	}
	
}