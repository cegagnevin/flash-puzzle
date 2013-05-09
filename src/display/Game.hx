package display;
import flash.display.Loader;
import flash.display.SimpleButton;
import flash.display.Sprite;
import flash.events.Event;
import flash.filters.GlowFilter;
import flash.filters.BitmapFilter;
import flash.net.URLLoader;
import flash.net.URLRequest;
import flash.text.TextField;
import flash.text.TextFormat;
import flash.xml.XML;
import haxe.xml.Fast;
import flash.display.Bitmap;
import flash.events.MouseEvent;
import flash.text.TextFieldAutoSize;

/**
 * Contains all statistics about a level.
 */
typedef Statistics = {
	var level : Int;
	var strokes : Int;
	var time : String;
}
	
/**
 * ...
 * @author cedric
 */
class Game extends Sprite
{
	/** Parser  about the "data/config.xml" file */
	private var fast:Fast;
	/** Array which contains images for levels */
	private var images:Array<Bitmap>;
	/** The difficulty of the game */
	private var difficulty:Int;
	/** Number of levels */
	private var nbLevels:Int;
	/** The current level */
	private var level:Int;
	/** The number of strokes */
	private var strokes:Int;
	/** The menu of the game */
	private var menu:Menu;
	/** The puzzle */
	private var puzzle:Puzzle;
	/** The banner which indicate that the game start */
	private var banner:Banner;
	/** Contains all statistics of all levels */
	private var stats:Array<Statistics>;
	


	public function new() 
	{
		super();
		stats = new Array<Statistics>();
		images = new Array<Bitmap>();
		banner = new Banner();
		menu = new Menu();
		this.addChild(menu);
		puzzle = new Puzzle();
		this.addChild(puzzle);
		
		var loader:URLLoader = new URLLoader(new URLRequest("data/config.xml"));
		loader.addEventListener(Event.COMPLETE, loaderCompleteHandler);
	}
	
	/**
	 * Store the Fast object when the config.xml has been loaded completely.
	 * @param	event The Event thrown when the file "config.xml" has been loaded.
	 */
	private function loaderCompleteHandler(event:Event)
	{
		var myXml = new XML(event.currentTarget.data); //event.currentTarget = objet sur lequel on ajoute l'evenement (ici le loader)
		var xmlParse:Xml = Xml.parse(myXml.toString());
		fast = new Fast(xmlParse.firstElement());
		
		loadConfig();
	}
	
	/**
	 * Load the configuration of the puzzle and load images used for levels.
	 */
	private function loadConfig()
	{
		//configuration
		var nbImages:Int = Std.parseInt(fast.node.mode.att.nbImg);
		nbLevels = nbImages;
		var mode:String = fast.node.mode.innerData;
		difficulty = Std.parseInt(fast.node.difficulty.innerData);
		
		//load and store images 
		var i:Int = 1;
		for ( i in 1 ... nbImages+1 ) 
		{
			var imageLoader = new Loader();
			var url:String = "data/images/" + mode + "/level-0" + i + ".jpg";
			var image = new URLRequest(url);
			imageLoader.load(image);
			imageLoader.contentLoaderInfo.addEventListener(Event.COMPLETE, storeImages);
		}
	}
	
	/**
	 * Stores images in puzzle attributes.
	 */
	private function storeImages(event:Event)
	{
		var image:Bitmap = cast event.currentTarget.content;
		images.push(image);
		
		if (images.length == nbLevels)
		{
			level = 1;
			puzzle.displayImage(images[0]); //initialize the puzzle
			showLevel();
		}
	}
	
	/**
	 * Shows the banner before begin to realize the puzzle.
	 * @param	event The Event throws when the user click on the puzzle.
	 */
	private function showLevel()
	{
		this.addChild(banner);
		banner.x = banner.y = 0;
		banner.showListener();
		puzzle.addEventListener(MouseEvent.CLICK, startLevel);
	}
	
	/**
	 * Hides the banner in order to begin to realize the puzzle.
	 * @param	event The Event throws when the user click on the puzzle.
	 */
	private function startLevel(event:Event )
	{
		puzzle.removeEventListener(MouseEvent.CLICK, startLevel);
		banner.hideListener();
		puzzle.mixUpPieces(difficulty);
		menu.chrono.reset();
		menu.chrono.start();
	}
	
