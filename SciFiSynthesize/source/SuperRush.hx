package;

import flixel.util.FlxColor;
import flixel.system.FlxAssets.FlxGraphicAsset;

class SuperRush extends Mutagen {
	public function new(X:Float, Y:Float, p:Player, ?SimpleGraphic:FlxGraphicAsset) {
		super(X, Y, p, FlxColor.PINK, SimpleGraphic);
		mut_str = "super rush";
	}	
	
    public override function activate():Void {
        //increase rush damage
    }

    public override function deactivate():Void {
        //revert rush damage to normal
    }

    public override function createRecipe():Void {
        _recipe.push("Fan");
        _recipe.push("Battery");
    }

    public override function changePlayerColor():Void {
        trace("Changing player color");
    }
}