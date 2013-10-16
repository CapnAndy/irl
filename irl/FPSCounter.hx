package irl;
import flash.display.DisplayObjectContainer;
import flash.text.TextField;
import flash.text.TextFieldAutoSize;

/**
 * ...
 * @author Andy Moore
 */
class FPSCounter extends WSprite {
	var textField:TextField;
	
	var fpsHistory:Array<Float>;
	
	static inline var averageLength:Int = 60 * 3;
	
	public function new() {
		super();
		textField = new TextField();
		textField.background = true;
		textField.backgroundColor = 0x333333;
		textField.autoSize = TextFieldAutoSize.LEFT;
		textField.textColor = 0xFFFFFF;
		fpsHistory = new Array<Float>();
		addChild(textField);
	}
	
	public function tick(delta:Float) {
		fpsHistory.push(delta);
		while (fpsHistory.length > averageLength) fpsHistory.shift();
		var totalD:Float = 0;
		for (d in fpsHistory) {
			totalD += d;
		}
		var avg = totalD / fpsHistory.length;
		avg = Math.round(1 / avg);
		textField.text = "FPS: " + avg;
	}
	
}