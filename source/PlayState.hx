package;

import flixel.FlxG;
import flixel.FlxState;
import flixel.text.FlxText;
import flixel.util.FlxStringUtil;
import io.newgrounds.NG;
using flixel.util.FlxStringUtil;
using StringTools;

class PlayState extends FlxState
{
	private var shoomCount:Int = 2;
	private var tmpShoom:Int = 0;
	private var txt:FlxText;
	private var credTxt:FlxText;
	
	private var bpm:Float = 60;
	private var crotchet:Float = 0;
	private var steps:Float = 0;
	
	private var lastBeats:Array<Float> = [0];
	private var beatTimer:Float = 0;
	
	private var notes:Array<Dynamic> = [];
	private var songPos:Float = 0;
	private var curBeat:Int = 0;
	private var curStep:Int = 0;
	private var lastBeat:Float = 0;
	private var lastStep:Float = 0;
	
	private var thaShoom:String = "";
	private var shoomText:FlxText;
	private var csvShit:String = "";
	
	//SHOOM WIDTH = 133/136
	//SHOOM HEIGHT = 48
	var format2 = new FlxTextFormat(0xFCA138, false, false, 0xFF8000);
	var format3 = new FlxTextFormat(0xFDA442, false, false, 0xFF8000);
	public var markUpShit:Array<FlxTextFormatMarkerPair>;
	
	private var drumPatterns:Array<Dynamic> = [];
	private var curTime:Float = 0;
	
	override public function create():Void
	{
		var ng = new NGio(APIStuff.APIKEY, APIStuff.ENCKEY);
		
		markUpShit = [new FlxTextFormatMarkerPair(format2, "<o>"),
						new FlxTextFormatMarkerPair(format3, "<o2>")];
		
		txt = new FlxText(20, 20, 0, "Ready", 24);
		add(txt);
		
		credTxt = new FlxText(700, 20, 0, "Made by ninjamuffin99", 18);
		add(credTxt);
		
		csvShit = FlxStringUtil.imageToCSV("assets/images/shoom.png");
		csvFunctionShit(csvShit);
		
		shoomText = new FlxText(9, FlxG.height * 0.11, FlxG.width - 10, "SHOOM");
		add(shoomText);
		
		for (r in 0...2)
		{
			notes.push([]);
			for (i in 0...16)
			{
				if (r == 0)
				{
					notes[r].push(i % 4 == 0);
				}
				else
					notes[r].push(i % 2 == 0);
			}
			
			
		}
		
		drumPatterns.push(notes);
		
		super.create();
	}

