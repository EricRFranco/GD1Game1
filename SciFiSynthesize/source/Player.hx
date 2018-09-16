package;

import flixel.FlxSprite;
import flixel.system.FlxAssets.FlxGraphicAsset;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;
import flixel.FlxG;

class Player extends FlxSprite  {
  public var speed:Float = 100;
  public var jump:Float = 200;
  public var xvel:Float = 0; //store x velocity
  public var yvel:Float = 0; // store y velocity
  public var airborne:Bool = true; //is the player off the ground?
  
  public var rushing:Bool = false; // True if player is in rushing animation, false otherwise
  public var just_rushed:Bool = false; // Marks cooldown for rush
  public var air_rush:Bool = true; // Restricts player to one rush while airborne
  
  public function new(?X:Float=0, ?Y:Float=0, ?SimpleGraphic:FlxGraphicAsset) {
    super(X,Y,SimpleGraphic);
    makeGraphic(20, 20, FlxColor.BLUE);
    drag.x = 1000;
    drag.y = 1000;
  }
  
  function move():Void {
    var _up:Bool = false;
    var _down:Bool = false;
    var _left:Bool = false;
    var _right:Bool = false;
    var _oldx:Float = xvel;
    var _oldy:Float = yvel;
    _up = FlxG.keys.anyPressed([UP, W]);
    _down = FlxG.keys.anyPressed([DOWN, S]);
    _left = FlxG.keys.anyPressed([LEFT, A]);
    _right = FlxG.keys.anyPressed([RIGHT, D]);
	
	if (rushing) { rush(true); } // Continues rush velocity if in rushing animation
    else if (airborne){
      _oldy = _oldy + 4;
      velocity.set(_oldx,_oldy);
      yvel = _oldy;
      //trace( velocity);
    }
    else if (_up && _down){
      _up = _down = false;
    }
    else if (_left && _right){
      _left = _right = false;
    }
    else if (_left && _up){
      velocity.set(-speed,-jump);
      xvel=-speed;
      yvel = -jump;
      airborne = true;
    }
    else if (_right && _up){
      velocity.set(speed,-jump);
      xvel=speed;
      yvel = -jump;
      airborne = true;
    }
    else if (_left ){
      velocity.set(-speed,0);
      xvel=-speed;
    }
    else if (_right){
      velocity.set(speed, 0);
      xvel = speed;
    }
    else if(_up){
      velocity.set(0,-jump);
      airborne = true;
      yvel = -jump;
    } 
	else {
	  velocity.set(0, 0);
	  xvel = 0;
	  yvel = 0;
	}
  }

  public function grounded() : Bool {
    airborne = false;
    velocity.set(xvel, 0);
    yvel = 0;
	air_rush = true;
    return true;
  }
  
  // Allows the player a short burst of speed, argument tells if player is in the middle of action
  function rush(midrush:Bool) : Void {
	var _rush = FlxG.keys.justPressed.C;
	if ((_rush || midrush) && !just_rushed && air_rush) {
		if (xvel > 0) {
			velocity.set(xvel + 400, 0);
		} 
		else if (xvel < 0) {
			velocity.set(xvel - 400, 0);
		}
		
		// If rush is just now being triggered, starts timers for cooldown/continuing rush
		if (!midrush) {
			rushing = true;
			new FlxTimer().start(0.075, stop_rush, 1); // Timer for rush duration
			new FlxTimer().start(0.5, end_cooldown, 1); // Cooldown timer
		}
		
		// If player is airborne, disallows more rushes until grounded
		if (airborne) { air_rush = false; }
	}
  }
  
  // Called when timer concludes to stop rushing velocity
  function stop_rush(Timer:FlxTimer) : Void {
	  rushing = false;
	  just_rushed = true;
  }
  
  // Called when timer concludes to end cooldown for rush
  function end_cooldown(Timer: FlxTimer) : Void {
	  just_rushed = false;
  }

  override public function update( elapsed:Float ) : Void {
    move();
	rush(false);
    super.update(elapsed);
  }

}