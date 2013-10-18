package irl;
import flash.display.Sprite;

class GreyBox extends WSprite {
	
	/**
	 * Creates a greybox with these dimensions. Note that linethickness is BEYOND the rectSize.
	 * TODO: Make it less than.
	 * @param	width
	 * @param	height
	 * @param	fillColor
	 * @param	lineThickness
	 * @param	lineColor
	 */
	public function new(width:Float, height:Float, fillColor:UInt = 0x555555, lineThickness:Float = 2, lineColor:UInt = 0x444444) {
		super();
		var tempSprite:Sprite = new Sprite();
		tempSprite.graphics.lineStyle(lineThickness,lineColor);
		tempSprite.graphics.beginFill(fillColor);
		tempSprite.graphics.drawRect(0,0,width,height);
		tempSprite.graphics.endFill();
		addChild(tempSprite);
	}
}