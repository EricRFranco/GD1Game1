package;

import flixel.FlxSprite;
import flixel.system.FlxAssets.FlxGraphicAsset;
import flixel.util.FlxColor;

class Component extends FlxSprite {

    private var _label:String;  // name of component, to check
  
    public function new(s:String, ?X:Float=0, ?Y:Float=0, ?SimpleGraphic:FlxGraphicAsset) {
        super(X,Y,SimpleGraphic);
        _label = s;
		
		switch(s) {
			case("Antennae"):
				loadGraphic("assets/images/antennae.png");
			case("Battery"):
				loadGraphic("assets/images/battery.png");
			case("Dumbell"):
				loadGraphic("assets/images/dumbell.png");
			case("Fan"):
				loadGraphic("assets/images/fan.png");
			case("Glove"):
				loadGraphic("assets/images/glove.png");
			case("Microphone"):
				loadGraphic("assets/images/microphone.png");
			case("Shoe"):
				loadGraphic("assets/images/shoe.png");
			case("Spring"):
				loadGraphic("assets/images/spring.png");
		}
    }

    public function getLabel():String {
        return _label;
    }
}