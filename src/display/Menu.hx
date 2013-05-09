package display;
import flash.display.Sprite;
import flash.Lib;
import flash.text.TextField;
import flash.text.TextFieldAutoSize;
import flash.text.TextFormat;

/**
 * ...
 * @author cedric
 */
class Menu extends Sprite
{
	/** The sound controler */
	private var soundControl:SoundControl;
	/** The chronometer of the current level */
	public var chrono:Chrono;
	/** The number of strokes played */
	private var fieldNbStrokes:TextField;
	/** The number of the current level */
	private var fieldLevel:TextField;
	
	/**
	 * Allows to display menu's items 
	 */
	public function new() 
	{
		super();
		//Draw the menu
		this.graphics.beginFill(0x888888);
		this.graphics.drawRect(0, 0, Lib.current.stage.stageWidth, 30);
		this.graphics.endFill();
		//Shadow
		this.graphics.beginFill(0x000000);
		this.graphics.drawRect(0, 30, Lib.current.stage.stageWidth, 2);
		this.graphics.endFill();

		//Displays the sound controler
		soundControl = new SoundControl();
		soundControl.x = 570;
		soundControl.y = 5;
		this.addChild(soundControl);
		
		//Displays the chronometer
		chrono = new Chrono();
		chrono.x = 400;
		chrono.y = 2;
		this.addChild(chrono);
		
		//Displays the number of strokes
		fieldNbStrokes = new TextField();
		fieldNbStrokes.text = "Nombre de coups : 0";
		var textFormat:TextFormat = new TextFormat();
		textFormat.color = 0xfdfdfd;
		textFormat.size = 16;
		textFormat.font = "Papyrus";
		fieldNbStrokes.setTextFormat(textFormat);
		fieldNbStrokes.autoSize = TextFieldAutoSize.LEFT;
		fieldNbStrokes.x = 170;
		fieldNbStrokes.y = 2;
		this.addChild(fieldNbStrokes);
		
		//Displays the current level
		fieldLevel = new TextField();
		fieldLevel.text = "Level : 1";
		fieldLevel.setTextFormat(textFormat);
		fieldLevel.autoSize = TextFieldAutoSize.LEFT;
		fieldLevel.x = 10;
		fieldLevel.y = 2;
		this.addChild(fieldLevel);
	}
	
	/**
	 * Allows to update the number of strokes.
	 * @param	strokes The number of strokes played.
	 */
	public function updateStrokes(strokes:Int)
	{
		fieldNbStrokes.text = "Nombre de coups : " + strokes;
		var textFormat:TextFormat = new TextFormat();
		textFormat.color = 0xfdfdfd;
		textFormat.size = 16;
		textFormat.font = "Papyrus";
		fieldNbStrokes.setTextFormat(textFormat);
		fieldNbStrokes.autoSize = TextFieldAutoSize.LEFT;
	}
	
	/**
	 * Allows to update the number of the current level.
	 * @param	level The number of the current level.
	 */
	public function updateLevel(level:Int)
	{
		fieldLevel.text = "Level : " + level;
		var textFormat:TextFormat = new TextFormat();
		textFormat.color = 0xfdfdfd;
		textFormat.size = 16;
		textFormat.font = "Papyrus";
		fieldLevel.setTextFormat(textFormat);
		fieldLevel.autoSize = TextFieldAutoSize.LEFT;
	}
	
	
	
}