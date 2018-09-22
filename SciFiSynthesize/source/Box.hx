package;

import flixel.FlxSprite;
import flixel.system.FlxAssets.FlxGraphicAsset;
import flixel.util.FlxColor;
import flixel.FlxG;

class Box extends FlxSprite {

    public function new(?X:Float=0, ?Y:Float=0, ?SimpleGraphic:FlxGraphicAsset) {
        super(X,Y,SimpleGraphic);
        makeGraphic(50,50,FlxColor.GREEN);
        drag.x = 1000;
        drag.y = 1000;
    }

    override public function update(elapsed:Float) {
        super.update(elapsed);
    }
}
