//------------------------------------------------------------------------------
//  Copyright (c) 2011 the original author or authors. All Rights Reserved. 
// 
//  NOTICE: You are permitted to use, modify, and distribute this file 
//  in accordance with the terms of the license agreement accompanying it. 
//------------------------------------------------------------------------------

package robotlegs.bender.extensions.mediatorMap.impl
{
	import flash.utils.Dictionary;
	
	import org.hamcrest.Matcher;
	import org.hamcrest.object.instanceOf;
	
	import robotlegs.bender.extensions.mediatorMap.api.IMediatorFactory;
	import robotlegs.bender.extensions.mediatorMap.api.IStarlingMediatorMap;
	import robotlegs.bender.extensions.mediatorMap.api.IStarlingMediatorViewHandler;
	import robotlegs.bender.extensions.mediatorMap.dsl.IMediatorMapper;
	import robotlegs.bender.extensions.mediatorMap.dsl.IMediatorMappingFinder;
	import robotlegs.bender.extensions.mediatorMap.dsl.IMediatorUnmapper;
	
	import starling.display.DisplayObject;

	public class StarlingMediatorMap implements IStarlingMediatorMap
	{

		/*============================================================================*/
		/* Private Properties                                                         */
		/*============================================================================*/

		private const _mappers:Dictionary = new Dictionary();

		private const _handler:IStarlingMediatorViewHandler = new StarlingMediatorViewHandler();

		private var _manager:IMediatorFactory;

		/*============================================================================*/
		/* Constructor                                                                */
		/*============================================================================*/

		public function StarlingMediatorMap(manager:IMediatorFactory)
		{
			_manager = manager;
		}

		/*============================================================================*/
		/* Public Functions                                                           */
		/*============================================================================*/

		public function map(matcher:Matcher):IMediatorMapper
		{
			return _mappers[String(matcher)] ||= createMapper(matcher);
		}

		public function mapView(viewType:Class):IMediatorMapper
		{
			const matcher:Matcher = instanceOf(viewType);
			return _mappers[String(matcher) + '|' + String(viewType)] ||= createMapper(matcher, viewType);
		}

		public function getMapping(matcher:Matcher):IMediatorMappingFinder
		{
			return _mappers[String(matcher)];
		}

		public function getViewMapping(viewType:Class):IMediatorMappingFinder
		{
			const matcher:Matcher = instanceOf(viewType);
			return _mappers[String(matcher) + '|' + String(viewType)];
		}

		public function unmap(matcher:Matcher):IMediatorUnmapper
		{
			return _mappers[String(matcher)];
		}

		public function unmapView(viewType:Class):IMediatorUnmapper
		{
			const matcher:Matcher = instanceOf(viewType);
			return _mappers[String(matcher) + '|' + String(viewType)];
		}

		public function handleView(view:DisplayObject, type:Class):void
		{
			_handler.handleView(view, type);
		}

		/*============================================================================*/
		/* Private Functions                                                          */
		/*============================================================================*/

		private function createMapper(matcher:Matcher, viewType:Class = null):IMediatorMapper
		{
			return new StarlingMediatorMapper(matcher, _handler, _manager, viewType);
		}
	}
}
