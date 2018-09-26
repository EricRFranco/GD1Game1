package;

import flixel.FlxSprite;
import flixel.FlxState;
import flixel.tile.FlxTilemap;
import flixel.addons.editors.tiled.TiledMap;
import flixel.addons.editors.tiled.TiledTileLayer;
import flixel.tile.FlxBaseTilemap;
import flixel.FlxObject;
import flixel.FlxG;
import flixel.FlxCamera;
import flixel.util.FlxColor;
import flixel.group.FlxGroup;
import flixel.addons.display.FlxBackdrop;
import flixel.text.FlxText;
import sys.io.File;

class Tutorial extends PlayState { //we can have this extend PlayState later
    var _map:TiledMap;
    var _mBackground:FlxTilemap;
    var _mDecorations:FlxTilemap;
    var _mComputers:FlxTilemap;
    var _switchfield:SwitchField;
	var log1:FlxText;
	var log1_background:FlxSprite;

    override public function create():Void {
        _map = new TiledMap(AssetPaths.tutorial__tmx);
		var bg = new FlxBackdrop("assets/images/background.png");
		add(bg);
		
		FlxG.sound.playMusic("assets/music/synthesize_level_music.wav");

        _mDecorations = new FlxTilemap();
        _mDecorations.loadMapFromArray(cast(_map.getLayer("Decoration"), TiledTileLayer).tileArray, _map.width, _map.height,
            AssetPaths.labset__png, _map.tileWidth, _map.tileHeight, FlxTilemapAutoTiling.OFF, 1, 1, 3);
        _mDecorations.follow();
        _mDecorations.setTileProperties(2, FlxObject.NONE);
        _mDecorations.setTileProperties(3, FlxObject.ANY);
        add(_mDecorations);

        _mBoxes = new FlxTilemap();
        _mBoxes.loadMapFromArray(cast(_map.getLayer("Boxes"), TiledTileLayer).tileArray, _map.width, _map.height,
            AssetPaths.labset__png, _map.tileWidth, _map.tileHeight, FlxTilemapAutoTiling.OFF, 1, 1, 3);
        _mBoxes.follow();
        _mBoxes.setTileProperties(2, FlxObject.NONE);
        _mBoxes.setTileProperties(3, FlxObject.ANY);
        add(_mBoxes);

        _mComputers = new FlxTilemap();
        _mComputers.loadMapFromArray(cast(_map.getLayer("Computer"), TiledTileLayer).tileArray, _map.width, _map.height,
            AssetPaths.labset__png, _map.tileWidth, _map.tileHeight, FlxTilemapAutoTiling.OFF, 1, 1, 3);
        _mComputers.follow();
        _mComputers.setTileProperties(2, FlxObject.NONE);
        _mComputers.setTileProperties(3, FlxObject.ANY);
        add(_mComputers);

        _mWalls = new FlxTilemap();
        _mWalls.loadMapFromArray(cast(_map.getLayer("Ground"), TiledTileLayer).tileArray, _map.width, _map.height,
             AssetPaths.labset__png, _map.tileWidth, _map.tileHeight, FlxTilemapAutoTiling.OFF, 1, 1, 3);
        _mWalls.follow();
        _mWalls.setTileProperties(2, FlxObject.NONE);
        _mWalls.setTileProperties(3, FlxObject.ANY);
        add(_mWalls);

        _player = new Player(20, 350);
		add(_player);
        //var tmpMap:TiledObjectLayer = cast _map.getLayer("entities");

		// Add components to the scene
		_spring = new Component("Spring", 250, 358);
		add(_spring);
		_sceneComponents.add(_spring);
		_shoe = new Component("Shoe", 400, 204);
		add(_shoe);
		_sceneComponents.add(_shoe);

		// Add enemies to the scene
		var enemy1 = new Enemy(100, 175, 0);
		enemy1.scale.set(0.5, 0.5);
		enemy1.updateHitbox();
		var enemy2 = new Enemy(120, 50, 0);
		enemy2.scale.set(0.5, 0.5);
		enemy2.updateHitbox();
		var enemy3 = new Enemy(150, 300, 2);
		enemy3.scale.set(0.5, 0.5);
		enemy3.updateHitbox();
		_enemies.add(enemy1);
		_enemies.add(enemy2);
		_enemies.add(enemy3);
		add(_enemies);
		
		var log1_background = new FlxSprite(25, 500);
		log1_background.makeGraphic(530, 675, FlxColor.BLACK);
		log1_background.screenCenter();
		log1_background.y -= 20;
		
		for (y in 0...675) {
			for (x in 0...530) {
				if(y <= 5 || y >= 665) {
					log1_background.pixels.setPixel(x, y, FlxColor.WHITE);
				}
				else if (x <= 5 || x >= 520) {
					log1_background.pixels.setPixel(x, y, FlxColor.WHITE);
				}
			}
		}
		
		var log2_background = new FlxSprite(0, 0);
		log2_background.makeGraphic(680, 725, FlxColor.BLACK);
		log2_background.screenCenter();
		
		for (y in 0...725) {
			for (x in 0...680) {
				if (y <= 5 || y >= 715) {
					log2_background.pixels.setPixel(x, y, FlxColor.WHITE);
				}
				else if (x <= 5 || x >= 670) {
					log2_background.pixels.setPixel(x, y, FlxColor.WHITE);
				}
			}
		}
		
		var log1_txt = sys.io.File.getContent("assets/data/tutlog1.txt");
		var log1 = new FlxText(35, 510, 500, log1_txt, 15);
		log1.screenCenter();
		
		var log2_txt = sys.io.File.getContent("assets/data/tutlog2.txt");
		var log2 = new FlxText(35, 510, 650, log2_txt, 12);
		log2.screenCenter();
		log2.y += 15;
		
		var log1_hitbox = new Computer(172, 200, log1, log1_background);
		_computers.add(log1_hitbox);
		add(log1_hitbox);
		
		var log2_hitbox = new Computer(270, 75, log2, log2_background);
		_computers.add(log2_hitbox);
		add(log2_hitbox);

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

        // camera to scroll with player
		_camera = new FlxCamera(0, 0, 925, 750);
		// camera to hold ui components
		_uicamera = new FlxCamera(0, 0, 925, 750);

		_uicamera.bgColor = FlxColor.TRANSPARENT;

		_camera.follow(_player);
		_camera.setScrollBounds(0, 462.5, 0, 390);
		_camera.zoom = 2;
		_switchfield  = new SwitchField(27,70);
		add(_switchfield);
		FlxG.cameras.reset(_camera);
		FlxG.cameras.add(_uicamera);

		FlxCamera.defaultCameras = [_camera];
		for (hp in _health) {
			hp.cameras = [_uicamera];
		}
		highjump.cameras = [_uicamera];
		log1.cameras = [_uicamera];
		log1_background.cameras = [_uicamera];
		log2.cameras = [_uicamera];
		log2_background.cameras = [_uicamera];
		
        super.create();
    }


  override public function update(elapsed:Float):Void{
    if(FlxG.overlap(_player,_switchfield) && ( FlxG.keys.anyPressed([DOWN, S]))){
      camera.fade(FlxColor.BLACK, 1,false,switchStates,false);
    }
    super.update(elapsed);
  }

  function switchStates() : Void {
    var temp = new Transition();
    temp._nextLevel = 1;
    FlxG.switchState(temp);
  }

}
