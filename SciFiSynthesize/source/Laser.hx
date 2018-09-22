package;

import flixel.FlxSprite;
import flixel.system.FlxAssets.FlxGraphicAsset;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;
import flixel.FlxG;
import Math;

class Laser extends FlxSprite {
  public var hitFrameStart:Int;
  public var hitFrameEnd:Int;
  var animationFrameEnd:Int;
  public var currentFrame:Int = 0;
  var facingLeft:Bool;
  public var alreadyHit:Bool = false;
  public function new( ?X:Float=0, ?Y:Float=0,  ?L:Bool = true, ?SimpleGraphic:FlxGraphicAsset) {
    super(X,Y,SimpleGraphic);
    facingLeft = L;
    makeGraphic(100,5, FlxColor.RED);
    hitFrameStart = 100;
    hitFrameEnd = 200;
    animationFrameEnd = 250;
  }
  public function fullReset(L) : Void {
    facingLeft = L;
    currentFrame = 0;
    alreadyHit = false;
    if (facingLeft){
      x +=900;
    }
  }
  public function hit() : Void {
    alreadyHit = true;
  }
  override public function update(elapsed:Float) : Void {
    super.update(elapsed);
    currentFrame +=1;
    if(currentFrame == hitFrameStart){
      setGraphicSize(1000,10);
      if (facingLeft){
        x -= 900;
      }
      y-=2.5;
      dirty=true;
      updateHitbox();
    }
    if(currentFrame == hitFrameEnd){
      setGraphicSize(100,5);
      if (facingLeft){
        x += 900;
      }
      y+=2.5;
      dirty = true;
      updateHitbox();
    }
    if(currentFrame > animationFrameEnd){
      kill();
    }
  }
}
