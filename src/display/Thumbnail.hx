package display;
import flash.display.Bitmap;
import flash.display.Shape;
import flash.display.Sprite;

/**
 * ...
 * @author cedric
 */
class Thumbnail extends Sprite
{
	/** The fragment image corresponding of this thumbnail */
	private var image:Bitmap;

	/** 
	 * Associates the image with this Thumbnail.
	 */ 
	public function new(image:Bitmap) 
	{
		super();
		this.image = image;
		
		//Draw borders
		this.graphics.beginFill(0x000000);
		this.graphics.lineStyle(2, 0x000000); 
		this.graphics.lineTo(0, 0);
		this.graphics.lineTo(image.width, 0);
		this.graphics.lineTo(image.width, image.height); 
		this.graphics.lineTo(0, image.height); 
		this.graphics.endFill();

		this.addChild(image);
	}
	
	/**
	 * Destroy the object.
	 */
	public function destroy()
	{
		if(image != null)
			this.removeChild(image);
	}
}