package;

import flixel.FlxSprite;
import flixel.system.FlxAssets.FlxGraphicAsset;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;
import flixel.FlxG;
import Math;

class Bullet extends FlxSprite {
  public var facingLeft:Bool;
  var maxRange:Int;
  var currentRange:Float;
  var speed:Float = 300;
  public function new( ?X:Float=0, ?Y:Float=0, ?L:Bool = true, ?SimpleGraphic:FlxGraphicAsset) {
    super(X,Y,SimpleGraphic);
    facingLeft = L;
    makeGraphic(20, 10, FlxColor.YELLOW);
    maxRange = 700;
  }

  public function fullReset( L:Bool ) : Void {
    currentRange = 0;
    if( L == true){
      velocity.set(-speed,0);
    }
    else{
      velocity.set(speed,0);
    }
  }

  override public function update(elapsed:Float) : Void {
    super.update(elapsed);
    currentRange += Math.abs(speed/60);
    if (currentRange > maxRange){
      kill();
    }
  }
}
