package;

class SuperRush extends Mutagen {

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