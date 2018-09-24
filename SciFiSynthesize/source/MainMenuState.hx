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
		_startButton = new FlxButton(10, 10, "Start", start);
		_startButton.screenCenter();
		add(_startButton);

		_testButton = new FlxButton(10, 10, "Test", test);
		_testButton.screenCenter();
		_testButton.y += 40;
		add(_testButton);

		_titleText = new FlxText(100, 100, 350, "Synthesize", 50);
		_titleText.screenCenter();
		_titleText.y -= 50;
		add(_titleText);

		super.create();
	}

	override public function update(elapsed:Float): Void {
		super.update(elapsed);
	}

	function start(): Void {
		FlxG.switchState(new Tutorial());
	}

	function test() : Void {
		FlxG.switchState(new PlayState());
	}
}
