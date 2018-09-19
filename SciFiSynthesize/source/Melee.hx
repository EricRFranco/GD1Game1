package;

import flixel.FlxSprite;
import flixel.system.FlxAssets.FlxGraphicAsset;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;
import flixel.FlxG;
import Math;

class Melee extends FlxSprite {
  var hitFrameStart:Int;
  var hitFrameEnd:Int;
  var animationFrameEnd:Int;
  var currentFrame:Int = 0;
  var facingLeft:Bool;
  public function new( ?X:Float=0, ?Y:Float=0,  ?L:Bool = true, ?SimpleGraphic:FlxGraphicAsset) {
    super(X,Y,SimpleGraphic);
    facingLeft = L;
    makeGraphic(60,40, FlxColor.GREEN);
    hitFrameStart = 30;
    hitFrameEnd = 60;
    animationFrameEnd = 90;
  }
  public function fullReset() : Void {
    currentFrame = 0;
  }
  override public function update(elapsed:Float) : Void {
    super.update(elapsed);
    currentFrame +=1;
    if(currentFrame > animationFrameEnd){
      kill();
      trace("killed the weapon");
    }
  }
}
