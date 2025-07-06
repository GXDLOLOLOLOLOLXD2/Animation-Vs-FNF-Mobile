package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;
import openfl.events.Event;
import vlc.bitmap.VLCBitmap as VlcBitmap;

/*
 * MP4Handler adapted for mobile (Android/iOS)
 * Compatible with the official hxCodec from haxelib
 * by azeitona-x7
*/
class MP4Handler {
	public var finishCallback:Void->Void;
	public var stateCallback:FlxState;

	public var bitmap:VlcBitmap;
	public var sprite:FlxSprite;

	public function new() {}

	public function playMP4(path:String, ?repeat:Bool = true, ?outputTo:FlxSprite = null, ?isWindow:Bool = false, ?isFullscreen:Bool = false, ?midSong:Bool = false):Void {
		if (!midSong && FlxG.sound.music != null)
			FlxG.sound.music.stop();

		bitmap = new VlcBitmap();
		bitmap.bitmap.smoothing = true;

		// Proporção 16:9
		if (FlxG.stage.stageHeight / 9 < FlxG.stage.stageWidth / 16) {
			bitmap.width = Std.int(FlxG.stage.stageHeight * (16 / 9));
			bitmap.height = Std.int(FlxG.stage.stageHeight);
		} else {
			bitmap.width = Std.int(FlxG.stage.stageWidth);
			bitmap.height = Std.int(FlxG.stage.stageWidth / (16 / 9));
		}

		FlxG.stage.addChildAt(bitmap, 0);

		FlxG.stage.addEventListener(Event.ENTER_FRAME, update);
		bitmap.play(checkFile(path));

		bitmap.addEventListener(Event.SOUND_COMPLETE, function(_) {
			if (repeat)
				bitmap.play(checkFile(path));
		});

		if (outputTo != null) {
			bitmap.alpha = 0;
			sprite = outputTo;
		}
	}

	function checkFile(fileName:String):String {
		#if mobile
		return fileName;
		#else
		var pDir = "";
		var appDir = "file:///" + Sys.getCwd() + "/";

		if (fileName.indexOf(":") == -1)
			pDir = appDir;
		else if (fileName.indexOf("file://") == -1 && fileName.indexOf("http") == -1)
			pDir = "file:///";

		return pDir + fileName;
		#end
	}

	public function kill() {
		if (bitmap != null) {
			if (FlxG.stage.contains(bitmap))
				FlxG.stage.removeChild(bitmap);

			FlxG.stage.removeEventListener(Event.ENTER_FRAME, update);
			bitmap.stop();
			bitmap.dispose();
			bitmap = null;
		}
		sprite = null;
	}

	function update(e:Event) {
		if (bitmap != null) {
			bitmap.volume = FlxG.sound.volume + 0.3;
			if (FlxG.sound.volume <= 0.1)
				bitmap.volume = 0;
		}
	}
}