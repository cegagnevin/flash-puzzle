package display;
import flash.display.Sprite;
import flash.text.TextField;
import flash.text.TextFormat;
import flash.text.TextFieldAutoSize;
import flash.events.Event;
import flash.Lib;

/**
 * ...
 * @author cedric
 */
class Banner extends Sprite
{
	/** Text to display on the banner */
	private var textBanner:TextField;
	
	/**
	 * Initialize the banner to display.
	 */
	public function new() 
	{
		super();
		
		this.buttonMode = true; //Hand cursor
		this.graphics.beginFill(0x000000, 0.5);
		this.graphics.drawRect(25, 0, 550, 50);
		this.graphics.endFill();
		
		textBanner = new TextField();
		textBanner.selectable = false;
		textBanner.text = "Clique pour commencer !!!";
		var textFormat:TextFormat = new TextFormat();
		textFormat.color = 0xfdfdfd;
		textFormat.size = 30;
		textFormat.font = "Comic Sans MS";
		textBanner.setTextFormat(textFormat);
		textBanner.autoSize = TextFieldAutoSize.LEFT;
		textBanner.x = (this.width - textBanner.width) / 2;
		textBanner.y = (this.height - textBanner.height) / 2;
		this.alpha = 0;
		this.addChild(textBanner);
	}
	
	/**
	 * Displays the banner.
	 */
	public function showListener()
	{
		this.addEventListener(Event.ENTER_FRAME, showBanner);
	}
	
	/**
	 * Displays the banner progressively.
	 * @param	event The Enter Frame event.
	 */
	public function showBanner(event:Event)
	{
		var stage = Lib.current.stage;
		if (this.y <= (stage.stageHeight/2 - 30))
		{
			this.y += 20;
		}

		if (this.alpha < 1)
		{
			this.alpha += 0.05;
		}
	}
	
	/**
	 * Hides the banner.
	 */
	public function hideListener()
	{
		this.addEventListener(Event.ENTER_FRAME, hideBanner);
		
	}
	
	/**
	 * Hides the banner progressively.
	 * @param	event The Enter Frame event.
	 */
	public function hideBanner(event:Event)
	{
		if (this.y <= (stage.stageHeight + this.height))
		{
			this.y += 20;
		}
		
		if (this.alpha >= 0)
		{
			this.alpha -= 0.1;
		}
	}
	
}