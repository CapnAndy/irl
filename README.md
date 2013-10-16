# (Internet) RadialLib

When making games, I don't use all-in-one game packages or frameworks - I just use a collection of helper functions to make my life a bit easier, sorta similar to FlashPunk. This set of tools has been evolving over the last two years and I think it would do better opened to the world!

This library is intended to be used with Haxe3, and some classes have dependencies (such as the OpenFL or Actuate libraries), but not all of them.  I try to keep them as unspecific and lightweight as possible.  Just use the classes you want, and ignore the rest; they won't compile into your project.

## Caveat!

I'm not a genius and I have no formal programmer training. To me, it's more important to hack things to "just work" quickly without much of an eye to performance or good design patterns. One of the reasons I'm sharing this library is to hopefully help fix that and make a better world for all of us. Let's work together! Let's make this beautiful and great! Maybe I'll learn to do things /right/ for a change!

## Installation

The easiest way to install this library is to use the `haxelib` tool from your command line:
	
	haxelib git irl https://github.com/weasello/irl.git
	
You then have to tell your project to use the haxe library, by adding the following to your `application.xml` file:

	<haxelib name="irl" />
	
(You can also just download this git repo and slam the `irl` folder into your project directory, it should work the same there.)

Once installed, just start using some functions! No library initialization is required. Example:
	
	import irl.Rndm;
	
Then in your code:
	
	myFunction() {
		trace( Rndm.bool() );
	}
	
## Usage

Each class /should/ be documented, so the code-completion in your editor should answer many questions, but I'll put some examples here:

### Rndm

The `Rndm` class is a selection of randomization tools that should work easily and nicely, across all Haxe-supported platforms.  Allows for specific seeding and resetting to previous seeds, and includes shortcuts to common utilities.

	// Set a random seed:
	Rndm.seed = 1234;
	
	// Common random figures, with min and optional max:
	Rndm.float(0.2, 1.4);
	Rndm.integer(5, 20);
	
	// Option arguments for common functions:
	Rndm.bool(); 	// (50%)
	Rndm.bool(0.8); // (80%)
	
	// These two return the same values:
	Rndm.staticDice(diceSides, numDice);
	trace( Rndm.lastStaticDiceRoll );
	
If no seed is specified (or you set the seed to 0), it will generate one randomly based off the timestamp the next time it needs one.

## Games using RadialLib:
	
 - Monster Loves You!, available on Steam/iOS/Android
 - All games by Radial Games

## ToDo

 - Add back in the AdobeAIR Specific libraries for SteamWorks, GameCenter, and GoogleGames.
 - Add to haxelib for easier install (once it's brushed up a bit more)
 - Document all the things.

http://www.radialgames.com