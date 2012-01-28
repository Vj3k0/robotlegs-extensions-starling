//------------------------------------------------------------------------------
//  Copyright (c) 2011 the original author or authors. All Rights Reserved. 
// 
//  NOTICE: You are permitted to use, modify, and distribute this file 
//  in accordance with the terms of the license agreement accompanying it. 
//------------------------------------------------------------------------------

package robotlegs.bender.extensions.modularity.events
{
	import robotlegs.bender.framework.context.api.IContext;
	
	import starling.events.Event;

	public class StarlingModularContextEvent extends Event
	{

		/*============================================================================*/
		/* Public Static Properties                                                   */
		/*============================================================================*/

		public static const CONTEXT_ADD:String = "contextAdd";

		public static const CONTEXT_REMOVE:String = "contextRemove";

		/*============================================================================*/
		/* Public Properties                                                          */
		/*============================================================================*/

		private var _context:IContext;

		public function get context():IContext
		{
			return _context;
		}

		/*============================================================================*/
		/* Constructor                                                                */
		/*============================================================================*/

		public function StarlingModularContextEvent(type:String, context:IContext)
		{
			super(type, true);
			_context = context;
		}

		/*============================================================================*/
		/* Public Functions                                                           */
		/*============================================================================*/

		override public function toString():String
		{
			return "[ModularContextEvent(context:" + context + ")]";
		}
	}
}
