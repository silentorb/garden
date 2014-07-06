package garden.flowers;
import bloom.Flower;
import metahub.schema.Property;
import metahub.schema.Trellis;
import js.JQuery;
import garden.channels.Entity_Channel;
import metahub.schema.Kind;

/**
 * ...
 * @author Christopher W. Johnson
 */
class Entity_Flower extends Flower
{
	public function new(seed:Dynamic, trellis:Trellis, garden:Garden) 
	{
		super();
		element = new JQuery(garden.blocks['entity']);
		element.find('h2').text(seed.name ? seed.name : 'Create ' + trellis.name);
		
		var list = element.find('.properties');
		var properties = trellis.get_all_properties();
		for (property in properties) {
			var field = new JQuery(garden.blocks['field']);
			var label = field.find('.label');
			label.text(property.name);
			//if (Reflect.hasField(seed, property.name)) {
			var value = field.find('.value');
			value.append(get_child_value(seed, property, garden));
			//}
			list.append(field);
		}
		
		element.find('.submit').click(function(e) {
			e.preventDefault();
			update(seed, trellis, garden);
		});
	}
	
	public function get_child_value(seed:Dynamic, property:Property, garden:Garden):JQuery {
		var value = Reflect.hasField(seed, property.name)
			? Reflect.field(seed, property.name)
			: null;
		
		switch (property.type) 
		{
			case Kind.reference:
				if (value == null)
					return new JQuery('<span>null</span>');

				var link = Entity_Channel.create_link(property.other_trellis, value, garden);
				return link.element;
				
			case Kind.list:
				if (value == null)
					return new JQuery('<span>null</span>');
				
				var values:Array<Dynamic> = value;
				return create_list(values, property, garden);

			case Kind.string:
				var input = new JQuery('<input type="text" />');
				if (value != null)
					input.val(Std.string(value));
					
				input.change(function(e) {
					Reflect.setField(seed, property.name, input.val());
				});
				return input;
				
			default:
				var span = new JQuery('<span />');
				span.text(Std.string(value));		
				return span;
		}
	}
	
	function create_list(values:Array<Dynamic>, property:Property, garden:Garden):JQuery {
		var links = new JQuery('<div/>');
		for (i in values) {
			var link = Entity_Channel.create_link(property.other_trellis, i, garden);
			var wrapper = new JQuery(garden.blocks['item']);
			wrapper.prepend(link.element.children()[0]);
			links.append(wrapper);
			wrapper.find('.remove').click(function(e) {
				Reflect.setField(i, '_removed_', true);
				wrapper.remove();
			});
		}
		return links;
	}
	
	public function get_update_value(seed:Dynamic, property:Property):Dynamic {
		var value = Reflect.field(seed, property.name);
		if (value == null)
			return null;
		
		switch (property.type) 
		{
			case Kind.reference:
				return get_reference_update(value, property);
				
			case Kind.list:
				var values:Array<Dynamic> = value;
				return Lambda.array(Lambda.map(values, function(v) { return get_reference_update(v, property); } ));
		
			default:
				return value;
		}
	}
	
	function get_reference_update(seed:Dynamic, property:Property):Dynamic {
		if (Reflect.field(seed, '_removed_') == true) {
			var result:Dynamic = cast {
				_removed_: true
			};
			var identity = property.other_trellis.identity_property.name;
			Reflect.setField(result, identity, Reflect.field(seed, identity));
			return result;
		}
		
		return property.other_trellis.get_identity(seed);
	}
	
	function update(source:Dynamic, trellis:Trellis,garden:Garden) {
		var seed:Dynamic = cast { };
		var properties = trellis.get_all_properties();
		for (property in properties) {
			if (Reflect.hasField(source, property.name)) {
				var value = get_update_value(source, property);
				if (value != null) {
					Reflect.setField(seed, property.name, value);
				}
			}
		}
		seed.trellis = trellis.name;

		var data = {
			objects: [ seed ]
		}
		
		garden.remote.post_json('vineyard/update', data)
		.then(function(response) {
			trace('Success!');
		});
	}
	
}