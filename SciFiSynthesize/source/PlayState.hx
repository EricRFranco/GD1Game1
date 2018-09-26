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
import flixel.text.FlxText;
import flixel.ui.FlxButton;

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
	var _camera:FlxCamera;
	var _uicamera:FlxCamera;
	var _computers = new FlxTypedGroup<Computer>();
	var log_open:Bool = false;
	var active_log:FlxText;
	var active_log_bg:FlxSprite;
	var gameover_box:FlxSprite;
	var gameover_text:FlxText;
	var gameover_button:FlxButton;
	var _health:FlxTypedGroup<Health>;

	override public function create():Void
	{
		// For debug mode
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
		
		// Add UI elements
		_health = new FlxTypedGroup<Health>();
		_hp1 = new Health(40, 10);
		_hp2 = new Health(60, 10);
		_hp3 = new Health(80, 10);
		_health.add(_hp1);
		_health.add(_hp2);
		_health.add(_hp3);
		add(_health);
		_player.health = 3;
		highjump = new HighJump(850, 10, _player);

		_uicamera = new FlxCamera(0, 0, 925, 750);
		_uicamera.bgColor = FlxColor.TRANSPARENT;
		FlxG.cameras.add(_uicamera);

		for (hp in _health) {
			hp.cameras = [_uicamera];
		}
		highjump.cameras = [_uicamera];

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
						_camera.shake(0.005);
						var health_left:Int = _player.hp;
						switch(health_left) {
							case (2):
								_health.remove(_hp3);
							case (1):
								_health.remove(_hp2);
							case(0):
								_health.remove(_hp1);
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
						_camera.shake(0.005);
						var health_left:Int = _player.hp;
						switch(health_left) {
							case (2):
								_health.remove(_hp3);
							case (1):
								_health.remove(_hp2);
							case(0):
								_health.remove(_hp1);
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
					_camera.shake(0.005);
					x.kill();
					var health_left:Int = _player.hp;
					trace(_player.hp);
					switch(health_left) {
						case (2):
							trace("Removing 1 health");
							_health.remove(_hp3);
						case (1):
							_health.remove(_hp2);
						case(0):
							_health.remove(_hp1);
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

		if (FlxG.collide(_player, _mWalls)) {
			if (_player.isTouching(FlxObject.UP)) {
				_player.yvel = 0;
			}
			if (_player.isTouching(FlxObject.DOWN)) {
				_player.grounded();
			}
		} else {
			_player.airborne = true;
		}

		if (FlxG.collide(_player, _mBoxes)) {
			if (_player.isTouching(FlxObject.DOWN)) {
				_player.grounded();
			}
		}

		for (enemy in _enemies) {
			if (FlxG.collide(enemy, _mWalls)) {
				enemy.grounded();
			}
			else {
				//trace("should fall");
				enemy.airborne = true;
			}
		}

		for (box in _boxes) {
			var temp:Bool = box.immovable;
			box.immovable = false;
			if (FlxG.collide(box, _mWalls)) {
				box.grounded();
			}
			else {
				box.airborne = true;
				for (x in _enemies){
					if (FlxG.overlap(x,box)){
						x.kill();
					}
				}
			}
			box.immovable = temp;
		}


		if (FlxG.keys.anyJustPressed([DOWN, S]) && log_open) {
			remove(active_log);
			remove(active_log_bg);
			active_log = null;
			active_log_bg = null;
			log_open = false;
			_player.paused = false;
			for (enemy in _enemies) {
				enemy.paused = false;
			}
		} else {
			FlxG.overlap(_player, _computers, openLog);
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

	public function openLog(player:Player, computer:Computer): Void {
		if (FlxG.keys.anyJustPressed([DOWN, S]) && !log_open) {
			active_log = computer.log_text;
			active_log_bg = computer.log_bg;
			add(active_log_bg);
			add(active_log);
			log_open = true;
			_player.paused = true;
			for (enemy in _enemies) {
				enemy.paused = true;
			}
		}
	}

	public function game_over() {
		gameover_box = new FlxSprite(0, 0);
		gameover_box.makeGraphic(925, 750, FlxColor.BLACK);
		gameover_box.cameras = [_uicamera];
		add(gameover_box);
		
		gameover_text = new FlxText(0, 0, 265, "Game Over, Man", 25);
		gameover_text.cameras = [_uicamera];
		gameover_text.screenCenter();
		gameover_text.y -= 30;
		add(gameover_text);
		
		gameover_button = new FlxButton(10, 10, " ", reset);
		gameover_button.cameras = [_uicamera];
		gameover_button.screenCenter();
		gameover_button.y += 30;
		add(gameover_button);
	}
	
	public function reset(): Void {
		FlxG.state.resetSubState();
	}
}
