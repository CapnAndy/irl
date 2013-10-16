package irl;
import haxe.CallStack;

/**
 * Basic assertation class to TEST YOUR ASSERTATIONS, shocking!
 * @author Andy Moore
 */

class Assert {

	/**
	 * Throws an (optionally: customized) error message if the expression is not true
	 * @param	expression	Put your test here. Eg: stage != null
	 * @param	message		An optional custom error message. Eg: "Stage doesn't exist"
	 */
	public static function isTrue(expression:Bool, message:String = "") {
		if (!expression) {
			if (message == "" || message == null) {
				message = "[Assertion failed] - this expression must be true";
            }
			#if windows
				// Getting a proper stacktrace in CPP builds doesn't always work properly. This can be removed
				// Once the bugfix is done in Haxe.
				var stack:Array<StackItem> = CallStack.callStack();
				message += "\n";
				for (line in stack) {
					message += line + "\n";
				}
			#end
			throw message;
		}
	}
	
	/**
	 * Shortcut function to quickly terminate if you don't have an easy assertation to test against
	 * @param	message		Optional custom error message
	 */
	public static function noRun(message:String = "") {
		isTrue(false, message);
	}
}