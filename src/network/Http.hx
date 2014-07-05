package network;
import promhx.Deferred;
import promhx.Promise.Promise;
import haxe.Json;

typedef Response_Info = {
	response:String,
	request:haxe.Http
}

/**
 * ...
 * @author Christopher W. Johnson
 */
class Http {
	var server_url:String;
	var cookies:String;

	public function new(server_url:String) {
		this.server_url = server_url;
	}

	function create_url(path:String):String {
		return 'http://' + server_url + '/' + path;
	}

  public function get(url:String):Promise<Response_Info> {
		return http(url, null, false);
	}

	public function post(url:String, data:String):Promise<Response_Info> {
		return http(url, data, true);
	}
	
	public function get_json(url:String):Promise<Dynamic> {
		return http(url, null, false)
		.then(function(info) {
			//haxe.Timer.delay(function() { request: r, response: response }, 1);
			return Json.parse(info.response);
		});
	}

	public function post_json(url:String, data:Dynamic):Promise<Dynamic> {
		return http(url, Json.stringify(data), true)
		.then(function(info) {
			return Json.parse(info.response);
		});
	}

  function http(url:String, data:String, post:Bool):Promise<Response_Info> {
    var def = new Deferred<Response_Info>();
    var r = new haxe.Http(create_url(url));
		if (cookies != null) {
			trace('Cookie', cookies);
			r.addHeader('Cookie', cookies);
		}		
    r.onError = function(response) {
			//trace('error', response);
			//trace('headers2', r.responseHeaders);
      //def.promise().reject(response);
			throw response;
    }
    r.onData = function(response) {
			//trace('http', response);
			haxe.Timer.delay(function() def.resolve({ request: r, response: response }), 1);
      //def.resolve(Json.parse(response));
    }
		if (post)
			r.setPostData(data);

		r.setHeader('Content-Type', 'application/json');
    r.request(post);

    return def.promise();
  }

	public function login(name:String, password:String):Promise<Dynamic> {
		return post('vineyard/login', Json.stringify({ name: name, pass: password }) )
		.then(function(info) {
			//trace('hey');
			//trace('headers1', info.request.responseHeaders);
			#if js
			#elseif flash
			#else
			cookies = info.request.responseHeaders.get('Set-Cookie');
			#end
			//trace('session_token', cookies);
			return Json.parse(info.response);
		});
	}
}