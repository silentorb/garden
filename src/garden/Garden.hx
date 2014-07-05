package garden;
import bloom.Flower;
import bloom.IFlower;
import garden.channels.Trellis_Channel;
import garden.flowers.Link;
import bloom.List;
import haxe.ds.StringMap;
import metahub.Hub;
import metahub.schema.Schema;
import metahub.schema.Trellis;
import network.Http;
import promhx.Deferred;
import promhx.Promise;
import vineyard.Vineyard;
import js.JQuery;

/**
 * ...
 * @author Christopher W. Johnson
 */

class Garden {
	var vineyard:Vineyard;
	var hub:Hub;
	var main_view:Flower;
	public var blocks = new Map<String, String>();

	public var remote:Http;

	public function new() {
		hub = new Hub();
		remote = new Http('localhost/garden');

		remote.get('blocks/blocks.html')
		.then(function(response) {
			var all = new JQuery(response.response);
			for (child in all.children()) {
				var name = child.attr('name');
				while (name == null) 
				{
					child = new JQuery(child.children()[0]);
					name = child.attr('name');
				}				
				blocks[name] = child[0].outerHTML;
			}
			return remote.login('cj', 'pass');
		})
		.then(function(response) {
			trace('logged in');
			return remote.get_json('vineyard/schema')
			.then(function(response) {
				trace('populating list...');
				var namespace = hub.schema.add_namespace('garden');
				hub.schema.load_trellises(response.trellises, namespace);
				trace('r', Reflect.fields(response));
				trace('trellises', Reflect.fields(response.trellises));
				populate_list(namespace.trellises);
			});
		});
		
	}

	function populate_list(trellises:Map<String, Trellis>) {
		var list = new List();
		new JQuery('#trellises').append(list.element);

		for (trellis in trellises) {
			var channel = new Trellis_Channel(trellis, this);
			list.add(new Link(trellis.name, channel));
		}

		trace('done populating');
	}

	public function set_main_view(view:Flower) {
		if (main_view != null) {
			main_view.element.remove();
		}

		main_view = view;
		new JQuery('#content').append(main_view.element);
		//main_view.x = 200;
		//main_view.y = 10;
	}
}