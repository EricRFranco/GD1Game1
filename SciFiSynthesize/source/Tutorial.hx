package;

import flixel.FlxState;
import flixel.FlxSprite;
import flixel.tile.FlxTilemap;
import flixel.addons.editors.tiled.TiledMap;
import flixel.addons.editors.tiled.TiledTileLayer;

class Tutorial extends FlxState { //we can have this extend PlayState later
    var _player:Player;
    var _map:TiledMap;
    var _mWalls:FlxTilemap;

    override public function create():Void {
        _map = new TiledMap(AssetPaths.tutorial__tmx);
        _mWalls = new FlxTilemap();
        //_mWalls.loadMapFromArray(cast(_map.getLayer("Ground"), TiledTileLayer).tileArray, _map.width, _map.height, AssetPaths.)
        super.create();
    }

    override public function update(elapsed:Float):Void {
        super.update(elapsed);
    }
}