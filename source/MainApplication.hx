package;

#if (lime && android)
import lime.app.Application;
import openfl.Lib;

import Main;

class MainApplication extends Application {
	override public function onCreate() {
		super.onCreate();
		Lib.current.addChild(new Main());
	}
}
#end
