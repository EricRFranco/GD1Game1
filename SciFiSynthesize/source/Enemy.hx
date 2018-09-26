package;

import flixel.FlxSprite;
import flixel.system.FlxAssets.FlxGraphicAsset;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;
import flixel.FlxG;
import Math;

class Enemy extends FlxSprite {
  var test:Bool = true;
  var speed:Float = 50;
  var jump:Float = 300;
  var xvel:Float = 0;
  var yvel:Float = 0;
  var attackCooldown:Float = 60; // if <0 can attack else wait
  public var airborne:Bool = true;
  var facingLeft:Bool = true; // Boolean to keep track of what direction the Enemy is facing to help with attack / defense hitboxes
  var enemyType:Int; //If we add multiple enemies this will keep track of which one they are
  var patrolLeft:Float; //Left bound for enemy patrols
  var patrolRight:Float; //Right bound for enemy patrols
  var researcherDirectionChangeCounter:Int = 0;
  var seenPlayer:Bool = false;
  var shots:Int = 0; // Number of bullets the enemey will shoot at a time;
  public var paused:Bool = false;
  
  public function new(?X:Float=0, ?Y:Float=0, ?E:Int = 0, ?R:Int = 0, ?SimpleGraphic:FlxGraphicAsset) { // Give this function x and y coordinates as if the sprites were 100 x 100 the constructor will adjust the values for each sprite
    super(X,Y,SimpleGraphic);
    enemyType = E;
    drag.x = 1000;
    if (enemyType == 0){
      health = 1;
      loadGraphic("assets/images/Scientists.png"); // 19 x 93 image
      y+=7;
    }
    else if (enemyType == 1){
      y+=27;
      loadGraphic("assets/images/SwatWithShield.png"); //  54 X 73 image
      health = 2;
      if (R == 0){
        patrolLeft = x-(400);
        patrolRight = x+(400);
      }
      else {
        patrolLeft = x-(R);
        patrolRight = x+(R);
      }
    }
    else { // 57 X 86 Image for both ranged types
      y+=14;
      if (enemyType == 2){
        loadGraphic("assets/images/SwatWithGun.png");
      }
      else loadGraphic("assets/images/SwatWithLaserGun.png");
      health = 3;
      if (R == 0){
        patrolLeft = x-200;
        patrolRight = x+200;
      }
      else {
        patrolLeft = x-(R);
        patrolRight = x+(R);
      }
    }
  }
  public function givePlayerLocation( playerX:Float, playerY:Float ) : Void {
      determineAction(playerX,playerY);
  }
  public function takeDamage( D:Int ) : Void {
      health -= D;
      if (health <=0){
        alive = false;
        //trace( "Enemy died" );
        //play death animation
      }
  }
  function determineAction(playerX:Float, playerY:Float ) : Void {
      //trace(playerX,x,playerY,y);
      var playerOnLeft:Bool = false;
      if ((playerX - x) < 0){
        playerOnLeft = true;
      }

	  if (paused) {
		  velocity.set(0, 0);
		  return;
	  }
      else if (airborne) {
        yvel = yvel + 4;
        velocity.set(xvel, yvel);
      }
      var distanceFromPlayer:Float = Math.sqrt((playerX - x)*(playerX - x) + (playerY-y)*(playerY - y));
      if (distanceFromPlayer > 2000){ // do nothing when far away from player
        move();
      }
      else if (distanceFromPlayer > 800 && distanceFromPlayer <= 2000){ // patrol when withing about a screens didstance from player
        if (((playerOnLeft && facingLeft) || (!playerOnLeft && !facingLeft))&&((playerY < y + height)&&(playerY > y -height))){ // only attack if facing the player otherwise keep patroling as if the player isn't seen
          seenPlayer = true;
        }
        if (enemyType == 0){
          if (seenPlayer==false){
            researcherDirectionChangeCounter+=1;
            if(researcherDirectionChangeCounter>180){
              researcherDirectionChangeCounter = 0;
              facingLeft = !facingLeft;
            }
            move();
          }
          else{
            if (facingLeft){
              move(true,false);
            }
            else{
              move(false,true);
            }
          }
        }
        if (facingLeft){
          if (x > patrolLeft){
            move(true,false);
          }
          else {
            facingLeft = false;
            move(false, true);
          }
        }
        else{
          if (x<patrolRight){
            move(false,true);
          }
          else{
            facingLeft = true;
            move(true,false);
          }
        }
      }
      else { // attack or flee if researcher
        if (((playerOnLeft && facingLeft) || (!playerOnLeft && !facingLeft))&&((playerY < y + height)&&(playerY > y -height))){ // only attack if facing the player otherwise keep patroling as if the player isn't seen
          seenPlayer = true;
        }
        //trace("Is player on left?",playerOnLeft,"which way we facing",facingLeft, "Paniced?",seenPlayer);
        if (enemyType == 0){
          if (seenPlayer==false){
            researcherDirectionChangeCounter+=1;
            if(researcherDirectionChangeCounter>180){
              researcherDirectionChangeCounter = 0;
              facingLeft = !facingLeft;
            }
          }
          else{
            //trace(researcherDirectionChangeCounter);
            if (playerOnLeft && facingLeft) { // only run away if the researcher sees the player
              move(false, true); // runaway to the right
              facingLeft = false;
            }
            else if ((!playerOnLeft)&&(!facingLeft)){
              move(true,false);
              facingLeft = true;
            }
          }
        }
        else if (enemyType ==1){ // Melee Enemy Attack Close Range Behavior
          if ((playerOnLeft && facingLeft) || (!playerOnLeft && !facingLeft)){ // only attack if facing the player otherwise keep patroling as if the player isn't seen
            seenPlayer = true;
            if (distanceFromPlayer>200){ // get closer for melee attack
              if ( playerOnLeft){
                if (x>patrolLeft){
                  move(true, false);
                }
                else{
                  move();
                }
              }
              else{
                if(x<patrolRight){
                  move(false, true);
                }
                else{
                  move();
                }
              }
            }
            else{
              attack();
            }
          }
          else if(seenPlayer){
            facingLeft = playerOnLeft;
          }
          else{ // continue patroling
            if (facingLeft){
              if (x > patrolLeft){
                move(true,false);
              }
              else {
                facingLeft = false;
                move(false, true);
              }
            }
            else{
              if (x<patrolRight){
                move(false,true);
              }
              else{
                facingLeft = true;
                move(true,false);
              }
            }
          }
        }
        else{ // Ranged Enemy Attack Range behavior
          if ((playerOnLeft && facingLeft) || ((!playerOnLeft) && (!facingLeft))){
            seenPlayer = true;
            if((playerY< y+86)&&(playerY>y-34)){
              attack();
            }
            else{
              move();
            }
          }
          else{
            if (seenPlayer){
              facingLeft = playerOnLeft;
            }
            else{
              if (facingLeft){
                if (x > patrolLeft){
                  move(true,false);
                }
                else {
                  facingLeft = false;
                  move(false, true);
                }
              }
              else{
                if (x<patrolRight){
                  move(false,true);
                }
                else{
                  facingLeft = true;
                  move(true,false);
                }
              }
            }
          }
        }
      }
      //trace (distanceFromPlayer);
  }

