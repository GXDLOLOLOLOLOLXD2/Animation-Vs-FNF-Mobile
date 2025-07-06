package;

import lime.app.Application;
import openfl.display.Sprite;
import openfl.Lib;

import Main;

class MainApplication extends Application {
	public function new() {
		super();
		Lib.current.addChild(new Main());
	}
}
