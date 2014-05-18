package;

import flash.display.BitmapData;
import flash.Lib;
import flixel.addons.ui.FlxSlider;
import flixel.atlas.FlxAtlas;
import flixel.atlas.FlxNode;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.group.FlxTypedGroup;
import flixel.text.FlxText;
import flixel.tile.FlxTileblock;
import flixel.tile.FlxTilemap;
import flixel.ui.FlxButton;
import flixel.util.FlxColor;
import flixel.util.loaders.CachedGraphics;
import flixel.util.loaders.TextureRegion;
import openfl.Assets;

/**
 * ...
 * @author Zaphod
 */
class PlayState extends FlxState
{
	override public function create():Void
	{
		// lets create atlas
		var atlas:FlxAtlas = new FlxAtlas("myAtlas", 512, 512);
		
		// and add nodes (images) on it
		var tilesNode:FlxNode = createNodeAndDisposeBitmap("assets/area02_level_tiles2.png", atlas);
		var monsterNode:FlxNode = createNodeAndDisposeBitmap("assets/lurkmonsta.png", atlas);
		var playerNode:FlxNode = createNodeAndDisposeBitmap("assets/lizardhead3.png", atlas);
		
		// now we can create some helper object which can be loaded in sprites and tilemaps
		var tileWidth:Int = 16;
		var tileHeight:Int = 16;
		var tileSpacing:Int = 0;
		var tilesRegion:TextureRegion = createTextureRegionFromFlxNode(atlas, tilesNode, tileWidth, tileHeight, tileSpacing, tileSpacing);
		
		// lets try load this object in newly created tilemap
		var tilemap:FlxTilemap = new FlxTilemap();
		tilemap.loadMap(Assets.getText("assets/mapCSV_Group1_Map1.csv"), tilesRegion);
		add(tilemap);
		
		// lets try this feature on sprites also
		var monsterWidth:Int = 16;
		var monsterHeight:Int = 17;
		var monsterRegion:TextureRegion = createTextureRegionFromFlxNode(atlas, monsterNode, monsterWidth, monsterHeight);
		
		var monster:FlxSprite = new FlxSprite();
		monster.loadGraphic(monsterRegion, true);
		add(monster);
		
		// why not animate some sprite?
		var playerWidth:Int = 16;
		var playerHeight:Int = 20;
		var playerRegion:TextureRegion = createTextureRegionFromFlxNode(atlas, playerNode, playerWidth, playerHeight);
		
		var player:FlxSprite = new FlxSprite(100, 0);
		player.loadGraphic(playerRegion, true);
		player.animation.add("walking", [0, 1, 2, 3], 12, true);
		player.animation.play("walking");
		add(player);
	}
	
	/**
	 * Helper method for getting TextureRegion objects for provided node from atlas
	 * @param	atlas				atlas, containing node
	 * @param	node				node, containing image
	 * @param	tileWidth			tile width in the image
	 * @param	tileHeight			tile height in the image
	 * @param	tileSpacingX		horizontal spacing between tiles in image
	 * @param	tileSpacingY		vertical spacing between tiles in image
	 * @return	region which can be loaded in sprites and tilemaps as the source of graphics
	 */
	private function createTextureRegionFromFlxNode(atlas:FlxAtlas, node:FlxNode, tileWidth:Int = 0, tileHeight:Int = 0, tileSpacingX:Int = 0, tileSpacingY:Int = 0):TextureRegion
	{
		// lets get cachedGraphics for atlas image
		var cachedGraphics:CachedGraphics = FlxG.bitmap.add(atlas.atlasBitmapData);
		
		// and now we can create TextureRegion object which can be loaded in FlxSprite or FlxTilemap as the source of graphics
		return new TextureRegion(cachedGraphics, node.x, node.y, tileWidth, tileHeight, tileSpacingX, tileSpacingY, node.width - atlas.borderX, node.height - atlas.borderY);
	}
	
	/**
	 * Helper method for getting FlxNodes for images, but with image disposing (for memory savings)
	 * @param	source	path to the image
	 * @param	atlas	atlas to load image onto
	 * @return	created FlxNode object for image
	 */
	private function createNodeAndDisposeBitmap(source:String, atlas:FlxAtlas):FlxNode
	{
		var bitmap:BitmapData = Assets.getBitmapData(source);
		var node:FlxNode = atlas.addNode(bitmap, source);
		Assets.cache.bitmapData.remove(source);
		bitmap.dispose();
		return node;
	}
}