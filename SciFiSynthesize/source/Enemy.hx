package;

import flixel.FlxSprite;
import flixel.system.FlxAssets.FlxGraphicAsset;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;
import flixel.FlxG;
import Math;

class Enemy extends FlxSprite {
  var test:Bool = true;
  var speed:Float = 200;
  var jump:Float = 300;
  var xvel:Float = 0;
  var yvel:Float = 0;
  var airborne:Bool = true;
  var facingLeft:Bool = true; // Boolean to keep track of what direction the Enemy is facing to help with attack / defense hitboxes
  var enemyType:Int; //If we add multiple enemies this will keep track of which one they are
  var patrolLeft:Float; //Left bound for enemy patrols
  var patrolRight:Float; //Right bound for enemy patrols
  var researcherDirectionChangeCounter:Int = 0;
  var seenPlayer:Bool = false;
  public function new(?X:Float=0, ?Y:Float=0, ?E:Int = 0, ?R:Int = 0, ?SimpleGraphic:FlxGraphicAsset) {
    super(X,Y,SimpleGraphic);
    enemyType = E;
    makeGraphic(40, 40, FlxColor.ORANGE);
    drag.x = 1000;
    if (enemyType == 0){
      health = 1;
    }
    else if (enemyType == 1){
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
    else {
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
        trace( "Enemy died" );
        //play death animation
      }
  }
  function determineAction(playerX:Float, playerY:Float ) : Void {
      //trace(playerX,x,playerY,y);
      var distanceFromPlayer:Float = Math.sqrt((playerX - x)*(playerX - x) + (playerY-y)*(playerY - y));
      if (distanceFromPlayer > 2000){ // do nothing when far away from player
        move();
      }
      else if (distanceFromPlayer > 800 && distanceFromPlayer <= 2000){ // patrol when withing about a screens didstance from player
        if (enemyType == 0){
          if (!seenPlayer){
            researcherDirectionChangeCounter+=1;
          }
          else{
            if (facingLeft){
              move(true,false);
            }
            else{
              move(false,true);
            }
          }
          if(researcherDirectionChangeCounter>180){
            researcherDirectionChangeCounter = 0;
            facingLeft = !facingLeft;
          }
          move();
          return;
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
        var playerOnLeft:Bool = false;
        if ((playerX - x) < 0){
          playerOnLeft = true;
        }
        //trace("Is player on left?",playerOnLeft,"which way we facing",facingLeft, "Paniced?",seenPlayer);
        if (enemyType == 0){
          if (!seenPlayer){
            researcherDirectionChangeCounter+=1;
          }
          if(researcherDirectionChangeCounter>180){
            researcherDirectionChangeCounter = 0;
            facingLeft = !facingLeft;
          }
          trace(researcherDirectionChangeCounter);
          if (playerOnLeft && facingLeft) { // only run away if the researcher sees the player
            move(false, true); // runaway to the right
            seenPlayer = true;
          }
          else if ((!playerOnLeft)&&(!facingLeft)){
            move(true,false);
            seenPlayer = true;
          }
          else{
            move();
          }
        }
        else if (enemyType ==1){ // Melee Enemy Attack Range Behavior
          if ((playerOnLeft && facingLeft) || (!playerOnLeft && !facingLeft)){ // only attack if facing the player otherwise keep patroling as if the player isn't seen
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
            if((playerY< y+40)&&(playerY>y)){
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

  function move(?_left:Bool=false,_right:Bool=false):Void {
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
    //trace("attack");
  }

  override public function update(elapsed:Float) : Void {
    super.update(elapsed);
  }
}
