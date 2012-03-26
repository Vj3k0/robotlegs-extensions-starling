//------------------------------------------------------------------------------
//  Copyright (c) 2011 the original author or authors. All Rights Reserved. 
// 
//  NOTICE: You are permitted to use, modify, and distribute this file 
//  in accordance with the terms of the license agreement accompanying it. 
//------------------------------------------------------------------------------

package robotlegs.bender.extensions.viewManager
{
	import robotlegs.bender.extensions.viewManager.api.IStarlingViewManager;
	import robotlegs.bender.extensions.viewManager.impl.StarlingContainerRegistry;
	import robotlegs.bender.extensions.viewManager.impl.StarlingViewManager;
	import robotlegs.bender.framework.context.api.IContext;
	import robotlegs.bender.framework.context.api.IContextExtension;
	import robotlegs.bender.framework.object.managed.impl.ManagedObject;

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

		private var _context:IContext;

		private var _viewManager:IStarlingViewManager;

		/*============================================================================*/
		/* Public Functions                                                           */
		/*============================================================================*/

		public function extend(context:IContext):void
		{
			_context = context;

			// Just one Container Registry
			_containerRegistry ||= new StarlingContainerRegistry();
			_context.injector.map(StarlingContainerRegistry).toValue(_containerRegistry);

			// But you get your own View Manager
			_context.injector.map(IStarlingViewManager).toSingleton(StarlingViewManager);

			_context.addStateHandler(ManagedObject.SELF_INITIALIZE, handleContextSelfInitialize);
			_context.addStateHandler(ManagedObject.SELF_DESTROY, handleContextSelfDestroy);
		}

		/*============================================================================*/
		/* Private Functions                                                          */
		/*============================================================================*/

		private function handleContextSelfInitialize():void
		{
			_viewManager = _context.injector.getInstance(IStarlingViewManager);
		}

		private function handleContextSelfDestroy():void
		{
			_viewManager.removeAllHandlers();
			_context.injector.unmap(IStarlingViewManager);
			_context.injector.unmap(StarlingContainerRegistry);
		}
	}
}
