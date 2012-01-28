//------------------------------------------------------------------------------
//  Copyright (c) 2011 the original author or authors. All Rights Reserved. 
// 
//  NOTICE: You are permitted to use, modify, and distribute this file 
//  in accordance with the terms of the license agreement accompanying it. 
//------------------------------------------------------------------------------

package robotlegs.bender.extensions.viewManager.impl
{
	import flash.events.EventDispatcher;
	import flash.utils.Dictionary;
	
	import starling.display.DisplayObject;
	import starling.display.DisplayObjectContainer;

	[Event(name="containerAdd", type="robotlegs.bender.extensions.viewManager.impl.StarlingContainerRegistryEvent")]
	[Event(name="containerRemove", type="robotlegs.bender.extensions.viewManager.impl.StarlingContainerRegistryEvent")]
	[Event(name="rootContainerAdd", type="robotlegs.bender.extensions.viewManager.impl.StarlingContainerRegistryEvent")]
	[Event(name="rootContainerRemove", type="robotlegs.bender.extensions.viewManager.impl.StarlingContainerRegistryEvent")]
	public class StarlingContainerRegistry extends EventDispatcher
	{

		/*============================================================================*/
		/* Public Properties                                                          */
		/*============================================================================*/

		private const _bindings:Vector.<StarlingContainerBinding> = new Vector.<StarlingContainerBinding>;

		public function get bindings():Vector.<StarlingContainerBinding>
		{
			return _bindings;
		}

		private const _rootBindings:Vector.<StarlingContainerBinding> = new Vector.<StarlingContainerBinding>;

		public function get rootBindings():Vector.<StarlingContainerBinding>
		{
			return _rootBindings;
		}

		/*============================================================================*/
		/* Private Properties                                                         */
		/*============================================================================*/

		private const _bindingByContainer:Dictionary = new Dictionary();

		/*============================================================================*/
		/* Public Functions                                                           */
		/*============================================================================*/

		public function addContainer(container:DisplayObjectContainer):StarlingContainerBinding
		{
			return _bindingByContainer[container] ||= createBinding(container);
		}

		public function removeContainer(container:DisplayObjectContainer):StarlingContainerBinding
		{
			const binding:StarlingContainerBinding = _bindingByContainer[container];
			binding && removeBinding(binding);
			return binding;
		}

		public function findParentBinding(target:DisplayObject):StarlingContainerBinding
		{
			var parent:DisplayObjectContainer = target.parent;
			while (parent)
			{
				var binding:StarlingContainerBinding = _bindingByContainer[parent];
				if (binding)
				{
					return binding;
				}
				parent = parent.parent;
			}
			return null;
		}

		public function getBinding(container:DisplayObjectContainer):StarlingContainerBinding
		{
			return _bindingByContainer[container];
		}

		/*============================================================================*/
		/* Private Functions                                                          */
		/*============================================================================*/

		private function createBinding(container:DisplayObjectContainer):StarlingContainerBinding
		{
			const binding:StarlingContainerBinding = new StarlingContainerBinding(container);
			_bindings.push(binding);

			// Add a listener so that we can remove this binding when it has no handlers
			binding.addEventListener(StarlingContainerBindingEvent.BINDING_EMPTY, onBindingEmpty);

			// If the new binding doesn't have a parent it is a Root
			binding.parent = findParentBinding(container);
			if (binding.parent == null)
			{
				addRootBinding(binding);
			}

			// Reparent any bindings which are contained within the new binding AND
			// A. Don't have a parent, OR
			// B. Have a parent that is not contained within the new binding
			for each (var childBinding:StarlingContainerBinding in _bindingByContainer)
			{
				if (container.contains(childBinding.container))
				{
					if (!childBinding.parent)
					{
						removeRootBinding(childBinding);
						childBinding.parent = binding;
					}
					else if (!container.contains(childBinding.parent.container))
					{
						childBinding.parent = binding;
					}
				}
			}

			dispatchEvent(new StarlingContainerRegistryEvent(StarlingContainerRegistryEvent.CONTAINER_ADD, binding.container));
			return binding;
		}

		private function removeBinding(binding:StarlingContainerBinding):void
		{
			// Remove the binding itself
			delete _bindingByContainer[binding.container];
			const index:int = _bindings.indexOf(binding);
			_bindings.splice(index, 1);

			// Drop the empty binding listener
			binding.removeEventListener(StarlingContainerBindingEvent.BINDING_EMPTY, onBindingEmpty);

			if (!binding.parent)
			{
				// This binding didn't have a parent, so it was a Root
				removeRootBinding(binding);
			}

			// Re-parent the bindings
			for each (var childBinding:StarlingContainerBinding in _bindingByContainer)
			{
				if (childBinding.parent == binding)
				{
					childBinding.parent = binding.parent;
					if (!childBinding.parent)
					{
						// This binding used to have a parent,
						// but no longer does, so it is now a Root
						addRootBinding(childBinding);
					}
				}
			}

			dispatchEvent(new StarlingContainerRegistryEvent(StarlingContainerRegistryEvent.CONTAINER_REMOVE, binding.container));
		}

		private function addRootBinding(binding:StarlingContainerBinding):void
		{
			_rootBindings.push(binding);
			dispatchEvent(new StarlingContainerRegistryEvent(StarlingContainerRegistryEvent.ROOT_CONTAINER_ADD, binding.container));
		}

		private function removeRootBinding(binding:StarlingContainerBinding):void
		{
			const index:int = _rootBindings.indexOf(binding);
			_rootBindings.splice(index, 1);
			dispatchEvent(new StarlingContainerRegistryEvent(StarlingContainerRegistryEvent.ROOT_CONTAINER_REMOVE, binding.container));
		}

		private function onBindingEmpty(event:StarlingContainerBindingEvent):void
		{
			removeBinding(event.target as StarlingContainerBinding);
		}
	}
}
