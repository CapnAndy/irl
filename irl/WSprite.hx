package irl;

import flash.display.Sprite;
import flash.events.Event;
import flash.events.MouseEvent;
import flash.events.TouchEvent;
import flash.geom.Point;
import flash.geom.Rectangle;
import flash.text.TextField;
import flash.text.TextFieldAutoSize;
import flash.text.TextFormat;
import motion.Actuate;

/**
 * Sprite replacement class that contains a lot of helpers. More docs to come
 */
class WSprite extends Sprite {
	
	/* Helpers
	 * ==================
	 */
	
	// TODO: Can we make these work without parents? Does that even make sense?
	public var top(get, set):Float; 
	private function get_top():Float {
		if (this.parent == null) {
			trace("Warning: tried to get .top without parent");
			return 0;
		}		
		return this.getBounds(parent).top;
	}
	private function set_top(to:Float):Float {
		this.y += to - top;
		return to;
	}

	
	public var bottom(get, set):Float; 
	private function get_bottom():Float {
		if (this.parent == null) {
			trace("Warning: tried to get .bottom without parent");
			return 0;
		}
		return this.getBounds(parent).bottom;
	}
	private function set_bottom(to:Float):Float {
		this.y += to - bottom;
		return to;
	}
	
	
	public var left(get, set):Float; 
	private function get_left():Float {
		if (this.parent == null) {
			trace("Warning: tried to get .left without parent");
			return 0;
		}
		return this.getBounds(parent).left;
	}
	private function set_left(to:Float):Float {
		this.x += to - left;
		return to;
	}
	
	
	public var right(get, set):Float; 
	private function get_right():Float {
		if (this.parent == null) {
			trace("Warning: tried to get .right without parent");
			return 0;
		}
		return this.getBounds(parent).right;
	}
	private function set_right(to:Float):Float {
		this.x += to - right;
		return to;
	}
	
	
	public var centerY(get, set):Float; 
	private function get_centerY():Float {
		return centerLocation.y;
	}
	private function set_centerY(to:Float):Float {
		var currentCenter:Point = centerLocation;
		currentCenter.y = to;
		return set_centerLocation(currentCenter).y;
	}

	
	public var centerX(get, set):Float; 
	private function get_centerX():Float {
		return centerLocation.x;
	}
	private function set_centerX(to:Float):Float {
		var currentCenter:Point = centerLocation;
		currentCenter.x = to;
		return set_centerLocation(currentCenter).x;
	}
	
	
	public var centerLocation(get, set):Point;
	private function get_centerLocation():Point {
		if (this.parent == null) {
			trace("Warning: tried to get .centerLocation without parent");
			return new Point(0, 0);
		}
		var r:Rectangle = this.getBounds(parent);
		var p:Point = new Point((r.width/2) + r.left,
							    (r.height/2) + r.top);
		return p;
	}
	private function set_centerLocation(to:Point):Point {
		var currentCenter:Point = centerLocation;
		currentCenter = to.subtract(currentCenter);
		this.x += currentCenter.x;
		this.y += currentCenter.y;
		return to;
	}
	 
	
	public var scale(get, set):Float;
	private function get_scale():Float {
		if (scaleX != scaleY) {
			throw "Scales do not match; cannot return value";
			return 0;
		} else return scaleX;
	}
	private function set_scale(to:Float):Float {
		scaleX = to;
		scaleY = to;
		return to;
	}
	
	public var location(get, set):Point;
	private function get_location():Point {
		return new Point(this.x, this.y);
	}
	private function set_location(to:Point):Point {
		this.x = to.x;
		this.y = to.y;
		return to;
	}
	
	public function new() {
		screenShakeOriginalLoc = new Point();
		shakeLength = 0;
		shakeIntensity = 0;
		originalScale = Math.NaN;		
		super();
	}
	
	/* Misc commonly-used utils
	 * ========================
	 */
	var onStageCallback:Void->Void;
	public function onStage(cback:Void->Void):Void {
		onStageCallback = cback;
		addEventListener(Event.ADDED_TO_STAGE, handleOnStage);
	}
	
	function handleOnStage(e:Event):Void {
		removeEventListener(Event.ADDED_TO_STAGE, handleOnStage);
		if (onStageCallback != null) onStageCallback();
		onStageCallback = null;
	}
	
	var onMouse:Void->Void;
	public function mouseListen(onEvent:Void->Void):Void {
		onMouse = onEvent;
		addEventListener(MouseEvent.MOUSE_DOWN, handleClick);
	}
	
	function handleClick(e:MouseEvent):Void {
		if (onMouse == null) {
			// We have no event listener for some reason? Woops. Let's remove the event listener so this doesn't come up again:
			unMouseListen();
		} else {
			onMouse();
		}
	}
	
	public function unMouseListen():Void {
		removeEventListener(MouseEvent.MOUSE_DOWN, handleClick);
		onMouse = null;
	}

	/* Screen Shake Stuff 
	 * ==================
	 */
	private var screenShakeOriginalLoc:Point;
	private var shakeLength:Float;
	private var shakeIntensity:Float;
	public function shake(intensity:Float, duration:Float = 60):Void {
		if (shakeLength == 0) {
			addEventListener(Event.ENTER_FRAME, shakeIt);
			screenShakeOriginalLoc = this.location;
			shakeLength = duration;
			shakeIntensity = intensity;
		} else {
			shakeLength += duration;
			shakeIntensity += intensity;
		}
	}
	
