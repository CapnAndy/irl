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
import haxe.macro.Expr.FunctionArg;
import motion.Actuate;

/**
 * Sprite replacement class that contains a lot of helpers. More docs to come
 */
class WSprite extends Sprite {
	
	/* Helpers
	 * ==================
	 */
	
	public var top(get, set):Float; 
	private function get_top():Float {
		if (this.parent == null) {
			trace("Warning: tried to get .top without parent. Scale discarded.");
			return this.getBounds(this).top;
		} else {
			return this.getBounds(parent).top;
		}
	}
	private function set_top(to:Float):Float {
		this.y += to - top;
		return to;
	}

	
	public var bottom(get, set):Float; 
	private function get_bottom():Float {
		if (this.parent == null) {
			trace("Warning: tried to get .bottom without parent. Scale discarded.");
			return this.getBounds(this).bottom;
		} else {
			return this.getBounds(parent).bottom;
		}
	}
	private function set_bottom(to:Float):Float {
		this.y += to - bottom;
		return to;
	}
	
	
	public var left(get, set):Float; 
	private function get_left():Float {
		if (this.parent == null) {
			trace("Warning: tried to get .left without parent. Scale discarded.");
			return this.getBounds(this).left;
		} else {
			return this.getBounds(parent).left;
		}
	}
	private function set_left(to:Float):Float {
		this.x += to - left;
		return to;
	}
	
	
	public var right(get, set):Float; 
	private function get_right():Float {
		if (this.parent == null) {
			trace("Warning: tried to get .right without parent. Scale discarded.");
			return this.getBounds(this).right;
		} else {
			return this.getBounds(parent).right;
		}
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
		var r:Rectangle;
		if (this.parent == null) {
			trace("Warning: tried to get .centerLocation without parent. Scale discarded.");
			r = this.getBounds(this);
		} else {
			r = this.getBounds(parent);
		}
		return new Point((this.width/2) + r.left, (this.height/2) + r.top);
	}
	private function set_centerLocation(to:Point):Point {
		var currentCenter = to.subtract(centerLocation);
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
	
	/**
	 * Requires irl.Input to be initialized first if we're going to use orientation events.
	 */
	public function new() {
		super();
		shakeLength = 0;
		shakeIntensity = 0;
		originalScale = Math.NaN;
	}
	
	/**
	 * Triggers orient() when Event.ADDED_TO_STAGE is called.
	 */
	public var orientOnStage(get, set):Bool;
	function get_orientOnStage():Bool {
		return _orientOnStage;
	}
	function set_orientOnStage(to:Bool):Bool {
		if (to) {
			if (_orientOnStage == false) {
				addEventListener(Event.ADDED_TO_STAGE, handleOnStage);
			} else {
				// We've already set this. no need to act.
			}
		} else {
			removeEventListener(Event.ADDED_TO_STAGE, handleOnStage); // Remove first, just in case it was doubly set
		}
		_orientOnStage = to;
		return to;
	}
	var _orientOnStage:Bool = false;
	
	/**
	 * Triggers orient() when Event.resize is triggered.
	 */
	public var orientOnResize(get, set):Bool;
	function get_orientOnResize():Bool {
		return _orientOnResize;
	}
	function set_orientOnResize(to:Bool):Bool {
		if (to) {
			if (_orientOnResize == false) {
				if (Input.resized == null) throw "irl.Input not initialized";
				Input.resized.add(orient);
			} else {
				// We've already set this. no need to act.
			}
		} else {
			Input.resized.remove(orient);
		}
		_orientOnResize = to;
		return to;
	}
	var _orientOnResize:Bool = false;
	
	/**
	 * Called anytime an orientation change event is dispatched, and the first time the element is added to the stage
	 */
	function orient() {
		// To be overridden
	}
	 
	/**
	 * Private function actually triggers the onstage stuff
	 * @param	e
	 */
	function handleOnStage(e:Event):Void {
		removeEventListener(Event.ADDED_TO_STAGE, handleOnStage);
		orient();
	}

	/* Screen Shake Stuff 
	 * ==================
	 */
	private var screenShakeOriginalLoc:Point;
	private var shakeLength:Float;
	private var shakeIntensity:Float;
	/**
	 * Let's shake things up a bit!
	 * @param	intensity	Intensity largely defines number of pixels to move as a baseline, though this will decay
	 * @param	duration	How long to shake
	 */
	public function shake(intensity:Float, duration:Float = 60):Void {
		if (shakeLength == 0) {
			removeEventListener(Event.ENTER_FRAME, shakeIt);
			addEventListener(Event.ENTER_FRAME, shakeIt);
			screenShakeOriginalLoc = this.location;
			shakeLength = duration;
			shakeIntensity = intensity;
		} else {
			shakeLength += duration;
			shakeIntensity += intensity;
		}
	}
	
	/**
	 * Private function to handle the shaking.
	 * @param	e
	 */
	function shakeIt(e:Event) {
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
	
	/**
	 * Cancel the mousebubbling behaviour.
	 */
	public function cancelBubble():Void {
		if (!Math.isNaN(originalScale)) {
			mouseOverShrink(null);
		}
		removeEventListener(MouseEvent.MOUSE_OVER, mouseOverGrow);
		removeEventListener(TouchEvent.TOUCH_OVER, mouseOverGrow);
	}
	
	var scaleAmount:Float = 0;
	var overrideTween:Bool;
	var originalScale:Float;
	/**
	 * Set this display object to "bubble" on mouseOver.
	 * @param	scaleAmount		What scale to multiply by (default 120%)
	 * @param	overrideTween	If we should overwrite any existing motion tweens with this motion
	 */
	public function bubbleOnMouseOver(scaleAmount:Float = 1.2, overrideTween:Bool = true):Void {
		originalScale = Math.NaN;
		this.overrideTween = overrideTween;
		this.scaleAmount = scaleAmount;
		
		// We need to put TOUCH stuff in too because OpenFL bug.
		removeEventListener(MouseEvent.MOUSE_OVER, mouseOverGrow);
		removeEventListener(TouchEvent.TOUCH_OVER, mouseOverGrow);
		
		// TODO: Might want to put an IF/ELSE in here in case both get called on some platforms:
		addEventListener(TouchEvent.TOUCH_OVER, mouseOverGrow);
		addEventListener(MouseEvent.MOUSE_OVER, mouseOverGrow);
	}
	
	/**
	 * Private function that makes the mouseOver bubble grow
	 * @param	e
	 */
	function mouseOverGrow(e:MouseEvent) {
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
	
	/**
	 * Private function that makes the mouseOver bubble reverse direction
	 * @param	e
	 */
	function mouseOverShrink(e:MouseEvent) {
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
	
	/**
	 * Private function that handles the completion of the bubble-shrink event
	 */
	function mouseOverShrinkComplete() {
		originalScale = Math.NaN;
	}
	
	var boundingBoxData:Sprite;
	/**
	 * Draws a bounding box in red around the object. the line traces exactly the interior edge (not exterior).
	 * @param addLabel	Should we add a little text label while we're at it?
	 */
	public function drawBoundingBox(addLabel:Bool = true) {
		if (boundingBoxData != null) {
			removeChild(boundingBoxData);
			boundingBoxData = null;
		} else {
			boundingBoxData = new Sprite();
			boundingBoxData.graphics.lineStyle(1,0xFF0000);
			boundingBoxData.graphics.drawRect(getBounds(this).left + 1, getBounds(this).top + 1, width - 2, height - 2);

			if (addLabel) {
				// And let's fit the dimensions into a little red label we'll put onto the box:
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
			}
			addChild(boundingBoxData);
		}
	}
	
	/* CleanUp
	 * ==================
	 */	
	
	/**
	 * Removes all references from this class. Suggested you use RemoveAndKill instead though, it's public.
	 */
	function kill() {
		Actuate.stop(this, false, false, false);
		removeEventListener(TouchEvent.TOUCH_OVER, mouseOverGrow);
		removeEventListener(TouchEvent.TOUCH_OUT, mouseOverShrink);
		removeEventListener(MouseEvent.MOUSE_OVER, mouseOverGrow);
		removeEventListener(MouseEvent.MOUSE_OUT, mouseOverShrink);
		removeEventListener(Event.ENTER_FRAME, shakeIt);

		orientOnStage = false; // will remove event listeners for added_to_stage
		screenShakeOriginalLoc = null;
		
		if (Input.resized != null) Input.resized.remove(orient);
		
		// Let's remove all sub-children of this. Probably unnecessary but might as well be safe:
		while (this.numChildren > 0) {
			// TODO: Investigate if we can just ask for a removeAndKill for all subchildren and call that?
			removeChildAt(0);
		}
		
		// kill that bounding box
		if (boundingBoxData != null) {
			if (boundingBoxData.parent != null) {
				boundingBoxData.parent.removeChild(boundingBoxData);
			}
			boundingBoxData = null;
		}		
	}
	
	/**
	 * Totally expecting you to call this anytime you want to remove the Sprite in your cleanup routines. Feel free to extend!
	 */
	public function removeAndKill() {
		if (this.parent != null) {
			this.parent.removeChild(this);
		}
		// And kill everything else.
		this.kill();
	}
	
}