package garden.flowers;
import bloom.Flower;
import garden.channels.Channel;
import garden.Garden;
import js.JQuery;

/**
 * ...
 * @author Christopher W. Johnson
 */
class Link extends Flower
{
	//var text:TextField;
	var channel:Channel;

	public function new(title:String, channel:Channel)
	{
		super();
		this.channel = channel;
		var text = new JQuery('<a href="#" />');
		//text.width = 150;
		if (title != null)
			text.text(title);
			
		element = new JQuery('<div />');
		element.append(text);

		//var format = new TextFormat();
    //format.font = "Arial";
    //format.size = 18;
    ////format.color = 0xBBBBBB;
    //text.setTextFormat(format);
		//text.selectable = false;

		//trace('a', text.text);
		//this.height = text.textHeight;

		//element.addChild(text);
		element.click(function(e) {
			e.preventDefault();
			this.channel.goto();
		});
	}

}