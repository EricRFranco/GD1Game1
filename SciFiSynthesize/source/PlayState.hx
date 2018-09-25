package;

import flixel.FlxObject;
import flixel.FlxState;
import flixel.FlxSprite;
import flixel.system.FlxAssets.FlxGraphicAsset;
import flixel.util.FlxColor;
import flixel.FlxG;
import flixel.group.FlxGroup;
import flixel.FlxCamera;
import flixel.tile.FlxTilemap;

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
	var _elevator:Elevator;
	var _switchfield:SwitchField;
	var _sceneComponents = new FlxTypedGroup<Component>();	//Grouping all components to simplify collision detection with player
	var _enemies = new FlxTypedGroup<Enemy>(); //Grouping all enemies to simplify passing information and collision detection
	var _boxes = new FlxTypedGroup<Box>();
	//Health markers displayed in top left corner
	var _hp1:Health;
	var _hp2:Health;
	var _hp3:Health;
	public var _meleeAttacks = new FlxTypedGroup<Melee>();
	public var _bullets = new FlxTypedGroup<Bullet>();
	public var _lasers = new FlxTypedGroup<Laser>();
	public static var allMutagens = new Array<Mutagen>();
	var highjump:HighJump;
	var pushboxes:PushBoxes;
	var superrush:SuperRush;
	var current_mut:Mutagen;
	var remove_mut:Bool;
	var _mWalls:FlxTilemap;
	var _mBoxes:FlxTilemap;

	override public function create():Void
	{
		// For debug mode
		/*bgColor = FlxColor.WHITE;
		FlxG.worldBounds.set(0, 0, 2000, 2000);
		FlxG.mouse.visible = false;

		for (x in 0...5){
			var temp = new Melee(-1,-1);
			temp.kill();
			_meleeAttacks.add(temp);
		}
		add(_meleeAttacks);
		for (x in 0...20){
			var temp = new Bullet(-1,-1);
			temp.kill();
			_bullets.add(temp);
		}
		add(_bullets);
		for (x in 0...5){
			var temp = new Laser(-1,-1);
			temp.kill();
			_lasers.add(temp);
		}
		add(_lasers);

		_player = new Player(210, 680);
		add(_player);

		_ground = new FlxSprite();
		_ground.makeGraphic(2000,200,FlxColor.GRAY);
		_ground.x = 0;
		_ground.y = 700;
		_ground.immovable = true;
		add(_ground);

		_switchfield = new SwitchField(1500,200);
		add(_switchfield);

		//components for high jump on left of player
		_spring = new Component("Spring", 180, 680);
		add(_spring);
		_sceneComponents.add(_spring);
		_shoe = new Component("Shoe", 150, 680);
		add(_shoe);
		_sceneComponents.add(_shoe);

		//components for super rush on the right of player
		_fan = new Component("Fan", 400, 680);
		add(_fan);
		_sceneComponents.add(_fan);
		_battery = new Component("Battery", 450, 680);
		add(_battery);
		_sceneComponents.add(_battery);

		//components for push boxes on the farther right of player
		_glove = new Component("Glove", 500, 680);
		add(_glove);
		_sceneComponents.add(_glove);
		_dumbell = new Component("Dumbell", 550, 680);
		add(_dumbell);
		_sceneComponents.add(_dumbell);

		var enemy1:Enemy = _enemies.add(new Enemy(1500, 600, 2));
		enemy1.velocity.set(0, 50);
		var enemy2:Enemy = _enemies.add(new Enemy(700, 600, 3));
		enemy2.velocity.set(0, 50);
		add(_enemies);
		_box = new Box(300, 650);
		add(_box);
		_boxes.add(_box);

		_elevator = new Elevator(1500, 675);
		add(_elevator);
		//camera to scroll with player
		var _camera = new FlxCamera(0, 0, 1200, 750);
		_camera.follow(_player);
		_camera.setScrollBounds(0, 2000, 0, 2000);
		FlxG.cameras.add(_camera);*/

		//health UI in upper left corner
		_hp1 = new Health(10, 10);
		add(_hp1);
		_hp2 = new Health(30, 10);
		add(_hp2);
		_hp3 = new Health(50, 10);
		add(_hp3);

		highjump = new HighJump(1100, 10, _player);
		pushboxes = new PushBoxes(1100, 10, _player);
		superrush = new SuperRush(1100, 10, _player);

		super.create();
	}


	override public function update(elapsed:Float):Void
	{
		if (FlxG.overlap(_player,_ground)){
			_player.grounded();
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
		if (FlxG.overlap(_player,_boxes)){
			for ( x in _boxes){
				if ((x.x <= _player.x+_player.width) || (x.x+x.width <= _player.x)){
					_player.grounded();
				}
			}
		}

		if(!((FlxG.overlap(_player,_ground))||(FlxG.overlap(_player,_boxes)))){
			_player.hitMeWithThatGravity();
		}

		if (FlxG.collide(_player, _enemies)) {
			//trace("Touched enemy!!");
			for (enemy in _enemies) {
				if (FlxG.overlap(_player, enemy)) {
					if (_player.y + 20 > enemy.y) {
						_player.knockback(false);
					} else {
						_player.move(true);
					}
					if (_player.rushing) {
						enemy.takeDamage(_player.power);
						if (!enemy.alive) {
							remove(enemy);
							_enemies.remove(enemy);
						}
					}
				}
			}
		}

		if (FlxG.overlap(_meleeAttacks,_player)){
			for (x in _meleeAttacks){
				if (FlxG.overlap(x,_player)){
					if(x.alreadyHit)continue;
					if(x.hitFrameStart<x.currentFrame && x.currentFrame < x.hitFrameEnd){
						x.hit();
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
			}
		}
		if (FlxG.overlap(_lasers,_player)){
			for (x in _lasers){
				if (FlxG.overlap(x,_player)){
					if(x.alreadyHit)continue;
					if(x.hitFrameStart<x.currentFrame && x.currentFrame < x.hitFrameEnd){
						x.hit();
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
			}
		}
		if (FlxG.overlap(_bullets,_player)){
			for (x in _bullets){
				if (FlxG.overlap(x,_player)){
					_player.takeDamage();
					x.kill();
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
		}
		for (x in _enemies){
			x.givePlayerLocation(_player.x+10,_player.y+10);
		}

		if(FlxG.overlap(_bullets, _boxes)){
			for(x in _bullets){
				if (FlxG.overlap(x,_boxes)){
					x.kill();
				}
			}
		}

		if(FlxG.collide(_player,_elevator)){
			_elevator.rise = true;
			_player.grounded();
		}

		if(FlxG.overlap(_player,_switchfield)){
			FlxG.switchState(new Tutorial());
		}

		if (_player.changing_mut) {
			if (current_mut != null){
				remove(current_mut);
			}
			switch(_player.active_mut){
				case("high jump"):
					add(highjump);
					current_mut = highjump;
				case("push boxes"):
					add(pushboxes);
					current_mut = pushboxes;
				case("super rush"):
					add(superrush);
					current_mut = superrush;
			}

			_player.changing_mut = false;
		}
		
		if (FlxG.collide(_player, _mWalls) || FlxG.collide(_player, _mBoxes)) {
			if (_player.isTouching(FlxObject.UP)) {
				_player.yvel = 0;
			}
			if (_player.isTouching(FlxObject.DOWN)) {
				_player.grounded();
			}
		} else {
			_player.airborne = true;
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
