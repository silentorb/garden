package garden.channels;
import garden.flowers.Entity_Flower;
import garden.flowers.Entity_List;
import garden.flowers.Link;
import metahub.schema.Trellis;

/**
 * ...
 * @author Christopher W. Johnson
 */
class Entity_Channel implements Channel {
	var trellis:Trellis;
	var id:Dynamic;
	var garden:Garden;

	public function new(trellis:Trellis, id:Dynamic, garden:Garden) {
		this.trellis = trellis;
		this.id = id;
		this.garden = garden;
	}

	public function goto() {
		var query = new Query(trellis);
		query.add_identity_filter(id);
		var properties = trellis.get_all_properties();
		var references = Lambda.filter(properties, function(p) { return p.other_trellis != null; } );
		query.add_expansions(
			Lambda.array(Lambda.map(references, function(p) { return p.name; }))
		);
		query.run(garden.remote)
		.then(function(response) {
			var view = new Entity_Flower(response.objects[0], trellis, garden);
			garden.set_main_view(view);
		});

	}

	public static function create_link(trellis:Trellis, seed:Dynamic, garden:Garden):Link {
		var channel = new Entity_Channel(trellis, trellis.get_identity(seed), garden);
		return new Link(seed.name, channel);
	}
}