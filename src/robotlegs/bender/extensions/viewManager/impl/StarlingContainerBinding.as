//------------------------------------------------------------------------------
//  Copyright (c) 2011 the original author or authors. All Rights Reserved. 
// 
//  NOTICE: You are permitted to use, modify, and distribute this file 
//  in accordance with the terms of the license agreement accompanying it. 
//------------------------------------------------------------------------------

package robotlegs.bender.extensions.viewManager.impl
{
	import flash.events.EventDispatcher;
	
	import robotlegs.bender.extensions.viewManager.api.IStarlingViewHandler;
	
	import starling.display.DisplayObject;
	import starling.display.DisplayObjectContainer;

	[Event(name="bindingEmpty", type="robotlegs.bender.extensions.viewManager.impl.StarlingContainerBindingEvent")]
	public class StarlingContainerBinding extends EventDispatcher
	{

		/*============================================================================*/
		/* Public Properties                                                          */
		/*============================================================================*/

		private var _parent:StarlingContainerBinding;

		public function get parent():StarlingContainerBinding
		{
			return _parent;
		}

		public function set parent(value:StarlingContainerBinding):void
		{
			_parent = value;
		}

		private var _container:DisplayObjectContainer;

		public function get container():DisplayObjectContainer
		{
			return _container;
		}

		public function get numHandlers():uint
		{
			return _handlers.length;
		}

		/*============================================================================*/
		/* Private Properties                                                         */
		/*============================================================================*/

		private const _handlers:Vector.<IStarlingViewHandler> = new Vector.<IStarlingViewHandler>;

		/*============================================================================*/
		/* Constructor                                                                */
		/*============================================================================*/

		public function StarlingContainerBinding(container:DisplayObjectContainer)
		{
			_container = container;
		}

		/*============================================================================*/
		/* Public Functions                                                           */
		/*============================================================================*/

		public function addHandler(handler:IStarlingViewHandler):void
		{
			if (_handlers.indexOf(handler) > -1)
				return;
			_handlers.push(handler);
		}

		public function removeHandler(handler:IStarlingViewHandler):void
		{
			const index:int = _handlers.indexOf(handler);
			if (index > -1)
			{
				_handlers.splice(index, 1);
				if (_handlers.length == 0)
				{
					dispatchEvent(new StarlingContainerBindingEvent(StarlingContainerBindingEvent.BINDING_EMPTY));
				}
			}
		}

		public function handleView(view:DisplayObject, type:Class):void
		{
			const length:uint = _handlers.length;
			for (var i:int = 0; i < length; i++)
			{
				var handler:IStarlingViewHandler = _handlers[i] as IStarlingViewHandler;
				handler.handleView(view, type);
			}
		}
	}
}
