package resize;

import signals.Signal;
import time.EnterFrame;
import openfl.display.Stage;
import openfl.events.Event;
import openfl.Lib;

/**
 * ...
 * @author P.J.Shand
 */
class Resize {
	static var repeatResizeForXFrames:Int = 4;
	static var resizeCount:Int = 0;
	static var onResize:Signal = new Signal();
	static var stage:Stage;

	static function init() {
		if (stage != null)
			return;

		stage = Lib.current.stage;

		onStageResize(null);

		EnterFrame.addAt(onTick, 0);
		onTick();

		stage.addEventListener(Event.RESIZE, onStageResize);
	}

	static function onStageResize(e:Event):Void {
		resizeCount = 0;
	}

	static function onTick():Void {
		resizeCount++;
		if (resizeCount < repeatResizeForXFrames) {
			onResize.dispatch();
		}
	}

	public static function add(callback:Void->Void, ?fireOnce:Bool = false, ?priority:Int = 0, ?fireOnAdd:Null<Bool> = null):BaseSignal<Void->Void> {
		init();
		onResize.add(callback, fireOnce, priority, fireOnAdd);
		callback();
		return onResize;
	}

	public static function dispatch():Void {
		onResize.dispatch();
	}

	public static function remove(listener:Void->Void = null):Void {
		onResize.remove(listener);
	}
}
