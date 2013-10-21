package irl;

/**
 * Bits of this harvested from different places on the internet at some point or another. Modified lots now.
 * 
 * @author Andy Moore
 */

class Rndm {	
	/**
	 * Random float generator
	 * @param	min	exclusive minimum.
	 * @param	?max	exclusive maximum
	 * @return	float value
	 */	
	public static function float(min:Float, max:Float = 0):Float {
		if (max == 0) { max = min; min = 0; } 
		return random()*(max-min)+min;
	}
	
	/**
	 * Random boolean generator
	 * @param	chance	percentage (0...1) of success
	 * @return	Returns true if success, false if failure
	 */
	public static function bool(chance:Float=0.5):Bool {
		return (random() < chance);
	}
	
	/**
	 * Random sign generator
	 * @param	chance	percentage (0...1) of success
	 * @return	returns 1 if success, 0 if failure
	 */
	public static function sign(chance:Float=0.5):Int {
		return (random() < chance) ? 1 : -1;
	}
	
	/**
	 * Random bit generator
	 * @param	chance	percentage (0...1) of success)
	 * @return	1 if success, 0 if failure
	 */
	public static function bit(chance:Float=0.5):Int {
		return (random() < chance) ? 1 : 0;
	}
	
	/**
	 * Random integer generator.
	 * @param	minInclusive	inclusive minimum
	 * @param	?maxExclusive	exclusive maximum. If null, minimum becomes 0 and maximum becomes min.
	 * @return	Returns the integer.
	 */
	public static function integer(minInclusive:Float, maxExclusive:Float=0):Int {
		var min:Float = minInclusive;
		var max:Float = maxExclusive;
		if (max == 0) { max = min; min=0; }
		// Need to use floor instead of bit shift to work properly with negative values:
		return Math.floor(float(min,max));
	}
	
	/**
	 * Random character from string
	 * @param	string	The string to pull the character from
	 * @return	a single character
	 */
	public static function charFromString(string:String):String {
		return string.charAt(integer(0, string.length));
	}
	
	// ### These are used for random word generation
	private static inline var commonVowels:String		= 'aeio';
	private static inline var allVowels:String			= 'aeiouy';
	private static inline var commonConsonants:String	= 'bcdglmnprst';
	private static inline var allConsonants:String 		= 'bcdfghjklmnpqrstvwxz';
	private static inline var floats:String 			= '0123456789';
	private static inline var symbols:String 			= '!@#$%^&*()';
	
	/**
	 * This is used internally by generateWord and generatePassword
	 * @param	length
	 * @param	setA
	 * @param	setB
	 * @return
	 */
	static function generateWordFromTwoSets(length:Int, setA:String, setB:String):String {
		var theWord = "";
		var alt = bool();
		for (i in 0...length) {
			if (alt) {
				theWord += charFromString(setA);
			} else {
				theWord += charFromString(setB);
			}
			alt = !alt;
		}
		return theWord;
	}
	/**
	 * Using common consonants and vowels, generates a regularish-sounding-word
	 * @param	length	How long the word should be.
	 * @return	returns the generated word.
	 */
	public static function generateWord(length:Int = 6):String {
		return generateWordFromTwoSets(length, commonVowels, commonConsonants);
	}
	
	/**
	 * Using randomish character selection, generates a zany password thing
	 * @param	length	how long the password should be
	 * @param	strength	Setting of 0..4 (inclusive) that increases password complexity. 0 is simple (letters only), 4 includes symbols and numbers
	 * @return	String of the generated password
	 */
	public static function generatePassword(length:Int = 9, strength:Int = 0):String {
		var vowels = allVowels;
		var consonants = allConsonants;
		if (strength == 0) {
			// No changes for strength 0.
		} else if (strength == 1) {
			// let's add uppercase.
			consonants += consonants.toUpperCase();
			vowels += vowels.toUpperCase();
		} else if (strength == 2) {
			// Add numbers in, but only for vowels
			vowels += floats;
		} else if (strength == 3) {
			// Add symbols but only for consonants
			consonants += symbols;
		} else if (strength == 4) {
			// fuck the alternating BS that makes it englishy
			vowels += symbols;
			consonants += floats;
		}
		return generateWordFromTwoSets(length, vowels, consonants);
	}

	/**
	 * Rolls dice and stores value in .lastStaticDiceRoll for later retrieval.
	 * @param	diceSides	Number of dice sides
	 * @param	numberOfDice	Number of dice to roll.
	 * @return integer assuming no zero-faces on your dice.
	 */
	public static function staticDice(diceSides:Int, numberOfDice:Int):Int {
		var value = integer(1, (diceSides * numberOfDice) + 1);
		lastStaticDiceRoll = value;
		return value;
	}
	
	
	
	
	// ### INTERNAL STUFFS. ===========================================================
	// IGNORE!!
	// Unless you want to set the seed or something. even though there's functions for that.
	
	static var _seed:Float = 0; // on some platforms Float initializes differently
	static var _currentSeed:Float = 0; // on some platforms Float initializes differently
	public static var lastStaticDiceRoll:Int;
	
	/**
	 * Randomizes the current seed based on the current date and time.
	 */
	public static function randomizeSeed() {
		seed = Date.now().getTime();
	}
	
	public static var seed(get, set):Float;
	static function get_seed():Float {
		if (_seed == 0) randomizeSeed();
		return _seed;
	}
	static function set_seed(value:Float) {
		_currentSeed = value;
		_seed = value;
		return value;
	}
		
	public static var currentSeed(get, null):Float;
	static function get_currentSeed():Float {
		if (_currentSeed == 0) randomizeSeed();
		return _currentSeed;
	}
	
	public static var useForNextSeedOnly:Float = 0;
	public static function random():Float {
		if (useForNextSeedOnly != 0) {
			// This allows us to generate just a signal number in a sequence from a given seed.
			var temp = useForNextSeedOnly;
			useForNextSeedOnly = 0;
			return ((temp * 16807) % 2147483647) / 0x7FFFFFFF + 0.000000000233;
		} else {
			// Standard random number generation.
			return (_currentSeed = (currentSeed * 16807) % 2147483647) / 0x7FFFFFFF + 0.000000000233;
		}
	}
	
	/**
	 * Resets the random number sequence while retaining the set seed.
	 */
	public static function reset():Void {
		_currentSeed = _seed;
	}	
	
	public function new() {	throw "Don't new this Rndm class! You fool"; }
		
}