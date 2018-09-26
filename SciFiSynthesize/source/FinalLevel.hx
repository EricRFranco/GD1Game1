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

class FinalLevel extends PlayState {
    var _map:TiledMap;
    var _mBackground:FlxTilemap;
    var _mDecorations:FlxTilemap;
    var _mComputers:FlxTilemap;
    var _switchfield:SwitchField;

    public override function create() : Void {
        _map = new TiledMap(AssetPaths.newlevel2__tmx);
        var bg = new FlxBackdrop("assets/images/sky.png");
		    add(bg);
        _currentState = 2;
        _switchfield = new SwitchField(1715,20);
        add(_switchfield);
		      FlxG.sound.playMusic("assets/music/synthesize_level_music.wav");

        _mDecorations = new FlxTilemap();
        _mDecorations.loadMapFromArray(cast(_map.getLayer("Decorations"), TiledTileLayer).tileArray, _map.width, _map.height,
            AssetPaths.OutdoorTileset__png, _map.tileWidth, _map.tileHeight, FlxTilemapAutoTiling.OFF, 1, 1, 3);
        _mDecorations.follow();
        _mDecorations.setTileProperties(2, FlxObject.NONE);
        _mDecorations.setTileProperties(3, FlxObject.ANY);
        add(_mDecorations);

        _mBoxes = new FlxTilemap();
        _mBoxes.loadMapFromArray(cast(_map.getLayer("Boxes"), TiledTileLayer).tileArray, _map.width, _map.height,
            AssetPaths.OutdoorTileset__png, _map.tileWidth, _map.tileHeight, FlxTilemapAutoTiling.OFF, 1, 1, 3);
        _mBoxes.follow();
        _mBoxes.setTileProperties(2, FlxObject.NONE);
        _mBoxes.setTileProperties(3, FlxObject.ANY);
        add(_mBoxes);

        _mWalls = new FlxTilemap();
        _mWalls.loadMapFromArray(cast(_map.getLayer("Walls"), TiledTileLayer).tileArray, _map.width, _map.height,
             AssetPaths.OutdoorTileset__png, _map.tileWidth, _map.tileHeight, FlxTilemapAutoTiling.OFF, 1, 1, 3);
        _mWalls.follow();
        _mWalls.setTileProperties(2, FlxObject.NONE);
        _mWalls.setTileProperties(3, FlxObject.ANY);
        add(_mWalls);

        _player = new Player(20, 440);
		_player.scale.set(0.35, 0.35);
		_player.updateHitbox();
		add(_player);

		_player._mutagens.push(new HighJump(0, 0, _player));
        _player._mutagens.push(new PushBoxes(0, 0, _player));
		_player.health = 3;

		_battery = new Component("Battery", 140, 280);
		_sceneComponents.add(_battery);
		add(_battery);
		_fan = new Component("Fan", 790, 470);
		_sceneComponents.add(_fan);
		add(_fan);
		var antennae = new Component("Antennae", 610, 65);
		_sceneComponents.add(antennae);
		add(antennae);

		var enemy1 = new Enemy(120, 425, 3); //laser
		_enemies.add(enemy1);
		var enemy2 = new Enemy(225, 350, 2);
		_enemies.add(enemy2);
		var enemy3 = new Enemy(170, 250, 3); //laser
		_enemies.add(enemy3);
		var enemy4 = new Enemy(340, 420, 2);
		_enemies.add(enemy4);
		var enemy5 = new Enemy(480, 335, 3); //laser
		_enemies.add(enemy5);
		var enemy6 = new Enemy(570, 15, 1);
		_enemies.add(enemy6);
		var enemy7 = new Enemy(630, 420, 2);
		_enemies.add(enemy7);
		var enemy8 = new Enemy(975, 420, 3); //laser
		_enemies.add(enemy8);
		var enemy9 = new Enemy(1180, 385, 2);
		_enemies.add(enemy9);
		var enemy10 = new Enemy(1070, 275, 2); //laser
		_enemies.add(enemy10);
		var enemy11 = new Enemy(1070, 175, 3); //laser
		_enemies.add(enemy11);

		for (enemy in _enemies) {
			enemy.scale.set(0.5, 0.5);
			enemy.updateHitbox();
		}

		add(_enemies);

		_camera = new FlxCamera(0, 0, 925, 750);
		_camera.follow(_player);
		_camera.setScrollBounds(0, 2000, 0, 500);
		_camera.zoom = 2;
		FlxG.cameras.reset(_camera);
		FlxCamera.defaultCameras = [_camera];

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
      temp._nextLevel = 3;
      for (x in _player._inventory){
        if (x.getLabel() == "Antennae"&&hasmicrophone)temp._nextLevel = 4;
      }
      FlxG.switchState(temp);
    }
}
