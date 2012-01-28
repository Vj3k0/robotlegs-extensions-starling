//------------------------------------------------------------------------------
//  Copyright (c) 2011 the original author or authors. All Rights Reserved. 
// 
//  NOTICE: You are permitted to use, modify, and distribute this file 
//  in accordance with the terms of the license agreement accompanying it. 
//------------------------------------------------------------------------------

package robotlegs.bender.extensions.viewManager.impl
{
	import starling.display.DisplayObject;
	import starling.display.DisplayObjectContainer;

	public class ManualStarlingStageObserver
	{

		/*============================================================================*/
		/* Private Properties                                                         */
		/*============================================================================*/

		private var _registry:StarlingContainerRegistry;

		/*============================================================================*/
		/* Constructor                                                                */
		/*============================================================================*/

		public function ManualStarlingStageObserver(containerRegistry:StarlingContainerRegistry)
		{
			_registry = containerRegistry;
			// We care about all containers (not just roots)
			_registry.addEventListener(StarlingContainerRegistryEvent.CONTAINER_ADD, onContainerAdd);
			_registry.addEventListener(StarlingContainerRegistryEvent.CONTAINER_REMOVE, onContainerRemove);
			// We might have arrived late on the scene
			for each (var binding:StarlingContainerBinding in _registry.bindings)
			{
				addContainerListener(binding.container);
			}
		}

		/*============================================================================*/
		/* Public Functions                                                           */
		/*============================================================================*/

		public function destroy():void
		{
			_registry.removeEventListener(StarlingContainerRegistryEvent.CONTAINER_ADD, onContainerAdd);
			_registry.removeEventListener(StarlingContainerRegistryEvent.CONTAINER_REMOVE, onContainerRemove);
			for each (var binding:StarlingContainerBinding in _registry.bindings)
			{
				removeContainerListener(binding.container);
			}
		}

		/*============================================================================*/
		/* Private Functions                                                          */
		/*============================================================================*/

		private function onContainerAdd(event:StarlingContainerRegistryEvent):void
		{
			addContainerListener(event.container);
		}

		private function onContainerRemove(event:StarlingContainerRegistryEvent):void
		{
			removeContainerListener(event.container);
		}

		private function addContainerListener(container:DisplayObjectContainer):void
		{
			// We're interested in ALL container bindings
			// but just for normal, bubbling events
			container.addEventListener(StarlingConfigureViewEvent.CONFIGURE_VIEW, onConfigureView);
		}

		private function removeContainerListener(container:DisplayObjectContainer):void
		{
			// Release the container listener
			container.removeEventListener(StarlingConfigureViewEvent.CONFIGURE_VIEW, onConfigureView);
		}

		private function onConfigureView(event:StarlingConfigureViewEvent):void
		{
			// Stop that event!
			event.stopImmediatePropagation();
			const container:DisplayObjectContainer = event.currentTarget as DisplayObjectContainer;
			const view:DisplayObject = event.target as DisplayObject;
			const type:Class = view['constructor'];
			_registry.getBinding(container).handleView(view, type);
		}
	}
}
