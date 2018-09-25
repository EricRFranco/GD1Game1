package;

import flixel.FlxSprite;
import flixel.system.FlxAssets.FlxGraphicAsset;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;
import flixel.FlxG;
import Math;


class SwitchField extends FlxSprite {
  public function new(X:Float, Y:Float, ?SimpleGraphic:FlxGraphicAsset) {
      super(X,Y,SimpleGraphic);
      makeGraphic(30,30,FlxColor.WHITE);
      alpha = 0;
      immovable = true;
  }

  override public function update(elapsed:Float) {
      super.update(elapsed);
  }
}
