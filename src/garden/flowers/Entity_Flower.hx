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
		element.find('h2').text(seed.name);
		
		var list = element.find('.properties');
		var properties = trellis.get_all_properties();
		for (property in properties) {
			var field = new JQuery(garden.blocks['field']);
			var label = field.find('.label');
			label.text(property.name);
			if (Reflect.hasField(seed, property.name)) {
				var value = field.find('.value');
				value.append(get_child_value(seed, property, garden));
			}
			list.append(field);
		}
	}
	
	public function get_child_value(seed:Dynamic, property:Property, garden:Garden):JQuery {
		var value = Reflect.field(seed, property.name);
		if (value == null)
			return new JQuery('<span>null</span>');
			
		if (property.type == Kind.reference) {
			var link = Entity_Channel.create_link(property.other_trellis, value, garden);
			return link.element;
		}
		else if (property.type == Kind.list) {
			var values:Array<Dynamic> = value;
			var links = new JQuery('<div/>');
			for (i in values) {
				var link = Entity_Channel.create_link(property.other_trellis, i, garden);
				links.append(link.element);
			}
			return links;
		}
		var span = new JQuery('<span />');
		span.text(Std.string(value));
		return span;
	}
	
}