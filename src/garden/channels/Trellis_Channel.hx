package garden.channels;
import garden.flowers.Entity_List;
import metahub.schema.Trellis;

/**
 * ...
 * @author Christopher W. Johnson
 */
class Trellis_Channel implements Channel{
	var trellis:Trellis;
	var garden:Garden;

	public function new(trellis:Trellis, garden:Garden) {
		this.trellis = trellis;
		this.garden = garden;
	}

	public function goto() {
		var query = new Query(trellis);
		var view = new Entity_List(trellis.name, query, garden);
		garden.set_main_view(view);
	}

}