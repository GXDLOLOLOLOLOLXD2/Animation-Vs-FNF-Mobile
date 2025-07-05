package;

#if VIDEOS_ALLOWED
import flixel.FlxG;
import flixel.util.FlxTimer;
import hxcodec.flixel.FlxVideoSprite;

/*
 * Video Handler Working using hxCodec
 * by @azeitona-x7(youtube channel)
*/
class MP4Handler {
	public var video:FlxVideoSprite;
	public var finishCallback:Void->Void;

	public function new() {}

	public function playMP4(file:String):Void {
		var path = Paths.video(file);

		video = new FlxVideoSprite();
		video.play(path, false);

		// Adiciona o vídeo ao grupo atual do Flixel
		FlxG.state.add(video);

		// Timer para checar se terminou
		FlxG.camera.flash(0xFF000000, 0.1); // só para ter um feedback visual (opcional)
		new FlxTimer().start(0.1, function checkFinished(_) {
			if (!video.playing) {
				trace("Video Finished!: " + file);
				if (finishCallback != null)
					finishCallback();
			} else {
				// Continua checando
				checkFinished(_);
			}
		});
	}

	public function playBackground(file:String):Void {
		var path = Paths.video(file);

		video = new FlxVideoSprite();
		video.play(path, true);

		FlxG.state.add(video); // Adiciona ao fundo
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
