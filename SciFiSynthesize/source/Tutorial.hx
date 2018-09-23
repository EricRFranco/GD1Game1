package;

import flixel.FlxState;
import flixel.tile.FlxTilemap;
import flixel.addons.editors.tiled.TiledMap;
import flixel.addons.editors.tiled.TiledTileLayer;
import flixel.tile.FlxBaseTilemap;
import flixel.FlxObject;
import flixel.FlxG;
import flixel.FlxCamera;

class Tutorial extends FlxState { //we can have this extend PlayState later
    var _player:Player;
    var _map:TiledMap;
    var _mWalls:FlxTilemap;

    override public function create():Void {
        _map = new TiledMap(AssetPaths.tutorial__tmx);
        _mWalls = new FlxTilemap();
        _mWalls.loadMapFromArray(cast(_map.getLayer("Ground"), TiledTileLayer).tileArray, _map.width, _map.height,
             AssetPaths.labset__png, _map.tileWidth, _map.tileHeight, FlxTilemapAutoTiling.OFF, 1, 1, 3);
        _mWalls.follow();
        _mWalls.setTileProperties(2, FlxObject.NONE);
        _mWalls.setTileProperties(3, FlxObject.ANY);
        add(_mWalls);

        _player = new Player(20, 20);
        //var tmpMap:TiledObjectLayer = cast _map.getLayer("entities");

        //camera to scroll with player
		var _camera = new FlxCamera(0, 0, 1200, 750);
		_camera.follow(_player);
		_camera.setScrollBounds(0, 2000, 0, 2000);
		FlxG.cameras.add(_camera);
        super.create();
    }

    override public function update(elapsed:Float):Void {
        super.update(elapsed);
        FlxG.collide(_player, _mWalls);
    }
}