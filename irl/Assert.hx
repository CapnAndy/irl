package irl;
import haxe.macro.Context;
import haxe.macro.Expr;

/**
 * Basic assertation class to TEST YOUR ASSERTATIONS, shocking!
 * Other classes can also use "using irl.Assert" to allow for things like yourClass.isTrue(blah);
 * 
 * This edition heavily influenced by deltaluca @ https://github.com/deltaluca/goodies
 * 
 * @author Andy Moore
 */

class Assert {

	/**
	 * Throws an (optionally: customized) error message if the expression is not true. Disabled if debug compilation.
	 * @param	expression	Put your test here. Eg: stage != null
	 * @param	message		An optional custom error message. Eg: "Stage doesn't exist"
	 */
    macro public static function isTrue(expression:Expr, message:String = "Assertation Error") {
		if (Context.defined("debug")) {
			var pos = Context.currentPos();
			var print = (new haxe.macro.Printer()).printExpr(expression);
			return macro { if (!($expression)) throw '${${message}}: ${$v{pos}} : ${$v{print}}'; };
		} else {
			return macro { };
		}
    }
}