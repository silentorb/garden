package garden.flowers;
import bloom.Flower;
import bloom.List;
import garden.channels.Entity_Channel;
import garden.Query;
import metahub.schema.Trellis;
import js.JQuery;

/**
 * ...
 * @author Christopher W. Johnson
 */
class Entity_List extends Flower {
	var title:String;
	var query:Query;

	public function new(title:String,query:Query, garden:Garden) {
		super();
		this.title = title;
		this.query = query;
		element = new JQuery('<div />');
		var text = new JQuery('<h2 />');
		text.text(title);
		//text.width(200);

		//var format = new TextFormat();
    //format.font = "Arial";
    //format.size = 24;
    ////format.color = 0xBBBBBB;
    //text.setTextFormat(format);
		element.append(text);
		
		query.run(garden.remote)
		.then(function(response) {
			var list = new List();
			//list.element.y = 30;
			var objects = response.objects;
			element.append(list.element);
			for (i in Reflect.fields(objects)) {
				var entity = Reflect.field(objects, i);
				var channel = new Entity_Channel(query.trellis, query.trellis.get_identity(entity), garden);
				var link = new Link(entity.name, channel);
				list.add(link);
			}
		});		
	}

}