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

class Tutorial extends PlayState {
    var _map:TiledMap;
    var _mBackground:FlxTilemap;
    var _mDecorations:FlxTilemap;
    var _mComputers:FlxTilemap;
    var _switchfield:SwitchField;
	var _canSynthesize:Bool = false;

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

        _player = new Player(20, 335);
		_player.health = 3;
		_player.scale.set(0.35, 0.35);
		_player.updateHitbox();
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
		_enemies.add(enemy1);
		_enemies.add(enemy2);
		add(_enemies);

    _switchfield = new SwitchField(25, 70);
    add(_switchfield);

		_camera = new FlxCamera(0, 0, 925, 750);
		_camera.follow(_player);
		_camera.setScrollBounds(0, 462.5, 0, 390);
		_camera.zoom = 2;
		FlxG.cameras.reset(_camera);
		FlxCamera.defaultCameras = [_camera];
		
		_canCreateMutagen.cameras = [_uicamera];
		_canCreateMutagen.screenCenter();
		add(_canCreateMutagen);

        super.create();

		var log1_hitbox = new Computer(172, 200, log1, log1_background);
		_computers.add(log1_hitbox);
		add(log1_hitbox);

		var log2_hitbox = new Computer(270, 75, log2, log2_background);
		_computers.add(log2_hitbox);
		add(log2_hitbox);
    }


  override public function update(elapsed:Float):Void{
    if(FlxG.overlap(_player,_switchfield) && ( FlxG.keys.anyPressed([DOWN, S]))){
      camera.fade(FlxColor.BLACK, 1,false,switchStates,false);
    }

	for(mut in _player.allMutagens()) {
		if(_player.hasAllComponents(mut)) {
			_canCreateMutagen.text = "Press E to synthesize a new mutagen!";
			_canSynthesize = true;
			break;
		}
		_canSynthesize = false;
	}
	if(!_canSynthesize)
		_canCreateMutagen.text = "";


    super.update(elapsed);
  }

  function switchStates() : Void {
    var temp = new Transition();
    temp._nextLevel = 1;
    FlxG.switchState(temp);
  }

}
