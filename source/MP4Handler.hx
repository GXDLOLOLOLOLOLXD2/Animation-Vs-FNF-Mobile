package;

#if VIDEOS_ALLOWED
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.util.FlxTimer;
import openfl.display.Sprite;
import video.VideoSprite;
import lime.app.Application;

/*
 * Video Handler Working using hxCodec
 * by @azeitona-x7(youtube channel)
*/

class MP4Handler {
	public var finishCallback:Void->Void;
	public var sprite:VideoSprite;

	public function new() {}

	// play just 1 time in the song and ends
	public function playMP4(file:String, ?outputTo:FlxSprite = null):Void
	{
		var path = Paths.video(file); // ex: 'animatedbg' -> assets/videos/animatedbg.mp4
		sprite = new VideoSprite();
		sprite.load(path);

		sprite.onComplete = function() {
			trace("Vídeo finalizado: " + file);
			if (finishCallback != null) {
				new FlxTimer().start(0.1, function(_) finishCallback());
			}
			// removed when the song finish
			if (sprite.parent != null) sprite.parent.removeChild(sprite);
		};

		sprite.play();

		// add the stage on top of everything
		Application.current.window.stage.addChild(sprite);

		// if wants appear inside a FlxSprite (like background)
		if (outputTo != null) {
			outputTo.loadGraphic(sprite.bitmapData);
			sprite.visible = false;
		}
	}

	// plays in loop
	public function playBackground(file:String):Void
	{
		var path = Paths.video(file);
		sprite = new VideoSprite();
		sprite.load(path);
		sprite.loop = true;
		sprite.play();

		Application.current.window.stage.addChildAt(sprite, 0);
	}

	public function stop():Void
	{
		if (sprite != null) {
			sprite.stop();
			if (sprite.parent != null) sprite.parent.removeChild(sprite);
			sprite = null;
		}
	}
}
#end