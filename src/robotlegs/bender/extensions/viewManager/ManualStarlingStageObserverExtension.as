//------------------------------------------------------------------------------
//  Copyright (c) 2011 the original author or authors. All Rights Reserved. 
// 
//  NOTICE: You are permitted to use, modify, and distribute this file 
//  in accordance with the terms of the license agreement accompanying it. 
//------------------------------------------------------------------------------

package robotlegs.bender.extensions.viewManager
{
	import org.swiftsuspenders.Injector;
	
	import robotlegs.bender.extensions.viewManager.impl.StarlingContainerRegistry;
	import robotlegs.bender.extensions.viewManager.impl.StarlingManualStageObserver;
	import robotlegs.bender.framework.api.IContext;
	import robotlegs.bender.framework.api.IContextExtension;

	public class ManualStarlingStageObserverExtension implements IContextExtension
	{

		/*============================================================================*/
		/* Private Static Properties                                                  */
		/*============================================================================*/

		// Really? Yes, there can be only one.
		private static var _manualStageObserver:StarlingManualStageObserver;

		private static var _installCount:uint;

		/*============================================================================*/
		/* Private Properties                                                         */
		/*============================================================================*/

		private var _injector:Injector;

		/*============================================================================*/
		/* Public Functions                                                           */
		/*============================================================================*/

		public function extend(context:IContext):void
		{
			_installCount++;
			_injector = context.injector;
			context.lifecycle.whenInitializing(handleContextSelfInitialize);
			context.lifecycle.whenDestroying(handleContextSelfDestroy);
		}

		/*============================================================================*/
		/* Private Functions                                                          */
		/*============================================================================*/

		private function handleContextSelfInitialize():void
		{
			if (_manualStageObserver == null)
			{
				const containerRegistry:StarlingContainerRegistry = _injector.getInstance(StarlingContainerRegistry);
				_manualStageObserver = new StarlingManualStageObserver(containerRegistry);
			}
		}

		private function handleContextSelfDestroy():void
		{
			_installCount--;
			if (_installCount == 0)
			{
				_manualStageObserver.destroy();
				_manualStageObserver = null;
			}
		}
	}
}
