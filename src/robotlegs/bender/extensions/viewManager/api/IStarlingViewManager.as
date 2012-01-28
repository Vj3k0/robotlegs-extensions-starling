//------------------------------------------------------------------------------
//  Copyright (c) 2011 the original author or authors. All Rights Reserved. 
// 
//  NOTICE: You are permitted to use, modify, and distribute this file 
//  in accordance with the terms of the license agreement accompanying it. 
//------------------------------------------------------------------------------

package robotlegs.bender.extensions.viewManager.api
{
	import starling.display.DisplayObjectContainer;

	public interface IStarlingViewManager
	{
		function addContainer(container:DisplayObjectContainer):void;
		function removeContainer(container:DisplayObjectContainer):void;

		function addViewHandler(handler:IStarlingViewHandler):void;
		function removeViewHandler(handler:IStarlingViewHandler):void;

		function removeAllHandlers():void;
	}
}