	private function shakeIt(e:Event):Void {
		shakeLength -= 1;
		shakeIntensity = shakeIntensity * 0.98;
		if (shakeLength <= 0) {
			shakeLength = 0;
			shakeIntensity = 0;
			this.location = screenShakeOriginalLoc;
			screenShakeOriginalLoc = null;
			removeEventListener(Event.ENTER_FRAME, shakeIt);
		} else {
			this.x = screenShakeOriginalLoc.x + Rndm.float(shakeIntensity * -1, shakeIntensity);
			this.y = screenShakeOriginalLoc.y + Rndm.float(shakeIntensity * -1, shakeIntensity);
		}
	}
	
	public function cancelBubble():Void {
		if (!Math.isNaN(originalScale))
			mouseOverShrink(null);
		removeEventListener(MouseEvent.MOUSE_OVER, mouseOverGrow);
	}
	
	private var scaleAmount:Float = 0;
	private var overrideTween:Bool;
	private var originalScale:Float;
	public function bubbleOnMouseOver(scaleAmount:Float = 1.2, overrideTween:Bool = true):Void {
		originalScale = Math.NaN;
		this.overrideTween = overrideTween;
		this.scaleAmount = scaleAmount;
		removeEventListener(MouseEvent.MOUSE_OVER, mouseOverGrow);
		removeEventListener(TouchEvent.TOUCH_OVER, mouseOverGrow);
		
		// TODO: Might want to put an IF/ELSE in here in case both get called on some platforms:
		addEventListener(TouchEvent.TOUCH_OVER, mouseOverGrow);
		addEventListener(MouseEvent.MOUSE_OVER, mouseOverGrow);
	}
	
	private function mouseOverGrow(e:MouseEvent):Void {
		removeEventListener(TouchEvent.TOUCH_OVER, mouseOverGrow);
		removeEventListener(MouseEvent.MOUSE_OVER, mouseOverGrow);
		removeEventListener(MouseEvent.MOUSE_OUT, mouseOverShrink);
		removeEventListener(TouchEvent.TOUCH_OUT, mouseOverShrink);

		addEventListener(TouchEvent.TOUCH_OUT, mouseOverShrink);
		addEventListener(MouseEvent.MOUSE_OUT, mouseOverShrink);
		Actuate.stop(this, null, true);
		if (Math.isNaN(originalScale)) originalScale = this.scale;
		Actuate.tween(this, 0.2, { scale:originalScale * scaleAmount }, overrideTween);
	}
	
	private function mouseOverShrink(e:MouseEvent):Void {
		removeEventListener(MouseEvent.MOUSE_OVER, mouseOverGrow);
		removeEventListener(MouseEvent.MOUSE_OUT, mouseOverShrink);
		
		removeEventListener(TouchEvent.TOUCH_OUT, mouseOverShrink);
		removeEventListener(TouchEvent.TOUCH_OVER, mouseOverGrow);

		Actuate.stop(this, null, true);
		if (Math.isNaN(originalScale)) {
			// we don't know what the original scale is? that's bad news.
			// should probably fix that sometime. ^^
			return; 
		}
		Actuate.tween(this, 0.2, { scale:originalScale }, overrideTween)
			.onComplete(mouseOverShrinkComplete, null);
			
		addEventListener(MouseEvent.MOUSE_OVER, mouseOverGrow);
		addEventListener(TouchEvent.TOUCH_OVER, mouseOverGrow);
	}
	
	private function mouseOverShrinkComplete():Void {
		originalScale = Math.NaN;
	}
	
	private var boundingBoxData:Sprite;
	public function drawBoundingBox():Void {
		if (boundingBoxData != null) {
			removeChild(boundingBoxData);
			boundingBoxData = null;
		} else {
			boundingBoxData = new Sprite();
			boundingBoxData.graphics.lineStyle(1,0xFF0000);
			boundingBoxData.graphics.drawRect(getBounds(this).left + 1, getBounds(this).top + 1, width - 2, height - 2);

			var format = new TextFormat();
			format.size = 8;
			format.color = 0xFFFFFF;
			var textField = new TextField();
			textField.defaultTextFormat = format;
			textField.autoSize = TextFieldAutoSize.LEFT;
			textField.background = true;
			textField.backgroundColor = 0xFF0000;
			textField.text = "x" + left + " y" + top + " w" + width + " h" + height;
			
			if (textField.width > boundingBoxData.width) textField.width = boundingBoxData.width;
			if (textField.height > boundingBoxData.height) textField.height = boundingBoxData.height;
			textField.x = boundingBoxData.getBounds(boundingBoxData).left + 1;
			textField.y = boundingBoxData.getBounds(boundingBoxData).top + 1;
			boundingBoxData.addChild(textField);
			//addChild(texty);
			addChild(boundingBoxData);
		}
	}
	
	/* CleanUp
	 * ==================
	 */	
	private function kill():Void {
		// In case this was never added to stage:
		removeEventListener(TouchEvent.TOUCH_OVER, mouseOverGrow);
		removeEventListener(TouchEvent.TOUCH_OUT, mouseOverShrink);
		removeEventListener(MouseEvent.MOUSE_OVER, mouseOverGrow);
		removeEventListener(MouseEvent.MOUSE_OUT, mouseOverShrink);
		removeEventListener(Event.ADDED_TO_STAGE, handleOnStage);
		onStageCallback = null;
		removeEventListener(Event.ENTER_FRAME, shakeIt);
		
		while (this.numChildren > 0) removeChildAt(0);
		unMouseListen();
		handleOnStage(null);
		
		if (boundingBoxData != null) {
			if (boundingBoxData.parent != null)
				boundingBoxData.parent.removeChild(boundingBoxData);
		}
		// add field reflect null
	}
	
	public function removeAndKill():Void {
		if (this.parent != null) {
			this.parent.removeChild(this);
		}
		kill();
	}
	
}