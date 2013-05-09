package display;
import flash.display.Sprite;
import flash.events.Event;
import flash.text.TextField;
import flash.text.TextFormat;
import flash.utils.Timer;
import flash.events.TimerEvent;
import flash.text.TextFieldAutoSize;

/**
 * ...
 * @author cedric
 */
class Chrono extends Sprite
{
	/** The timer of the chrono */
    private var clock:Timer;
	/** The date about the chrono */
	private var chronoDate:Date;
	/** Currents minutes */
	private var minutes:Int;
	/** Currents seconds */
	private var seconds:Int;
	/** Currents milliseconds */
	private var milliseconds:Int;
	/** Text to display */
	private var text:TextField;
	 
	/**
	 * Initializes the chronometer. 
	 */
	public function new()
	{
		super();
		text = new TextField(); 

		text.text = "Timer  :  00:00:00";
		var textFormat:TextFormat = new TextFormat();
		textFormat.color = 0xfdfdfd;
		textFormat.size = 16;
		textFormat.font = "Papyrus";
		text.setTextFormat(textFormat);
		text.autoSize = TextFieldAutoSize.LEFT;
		this.addChild(text);
	}
	
	/**
	 * Allows to launch the chronometer.
	 */
	public function start()
	{
		clock.start();
	}
	
	/**
	 * Allows to stop the chronometer.
	 */
	public function stop()
	{
		clock.stop();
	}
	 
	/**
	 * Displays the chronometer.
	 * @param	e The Event thrown by the timer.
	 */
	public function displayChrono(e:TimerEvent)
	{
		computeElapsedTime();
		var secondsDisplayed:String;
		var minutesDisplayed:String;

		secondsDisplayed = (seconds < 10) ? "0" + seconds : cast seconds;
		minutesDisplayed = (minutes < 10) ? "0" + minutes : cast minutes;
		
		text.text = "Timer  :  " + minutesDisplayed + ":" + secondsDisplayed + ":" + milliseconds;
		var textFormat:TextFormat = new TextFormat();
		textFormat.color = 0xfdfdfd;
		textFormat.size = 16;
		textFormat.font = "Papyrus";
		text.setTextFormat(textFormat);
		text.autoSize = TextFieldAutoSize.LEFT;
		this.addChild(text);
	}
	 
	/**
	 * Compute the elapsed time.
	 */
	private function computeElapsedTime()
	{
		var mSecElapsed:Int = cast Date.now().getTime() - chronoDate.getTime();
		 
		minutes = Math.floor(mSecElapsed / (60 * 1000));
		mSecElapsed -= minutes * 60 * 1000;
		seconds = Math.floor(mSecElapsed / 1000);
		mSecElapsed -= seconds * 1000;
		milliseconds = mSecElapsed;
	}
	 
	/**
	 * Allows to know the time displayed on the chrono.
	 * @return The time displayed on the chrono.
	 */
	public function getTimeOfChrono() : String
	{
		var timeDisplayed:String = this.text.text;
		return timeDisplayed.substring(10, timeDisplayed.length); 
	}
	
	/**
	 * Re-initialize the chronometer.
	 */
	public function reset()
	{
		clock = new Timer(50);
		clock.addEventListener(TimerEvent.TIMER, displayChrono);
		chronoDate = Date.now();
		text.text = "Timer  :  00:00:00";
		var textFormat:TextFormat = new TextFormat();
		textFormat.color = 0xfdfdfd;
		textFormat.size = 16;
		textFormat.font = "Papyrus";
		text.setTextFormat(textFormat);
		text.autoSize = TextFieldAutoSize.LEFT;
	}
	
}