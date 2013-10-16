package irl;
import flash.display.Bitmap;
import flash.display.BitmapData;
import flash.display.PixelSnapping;
import flash.display.Sprite;
import flash.filters.BitmapFilter;
import flash.geom.Matrix;
import flash.geom.Rectangle;
import flash.text.AntiAliasType;
import flash.text.TextField;
import flash.text.TextFieldAutoSize;
import flash.text.TextFormat;
import flash.text.TextFormatAlign;

/**
 * ...
 * @author Andy Moore
 */
class BitmapText extends WSprite {
	private var textField:TextField;
	private var textFormat:TextFormat;
	private var numberText:Float;
	private var wordWrap:Bool;
	private var bitmap:Bitmap;
	
	public function new(text:String, format:TextFormat, ?filters:Array<BitmapFilter>, setWidth:Float = 0) {
		super();
		textField = new TextField();
		numberText = 0;
		wordWrap = false;
		
		textFormat = format;
		
		if (setWidth > 0) {
			textField.width = setWidth;
			wordWrap = true;
		}
		
		textField.wordWrap = wordWrap;
		textField.multiline = true;
		textField.embedFonts = true;
		textField.defaultTextFormat = textFormat;
		textField.antiAliasType = AntiAliasType.ADVANCED;
		textField.selectable = false;
		textField.mouseEnabled = false;
		textField.filters = filters;
		
		if (textFormat.align == TextFormatAlign.RIGHT) {
			textField.autoSize = TextFieldAutoSize.RIGHT;
		} else if (textFormat.align == TextFormatAlign.CENTER) {
			textField.autoSize = TextFieldAutoSize.CENTER;
		} else {
			textField.autoSize = TextFieldAutoSize.LEFT;
		}
					
		textField.htmlText = text;
		drawBitmap();
	}
	
	
	public var text (get, set):String;
	function set_text(to:String):String {
		if (textField.text == to) return to;
		textField.text = to;
		drawBitmap();
		return to;
	}
	function get_text():String {
		return textField.text;
	}
	
	public var number (get, set):Float;
	function set_number(to:Float):Float {
		numberText = to;
		text = Utils.addCommasToNumber(numberText);
		return to;
	}
	function get_number():Float {
		return this.numberText;
	}
	
	private function drawBitmap():Void {
		if (bitmap != null) {
			removeChild(bitmap);
			bitmap = null;
		}
		
		var tempSprite:Sprite = new Sprite();
		tempSprite.addChild(textField);
		
		// Need the +2 here for the dropshadow-bitmap
		var data:BitmapData = new BitmapData(Std.int(tempSprite.width + 2), Std.int(tempSprite.height), true, 0x000000);
		bitmap = new Bitmap(data, PixelSnapping.NEVER, true);

		// Get the bounds of the object in case top-left isn't 0,0
		var bounds:Rectangle = tempSprite.getBounds(tempSprite);
			
		var m:Matrix = new Matrix();
		m.translate(-bounds.x, -bounds.y);
		
		bitmap.bitmapData.draw(tempSprite, m);
		addChild(bitmap);
		bitmap.pixelSnapping = PixelSnapping.NEVER;
		moveBitmap();
	}
	
	private function moveBitmap():Void {
		if (textField.autoSize == TextFieldAutoSize.RIGHT) {
			bitmap.x = 0-bitmap.width;
		} else if (textField.autoSize == TextFieldAutoSize.CENTER) {
			bitmap.x = 0 - (bitmap.width / 2);
		}
	}
}