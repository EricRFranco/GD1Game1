package;

import flixel.FlxSprite;
import flixel.system.FlxAssets.FlxGraphicAsset;
import flixel.util.FlxColor;
import flixel.FlxG;

class Box extends FlxSprite {
    public var airborne:Bool = false;
    public function new(?X:Float=0, ?Y:Float=0, ?SimpleGraphic:FlxGraphicAsset) {
        super(X,Y,SimpleGraphic);
        makeGraphic(50,50,FlxColor.GREEN);
        drag.x = 1000;
        drag.y = 1000;
        allowCollisions = 0x1111;
    }

    override public function update(elapsed:Float) {
        super.update(elapsed);
        if(airborne){
          acceleration.set(0,25);
        }
    }

    public function grounded() : Bool {
      //trace("grounding");
      airborne = false;
      velocity.set(0, 0);
      acceleration.set(0,0);
      return true;
    }
}
