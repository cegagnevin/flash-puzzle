package ;

import display.Game;
import display.Menu;
import display.Puzzle;
import flash.display.StageAlign;
import flash.display.StageScaleMode;
import flash.Lib;

/**
 * ...
 * @author cedric
 */

class Main 
{
	/**
	 * Run the puzzle game.
	 */
	static function main() 
	{
		var stage = Lib.current.stage;
		stage.scaleMode = StageScaleMode.NO_SCALE;
		stage.align = StageAlign.TOP_LEFT;
		// entry point
		
		var game:Game = new Game();
		stage.addChild(game);
	}
	
}