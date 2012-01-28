//------------------------------------------------------------------------------
//  Copyright (c) 2011 the original author or authors. All Rights Reserved.
//
//  NOTICE: You are permitted to use, modify, and distribute this file
//  in accordance with the terms of the license agreement accompanying it.
//------------------------------------------------------------------------------

package robotlegs.bender.extensions.viewManager.impl
{
	import flash.events.Event;
	
	import starling.display.DisplayObject;

	public class StarlingConfigureViewEvent extends Event
	{
		public static const CONFIGURE_VIEW:String = 'configureView';

		private var _view:DisplayObject;

		public function get view():DisplayObject
		{
			return _view;
		}

		public function StarlingConfigureViewEvent(type:String, view:DisplayObject = null)
		{
			super(type, true, true);
			_view = view;
		}

		override public function clone():Event
		{
			return new StarlingConfigureViewEvent(type, _view);
		}
	}
}
