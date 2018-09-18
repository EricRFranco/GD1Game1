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
	var _spring:Component;	// Exist only to test mutagen synthesis
	var _shoe:Component;
	var _fan:Component;
	var _battery:Component;	
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
		//components for high jump on left of player
		_spring = new Component("Spring", 200, 220);
		add(_spring);
		_sceneComponents.add(_spring);
		_shoe = new Component("Shoe", 150, 220);
		add(_shoe);
		_sceneComponents.add(_shoe);
		//components for super rush on the right of player
		_fan = new Component("Fan", 400, 220);
		add(_fan);
		_sceneComponents.add(_fan);
		_battery = new Component("Battery", 450, 220);
		add(_battery);
		_sceneComponents.add(_battery);
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
