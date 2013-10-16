package irl;

import flash.display.BitmapData;
import flash.display.DisplayObject;
import flash.geom.Point;
import flash.geom.Rectangle;
import openfl.Assets;
import flash.display.Bitmap;
import flash.display.PixelSnapping;
import flash.display.Sprite;

/**
 * ...
 * @author Andy Moore
 */

class Utils {

	public function new() {	}
	
	#if !windows
	public static function weakEvent(target:Sprite, type:String, listener:Dynamic->Void):Void {
			//throw new nme.errors.Error("Weak Events do not work properly in the CPP environment.");
		target.addEventListener(type, listener, false, 0, true);
	}
	#end
	
	public static function toRad(i:Float):Float { return i * Math.PI/180; }
	public static function toDeg(i:Float):Float { return i * 180 / Math.PI; }

	public static function oneEighty(input:Float):Float {
		while (input > 180 || input < -180) {
			if (input > 180) input -= 360;
			else if (input < -180) input += 360;
		}
		return input;
	}
	
	public static function rotate(p:Point, rad:Float):Point {
		//var hyp:Number = Point.distance(new Point(0,0), p);
		var newP:Point = new Point(0,0);
		newP.x = p.x*Math.cos(rad) - p.y*Math.sin(rad);
		newP.y = p.y*Math.cos(rad) + p.x*Math.sin(rad);
		return newP;
	}
		
	public static function inSet(needle:Dynamic, haystack:Array<Dynamic>):Bool {
		for (item in haystack) {
			if (needle == item) return true;
		}
		return false;
	}

	public static function removeFromSet(needle:Dynamic, haystack:Array<Dynamic>):Array<Dynamic> {
		var newHaystack = new Array<Dynamic>();
		for (item in haystack) {
			if (needle != item) newHaystack.push(item);
		}
		return newHaystack;
	}
	
	public static function sortArray(array:Array<Dynamic>, sortBy:String, ascending:Bool = true):Void {
		array.sort(function(a:Dynamic, b:Dynamic):Int {
			if (a.fetch(sortBy) == b.fetch(sortBy)) {
				return 0;
			}
			else if (a.fetch(sortBy) > b.fetch(sortBy)) {
				if (ascending) return 1;
				else return -1;
			}
			else if (a.fetch(sortBy) < b.fetch(sortBy)) {
				if (ascending) return -1;
				else return 1;
			} 
			else {
				throw "Couldn't run sortArray because AAAAAAAGRHGHH";
				return 1;
			}
		});
	}
	
	public static function implode(glue:String="", array:Array<String>):String {
		var temp:String = "";
		for (i in 0...array.length) {
			if (i != 0) temp = temp + glue;
			temp = temp + array[i];
		}
		return temp;
	}

	public static function bitmap(assetName:String):Bitmap {
		return new Bitmap(Assets.getBitmapData(assetName), PixelSnapping.NEVER, true);
	}
	
	//public static function bitmap(assetName:String):Bitmap {
		//return new Bitmap(Rasset.getBitmapData(assetName), PixelSnapping.AUTO, true);
	//}
	
	public static function trimTransparency(input:BitmapData, colourChecker:Int = 0x00FF00):Bitmap {
        //Keep a copy of the original
        var original:Bitmap = new Bitmap(input, PixelSnapping.AUTO, true);

        //Clone the orignal with a white background
        var clone:BitmapData = new BitmapData(Std.int(original.width), Std.int(original.height), true, colourChecker);
        clone.draw(original);

        //Grab the bounds of the clone checking against white
        var bounds:Rectangle = clone.getColorBoundsRect(colourChecker, colourChecker, false);
		
		// Return everything if we ended up excluding it all.
		if (bounds.width == 0) bounds = new Rectangle(0, 0, clone.width, clone.height);
		
        //Create a new bitmap to return the changed bitmap
        var returnedBitmap:Bitmap = new Bitmap();
		returnedBitmap.smoothing = true;
        returnedBitmap.bitmapData = new BitmapData(Std.int(bounds.width), Std.int(bounds.height), true, 0x00000000);
        returnedBitmap.bitmapData.copyPixels(original.bitmapData, bounds, new Point(0,0));
        return returnedBitmap;
    }
	
	public static function addCommasToNumber(number:Float):String {
		var result:String = "";

		// First let's figure out if this is positive or negative.
		if (number < 0) {
			result = "-";
			number = Math.abs(number);
		}
		
		// Now we begin string conversion
		var num:String = Std.string(number);
		
		//  Save the decimal stuff for later
		var decimalSplit:Array<String> = num.split(".");
		num = decimalSplit[0];
		
		// There's only commas required if the length is over 3.
		if (num.length > 3) {
			
			// How many clumps of 3 are there?
			var mod:Int = num.length % 3;
			// Add the remainder to the front. These are our first digit results.
			result += num.substr(0, mod);
			
			// i will equal the character position after the tacked on bits.
			var i = mod;
			while (i < num.length) {
				var bit:String = num.substr(i, 3);
				if (mod == 0 && i == 0) {
					result += "";
				} else {
					result += ",";
				}
				result += bit;
				i += 3;
				//output += ((mod == 0 && i == 0) ? "" : ",")+num.substr(i, 3);
			}
			
		} else {
			// No commas required! just tack the whole number on.
			result += num;
		}

		// Let's add back on the decimals.
		if (decimalSplit.length > 1) {
			result += num + "." + decimalSplit[1];
		}
		
		return result;
	}
	
}