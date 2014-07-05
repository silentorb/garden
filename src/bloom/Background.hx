package bloom;
import openfl.display.DisplayObject;
import openfl.display.Shape;
import openfl.events.Event;
/**
 * ...
 * @author Christopher W. Johnson
 */
class Background extends Shape
{
	public var color:Int;
	public var target:DisplayObject;

	public function new(color:Int, target:DisplayObject) 
	{
		super();
		this.color = color;
		this.target = target;
		target.addEventListener(Event.CHANGE, function(info) {
			update();
		});
	}
	
	public function update() {
		graphics.clear();
		graphics.beginFill(color);
		var bounds = target.getRect(target.parent);
		graphics.drawRect(bounds.left, bounds.top, bounds.width, bounds.height);
	}
}