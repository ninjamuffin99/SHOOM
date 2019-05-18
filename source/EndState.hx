package;

import flixel.FlxState;
import flixel.addons.text.FlxTextField;
import flixel.text.FlxText;

/**
 * ...
 * @author ninjamuffin99
 */
class EndState extends FlxState 
{

	override public function create():Void 
	{
		var end:FlxText = new FlxText(0, 0, 0, "THE END LMAO\nMADE BY NINJAMUFFIN99\nSHOUTOUT TO JOJO", 30);
		add(end);
		end.alignment = CENTER;
		end.screenCenter();
		
		super.create();
	}
	
}