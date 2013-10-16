package irl;
import haxe.CallStack;

/**
 * ...
 * @author Andy Moore
 */

class Assert {

	public function new() { throw "Don't new Assert! I'm a static class silly";  }
	
	public static function isTrue(expression:Bool, message:String = "") {
		if (!expression) {
			if (message == "" || message == null) {
				message = "[Assertion failed] - this expression must be true";
            }
			#if windows
				var stack:Array<StackItem> = CallStack.callStack();
				message += "\n";
				for (line in stack) {
					message += line + "\n";
				}
			#end
			throw message;
		}
	}
	
	public static function noRun(message:String = "") {
		isTrue(false, message);
	}
}