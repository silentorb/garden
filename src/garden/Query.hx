package garden;
import metahub.schema.Trellis;
import network.Http;
import promhx.Promise;
import haxe.Json;

/**
 * ...
 * @author Christopher W. Johnson
 */

typedef Filter = {
	path:String,
	?operator:String,
	value:Dynamic
}

typedef Pager =
{
	?limit:Int,
	?offset:Int
}

typedef Sort =
{
	path:String,
	?dir:String
}

typedef Query_Source =
{
  trellis:String,
	?filters:Array<Dynamic>,
	?sorts:Array<Sort>,
	?pager:Pager,
	?expansions:Array<String>
}

class Query {

	public var trellis:Trellis;
	var filters = new Array<Filter>();
	var expansions:Array<String>;

	public function new(trellis:Trellis) {
		this.trellis = trellis;
	}
	
	public function add_identity_filter(id:Dynamic) {
		filters.push({
			path: trellis.identity_property.name,
			value: id
		});
	}
	
	public function add_expansions(additions:Array<String>) {
		if (expansions == null)
			expansions = new Array<String>();
		
		expansions = expansions.concat(additions);
	}

	public function render():String {
		var data:Query_Source = {
			trellis: trellis.name
		};
		if (filters.length > 0) {
			data.filters = filters;
		}
		if (expansions != null && expansions.length > 0) {
			data.expansions = expansions;
		}
		return Json.stringify(data);
	}
	
	public function run(remote:Http):Promise<Dynamic> {
		var json = render();
		return remote.post('vineyard/query', json)
			.then(function(info) {
			return Json.parse(info.response);
		});
	}

}