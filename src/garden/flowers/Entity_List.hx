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

	public function new(title:String, query:Query, garden:Garden) {
		super();
		this.title = title;
		this.query = query;
		element = new JQuery(garden.blocks['trellis-query']);
		var text = element.find('.title');
		text.text(title);
		element.find('.create').click(function (e) {
			var view = new Entity_Flower({}, query.trellis, garden);
			garden.set_main_view(view);	
		});
		
		query.run(garden.remote)
		.then(function(response) {
			var list = new List();
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