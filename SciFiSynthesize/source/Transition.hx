package;

import flixel.FlxState;
import flixel.FlxSprite;
import flixel.FlxG;
import flixel.text.FlxText;
import flixel.ui.FlxButton;

class Transition extends FlxState{
  var _proceedButton:FlxButton;
  var _proceedSprite:FlxSprite;
  var _transitionText:FlxText;
  var _theActualText:String;
  public var _nextLevel:Int;
  public var hasmicrophone:Bool = false;

  override public function create(): Void {
	FlxG.sound.playMusic("assets/music/synthesize_elevator_music.wav");

    _proceedButton = new FlxButton(0, 0, " ", next);
    _proceedButton.loadGraphic("assets/images/proceed-unpressed.png");
    _proceedButton.updateHitbox();
    _proceedButton.screenCenter();
    _proceedButton.y = 625;
    _proceedButton.onDown.callback = onButtonDown;
    add(_proceedButton);

    //trace(_nextLevel);
    if(_nextLevel == 1){
      _theActualText = sys.io.File.getContent('assets/data/tutorialend.txt');
    }
    else if (_nextLevel ==2){
      _theActualText = sys.io.File.getContent('assets/data/level1end.txt');
    }
    else if (_nextLevel ==3){
      _theActualText = sys.io.File.getContent('assets/data/badending.txt');
    }
    else if (_nextLevel ==4){
      _theActualText = sys.io.File.getContent('assets/data/goodending.txt');
    }
    _transitionText = new FlxText(100, 100, 825, _theActualText, 15);
    _transitionText.screenCenter();
    _transitionText.y -=80;
    add(_transitionText);
    super.create();
  }
  function next(  ) : Void {
    if(_nextLevel == 1){
      FlxG.switchState(new LevelOne());
    }
    else if (_nextLevel == 2){
      var temp = new FinalLevel();
      if(hasmicrophone){
        temp.hasmicrophone = true;
      }
      FlxG.switchState(temp);
    }
    else{
      FlxG.switchState(new MainMenuState());      
    }
  }
  function onButtonDown( ) : Void {
    _proceedButton.loadGraphic("assets/images/proceed-pressed.png");
  }
}
