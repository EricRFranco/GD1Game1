package;

import flixel.FlxState;
import flixel.FlxSprite;
import flixel.system.FlxAssets.FlxGraphicAsset;
import flixel.util.FlxColor;
import flixel.FlxG;
import flixel.group.FlxGroup;
import flixel.FlxCamera;

class PlayState extends FlxState
{
	var _player:Player;
	var _ground:FlxSprite;
	var _spring:Component;	// Exist only to test mutagen synthesis
	var _shoe:Component;
	var _fan:Component;
	var _battery:Component;
	var _sceneComponents = new FlxTypedGroup<Component>();	//Grouping all components to simplify collision detection with player
	var _enemies = new FlxTypedGroup<Enemy>(); //Grouping all enemies to simplify passing information and collision detection
	public static var allMutagens = new Array<Mutagen>();
	override public function create():Void
	{
		FlxG.worldBounds.set(0, 0, 2000, 2000);
		
		_player = new Player(200, 200);
		add(_player);
		
		_ground = new FlxSprite();
		_ground.makeGraphic(2000,200,FlxColor.GRAY);
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
		
		_enemies.add(new Enemy(1500,200,2));
		add(_enemies);
		
		var _camera = new FlxCamera(0, 0, 1200, 750);
		_camera.follow(_player);
		_camera.setScrollBounds(0, 2000, 0, 2000);
		FlxG.cameras.add(_camera);
		
		super.create();
	}


	override public function update(elapsed:Float):Void
	{
		if (FlxG.overlap(_player,_ground)){
			_player.grounded();
			_ground.velocity.set(0,0);
			_ground.x=0;
			_ground.y= 240;
		}

		if(FlxG.overlap(_player, _sceneComponents)) {
			onOverlapComponent();
		}
		
		if (FlxG.overlap(_player, _enemies)) {
			//trace("Touched enemy!!");
			for (enemy in _enemies) {
				if (FlxG.overlap(_player, enemy)) {
					if (_player.rushing) {
						enemy.takeDamage(3);
						if (!enemy.alive) {
							remove(enemy);
							_enemies.remove(enemy);
						}
					}
				}
			}
		}
		for (x in _enemies){
			x.givePlayerLocation(_player.x+10,_player.y+10);
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
