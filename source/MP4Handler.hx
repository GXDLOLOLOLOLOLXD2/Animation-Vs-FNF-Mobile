package;

#if VIDEOS_ALLOWED
import flixel.FlxG;
import flixel.util.FlxTimer;
import hxcodec.flixel.FlxVideoSprite;

/*
 * Video Handler Working using hxCodec
 * by @azeitona-x7 (youtube channel)
 */
class MP4Handler {
	public var video:FlxVideoSprite;
	public var finishCallback:Void->Void;

	public function new() {}

	public function playMP4(file:String):Void {
		var path = Paths.video(file);

		video = new FlxVideoSprite();
		video.play(path, false, function() {
			trace("Video Finished!: " + file);
			if (finishCallback != null)
				finishCallback();
		});

		FlxG.state.add(video);
	}

	public function playBackground(file:String):Void {
		var path = Paths.video(file);

		video = new FlxVideoSprite();
		video.play(path, true);
		FlxG.state.add(video);
	}

	public function stop():Void {
		if (video != null) {
			video.stop();
			video.kill();
			video.destroy();
			video = null;
		}
	}
}
#end