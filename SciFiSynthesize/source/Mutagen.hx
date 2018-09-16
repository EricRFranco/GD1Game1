package;

class Mutagen {
    
    private var:Player _player;     //reference to player 
    private var:String _recipe;     //for comparison between player's "inventory" and components necessary to create mutagen

    public funtion new(p:Player) {
        _player = p;
        _recipe = new Array();
    }

    // All mutagens must be synthesized by getting all components and pressing the synthesize button.
    public function Synthesize():Void {

    }

    // When the player cycles through their already-created mutagens, they will activate one and deactivate all others.
    public function Activate():Void {

    }

    public function Deactivate():Void {

    }
}