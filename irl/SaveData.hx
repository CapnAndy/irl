package irl;
import flash.net.SharedObject;
/**
 * Wraps flash's SharedObject with a simple get and set commands for ease of use.
 * @author Andy Moore
 */
class SaveData {
	
	static var sharedObject:SharedObject;

	/**
	 * Opens a file handler and readies SaveData for use.
	 * @param	fileTitle	The title of the saveData object.
	 * @param	filePath	The (relative) path to store the file. Where this is depends on the target.
	 */
	public static function init(fileTitle:String, filePath:String) {
		if (sharedObject != null) {
			// In case this is has already been initialized, let's close things and throw a warning.
			trace("You should call .close() before re-initializing SaveData. I'll do it for you this time though, tsk tsk.");
			close();
		}
		sharedObject = SharedObject.getLocal(fileTitle, filePath);
	}

	/**
	 * Store (and immediately save) data to disk.
	 * @param	key	The field to save. Recommend you use constants defined.
	 * @param	to	The value to save.
	 */
	public static function set(key:String, to:Dynamic) {
		if (sharedObject == null) throw "No data found. Not initialized?";
		Reflect.setField(sharedObject.data, key, to);
		sharedObject.flush(); // TODO: Maybe put this on a timer? Might cause performance problems if accessed too often.
	}
	
	/**
	 * Retrieve stowed data. Note changes outside of this class will not be reflected unless init is called again (eg: external file manipulation)
	 * @param	key	The field to retrieve. Recommend you use constants defined.
	 * @return	returns the property stowed.
	 */	
	public static function get(key:String):Dynamic {
		if (sharedObject == null) throw "No data found. Not initialized?";
		return Reflect.field(sharedObject.data, key);
	}
		
	/**
	 * Closes the file handler and frees up init() to be called again. Not sure why you'd need this right now though... 
	 * Unless, you know, you extend the class and pass in file parameters or something. Heh. speaking of which...
	 * Maybe I should make this class accept all sorts of input? That'd be kinda cool.
	 */
	public static function close() {
		if (sharedObject == null) {
			// Already closed? what is this madness?
			trace("But.. you already .close()d SaveData!... Are you trying to trick me?");
			return;
		}
		#if flash
			// Okay this throws errors if we target android/ios, will be fixed in some future version of openFL.
			// (OpenFL doesn't maintain a file handler anyway on android)
			sharedObject.close();
		#end
		sharedObject = null;
	}
}