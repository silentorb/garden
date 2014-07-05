package garden.flowers;
import bloom.Flower;

/**
 * ...
 * @author Christopher W. Johnson
 */
class Main_Entity_Flower extends Flower{

	public var seed:Dynamic;
	public var trellis:Trellis;

	public function new() {
				var text = element = new TextField();
		if (title != null)
			text.text = title;

		var format = new TextFormat();
    format.font = "Arial";
    format.size = 24;
    //format.color = 0xBBBBBB;
    text.setTextFormat(format);
		text.selectable = false;
		element.addChild(text);
	}

}