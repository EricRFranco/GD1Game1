package;

import flixel.util.FlxColor;

class PushBoxes extends Mutagen {

    public override function activate():Void {
        
    }

    public override function deactivate():Void {
        
    }

    private override function createRecipe():Void {
        _recipe.push("Glove");
        _recipe.push("Dumbell");
    }

    public override function changePlayerColor():Void {
        trace("Changing player color");
    }

}