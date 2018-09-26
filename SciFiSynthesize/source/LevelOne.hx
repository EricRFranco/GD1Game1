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

    public override function create() : Void {
        _map = new TiledMap(AssetPaths.newlevel1__tmx);
        //background goes here

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
		var enemy2 = new Enemy(40, 350, 2, 0);
		_enemies.add(enemy2);
		var enemy3 = new Enemy(730, 200, 1, 0);
		_enemies.add(enemy3);
		
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
}