package;

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

class Tutorial extends PlayState { //we can have this extend PlayState later
    var _map:TiledMap;
    var _mBackground:FlxTilemap;
    var _mDecorations:FlxTilemap;
    var _mComputers:FlxTilemap;
    var _switchfield:SwitchField;

    override public function create():Void {
        _map = new TiledMap(AssetPaths.tutorial__tmx);
		var bg = new FlxBackdrop("assets/images/background.png");
		add(bg);
		
		if (FlxG.sound.music == null) {
			FlxG.sound.playMusic("assets/music/synthesize_level_music.wav");
		}
        //Make sure the background is loaded first. Otherwise it will cover the walls layer
        /*_mBackground = new FlxTilemap();
        _mBackground.loadMapFromArray(cast(_map.getLayer("Background"), TiledTileLayer).tileArray, _map.width, _map.height,
            AssetPaths.labset__png, _map.tileWidth, _map.tileHeight, FlxTilemapAutoTiling.OFF, 1, 1, 3);
        _mBackground.follow();
        _mBackground.setTileProperties(2, FlxObject.NONE);
        _mBackground.setTileProperties(3, FlxObject.ANY);
        add(_mBackground);*/
		//bgColor = FlxColor.GRAY;

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
		
		_spring = new Component("Spring", 250, 358);
		add(_spring);
		_sceneComponents.add(_spring);
		
		_shoe = new Component("Shoe", 400, 204);
		add(_shoe);
		_sceneComponents.add(_shoe);

		var _health = new FlxTypedGroup<Health>();
		_hp1 = new Health(40, 10);
		_hp2 = new Health(60, 10);
		_hp3 = new Health(80, 10);
		_health.add(_hp1);
		_health.add(_hp2);
		_health.add(_hp3);
		add(_health);

        //camera to scroll with player
		var _camera = new FlxCamera(0, 0, 925, 750);
		var _uicamera = new FlxCamera(0, 0, 925, 750);

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

        super.create();
    }


  override public function update(elapsed:Float):Void{
    if(FlxG.overlap(_player,_switchfield) && ( FlxG.keys.anyPressed([DOWN, S]))){
      camera.fade(FlxColor.BLACK, 1,false,switchStates,false);
    }
    super.update(elapsed);
  }

  function switchStates() : Void {
   FlxG.switchState(new Tutorial());
  }

}
