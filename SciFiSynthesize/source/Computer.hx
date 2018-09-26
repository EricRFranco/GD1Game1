package;

import flixel.FlxSprite;
import flixel.system.FlxAssets.FlxGraphicAsset;
import flixel.text.FlxText;
import flixel.util.FlxColor;

class Computer extends FlxSprite
{
	public var log_text:FlxText;
	public var log_bg:FlxSprite;
	
	public function new(X:Float, Y:Float, text:FlxText, bg:FlxSprite, ?SimpleGraphic:FlxGraphicAsset) 
	{
		super(X, Y, SimpleGraphic);
		makeGraphic(20, 20, FlxColor.TRANSPARENT);
		log_text = text;
		log_bg = bg;
	}
	
}