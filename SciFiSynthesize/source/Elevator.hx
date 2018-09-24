package;

import flixel.FlxSprite;
import flixel.system.FlxAssets.FlxGraphicAsset;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;
import flixel.FlxG;
import Math;


class Elevator extends FlxSprite {
  public var rise:Bool = false;
  public function new(?X:Float=0, ?Y:Float=0, ?SimpleGraphic:FlxGraphicAsset) {
      super(X,Y,SimpleGraphic);
      makeGraphic(400,25,FlxColor.CYAN);
      drag.x = 1000;
      drag.y = 1000;
      immovable = true;
  }

  override public function update(elapsed:Float) {
      super.update(elapsed);
      if (rise){
        acceleration.set(0,-50);
      }
  }
}
