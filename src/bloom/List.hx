package bloom;
import js.JQuery;

/**
 * ...
 * @author Christopher W. Johnson
 */

class List extends Flower
{
	var children = new Array<Flower>();
	
	public function new() 
	{
		super();
		element = new JQuery('<div/>');
	}
	
	public function add(child:Flower) {
		//trace('b', height, child.height);
		//child.y = height;
		//child.y = height;
		//_height += child.height;
		//children.push(child);
		//element.addChild(child.get_general_element());
		element.append(child.element);
		//addChild(child);
	}
}