  function move(?_left:Bool = false, _right:Bool = false):Void {
    if (attackCooldown > 120) return;
    var _oldx:Float = xvel;
    var _oldy:Float = yvel;
    if (_left ){
      velocity.set(-speed,0);
      xvel=-speed;
      //trace ("left");
    }
    else if (_right){
      velocity.set(speed, 0);
      xvel = speed;
      //trace("right");
    }
    else {
      velocity.set(0,0);
      xvel = 0;
      //trace("still");
    }
  }
  function attack( ) : Void {
    if(attackCooldown <=0){
      if(enemyType == 1){ // melee attack
        var playState:PlayState = cast FlxG.state;
        var melee = playState._meleeAttacks.recycle();
        if (facingLeft){
          melee.reset(x-60,y);
        }
        else{
          melee.reset(x+57,y);
        }
        melee.fullReset();
        attackCooldown = 240;
      }
      else{ //ranged attack
        if (enemyType == 2){  // Bullet Type
          shots = Std.random(5) + 1;
		  FlxG.sound.play("assets/sounds/gunshots.wav");
        }
        else if(enemyType == 3){ // Laser Type
          attackCooldown = 420;
          var playState:PlayState = cast FlxG.state;
          var laser = playState._lasers.recycle();
		  FlxG.sound.play("assets/sounds/laser.wav");
          if (facingLeft){
            laser.reset(x-1000, y+18);
          }
          else{
            laser.reset(x+56, y+18);
          }
          laser.fullReset(facingLeft);
        }
      }
    }
  }

  function multiShot() : Void {
    if ( shots > 0){
      if(attackCooldown <= 300){
        attackCooldown = 310;
        var playState:PlayState = cast FlxG.state;
        var bullet = playState._bullets.recycle();
        if (facingLeft){
          bullet.reset(x-20,y+18);
        }
        else{
          bullet.reset(x+56,y+18);
        }
        bullet.fullReset(facingLeft);
        shots -= 1;
      }
    }
  }
  public function grounded() : Bool {
    airborne = false;
    velocity.set(xvel, 0);
    yvel = 0;
    return true;
  }
  override public function update(elapsed:Float) : Void {
    super.update(elapsed);
    attackCooldown -= 1;
    multiShot();
    facing = 1;
    if (attackCooldown > 120) return;
    if (facingLeft){
      setFacingFlip(1,true,false);
    }
    else setFacingFlip(1,false,false);
  }
}
