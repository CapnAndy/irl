package irl;
import flash.display.Bitmap;
import flash.display.BitmapData;
import flash.display.Sprite;
import flash.geom.Matrix;
import flash.geom.Point;
import flash.geom.Rectangle;

/**
 * This class is about to go through some overhauls, so ignore!
 * (Lots of functionality deprecated)
 */
class CachedSprite extends WSprite {
	//Declare a static data cache
	public var clip:Bitmap;
	public var centered:Bool;

	public function new(filename:String, centered:Bool = false) {
		super();
		this.centered = centered;
		clip = Utils.bitmap(filename);
		clip.cacheAsBitmap = true;
		
		addChild(clip);
		scaleClipTo(1);
	}
	
	public function scaleClipTo(to:Float):Void {
		clip.scaleX = to;
		clip.scaleY = to;
		if (centered) {
			// If we want the clip to be centered instead of top-left oriented:
			var bounds = clip.getBounds(this);
			clip.x = bounds.width / -2;
			clip.y = bounds.height / -2;
		}
	}
	
	public override function removeAndKill() {
		if (clip != null) {
			if (clip.parent != null) {
				removeChild(clip);
			}
			clip = null;
		}
		super.removeAndKill();
	}
}