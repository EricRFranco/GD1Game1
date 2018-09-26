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

class LevelOne extends PlayState {

    var _map:TiledMap;
    var _mBackground:FlxTilemap;
    var _mDecorations:FlxTilemap;
    var _mComputers:FlxTilemap;
    var _switchfield:SwitchField;
    public override function create() : Void {
        _currentState = 1;
        _map = new TiledMap(AssetPaths.newlevel1__tmx);
		var bg = new FlxBackdrop("assets/images/background.png");
		add(bg);

		FlxG.sound.playMusic("assets/music/synthesize_level_music.wav");

        _mDecorations = new FlxTilemap();
        _mDecorations.loadMapFromArray(cast(_map.getLayer("Decorations"), TiledTileLayer).tileArray, _map.width, _map.height,
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
        _mComputers.loadMapFromArray(cast(_map.getLayer("Computers"), TiledTileLayer).tileArray, _map.width, _map.height,
            AssetPaths.labset__png, _map.tileWidth, _map.tileHeight, FlxTilemapAutoTiling.OFF, 1, 1, 3);
        _mComputers.follow();
        _mComputers.setTileProperties(2, FlxObject.NONE);
        _mComputers.setTileProperties(3, FlxObject.ANY);
        add(_mComputers);

        _mWalls = new FlxTilemap();
        _mWalls.loadMapFromArray(cast(_map.getLayer("Walls"), TiledTileLayer).tileArray, _map.width, _map.height,
             AssetPaths.labset__png, _map.tileWidth, _map.tileHeight, FlxTilemapAutoTiling.OFF, 1, 1, 3);
        _mWalls.follow();
        _mWalls.setTileProperties(2, FlxObject.NONE);
        _mWalls.setTileProperties(3, FlxObject.ANY);
        add(_mWalls);

        _player = new Player(20, 460);
		add(_player);

		_player._mutagens.push(new HighJump(0, 0, _player));

		var enemy1 = new Enemy(200, 450, 1);
		_enemies.add(enemy1);
		var enemy2 = new Enemy(92, 350, 2, 50);
		_enemies.add(enemy2);
		var enemy3 = new Enemy(690, 200, 1, 40);
		_enemies.add(enemy3);
		var enemy4 = new Enemy(475, 25, 0);
		_enemies.add(enemy4);
		var enemy5 = new Enemy(895, 445, 2);
		_enemies.add(enemy5);
		var enemy6 = new Enemy(840, 350, 2, 5);
		_enemies.add(enemy6);
		var enemy7 = new Enemy(1020, 175, 2, 20);
		_enemies.add(enemy7);
		var enemy8 = new Enemy(1050, 175, 0);
		_enemies.add(enemy8);
		var enemy9 = new Enemy(1040, 70, 1,40);
		_enemies.add(enemy9);
		var enemy10 = new Enemy(1440, 70, 2, 40);
		_enemies.add(enemy10);
		var enemy11 = new Enemy(1450, 250, 1, 30);
		_enemies.add(enemy11);
		var enemy12 = new Enemy(1325, 445, 0);
		_enemies.add(enemy12);
		var enemy13 = new Enemy(1570, 250, 1, 60);
		_enemies.add(enemy13);
		var enemy14 = new Enemy(1670, 250, 2, 50);
		_enemies.add(enemy14);
		var enemy15 = new Enemy(1700, 445, 2,40);
		_enemies.add(enemy15);

    _switchfield = new SwitchField(1565,460);
    add(_switchfield);

		for (enemy in _enemies) {
			enemy.scale.set(0.5, 0.5);
			enemy.updateHitbox();
		}
		add(_enemies);

		var box1 = new Box(350, 365);
		_boxes.add(box1);
		var box2 = new Box(1125, 80);
		_boxes.add(box2);

		for (box in _boxes) {
			box.scale.set(0.5, 0.5);
			box.updateHitbox();
		}
		add(_boxes);

		_glove = new Component("Glove", 425, 140);
		_sceneComponents.add(_glove);
		_dumbell = new Component("Dumbell", 1065, 95);
		_sceneComponents.add(_dumbell);
		add(_sceneComponents);

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
      temp._nextLevel = 2;
      FlxG.switchState(temp);
    }
}
