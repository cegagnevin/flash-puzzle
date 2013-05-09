package display;
import flash.display.BitmapData;
import flash.display.Loader;
import flash.display.Sprite;
import flash.events.Event;
import flash.events.EventDispatcher;
import flash.events.MouseEvent;
import flash.geom.Point;
import flash.geom.Rectangle;
import flash.net.URLLoader;
import flash.net.URLRequest;
import flash.xml.XML;
import haxe.xml.Fast;
import flash.display.Bitmap;
import feffects.Tween;
import feffects.easing.Linear;

/**
 * ...
 * @author cedric
 */
class Puzzle extends Sprite
{
	/** The current image displays by the puzzle */
	private var image:Bitmap;
	/** Contains all thumbnails in the right order */
	private var solutionImages:Array<Thumbnail>;
	/** Contains thumbnails like positionned by the player */
	private var currentImages:Array<Thumbnail>;
	/** Thumbnail width */
	private var pieceWidth:Int;
	/** Thumbnail height */
	private var pieceHeight:Int;
	/** x coordinate of the source thumbnail on the current drag and drop */
	private var xSource:Int;
	/** y coordinate of the source thumbnail on the current drag and drop */
	private var ySource:Int;
	
	/**
	 * Launch the loading of the configuration file.
	 */
	public function new() 
	{
		super(); 
		solutionImages = new Array<Thumbnail>();
		currentImages = new Array<Thumbnail>();
		this.buttonMode = true; //Hand cursor
	}
	
	
	/**
	 * Displays the image of a new level.
	 * @param	image The image of the level.
	 */
	public function displayImage(image:Bitmap)
	{
		this.image = image;
		image.x = 25;
		image.y = 55;
		image.alpha = 0;
		this.addChild(this.image);
        var tween = new Tween( 0, 1, 2000, Linear.easeNone );
        tween.onUpdate( appear );
        tween.start();
    }
    
	/**
	 * Makes appear the image.
	 * @param	e Value of the alpha
	 */
    function appear( e : Float ) {
        image.alpha = e;
    }


	
	/**
	 * Transforms the original image to multiples thumbnails and displays them.
	 * @param	difficulty The difficulty of the puzzle.
	 */
	public function mixUpPieces(difficulty:Int)
	{
		if (image != null)
		{
			this.removeChild(image);
		}
		
		//Split image
		pieceWidth = cast image.width / difficulty;
		pieceHeight = cast image.height / difficulty;
		var i:Int = 0;
		var j:Int = 0;
		for ( i in 0 ... difficulty)
		{
			for ( j in 0 ... difficulty)
			{
				var sourceRect = new Rectangle(pieceWidth*j, pieceHeight*i, pieceWidth, pieceHeight);
				var destPoint = new Point(0,0);
				var bmd = new BitmapData(pieceWidth,pieceHeight);
				bmd.copyPixels(image.bitmapData, sourceRect, destPoint);
				var bmp = new Bitmap(bmd);
				var thumbnail:Thumbnail = new Thumbnail(bmp);
				solutionImages.push(thumbnail);
				currentImages.push(thumbnail);
			}
		}
		
		//Suffle
		currentImages = shuffle(currentImages);
		
		//Display
		var row:Int = 0;
		var column:Int = 0;
		for ( i in 0 ... (difficulty * difficulty))
		{		
			var thumbnail:Thumbnail = currentImages[i];
			//thumbnail.y = i * pieceWidth;
			thumbnail.x = column + 25;
			thumbnail.y = row * pieceHeight + 55;
			thumbnail.name = thumbnail.x + ":" + thumbnail.y;
			thumbnail.addEventListener(MouseEvent.MOUSE_DOWN, mouseDownHandler);
			thumbnail.addEventListener(MouseEvent.MOUSE_UP, mouseUpHandler);
			this.addChild(thumbnail);
			
			
			if ( (i+1) % difficulty == 0)
			{
				row ++;
			}
			
			column = ((i+1) % difficulty == 0)? 0 : ((i+1) % difficulty) * pieceWidth;
		}
	}
	
	/**
	 * Called on "mouseDown". Starts the drag and drop of the selected thumbnail. 
	 * @param	event Mouse Event 
	 */
	private function mouseDownHandler(event:MouseEvent)
	{
		var thumbnail:Thumbnail = cast event.currentTarget;
		xSource = cast thumbnail.x;
		ySource = cast thumbnail.y;
		setChildIndex(thumbnail, this.numChildren-1); //This thumbnail is in the first plan
		thumbnail.startDrag();
		var game:Game = cast this.parent;
		game.incrementStrokes();
	}
 
	
	/**
	 * Called on "mouseUp". Manages move of thumbnails.
	 * @param	event Mouse Event 
	 */
	private function mouseUpHandler(event:MouseEvent)
	{
		var obj = event.target;
		var target:Bitmap = cast obj.dropTarget;
		
		if (target != null )//&& Std.is(target, Thumbnail))
		{
			if (Std.is(target, Bitmap))
			{
				swap(obj.name, event.stageX, event.stageY);
				//thumbnailTarget.alpha = 0.7;
			}
		}
		else //Reposition the thumbnail on it initial position
		{
			obj.x = xSource;
			obj.y = ySource;
		}

		obj.stopDrag();
	}
	
