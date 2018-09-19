package;

import flixel.FlxObject;
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
	var _glove:Component;
	var _dumbell:Component;
	var _box:Box;
	var _sceneComponents = new FlxTypedGroup<Component>();	//Grouping all components to simplify collision detection with player
	var _enemies = new FlxTypedGroup<Enemy>(); //Grouping all enemies to simplify passing information and collision detection
	var _boxes = new FlxTypedGroup<Box>();
	public static var allMutagens = new Array<Mutagen>();
	override public function create():Void
	{
		_player = new Player(200, 200);
		add(_player);
		_ground = new FlxSprite();
		_ground.makeGraphic(1600,200,FlxColor.GRAY);
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
		add(_enemies);
		_box = new Box(300, 190);
		add(_box);
		_boxes.add(_box);
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
		}
		FlxG.collide(_player,_boxes);
		
		if (FlxG.overlap(_player, _enemies)) {
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
