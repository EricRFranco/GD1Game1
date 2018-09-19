package;

import flixel.FlxObject;
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
	var _glove:Component;
	var _dumbell:Component;
	var _box:Box;
	var _sceneComponents = new FlxTypedGroup<Component>();	//Grouping all components to simplify collision detection with player
	var _enemies = new FlxTypedGroup<Enemy>(); //Grouping all enemies to simplify passing information and collision detection
	var _boxes = new FlxTypedGroup<Box>();
	//Health markers displayed in top left corner
	var _hp1:Health;
	var _hp2:Health;
	var _hp3:Health;
	public static var allMutagens = new Array<Mutagen>();
	override public function create():Void
	{
		FlxG.worldBounds.set(0, 0, 2000, 2000);
		FlxG.mouse.visible = false;
		
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
		//components for push boxes on the farther right of player
		_glove = new Component("Glove", 500, 220);
		add(_glove);
		_sceneComponents.add(_glove);
		_dumbell = new Component("Dumbell", 550, 220);
		add(_dumbell);
		_sceneComponents.add(_dumbell);
		_enemies.add(new Enemy(1500,200,2));
		_enemies.add(new Enemy(700,200,2));
		add(_enemies);
		_box = new Box(300, 190);
		add(_box);
		_boxes.add(_box);
		
		//camera to scroll with player
		var _camera = new FlxCamera(0, 0, 1200, 750);
		_camera.follow(_player);
		_camera.setScrollBounds(0, 2000, 0, 2000);
		FlxG.cameras.add(_camera);
		
		//health UI in upper left corner
		_hp1 = new Health(10, 10);
		add(_hp1);
		_hp2 = new Health(30, 10);
		add(_hp2);
		_hp3 = new Health(50, 10);
		add(_hp3);
		
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

		for(box in _boxes) {
			if(!_player.canPush && !box.immovable)
				box.immovable = true;
			else if(_player.canPush && box.immovable)
				box.immovable = false;
		}
		FlxG.collide(_player,_boxes);
		
		if (FlxG.collide(_player, _enemies)) {
			//trace("Touched enemy!!");
			if (_player.rushing) {
				for (enemy in _enemies) {
					if (FlxG.overlap(_player, enemy)) {
						enemy.takeDamage(3);
						if (!enemy.alive) {
							remove(enemy);
							_enemies.remove(enemy);
						}
					}
				}
			} else {
				_player.takeDamage();
				var health_left:Int = _player.hp;
				switch(health_left) {
					case (2):
						remove(_hp3);
					case (1):
						remove(_hp2);
					case(0):
						remove(_hp1);
						game_over();
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
	
	public function game_over() {
		trace("You died lol");
	}
}
