package irl;

class GreyCircle extends WSprite {
	
	public function new(radius:UInt, innerFill:UInt = 0x555555, outline:UInt = 0x444444) {
		super();
		graphics.lineStyle(2, outline);
		graphics.beginFill(innerFill);
		graphics.drawCircle(0,0,radius);
		graphics.endFill();
	}
	
}