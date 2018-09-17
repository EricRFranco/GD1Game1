package;

class Mutagen {
    
    private var _player:Player;         //reference to player 
    private var _recipe = new Array();  //for comparison between player's "inventory" and components necessary to create mutagen

    public function new(p:Player) {
        _player = p;
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