package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import openfl.events.Event;
import hxcodec.VideoSprite;

/*
 * MP4Handler for Android using hxCodec
 * Loopable video background handler
 * by azeitona-x7 (adapted for hxCodec)
 */
class MP4Handler {
	public var video:VideoSprite;
	public var sprite:FlxSprite;
	public var finishCallback:Void->Void;
	public var stateCallback:FlxState;

	public function new() {}

	public function playMP4(path:String, ?repeat:Bool = true, ?outputTo:FlxSprite = null, ?midSong:Bool = false):Void {
		if (!midSong && FlxG.sound.music != null)
			FlxG.sound.music.stop();

		video = new VideoSprite();
		video.smoothing = true;

		if (FlxG.stage.stageHeight / 9 < FlxG.stage.stageWidth / 16) {
			video.width = Std.int(FlxG.stage.stageHeight * (16 / 9));
			video.height = Std.int(FlxG.stage.stageHeight);
		} else {
			video.width = Std.int(FlxG.stage.stageWidth);
			video.height = Std.int(FlxG.stage.stageWidth / (16 / 9));
		}

		FlxG.stage.addChildAt(video, 0);
		FlxG.stage.addEventListener(Event.ENTER_FRAME, update);

		if (outputTo != null) {
			video.alpha = 0;
			sprite = outputTo;
		}

		video.play(path);

		video.addEventListener(Event.SOUND_COMPLETE, function(_) {
			if (repeat)
				video.play(path);
			else if (finishCallback != null)
				finishCallback();
		});
	}

	public function kill() {
		if (video != null) {
			if (FlxG.stage.contains(video))
				FlxG.stage.removeChild(video);

			FlxG.stage.removeEventListener(Event.ENTER_FRAME, update);
			video.stop();
			video.dispose(); // ← now works
			video = null;
		}
		sprite = null;
	}

	function update(e:Event) {
		if (video != null) {
			video.volume = FlxG.sound.volume + 0.3;
			if (FlxG.sound.volume <= 0.1)
				video.volume = 0;
		}
	}
}