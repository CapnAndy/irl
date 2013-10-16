package irl;

import googleAnalytics.Page;
import googleAnalytics.Session;
import googleAnalytics.Tracker;
import googleAnalytics.Visitor;

/**
 * A basic GoogleAnalytics wrapper class to make GA stuff really easy.
 * 
 * Requires haxelib haxe-ga
 * 
 * @author Andy Moore
 */
class Analytics {
	static var tracker:Tracker;
	static var session:Session;
	static var visitor:Visitor;
	static var prefix:String;
	
	public function new() {
		throw "Cannot make a new Analytics thingy, just call Init. (This is a static class)";
	}
	
	/**
	 * Initializes Google Analytics tracking.
	 * @param	accountID	GA account ID.
	 * @param	domain		Domain to report.
	 * @param	string		If set, will prefix all URL paths with this value (eg: radialgames.com/PREFIX/mydata)
	 */
	public static function init(accountID:String, domain:String, prefix:String = null) {
		tracker = new Tracker(accountID, domain);
		
		session = new Session();
		// TODO: Add relevant session data if necessary.
		
		visitor = new Visitor();
		visitor.setUserAgent('haxe-ga');
		// TODO: Add relevant visitor data like screen resolution or whatnot.
		
		Analytics.prefix = prefix;
	}
	
	/**
	 * Track a pageview to Google Analytics.
	 * @param	page	The page to record a view on. Will use prefix data if specified in init
	 */
	public static function pageView(page:String) {
		if (tracker == null) throw "You have to call init first, before using Analytics";
		if (prefix != null) page = prefix+""+page;
		var pg = new Page(page);
		tracker.trackPageview(pg, session, visitor);
	}
}