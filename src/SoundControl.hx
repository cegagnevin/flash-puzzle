package ;
import display.SoundControlImage;
import flash.display.Sprite;
import flash.events.Event;
import flash.media.SoundChannel;
import sound.Ambiance;
import flash.events.MouseEvent;

/**
 * ...
 * @author cedric
 */
class SoundControl extends Sprite
{
	/** The image which indicate if the sound is on/off */
	private var soundControlImage:SoundControlImage;
	/** The sound played */
	private var ambiance:Ambiance;
	/** Channel which allows to control the sound played */
	private var channel:SoundChannel;

	/**
	 * Initialize the sound controler.
	 */
	public function new() 
	{
		super();
		soundControlImage = new SoundControlImage();
		this.addChild(soundControlImage);
		
		ambiance = new Ambiance();
		channel = ambiance.play(0, 65000);
		
		this.addEventListener(MouseEvent.CLICK, manageSound);

	}
	
	/**
	 * Activate/Desactivate the sound.
	 * @param	event Clic Event on the image which control the sound.
	 */
	private function manageSound(event:Event)
	{
		if (soundControlImage.currentFrame == 1) //Stop the music
		{
			soundControlImage.toggleImage(true);
			channel.stop(); 
		}
		else //Activate the sound
		{
			soundControlImage.toggleImage(false);
			channel = ambiance.play(0, 65000);
		}
	}
	
}