	override public function update(elapsed:Float):Void
	{
		txt.text = "Shoom count: " + shoomCount;
		txt.screenCenter(X);
		
		beatTimer += FlxG.elapsed;
		songPos += FlxG.elapsed;
		
		if (FlxG.camera.zoom > 1)
		{
			FlxG.camera.zoom -= 0.4 * FlxG.elapsed;
		}
		else
			FlxG.camera.zoom = 1;
		
		if (FlxG.keys.justPressed.R)
			FlxG.resetGame();
		
		
		if (shoomCount > 2)
		{
			beatHandling();
			
			if (shoomText.alpha >= 0)
			{
				shoomText.alpha -= FlxG.elapsed * 2.6;
			}
			if (credTxt.alpha >= 0)
				credTxt.alpha -= FlxG.elapsed * 2;
			if (txt.alpha >= 0)
				txt.alpha -= FlxG.elapsed * 2.6;
			
		}
		
		// Time in MILLISECONDS
		curTime += FlxG.elapsed;
		
		if (FlxG.mouse.justPressed || FlxG.keys.justPressed.SPACE)
		{
			shoomCount += 1;
			shoomText.alpha = 1;
			txt.alpha = 1;
			credTxt.alpha = 1;
			
			if (FlxG.camera.zoom < 1.1)
			{
				FlxG.camera.zoom += 0.025;
			}
			
			if (shoomCount == 77)
			{
				if (NGio.isLoggedIn)
				{
					var board = NG.core.scoreBoards.get(8541);// ID found in NG project view
					board.postScore(Std.int(curTime * 1000));
					FlxG.log.add(curTime * 1000);
					
					var hornyMedal = NG.core.medals.get(57081);
					if (!hornyMedal.unlocked)
						hornyMedal.sendUnlock();
					
					
				}
				
				txt.text = "Shoom count: <o>" + shoomCount + "<o>";
				txt.applyMarkup(txt.text, markUpShit);
				FlxG.sound.play(AssetPaths.hit77__mp3, 0.5);
			}
			else
				txt.clearFormats();
			
			if (shoomCount == 6478)
			{
				if (NGio.isLoggedIn)
				{
					var hornyMedal = NG.core.medals.get(57082);
					if (!hornyMedal.unlocked)
						hornyMedal.sendUnlock();
				}
				
				FlxG.switchState(new EndState());
			}
		
			//FlxG.log.add();
			thaShoom = "SH";

			//NOTE TO SELF
			// FIND A MORE EFFICIENT WAY TO DO THIS SO THAT YOU CAN APPLY MARKUP EASIER
			for (i in 0...shoomCount)
			{
				/*
				if (_data[i] == 1)
				{
					if (_data[i + 1] == 1)
					{
						if (_data[i - 1] == 1)
							thaShoom += "O";
						else
							thaShoom += "<o>O";
					}
					else if (_data[i - 1] == 1)
					{
						thaShoom += "O<o>";
					}
					else
						thaShoom += "<o>O<o>";
					
					//thaShoom += "O";
				}
				else
					thaShoom += "O";
				*/
					
				thaShoom += "O";
			}
			
			thaShoom += "M";
			shoomText.text = thaShoom;
			shoomText.applyMarkup(shoomText.text, markUpShit);
			
			lastBeats.push(beatTimer);
			beatTimer = 0;
			
			if (shoomCount % 4 == 0 && FlxG.random.bool())
			{
				FlxG.sound.play("assets/sounds/chord" + FlxG.random.int(1, 5) + ".mp3", FlxG.random.float(0.4, 0.8));
			}
			else if (FlxG.random.bool(30))
			{
				if (FlxG.random.bool(70))
				{
					FlxG.sound.play("assets/sounds/pluck" + FlxG.random.int(2, 7) + ".mp3", FlxG.random.float(0.1, 0.5));
				}
				else
				{
					FlxG.sound.play("assets/sounds/highpass" + FlxG.random.int(1, 5) + ".mp3", FlxG.random.float(0.1, 0.5));
				}
				
				
			}
			else
			{
				FlxG.sound.play("assets/sounds/hihat8bit.mp3", FlxG.random.float(0.1, 0.5));
			}
		}
		
		super.update(elapsed);
	}
	
	
	private function beatHandling():Void
	{
		
		if (songPos > lastBeat)
		{
			lastBeat += crotchet;
			curBeat += 1;
		}
		
		if (songPos > lastStep + steps)
		{
			lastStep += steps;
			curStep += 1;
			
			if (lastBeats.length >= 15)
			{
				if (notes[0][curStep])
				{
					FlxG.sound.play("assets/sounds/kick.mp3", 0.3);
				}
				
				if (notes[1][curStep])
				{
					FlxG.sound.play("assets/sounds/hihat.mp3", 0.8);
				}
			}
			
		}
		
		if (curStep == 16)
		{
			curBeat = 0;
			lastBeat = 0;
			curStep = 0;
			lastStep = 0;
			songPos = 0;
			
			if (notes[0][0])
			{
				FlxG.sound.play("assets/sounds/kick.mp3", 0.8);
			}
			
			if (notes[1][0])
			{
				FlxG.sound.play("assets/sounds/hihat.mp3", 0.8);
			}
			
		}
		
		if (beatTimer >= 10)
		{
			lastBeats = [];
		}
		
		var tempBPM:Float = 0;
		
		for (i in lastBeats)
		{
			tempBPM += i;
		}
		
		tempBPM /= lastBeats.length;
		
		bpm = (60 / tempBPM) / 4;
		crotchet = (60 / bpm);
		steps = (crotchet * 0.25);
		
		if (lastBeats.length > 20)
		{
			lastBeats.shift();
		}

	}
	
	
	var _data:Array<Int>;
	var heightInTiles:Int = 0;
	var widthInTiles:Int = 0;
	private function csvFunctionShit(MapData:String)
	{
		// Figure out the map dimensions based on the data string
		_data = new Array<Int>();
		var columns:Array<String>;
		
		var regex:EReg = new EReg("[ \t]*((\r\n)|\r|\n)[ \t]*", "g");
		var lines:Array<String> = regex.split(MapData);
		var rows:Array<String> = lines.filter(function(line) return line != "");
		
		heightInTiles = rows.length;
		widthInTiles = 0;
		
		var row:Int = 0;
		while (row < heightInTiles)
		{
			var rowString = rows[row];
			if (rowString.endsWith(","))
				rowString = rowString.substr(0, rowString.length - 1);
			columns = rowString.split(",");
			
			if (columns.length == 0)
			{
				heightInTiles--;
				continue;
			}
			if (widthInTiles == 0)
			{
				widthInTiles = columns.length;
			}
			
			var column = 0;
			while (column < widthInTiles)
			{
				//the current tile to be added:
				var columnString = columns[column];
				var curTile = Std.parseInt(columnString);
				
				if (curTile == null)
					throw 'String in row $row, column $column is not a valid integer: "$columnString"';
				
				// anything < 0 should be treated as 0 for compatibility with certain map formats (ogmo)
				if (curTile < 0)
					curTile = 0;
				
				_data.push(curTile);
				column++;
			}
			
			row++;
		}
		
	}
}
