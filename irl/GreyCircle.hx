package irl;

class GreyCircle extends WSprite {
	
	public function new(radius:UInt, innerFill:UInt = 0x555555, outline:UInt = 0x444444) {
		super();
		var tempSprite:WSprite = new WSprite();
		tempSprite.graphics.lineStyle(2, outline);
		tempSprite.graphics.beginFill(innerFill);
		tempSprite.graphics.drawCircle(0,0,radius);
		tempSprite.graphics.endFill();
		addChild(tempSprite);
	}
	
}