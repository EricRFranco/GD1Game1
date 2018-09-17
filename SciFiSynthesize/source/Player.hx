package;

import flixel.FlxSprite;
import flixel.system.FlxAssets.FlxGraphicAsset;
import flixel.util.FlxColor;
import flixel.FlxG;

class Player extends FlxSprite  {
  public  var speed:Float = 100;
  public  var jump:Float = 200;
  public  var xvel:Float = 0; //store x velocity
  public  var yvel:Float = 0; // store y velocity
  public  var airborne:Bool = true; //is the player off the ground?
  private var _inventory = new Array(); //Stores all components the player has picked up
  private var _mutagens = new Array();  //Stores all mutagens that have been synthesized by player
  private var _selectedMutagen:Mutagen;

  public function new(?X:Float=0, ?Y:Float=0, ?SimpleGraphic:FlxGraphicAsset) {
    super(X,Y,SimpleGraphic);
    makeGraphic(20, 20, FlxColor.BLUE);
    drag.x = 1000;
    drag.y = 0;
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
    if (airborne){
      _oldy = _oldy+4;
      velocity.set(_oldx,_oldy);
      yvel = _oldy;
      trace( velocity);

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
  }

  public function grounded() : Bool {
    airborne = false;
    velocity.set(xvel,0);
    yvel = 0;
    return true;
  }

  override public function update( elapsed:Float ) : Void {
    move();
    // Checking if any mutagens can be made, and if the key has been pressed to create it.
    for(m in PlayState.allMutagens) {
      if(hasAllComponents(m) && FlxG.keys.justPressed.E) {
        synthesizeMutagen(m);
        break;  // To ensure you only synthesize one mutagen at a time.
      }
    }
    super.update(elapsed);
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

  public function selectMutagen(m:Mutagen):Void {
    _selectedMutagen = m;
    m.changePlayerColor();
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
}
