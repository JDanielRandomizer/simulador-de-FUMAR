package;

import flixel.FlxGame;
import openfl.display.Sprite;
import flixel.FlxG;
import flixel.util.FlxColor;
import openfl.display.FPS;

class Main extends Sprite
{
	public function new()
	{
		super();
		addChild(new FlxGame(1280, 720, PlayState, 100, 100, true, false));
		addChild(new FPS(0, 703, 0x000000));
		
		FlxG.cameras.bgColor = FlxColor.WHITE;
		FlxG.mouse.visible = false;
		FlxG.autoPause = false;

		if(FlxG.save.data.HighScore == null) FlxG.save.data.HighScore = 0;
	}
}
