package;

import flixel.FlxState;
import flixel.FlxG;
import flixel.text.FlxText;
import flixel.ui.FlxButton;

class MainMenuState extends FlxState
{
	var _startButton:FlxButton;
	var _testButton:FlxButton;
	var _titleText:FlxText;


	override public function create(): Void {
		FlxG.mouse.useSystemCursor = true;
		_startButton = new FlxButton(10, 10, " ", start);
		_startButton.loadGraphic("assets/images/start-unpressed.png");
		_startButton.updateHitbox();
		_startButton.screenCenter();
		_startButton.onDown.callback = onButtonDown;
		add(_startButton);

		_titleText = new FlxText(100, 100, 350, "Synthesize", 50);
		_titleText.screenCenter();
		_titleText.y -= 50;
		add(_titleText);

		super.create();
	}

	override public function update(elapsed:Float): Void {
		super.update(elapsed);
	}
	function onButtonDown( ) : Void {
		_startButton.loadGraphic("assets/images/start-pressed.png");
	}
	function start(): Void {
		FlxG.switchState(new Tutorial());
	}
}
