package;

import flixel.util.FlxColor;
import flixel.system.FlxAssets.FlxGraphicAsset;

class HighJump extends Mutagen {
	public function new(X:Float, Y:Float, p:Player, ?SimpleGraphic:FlxGraphicAsset) {
		super(X, Y, p, FlxColor.GREEN, SimpleGraphic);
		mut_str = "high jump";
	}
	
    public override function activate():Void {
        _player.jump *= 2;
        //trace(_player.jump);
    }

    public override function deactivate():Void {
        _player.jump /= 2;
        //trace(_player.jump);
    }

    private override function createRecipe():Void {
        _recipe.push("Spring");
        _recipe.push("Shoe");
    }

    public override function changePlayerColor():Void {
        trace("Changing player color");
        //_player.color = FlxColor.GREEN;   // Apparently changing color this way makes the sprite disappear altogether.
    }

}
