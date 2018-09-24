package;

import flixel.util.FlxColor;
import flixel.system.FlxAssets.FlxGraphicAsset;

class SuperRush extends Mutagen {
	public function new(X:Float, Y:Float, p:Player, ?SimpleGraphic:FlxGraphicAsset) {
		super(X, Y, p, FlxColor.PINK, SimpleGraphic);
		mut_str = "super rush";
	}	
	
    public override function activate():Void {
        _player.power = 3;
    }

    public override function deactivate():Void {
        _player.power = 1;
    }

    public override function createRecipe():Void {
        _recipe.push("Fan");
        _recipe.push("Battery");
    }

    public override function changePlayerColor():Void {
        trace("Changing player color");
    }
}