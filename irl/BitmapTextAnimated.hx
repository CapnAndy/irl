package irl;
import flash.events.TimerEvent;
import flash.filters.BitmapFilter;
import flash.text.TextFormat;
import flash.utils.Timer;

/**
 * ...
 * @author Andy Moore
 */
class BitmapTextAnimated extends BitmapText {
	private var targetText:String;
	private var timer:Timer;
	
	public var animatedWidth:Float;
	public var animatedHeight:Float;
	
	private var speedPerChar:Float;
	
	public function new(text:String, format:TextFormat, ?filters:Array<BitmapFilter>, ?setWidth:Float) {
		super(text, format, filters, setWidth);
		targetText = text;
		animatedWidth = this.width;
		animatedHeight = this.height;
		this.text = "";
	}
	
	/**
	 * Begins the animation.
	 * @param	delay	In seconds, before the animation should begin
	 * @param	speedPerChar	In milliseconds, time per letter (min 17)
	 */
	public function startAnimation(delay:Int, speedPerChar:Float):Void {
		this.speedPerChar = speedPerChar;
		speedPerChar = Math.max(17, speedPerChar);
		timer = new Timer(speedPerChar);
		haxe.Timer.delay(actuallyBegin, Math.round(delay*1000));
	}
	
	private function actuallyBegin():Void {
		if (speedPerChar == 0) {
			text = targetText;
			timer = null;
		} else {
			timer.start();
			timer.addEventListener(TimerEvent.TIMER, timerTick);
		}
	}
	
	private function timerTick(e:TimerEvent):Void {
		if (text.length == targetText.length) {
			// All done!
			timer.stop();
			timer.removeEventListener(TimerEvent.TIMER, timerTick);
			timer = null;
		} else {
			var currentLength:Int = text.length;
			text = targetText.substr(0, currentLength + 1);
		}
	}
}