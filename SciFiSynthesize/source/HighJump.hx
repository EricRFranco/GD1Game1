package;

import flixel.util.FlxColor;

class HighJump extends Mutagen {
    public override function new(p:Player) {
        super(p);
        createRecipe();
    }

    public override function activate():Void {

    }

    public override function deactivate():Void {
        
    }

    private override function createRecipe():Void {
        _recipe.push("Spring");
        _recipe.push("Shoe");
    }

    public override function changePlayerColor():Void {
        trace("Changing player color");
        //_player.color = FlxColor.GREEN;   // Apparently changing color this way makes the sprite disappear altogether.
    }

    /*public override function getRecipe():Array<String> {
        return _recipe;
    }*/

}
