package;

import flixel.FlxState;
import flixel.FlxSprite;
import flixel.system.FlxAssets.FlxGraphicAsset;
import flixel.util.FlxColor;
import flixel.FlxG;
class PlayState extends FlxState
{
	var _player:Player;
	var _ground:FlxSprite;
	var _component:Component;
	override public function create():Void
	{
		_player = new Player(320, 200);
		add(_player);
		_ground = new FlxSprite();
		_ground.makeGraphic(640,240,FlxColor.GRAY);
		_ground.x = 0;
		_ground.y = 240;
		add(_ground);
		_component = new Component("Component", 200, 220);
		add(_component);
		super.create();
	}


	override public function update(elapsed:Float):Void
	{
		if (FlxG.collide(_player,_ground)){
			_player.grounded();
			_ground.velocity.set(0,0);
			_ground.x=0;
			_ground.y= 240;
		}
		super.update(elapsed);
	}
}