	/**
	 * Swaps 2 thumbnails.
	 * @param	sourceName The name of the source thumbnail.
	 * @param	xDestMouse The x coordinate of the mouse corresponding to the x position of the destination thumbnail.
	 * @param	yDestMouse The y coordinate of the mouse corresponding to the y position of the destination thumbnail.
	 */
	private function swap(sourceName:String, xDestMouse:Float, yDestMouse:Float)
	{
		//trace("Source : " + sourceName);
		var indexSource:Int = findInArray(currentImages, sourceName);

		//trace("Destination : " + xDestMouse + ":" + yDestMouse);
		var indexDest:Int = findByMouseCoordinates(currentImages, xDestMouse, yDestMouse);

		
		//var xSource:Int = cast currentImages[indexSource].x;
		//var ySource:Int = cast currentImages[indexSource].y;
		var xDest:Int = cast currentImages[indexDest].x;
		var yDest:Int = cast currentImages[indexDest].y;
		
		var source:Thumbnail = currentImages[indexSource];
		var dest:Thumbnail = currentImages[indexDest];
		
		currentImages[indexSource].x = xDest;
		currentImages[indexSource].y = yDest;
		currentImages[indexSource] = dest;
		
		currentImages[indexDest].x = xSource;
		currentImages[indexDest].y = ySource;
		currentImages[indexDest] = source;
		
		//is finished?
		var isEqual:Bool = isEqual(solutionImages, currentImages);
		
		if (isEqual == true)
		{
			var game:Game = cast this.parent;
			game.endOfLevel();
		}
	}
	
	/**
	 * Allows to know the index of a value given in param into an array given too.
	 * @param	tab The array where we have to search.
	 * @param	val The value to search.
	 * @return The index corresponding.
	 * 		   -1 if it doesn't exist.
	 */
	private function findInArray(tab:Array<Thumbnail>, val:String) : Int
	{
		var i:Int = 0;
		for (i in 0 ... tab.length)
		{
			if (tab[i].name == val)
			{
				return i;
			}
		}
		return -1; 
	}
	
	/**
	 * Allows to know the index of the thumbnail corresponding to mouse's coordinates given in params.
	 * @param	tab The array when we have to search the tumbnail corresponding.
	 * @param	x The x coordinasste of the mouse
	 * @param	y The y coordinate of the mouse
	 * @return The index founded.
	 * 		   -1 if it doesn't exist
	 */
	private function findByMouseCoordinates(tab:Array<Thumbnail>, x:Float, y:Float) : Int
	{		
		var i:Int = 0;
		for (i in 0 ... tab.length)
		{
			//trace("x:" + x + " ; y:" + y);
			//trace("Xmin:" + tab[i].x + " ; Xmax:" + (tab[i].x + pieceWidth));
			//trace("Ymin:" + tab[i].y + " ; Ymax:" + (tab[i].y + pieceHeight));
			var Xmin:Int = cast tab[i].x;
			var Xmax:Int = cast (tab[i].x + pieceWidth);
			var Ymin:Int = cast tab[i].y;
			var Ymax:Int = cast (tab[i].y + pieceHeight);
			
			if (x >= Xmin && x <= Xmax)
			{
				if (y >= Ymin && y <= Ymax)
				{
					return i;
				}
			}
		}
		return -1; 
	}
	
	/**
	 * Compare 2 arrays.
	 * @param	tab The fisrt array
	 * @param	tab2 The second array
	 * @return true if its are equals
	 * 	       false otherwise
	 */
	private function isEqual(tab:Array<Thumbnail>, tab2:Array<Thumbnail>) : Bool
	{
		for (i in 0 ... tab.length)
		{
			if (tab[i].name != tab2[i].name)
			{
				return false;
			}
		}
		return true; 
	}
	
	/**
	 * Suffle an array.
	 * @param	array The array sorted.
	 * @return The array shuffled.
	 */
	private function shuffle(array:Array<Thumbnail>):Array<Thumbnail>
	{
		var n:Int = array.length;
		while (n > 1) 
		{
			var k:Int = Math.floor(Math.random()*n);
			n--;
			var tmp = array[k];
			array[k] = array[n];
			array[n] = tmp;
		}
		return array;
	}
	
	/**
	 * Destroy objects related to the current level.
	 */
	public function destroyCurrentLevel()
	{
		var i:Int = 0;
		for (i in 0 ... currentImages.length)
		{
			currentImages[i].removeEventListener(MouseEvent.MOUSE_DOWN, mouseDownHandler);
			currentImages[i].removeEventListener(MouseEvent.MOUSE_UP, mouseUpHandler);
			this.removeChild(currentImages[i]);
		}
		
		solutionImages = new Array<Thumbnail>();
		currentImages = new Array<Thumbnail>();
	}
	
}