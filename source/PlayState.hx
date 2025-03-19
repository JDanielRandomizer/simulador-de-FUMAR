package;

import flixel.FlxState;
import flixel.FlxG;
import flixel.util.FlxColor;
import flixel.FlxSprite;
import flixel.text.FlxText;
import flixel.FlxSubState;
import flixel.graphics.frames.FlxAtlasFrames;

import flixel.tweens.FlxTween;
import flixel.tweens.FlxEase;

import SprigatitoGroup;

class PlayState extends FlxState
{
	// FlxText
	public static var textStats:FlxText;

	// Int || Float
	public static var bothTimer:Array<Float> = [
		0.0,     // timeHolding
		100.0  // timeUsable
	];
	
	// .
	public static var SPRIGATITO_GROUP:SprigatitoGroup; // do nada comecei a amar "_"
	public static var FAKE_MOUSE:FakeMouse;

	override public function create()
	{
		super.create();

		textStats = new FlxText(10, 10, 0, 'Tempo Fumando: ${bothTimer[0]}\nOxigênio: ${bothTimer[1]}');
    	textStats.setFormat('_sans', 32, FlxColor.BLACK, LEFT, FlxTextBorderStyle.SHADOW, FlxColor.GRAY);
		add(textStats);

		SPRIGATITO_GROUP = new SprigatitoGroup();
		add(SPRIGATITO_GROUP);

		FAKE_MOUSE = new FakeMouse();
		add(FAKE_MOUSE);
	}

	override public function update(elapsed:Float)
	{
		super.update(elapsed);

		textStats.text = 'Tempo Fumando: ${Math.floor(bothTimer[0])}\nOxigênio: ${Math.floor(bothTimer[1])}';

		if(FlxG.mouse.pressed) {
			if(bothTimer[1] > 0) {
				bothTimer[1] -= 10/100;
				bothTimer[0] += 1/100;
			} else
				openSubState(new DeathSubstate());
		} else if(bothTimer[1] < 100) 
		bothTimer[1] += 2/100;

	if(FlxG.keys.justPressed.F5 && FlxG.keys.pressed.CONTROL) // silly little me
		SPRIGATITO_GROUP.preloadShit();

	if(FlxG.keys.justPressed.F4 && FlxG.keys.pressed.CONTROL) // silly little...
		SPRIGATITO_GROUP.deathAnim();

	if(FlxG.keys.justPressed.F3 && FlxG.keys.pressed.CONTROL) // silly little you
		openSubState(new DeathSubstate());
	}
}

class FakeMouse extends FlxSprite
{
	override public function new()
	{
		super();

		loadGraphic('assets/images/mouse/mouse.png');
	}

	override public function update(elapsed:Float)
	{
		setPosition(FlxG.mouse.x-43, FlxG.mouse.y);

		if(FlxG.mouse.justPressed)
			loadGraphic('assets/images/mouse/mouseSegurando.png');

		if(FlxG.mouse.justReleased)
			loadGraphic('assets/images/mouse/mouse.png');

		super.update(elapsed);
	}
}

class DeathSubstate extends FlxSubState
{
	// FlxSprite
	var restartButton:FlxSprite;
	var leaveGame:FlxSprite;

	// Bool
	var canAccept:Bool = true;

	override public function create()
	{
		super.create();

		PlayState.FAKE_MOUSE.destroy();
		PlayState.SPRIGATITO_GROUP.destroy();

		if(PlayState.bothTimer[0] > FlxG.save.data.HighScore) {
			FlxG.save.data.HighScore = PlayState.bothTimer[0];
			FlxG.save.flush();
		}

		PlayState.textStats.text = 'Tempo Fumando: ${Math.floor(PlayState.bothTimer[0])}\nOxigênio: 0';

		var beck = new FlxSprite(598,500,'assets/images/sprigatito/cigarro.png');
		FlxTween.tween(beck, {y:500-(PlayState.bothTimer[0]*10)}, 0.75, {ease: FlxEase.expoOut});
		FlxTween.tween(beck, {y:500}, 0.75, {ease: FlxEase.expoIn, startDelay: 0.75});
		FlxTween.tween(beck, {y:450}, 0.75, {ease: FlxEase.sineInOut, type: PINGPONG, startDelay: 1.6});
		FlxTween.tween(beck, {y:475, "scale.x": -1}, 2, {ease: FlxEase.sineInOut, type: PINGPONG, startDelay: 1.5});
		add(beck);

		var SPRIGATITO_GROUP = new SprigatitoGroup(true);
		add(SPRIGATITO_GROUP);

		var minecraftRedThing = new FlxSprite().makeGraphic(1280, 720, FlxColor.RED);
		minecraftRedThing.alpha = 0.75;
		add(minecraftRedThing);

		var youdied = new FlxText(329, 100, 0, 'YOU DIED');
    	youdied.setFormat('_sans', 128, FlxColor.WHITE, CENTER, FlxTextBorderStyle.SHADOW, FlxColor.GRAY);
		add(youdied);

		var dieMessage = new FlxText(249, 322, 0, 'Sprig forgot to take a break\nhighscore: ${Math.floor(FlxG.save.data.HighScore)}');
    	dieMessage.setFormat('_sans', 64, FlxColor.WHITE, CENTER, FlxTextBorderStyle.SHADOW, FlxColor.GRAY);
		dieMessage.screenCenter();
		add(dieMessage);

		restartButton = new FlxSprite(283, 546, 'assets/images/restart.png');
		add(restartButton);

		leaveGame = new FlxSprite(0.5,-720);
		leaveGame.frames = FlxAtlasFrames.fromSparrow('assets/images/sprigatito/reset/endAnim.png', 'assets/images/sprigatito/reset/endAnim.xml');
		leaveGame.animation.addByPrefix('anime', 'anime', 24, false);
		leaveGame.visible = false;
		add(leaveGame);

		var FAKE_MOUSE = new FakeMouse();
		add(FAKE_MOUSE);
	}

	override public function update(elapsed:Float)
	{
		super.update(elapsed);
		if(leaveGame.animation.finished && leaveGame.visible) {
			FlxG.resetGame();

			PlayState.bothTimer[0] = 0;		PlayState.bothTimer[1] = 100;
		}

		if(canAccept) {
			if(FlxG.mouse.justPressed && FlxG.mouse.overlaps(restartButton)) {
				leaveGame.animation.play('anime');
				leaveGame.visible = true;

				canAccept = false;
			}
		}
	}
}