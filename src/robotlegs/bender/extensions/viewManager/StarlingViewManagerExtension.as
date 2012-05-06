//------------------------------------------------------------------------------
//  Copyright (c) 2011 the original author or authors. All Rights Reserved. 
// 
//  NOTICE: You are permitted to use, modify, and distribute this file 
//  in accordance with the terms of the license agreement accompanying it. 
//------------------------------------------------------------------------------

package robotlegs.bender.extensions.viewManager
{
	import org.swiftsuspenders.Injector;
	
	import robotlegs.bender.extensions.viewManager.api.IStarlingViewManager;
	import robotlegs.bender.extensions.viewManager.impl.StarlingContainerRegistry;
	import robotlegs.bender.extensions.viewManager.impl.StarlingViewManager;
	import robotlegs.bender.framework.api.IContext;
	import robotlegs.bender.framework.api.IContextExtension;

	public class StarlingViewManagerExtension implements IContextExtension
	{

		/*============================================================================*/
		/* Private Static Properties                                                  */
		/*============================================================================*/

		// Really? Yes, there can be only one.
		private static var _containerRegistry:StarlingContainerRegistry;

		/*============================================================================*/
		/* Private Properties                                                         */
		/*============================================================================*/
		
		private var _injector:Injector;

		private var _viewManager:IStarlingViewManager;

		/*============================================================================*/
		/* Public Functions                                                           */
		/*============================================================================*/

		public function extend(context:IContext):void
		{
			_injector = context.injector;

			// Just one Container Registry
			_containerRegistry ||= new StarlingContainerRegistry();
			_injector.map(StarlingContainerRegistry).toValue(_containerRegistry);

			// But you get your own View Manager
			_injector.map(IStarlingViewManager).toSingleton(StarlingViewManager);
			
			context.lifecycle.whenInitializing(handleContextSelfInitialize);
			context.lifecycle.whenDestroying(handleContextSelfDestroy);
		}

		/*============================================================================*/
		/* Private Functions                                                          */
		/*============================================================================*/

		private function handleContextSelfInitialize():void
		{
			_viewManager = _injector.getInstance(IStarlingViewManager);
		}

		private function handleContextSelfDestroy():void
		{
			_viewManager.removeAllHandlers();
			_injector.unmap(IStarlingViewManager);
			_injector.unmap(StarlingContainerRegistry);
		}
	}
}
