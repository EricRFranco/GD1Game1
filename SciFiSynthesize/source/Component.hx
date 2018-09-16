package;

import flixel.FlxSprite;
import flixel.system.FlxAssets.FlxGraphicAsset;
import flixel.util.FlxColor;

class Component extends FlxSprite {

    private var _label:String;  // name of component, to check
  
    public function new(s:String, ?X:Float=0, ?Y:Float=0, ?SimpleGraphic:FlxGraphicAsset) {
        super(X,Y,SimpleGraphic);
        _label = s;
        makeGraphic(20, 20, FlxColor.RED);
    }

    public function GetLabel():String {
        return _label;
    }
}