package;

import flixel.FlxSprite;
import flixel.system.FlxAssets.FlxGraphicAsset;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;
import flixel.FlxG;

class Player extends FlxSprite  {
  var damageCooldown:Int = 0;
  public  var speed:Float = 300;
  public  var jump:Float = 175;
  public  var xvel:Float = 0; //store x velocity
  public  var yvel:Float = 0; // store y velocity
  public  var airborne:Bool = true; //is the player off the ground?
  public  var rushing:Bool = false; // True if player is in rushing animation, false otherwise
  public  var just_rushed:Bool = false; // Marks cooldown for rush
  public  var air_rush:Bool = true; // Restricts player to one rush while airborne
  public var canPush:Bool = false;
  private var _inventory = new Array(); //Stores all components the player has picked up
  public var _mutagens = new Array();  //Stores all mutagens that have been synthesized by player
  private var _selectedMutagen:Mutagen;
  private var _allMutagens = new Array<Mutagen>(); //Stores all possible mutagens
  public  var hp:Int = 3;
  public  var _alive:Bool = true;
  public  var _recoiling = false; // True if player is in the middle of knockback
  public  var power = 1;
  public  var active_mut:String = "none";
  public  var changing_mut:Bool = false;
  public  var paused:Bool = false;

  public function new(?X:Float=0, ?Y:Float=0, ?SimpleGraphic:FlxGraphicAsset) {
    super(X,Y,SimpleGraphic);
    makeGraphic(20, 20, FlxColor.BLUE);
    drag.x = 1000;
    drag.y = 0; // vertical drag is handled manually by the move() function
    addAllMutagens();
  }

  public function move(?bounce:Bool = false):Void {
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

	if (paused) {
		velocity.set(0, 0);
	}
	else if (bounce) {
		velocity.set(xvel, -100);
		yvel = -100;
	}
    else if (rushing) {
      rush(true);  // Continues rush velocity if in rushing animation
    }
	else if (_recoiling) {
		knockback(true);
	}
    else if (airborne){
      _oldy = _oldy + 4;
      if (_left && _right){
        velocity.set(0,_oldy);
      }
      else if (_left){
        velocity.set(-speed,_oldy);
        xvel = -speed;
      }
      else if (_right){
        velocity.set(speed,_oldy);
        xvel = speed;
      }
      else {
        velocity.set(0,_oldy);
      }
      yvel = _oldy;
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
    else{
      velocity.set(0, 0);
	  xvel = 0;
    }
}

  public function grounded() : Bool {
    airborne = false;
    velocity.set(xvel, 0);
    yvel = 0;
	air_rush = true;
    return true;
  }

  public function hitMeWithThatGravity( ) : Void {
    airborne = true;
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
		else {
			return;
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
	  velocity.set(0, 0);
	  just_rushed = true;
  }

  // Called when timer concludes to end cooldown for rush
  function end_cooldown(Timer: FlxTimer) : Void {
	  just_rushed = false;
  }

  override public function update( elapsed:Float ) : Void {
    damageCooldown -=1;
    move();
	rush(false);
    var cycle:Bool = true;
    // Checking if any mutagens can be made, and if the key has been pressed to create it.
    for(m in _allMutagens) {
      if(hasAllComponents(m) && FlxG.keys.justPressed.E) {
        synthesizeMutagen(m);
        cycle = false;
        break;  // To ensure you only synthesize one mutagen at a time.
      }
    }
    //Cycle through mutagens if no mutagen can be synthesized.
    if(cycle && FlxG.keys.justPressed.E) {
      cycleMutagen();
    }
    super.update(elapsed);
  }

  public function allMutagens() : Array<Mutagen> {
    return _allMutagens;
  }

  public function addAllMutagens() : Void {
    _allMutagens.push(new HighJump(20, 20, this));
    _allMutagens.push(new SuperRush(20, 20, this));
    _allMutagens.push(new PushBoxes(20, 20, this));
  }

  // Is called whenever a component is picked up
  public function addToInventory(c:Component) : Void {
    _inventory.push(c);
  }

  // Adds new mutagen to player's accessible mutagens, then removes the components used from the inventory.
  // NEED TO ACCOMODATE FOR HAVING MORE THAN ONE OF THE SAME COMPONENT
  public function synthesizeMutagen(m:Mutagen) : Void {
    _mutagens.push(m);
    selectMutagen(m);
    for(c in _inventory) {
      for(item in m.getRecipe()) {
        if(c.getLabel() == item) {
          _inventory.remove(c);
        }
      }
    }
    for(mut in _mutagens) {
      if(mut == m)
        trace("Mutagen synthesized.");
    }
  }

  public function cycleMutagen() {
	if (_mutagens.length != 0) {
		var currentIndex:Int = _mutagens.indexOf(_selectedMutagen);
		trace("Selecting new mutagen");
		if(currentIndex == _mutagens.length - 1)
			selectMutagen(_mutagens[0]);
		else
			selectMutagen(_mutagens[currentIndex + 1]);
	}
  }

  public function selectMutagen(m:Mutagen):Void {
    if(_selectedMutagen != null)
      _selectedMutagen.deactivate();
    _selectedMutagen = m;
    _selectedMutagen.activate();
    //_selectedMutagen.changePlayerColor();
	active_mut = _selectedMutagen.mut_str;
	changing_mut = true;
  }

  public function hasAllComponents(m:Mutagen):Bool {
    var playerComponents = new Array();
    for(x in 0...m.getRecipe().length) {
      playerComponents.push(0);
    }

    for(i in 0...m.getRecipe().length) {
      for(inv in _inventory) {
        if(m.getRecipe()[i] == inv.getLabel())
          playerComponents[i]++;
      }
    }

    for(i in playerComponents) {
      if(i == 0)
        return false;
    }
    return true;
  }

  public function takeDamage():Void {
    if (damageCooldown >0)return;
	  hp -= 1;
    damageCooldown=40;
	  if (hp <= 0) {
		  _alive = false;
	  }
  }

  public function knockback(midknock:Bool):Void {
	  if (xvel > 0) {
		  velocity.set(-200, yvel);
	  } else {
		  velocity.set(200, yvel);
	  }

	  if (!midknock) {
		  _recoiling = true;
		  new FlxTimer().start(0.25, end_knock, 1);
	  }
  }

  public function end_knock(Timer:FlxTimer):Void {
	  _recoiling = false;
  }
}
