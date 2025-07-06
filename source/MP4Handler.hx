package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;
import openfl.events.Event;
import vlc.VLCBitmap;

/*
 * MP4Handler adapted for mobile (Android/iOS)
 * Compatible with the original structure of Animation Vs FNF
 * by azeitona-x7 and originals creators
*/
class MP4Handler {
	public var finishCallback:Void->Void;
	public var stateCallback:FlxState;

	public var bitmap:VLCBitmap;
	public var sprite:FlxSprite;

	public function new() {}

	public function playMP4(path:String, ?repeat:Bool = true, ?outputTo:FlxSprite = null, ?isWindow:Bool = false, ?isFullscreen:Bool = false, ?midSong:Bool = false):Void {
		if (!midSong && FlxG.sound.music != null)
			FlxG.sound.music.stop();

		bitmap = new VLCBitmap();

		// Define tamanho proporcional
		if (FlxG.stage.stageHeight / 9 < FlxG.stage.stageWidth / 16) {
			bitmap.width = Std.int(FlxG.stage.stageHeight * (16 / 9));
			bitmap.height = Std.int(FlxG.stage.stageHeight);
		} else {
			bitmap.width = Std.int(FlxG.stage.stageWidth);
			bitmap.height = Std.int(FlxG.stage.stageWidth / (16 / 9));
		}

		// Callbacks VLC
		bitmap.onVideoReady = onVLCVideoReady;
		bitmap.onComplete = onVLCComplete;
		bitmap.onError = onVLCError;

		FlxG.stage.addEventListener(Event.ENTER_FRAME, update);

		bitmap.repeat = repeat ? -1 : 0;
		bitmap.inWindow = isWindow;
		bitmap.fullscreen = isFullscreen;

		FlxG.addChildBelowMouse(bitmap);
		bitmap.play(checkFile(path));

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

	function onVLCVideoReady() {
		trace("video loaded!");

		if (sprite != null)
			sprite.loadGraphic(bitmap.bitmapData);
	}

	public function onVLCComplete() {
		FlxG.camera.fade(FlxColor.BLACK, 0, false);
		trace("Big, Big Chungus, Big Chungus!");

		new FlxTimer().start(0, function(tmr:FlxTimer) {
			if (finishCallback != null)
				finishCallback();
			else if (stateCallback != null)
				LoadingState.loadAndSwitchState(stateCallback);
		});
	}

	public function kill() {
		if (bitmap != null) {
			#if flash
			FlxG.stage.removeChild(bitmap);
			#else
			if (FlxG.stage.contains(bitmap))
				FlxG.stage.removeChild(bitmap);
			#end

			FlxG.stage.removeEventListener(Event.ENTER_FRAME, update);
			bitmap.stop();
			bitmap.dispose();
			bitmap = null;
		}

		sprite = null;
	}

	function onVLCError() {
		if (finishCallback != null)
			finishCallback();
		else if (stateCallback != null)
			LoadingState.loadAndSwitchState(stateCallback);
	}

	function update(e:Event) {
		bitmap.volume = FlxG.sound.volume + 0.3;
		if (FlxG.sound.volume <= 0.1)
			bitmap.volume = 0;
	}
}