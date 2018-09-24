package;

import flixel.FlxSprite;
import flixel.system.FlxAssets.FlxGraphicAsset;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;
import flixel.FlxG;
import Math;


class SwitchField extends FlxSprite {
  public function new(?X:Float=0, ?Y:Float=0, ?SimpleGraphic:FlxGraphicAsset) {
      super(X,Y,SimpleGraphic);
      makeGraphic(400,10,FlxColor.LIME);
      immovable = true;
  }

  override public function update(elapsed:Float) {
      super.update(elapsed);
  }
}
