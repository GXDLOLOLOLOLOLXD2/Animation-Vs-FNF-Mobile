package;

#if VIDEOS_ALLOWED
import flixel.FlxG;
import flixel.util.FlxTimer;
import hxcodec.VideoHandler;
import lime.app.Application;

/*
 * Video Handler Working using hxCodec
 * by @azeitona-x7(youtube channel)
*/
class MP4Handler {
	public var video:VideoHandler;
	public var finishCallback:Void->Void;

	public function new() {}

	// Toca um vídeo uma vez (cutscene ou intro)
	public function playMP4(file:String):Void {
		var path = Paths.video(file); // Ex: 'intro' => assets/videos/intro.mp4

		video = new VideoHandler();
		video.play(path, false);

		video.finishCallback = function() {
			trace("Vídeo finalizado: " + file);
			if (finishCallback != null)
				new FlxTimer().start(0.1, function(_) finishCallback());
		};

		Application.current.window.stage.addChild(video);
	}

	// Toca em loop como background
	public function playBackground(file:String):Void {
		var path = Paths.video(file);

		video = new VideoHandler();
		video.play(path, true); // true = loop

		Application.current.window.stage.addChildAt(video, 0);
	}

	public function stop():Void {
		if (video != null) {
			video.stop();
			if (video.parent != null) video.parent.removeChild(video);
			video = null;
		}
	}
}
#end