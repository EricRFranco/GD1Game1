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
      loadGraphic("assets/images/ScientistMoving.png", true, 100, 100); // 19 x 93 image
      animation.add("Walk", [0,1,0,2], 15);
      y+=7;
    }
    else if (enemyType == 1){
      y+=27;
      loadGraphic("assets/images/SwatShieldMoving.png", true, 100,100); //  54 X 73 image
      animation.add("Walk", [0,1,2,3,4,5,6,7], 15);
      animation.add("Attack", [7,8], 15);
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
        loadGraphic("assets/images/SwatGunMoving.png", true, 100, 100);
        animation.add("Walk", [0,1,2,3,4,5,6,7], 15);
      }
      else {
        loadGraphic("assets/images/SwatLaserMoving.png", true, 100, 100);
        animation.add("Walk", [0,1,2,3,4,5,6,7], 15);
      }
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
      if(attackCooldown > 120)return;
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
      var distanceFromPlayer:Float = Math.sqrt((playerX - (x+width/2))*(playerX - (x+width/2)) + (playerY-(y+height/2))*(playerY - (y+height/2)));
      if (distanceFromPlayer > 2000){ // do nothing when far away from player
        //move();
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
            move(false,false);
          }
          else{
            if (playerOnLeft==false){
              move(true,false);
              facingLeft = true;
            }
            else{
              move(false,true);
              facingLeft =false;
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
          if (((playerOnLeft && facingLeft) || (!playerOnLeft && !facingLeft))&&((playerY < y + height)&&(playerY > y -height))){ // only attack if facing the player otherwise keep patroling as if the player isn't seen
            if (distanceFromPlayer>40){ // get closer for melee attack
              if ( playerOnLeft){
                if (x>patrolLeft){
                  move(true, false);
                }
                else{
                  move(false,false);
                }
              }
              else{
                if(x<patrolRight){
                  move(false, true);
                }
                else{
                  move(false,false);
                }
              }
            }
            else{
              //trace(distanceFromPlayer);
              attack();
              move(false,false);
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
          if (((playerOnLeft && facingLeft) || (!playerOnLeft && !facingLeft))&&((playerY < y + height)&&(playerY > y -height))){
            facingLeft = playerOnLeft;
            attack();
            move(false,false);
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
	if (enemyType == 2 || enemyType == 3) {
		return;
	}
    if (attackCooldown > 120){
      velocity.set(0,0);
      acceleration.set(0,0);
      return;
    }
    var _oldx:Float = xvel;
    var _oldy:Float = yvel;
    if (_left ){
      velocity.set(-speed,yvel);
      xvel=-speed;
      animation.play("Walk");
      //trace ("left");
    }
    else if (_right){
      velocity.set(speed, yvel);
      xvel = speed;
      animation.play("Walk"); //For debug
      //trace("right");
    }
    else {
      velocity.set(0,yvel);
      xvel = 0;
      animation.stop();
      //trace("still");
    }
  }
  function attack( ) : Void {
      if(attackCooldown <=0){
      if(enemyType == 1){ // melee attack
        var playState:PlayState = cast FlxG.state;
        var melee = playState._meleeAttacks.recycle();
        if (facingLeft){
          melee.reset(x-20,y);
        }
        else{
          melee.reset(x+26,y);
        }
        melee.fullReset();
        attackCooldown = 240;
        animation.play("Attack");
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
            laser.reset(x-1000, y+8);
          }
          else{
            laser.reset(x+28, y+8);
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
          bullet.reset(x-12,y+9);
        }
        else{
          bullet.reset(x+24,y+9);
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
    facing = 1;
    if (facingLeft){
      setFacingFlip(1,true,false);
    }
    else setFacingFlip(1,false,false);
    attackCooldown -= 1;
    multiShot();
    if (attackCooldown > 120) {
      move(false,false);
      return;
    }
  }
}
