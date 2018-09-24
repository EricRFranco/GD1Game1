package;

import flixel.util.FlxColor;
import flixel.system.FlxAssets.FlxGraphicAsset;

class PushBoxes extends Mutagen {
	public function new(X:Float, Y:Float, p:Player, ?SimpleGraphic:FlxGraphicAsset) {
		super(X, Y, p, FlxColor.MAGENTA, SimpleGraphic);
		mut_str = "push boxes";
	}

    public override function activate():Void {
        _player.canPush = true;
    }

    public override function deactivate():Void {
        _player.canPush = false;
    }

    private override function createRecipe():Void {
        _recipe.push("Glove");
        _recipe.push("Dumbell");
    }

    public override function changePlayerColor():Void {
        trace("Changing player color");
    }

}