package resize;

import signal.Signal;
import time.EnterFrame;
import openfl.display.Stage;
import openfl.events.Event;
import openfl.Lib;

/**
 * ...
 * @author P.J.Shand
 */
class Resize
{
	static var repeatResizeForXFrames:Int = 4;
	static var resizeCount:Int = 0;
	static var onResize:Signal = new Signal();
	static var stage:Stage;
	
	static function init() 
	{
		if (stage != null) return;

		stage = Lib.current.stage;

		onStageResize(null);
		
		EnterFrame.addAt(OnTick, 0);
		OnTick();
		
		stage.addEventListener(Event.RESIZE, onStageResize);
	}
	
	static function onStageResize(e:Event):Void 
	{
		resizeCount = 0;
	}
	
	static function OnTick():Void 
	{
		resizeCount++;
		if (resizeCount < repeatResizeForXFrames) {
			onResize.dispatch();
		}
	}
	
	public static function add(callback:Void -> Void, fireOnce:Bool=false, priority:Int = 0):Void
	{
		init();
		onResize.add(callback, fireOnce, priority);
		callback();
	}
	
	public static function dispatch():Void
	{
		onResize.dispatch();
	}
	
	public static function remove(listener:Void -> Void = null):Void
	{
		onResize.remove(listener);
	}
}