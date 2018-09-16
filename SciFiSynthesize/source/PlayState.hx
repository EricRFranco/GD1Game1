package;

import flixel.FlxState;
import flixel.FlxSprite;
import flixel.system.FlxAssets.FlxGraphicAsset;
import flixel.util.FlxColor;
import flixel.FlxG;
import flixel.group.FlxGroup;

class PlayState extends FlxState
{
	var _player:Player;
	var _ground:FlxSprite;
	var _component:Component;
	var _sceneComponents = new FlxTypedGroup<Component>();	//Grouping all components to simplify collision detection with player
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
		_sceneComponents.add(_component);
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
		if(FlxG.overlap(_player, _sceneComponents)) {
			onOverlapComponent();
		}
		super.update(elapsed);
	}

	public function onOverlapComponent() : Void {
    	for(c in _sceneComponents) {
			if(FlxG.overlap(_player, c)) {
				_player.addToInventory(c);
				_sceneComponents.remove(c);
				remove(c);
				return;
			}
		}
  	}
}
