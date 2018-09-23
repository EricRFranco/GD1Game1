package;

import flixel.FlxSprite;
import flixel.system.FlxAssets.FlxGraphicAsset;
import flixel.util.FlxColor;

class Mutagen extends FlxSprite {
    
    private var _player:Player;          //reference to player 
    private var _recipe = new Array();   //for comparison between player's "inventory" and components necessary to create mutagen
	public  var mut_str:String = "none"; //Tells what specific mutagen this is

    public function new(X:Float, Y:Float, p:Player, c:FlxColor, ?SimpleGraphic:FlxGraphicAsset) {
		super(X, Y, SimpleGraphic);
		makeGraphic(30, 30, c);
        _player = p;
        createRecipe();
		scrollFactor.set(0, 0);
    }

    public function getRecipe() : Array<String> {
        return _recipe;
    }


    // When the player cycles through their already-created mutagens, they will activate one and deactivate all others.
    public function activate():Void {
        
    }

    public function deactivate():Void {
        
    }

    private function createRecipe():Void {
        
    } 

    public function changePlayerColor():Void {
        
    }

}