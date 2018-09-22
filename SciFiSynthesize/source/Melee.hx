package;

import flixel.FlxSprite;
import flixel.system.FlxAssets.FlxGraphicAsset;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;
import flixel.FlxG;
import Math;

class Melee extends FlxSprite {
  public var hitFrameStart:Int;
  public var hitFrameEnd:Int;
  var animationFrameEnd:Int;
  public var currentFrame:Int = 0;
  var facingLeft:Bool;
  public var alreadyHit:Bool = false;
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
    alreadyHit = false;
  }
  public function hit() : Void {
    alreadyHit = true;
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
