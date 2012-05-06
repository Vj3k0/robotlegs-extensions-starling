//------------------------------------------------------------------------------
//  Copyright (c) 2011 the original author or authors. All Rights Reserved. 
// 
//  NOTICE: You are permitted to use, modify, and distribute this file 
//  in accordance with the terms of the license agreement accompanying it. 
//------------------------------------------------------------------------------

package robotlegs.bender.extensions.modularity
{
	import org.swiftsuspenders.Injector;
	
	import robotlegs.bender.extensions.modularity.events.StarlingModularContextEvent;
	import robotlegs.bender.framework.api.IContext;
	import robotlegs.bender.framework.api.IContextExtension;
	import robotlegs.bender.framework.api.ILogger;
	import robotlegs.bender.framework.impl.UID;
	
	import starling.display.DisplayObjectContainer;

	/**
	 * <p>This extension allows a context to inherit dependencies from a parent context,
	 * and to expose its dependences to child contexts.</p>
	 *
	 * <p>It should be installed before context initialization.</p>
	 */
	public class StarlingModularityExtension implements IContextExtension
	{

		/*============================================================================*/
		/* Private Properties                                                         */
		/*============================================================================*/

		private const _uid:String = UID.create(StarlingModularityExtension);

		private var _context:IContext;

		private var _injector:Injector;

		private var _logger:ILogger;

		private var _inherit:Boolean;

		private var _export:Boolean;

		private var _contextView:DisplayObjectContainer;

		/*============================================================================*/
		/* Constructor                                                                */
		/*============================================================================*/

		/**
		 * Modularity
		 *
		 * @param inherit Should this context inherit dependencies?
		 * @param export Should this context expose its dependencies?
		 */
		public function StarlingModularityExtension(inherit:Boolean = true, export:Boolean = true)
		{
			_inherit = inherit;
			_export = export;
		}

		/*============================================================================*/
		/* Public Functions                                                           */
		/*============================================================================*/

		public function extend(context:IContext):void
		{
			_context = context;
			_injector = context.injector;
			_logger = context.getLogger(this);
			_context.lifecycle.beforeInitializing(handleContextPreInitialize);
			_context.lifecycle.beforeDestroying(handleContextPreDestroy);
		}

		public function toString():String
		{
			return _uid;
		}

		/*============================================================================*/
		/* Private Functions                                                          */
		/*============================================================================*/

		private function handleContextPreInitialize():void
		{
			if (!_injector.satisfiesDirectly(DisplayObjectContainer))
				throw new Error("This extension requires a DisplayObjectContainer to mapped.");

			_contextView = _injector.getInstance(DisplayObjectContainer);
			_inherit && broadcastExistence();
			_export && addExistenceListener();
		}

		private function handleContextPreDestroy():void
		{
			_logger.debug("Removing modular context existence event listener...");
			_export && _contextView.removeEventListener(StarlingModularContextEvent.CONTEXT_ADD, onContextAdd);
		}

		private function broadcastExistence():void
		{
			_logger.debug("Modular context configured to inherit. Broadcasting existence event...");
			_contextView.dispatchEvent(new StarlingModularContextEvent(StarlingModularContextEvent.CONTEXT_ADD, _context));
		}

		private function addExistenceListener():void
		{
			_logger.debug("Modular context configured to export. Listening for existence events...");
			_contextView.addEventListener(StarlingModularContextEvent.CONTEXT_ADD, onContextAdd);
		}

		private function onContextAdd(event:StarlingModularContextEvent):void
		{
			_logger.debug("Modular context existence message caught. Configuring child module...");
			event.stopImmediatePropagation();
			event.context.injector.parentInjector = _context.injector;
		}
	}
}
