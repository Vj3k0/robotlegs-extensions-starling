//------------------------------------------------------------------------------
//  Copyright (c) 2011 the original author or authors. All Rights Reserved. 
// 
//  NOTICE: You are permitted to use, modify, and distribute this file 
//  in accordance with the terms of the license agreement accompanying it. 
//------------------------------------------------------------------------------

package robotlegs.bender.extensions.viewManager.impl
{
	import flash.events.Event;

	public class StarlingContainerBindingEvent extends Event
	{

		/*============================================================================*/
		/* Public Static Properties                                                   */
		/*============================================================================*/

		public static const BINDING_EMPTY:String = 'bindingEmpty';

		/*============================================================================*/
		/* Constructor                                                                */
		/*============================================================================*/

		public function StarlingContainerBindingEvent(type:String)
		{
			super(type);
		}

		/*============================================================================*/
		/* Public Functions                                                           */
		/*============================================================================*/

		override public function clone():Event
		{
			return new StarlingContainerBindingEvent(type);
		}
	}
}
