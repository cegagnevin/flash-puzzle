package display;
import flash.display.MovieClip;
import flash.events.Event;
import flash.Lib;

/**
 * ...
 * @author cedric
 */
class SoundControlImage extends MovieClip
{
	/**
	 * Displays the image "sound activated"
	 */
	public function new() 
	{
		super();
		//this.scaleX = this.scaleY = 0.08;
		this.gotoAndStop(1); //Arret sur la 1ere image	
	}
	
	/**
	 * Swap sound control images.
	 * @param	soundActivate Boolean which indicate if the sound must be activated or not.
	 */
	public function toggleImage(soundActivate:Bool)
	{
		if (soundActivate == true) //Stop
		{
			this.gotoAndStop(2); 
		}
		else //Activate
		{
			this.gotoAndStop(1); 
		}
	}
}