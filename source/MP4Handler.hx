package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;
import openfl.events.Event;
import vlc.VlcBitmap;

/*
 * Original MP4Handler modified for mobile(android & ios)
 * by azeitona-x7 and the originals creators
*/
class MP4Handler
{
	public var finishCallback:Void->Void;
	public var stateCallback:FlxState;

	public var bitmap:VlcBitmap;
	public var sprite:FlxSprite;

	public function new()
	{
		//FlxG.autoPause = false;
	}

	public function playMP4(path:String, ?repeat:Bool = true, ?outputTo:FlxSprite = null, ?isWindow:Bool = false, ?isFullscreen:Bool = false, ?midSong:Bool = false):Void
	{
		if (!midSong)
		{
			if (FlxG.sound.music != null)
			{
				FlxG.sound.music.stop();
			}
		}

		bitmap = new VlcBitmap();

		if (FlxG.stage.stageHeight / 9 < FlxG.stage.stageWidth / 16)
		{
			bitmap.set_width(FlxG.stage.stageHeight * (16 / 9));
			bitmap.set_height(FlxG.stage.stageHeight);
		}
		else
		{
			bitmap.set_width(FlxG.stage.stageWidth);
			bitmap.set_height(FlxG.stage.stageWidth / (16 / 9));
		}

		bitmap.onVideoReady = onVLCVideoReady;
		bitmap.onComplete = onVLCComplete;
		bitmap.onError = onVLCError;

		FlxG.stage.addEventListener(Event.ENTER_FRAME, update);

		if (repeat)
			bitmap.repeat = -1;
		else
			bitmap.repeat = 0;

		bitmap.inWindow = isWindow;
		bitmap.fullscreen = isFullscreen;

		FlxG.addChildBelowMouse(bitmap);
		bitmap.play(checkFile(path));

		if (outputTo != null)
		{
			bitmap.alpha = 0;
			sprite = outputTo;
		}
	}

	function checkFile(fileName:String):String
	{
		#if mobile
		return fileName; // Android/iOS: asset interno, não precisa de caminho absoluto
		#else
		var pDir = "";
		var appDir = "file:///" + Sys.getCwd() + "/";

		if (fileName.indexOf(":") == -1)
			pDir = appDir;
		else if (fileName.indexOf("file://") == -1 || fileName.indexOf("http") == -1)
			pDir = "file:///";

		return pDir + fileName;
		#end
	}

	function onVLCVideoReady()
	{
		trace("video loaded!");

		if (sprite != null)
			sprite.loadGraphic(bitmap.bitmapData);
	}

	public function onVLCComplete()
	{
		FlxG.camera.fade(FlxColor.BLACK, 0, false);

		trace("Big, Big Chungus, Big Chungus!");

		new FlxTimer().start(0, function(tmr:FlxTimer)
		{
			if (finishCallback != null)
			{
				finishCallback();
			}
			else if (stateCallback != null)
			{
				LoadingState.loadAndSwitchState(stateCallback);
			}
		});
	}

	public function kill()
	{
		if (bitmap != null)
		{
			#if flash
			FlxG.stage.removeChild(bitmap); // Flash usa stage direto
			#else
			if (FlxG.stage.contains(bitmap))
				FlxG.stage.removeChild(bitmap);
			#end

			FlxG.stage.removeEventListener(Event.ENTER_FRAME, update);
			bitmap.stop();
			bitmap.dispose(); // Libera a memória nativa do VLC
			bitmap = null;
		}

		sprite = null;
	}

	function onVLCError()
	{
		if (finishCallback != null)
		{
			finishCallback();
		}
		else if (stateCallback != null)
		{
			LoadingState.loadAndSwitchState(stateCallback);
		}
	}

	function update(e:Event)
	{
		bitmap.volume = FlxG.sound.volume + 0.3;

		if (FlxG.sound.volume <= 0.1)
			bitmap.volume = 0;
	}
}