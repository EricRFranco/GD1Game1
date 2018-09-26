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

  override public function create(): Void {
    _proceedButton = new FlxButton(0, 0, " ", next);
    _proceedButton.loadGraphic("assets/images/proceed-unpressed.png");
    _proceedButton.updateHitbox();
    _proceedButton.screenCenter();
    _proceedButton.y = 625;
    _proceedButton.onDown.callback = onButtonDown;
    add(_proceedButton);

    trace(_nextLevel);
    if(_nextLevel == 1){
      _theActualText = sys.io.File.getContent('assets/data/level1log1.txt');
    }
    else{
      trace('lvl2');
    }
    _transitionText = new FlxText(100, 100, 825, _theActualText, 20);
    _transitionText.screenCenter();
    _transitionText.y -=100;
    add(_transitionText);
    super.create();
  }
  function next(  ) : Void {
    if(_nextLevel == 1){
      FlxG.switchState(new Tutorial());
    }
    else{
      //FlxG.switchState(new MainMenuState());
    }
  }
  function onButtonDown( ) : Void {
    _proceedButton.loadGraphic("assets/images/proceed-pressed.png");
  }
}
