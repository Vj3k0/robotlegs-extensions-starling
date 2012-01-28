//------------------------------------------------------------------------------
//  Copyright (c) 2011 the original author or authors. All Rights Reserved. 
// 
//  NOTICE: You are permitted to use, modify, and distribute this file 
//  in accordance with the terms of the license agreement accompanying it. 
//------------------------------------------------------------------------------

package robotlegs.bender.extensions.viewManager.impl
{
	import flash.events.Event;
	
	import starling.display.DisplayObjectContainer;

	public class StarlingContainerRegistryEvent extends Event
	{

		/*============================================================================*/
		/* Public Static Properties                                                   */
		/*============================================================================*/

		public static const CONTAINER_ADD:String = 'containerAdd';

		public static const CONTAINER_REMOVE:String = 'containerRemove';

		public static const ROOT_CONTAINER_ADD:String = 'rootContainerAdd';

		public static const ROOT_CONTAINER_REMOVE:String = 'rootContainerRemove';

		/*============================================================================*/
		/* Public Properties                                                          */
		/*============================================================================*/

		private var _container:DisplayObjectContainer;

		public function get container():DisplayObjectContainer
		{
			return _container;
		}

		/*============================================================================*/
		/* Constructor                                                                */
		/*============================================================================*/

		public function StarlingContainerRegistryEvent(type:String, container:DisplayObjectContainer)
		{
			super(type);
			_container = container;
		}

		/*============================================================================*/
		/* Public Functions                                                           */
		/*============================================================================*/

		override public function clone():Event
		{
			return new StarlingContainerRegistryEvent(type, _container);
		}
	}
}