	/**
	 * Called at the end of a level.
	 * Stop the chrono, save statistics of the ending level and run the next level.
	 */
	public function endOfLevel()
	{
		trace("FIN DU NIVEAU (endOfLevel [Game])");
		//Stop the chronometer
		menu.chrono.stop();
		
		//Destroy the current level
		puzzle.destroyCurrentLevel();
		
		//Save stats of this level
		var statsLevel:Statistics = { 
			level : this.level,
			strokes : this.strokes,
			time : this.menu.chrono.getTimeOfChrono()
		};
		
		trace("Stats - Level:" + statsLevel.level + ", Strokes:" + statsLevel.strokes + ", Time:" + statsLevel.time);
		this.stats.push(statsLevel);
		
		if (level < nbLevels)
		{
			//Run the next level
			runNextLevel();
		}
		else //End of the gamee
		{
			endOfGame();
		}
	}
	
	/**
	 * Launch the next level.
	 */
	private function runNextLevel()
	{
		trace("NEXT LEVEL");
		level ++;
		this.menu.updateLevel(level);
		strokes = 0;
		this.menu.updateStrokes(strokes);
		
		puzzle.displayImage(images[level-1]); //initialize the puzzle
		showLevel();
	}
	
	/**
	 * Called at the end of the game. Displays statistics of all levels.
	 */
	public function endOfGame()
	{
		//Displays all stats
		var textFormat:TextFormat = new TextFormat();
		textFormat.color = 0x000000;
		textFormat.bold = true;
		textFormat.size = 20;
		
		var glowFilter:GlowFilter = new GlowFilter(0x29f7ff, 0.8, 6, 6, 2, 1, false, false);
		var filtersList:Array<BitmapFilter> = new Array();
		filtersList.push(glowFilter);
		
		var textField:TextField = new TextField();
		textField.selectable = false;
		textField.width = 500;
		textField.height = 400;
		textField.x = 35;
		textField.y = 60;
		textField.text = "*** THE END ***";
		textField.filters = filtersList;
		textField.name = "titleStats";
		textField.setTextFormat(textFormat);
		this.addChild(textField);
		
		var i:Int = 0;
		for (i in 0 ... stats.length)
		{
			textField = new TextField();
			textField.selectable = false;
			textField.text += "Level " + stats[i].level +" ......................... " + stats[i].strokes +" coups  [ " + stats[i].time + " ]";
			textField.width = 500;
			textField.height = 400;
			textField.x = 35;
			textField.y = 60 + ((i + 1) * 60);
			textField.filters = filtersList;
			textField.setTextFormat(textFormat);
			textField.textColor = 0x000000;
			textField.name = "textField"+i;
			this.addChild(textField);
		}
		
		//Button replay
		var format:TextFormat = new TextFormat();
		format.bold = true;
		format.size = 18;
		
		var button = new Sprite();
		button.graphics.beginFill(0xc8c8c8);
		button.graphics.drawRoundRect(0, 0, 120, 30, 10, 10); // x, y, width, height, ellipseW, ellipseH
		button.graphics.endFill;
		button.x = (stage.stageWidth / 2) - (button.width / 2);
		button.y = stage.stageHeight - 40;
		var textLabel = new TextField();
		textLabel.text = 'Replay !';
		textLabel.setTextFormat(format);
		textLabel.textColor = 0x293cff;
		textLabel.x = 24;
		textLabel.y = 3;
		textLabel.autoSize = TextFieldAutoSize.LEFT;
		textLabel.selectable = false;
		button.addChild(textLabel);
		this.addChild(button);
		button.buttonMode = true;
		button.name = "replayButton";
		button.addEventListener(MouseEvent.CLICK, replay);
	}
	
	/**
	 * Increment strokes counter.
	 */
	public function incrementStrokes()
	{
		strokes++;
		this.menu.updateStrokes(strokes);
	}
	
	/**
	 * Allows to replay the game.
	 * @param	event Clic Event
	 */
	public function replay(event:MouseEvent)
	{
		trace("REPLAY");
		this.menu.updateLevel(1);
		level = 1;
		this.menu.updateStrokes(0);
		strokes = 0;
		menu.chrono.reset();
		stats = new Array<Statistics>();
		this.removeChild(banner);
		destroyStatsDisplayed();
		puzzle.displayImage(images[0]); //initialize the puzzle
		showLevel();
	}
	
	/**
	 * Removes objects related to statistics displayed.
	 */
	private function destroyStatsDisplayed()
	{
		this.removeChild(this.getChildByName("replayButton")); 
		this.removeChild(this.getChildByName("titleStats"));
		
		var i:Int = 0;
		for (i in 0 ... nbLevels)
		{
			this.removeChild(this.getChildByName("textField"+i));
		}
	}
}