package irl;

// TODO: Can I just extend Map for this?
class GenericProperties {
	public var properties:Map<String, Dynamic>;
	
	public function new() {
		properties = new Map<String, Dynamic>();
	}
	
	public function get(property:String):Dynamic {
		if (properties.exists(property)) {
			return properties.get(property);
		} else {
			set(property, null);
			return null;
		}
	}
	
	public function set(property:String, to:Dynamic):Void {
		properties.set(property, to);
	}		
}