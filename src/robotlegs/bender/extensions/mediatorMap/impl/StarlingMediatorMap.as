//------------------------------------------------------------------------------
//  Copyright (c) 2011 the original author or authors. All Rights Reserved. 
// 
//  NOTICE: You are permitted to use, modify, and distribute this file 
//  in accordance with the terms of the license agreement accompanying it. 
//------------------------------------------------------------------------------

package robotlegs.bender.extensions.mediatorMap.impl
{
	import flash.utils.Dictionary;
	
	import robotlegs.bender.extensions.matching.ITypeMatcher;
	import robotlegs.bender.extensions.matching.TypeMatcher;
	import robotlegs.bender.extensions.mediatorMap.api.IMediatorFactory;
	import robotlegs.bender.extensions.mediatorMap.api.IStarlingMediatorMap;
	import robotlegs.bender.extensions.mediatorMap.api.IStarlingMediatorViewHandler;
	import robotlegs.bender.extensions.mediatorMap.dsl.IMediatorMapper;
	import robotlegs.bender.extensions.mediatorMap.dsl.IMediatorUnmapper;
	import robotlegs.bender.extensions.viewManager.api.IStarlingViewHandler;
	
	import starling.display.DisplayObject;
	
	public class StarlingMediatorMap implements IStarlingMediatorMap, IStarlingViewHandler
	{
		/*============================================================================*/
		/* Private Properties                                                         */
		/*============================================================================*/
		
		private const _mappers:Dictionary = new Dictionary();
		
		private var _handler:IStarlingMediatorViewHandler;
		
		private var _factory:IMediatorFactory;
		
		private const NULL_UNMAPPER:IMediatorUnmapper = new NullMediatorUnmapper();
		
		/*============================================================================*/
		/* Constructor                                                                */
		/*============================================================================*/
		
		public function StarlingMediatorMap(factory:IMediatorFactory, handler:IStarlingMediatorViewHandler = null)
		{
			_factory = factory;
			_handler = handler || new StarlingMediatorViewHandler(_factory);
		}
		
		/*============================================================================*/
		/* Public Functions                                                           */
		/*============================================================================*/
		
		public function mapMatcher(matcher:ITypeMatcher):IMediatorMapper
		{
			return _mappers[matcher.createTypeFilter().descriptor] ||= createMapper(matcher);
		}
		
		public function map(type:Class):IMediatorMapper
		{
			const matcher:ITypeMatcher = new TypeMatcher().allOf(type);
			return mapMatcher(matcher);
		}
		
		public function unmapMatcher(matcher:ITypeMatcher):IMediatorUnmapper
		{
			return _mappers[matcher.createTypeFilter().descriptor] || NULL_UNMAPPER;
		}
		
		public function unmap(type:Class):IMediatorUnmapper
		{
			const matcher:ITypeMatcher = new TypeMatcher().allOf(type);
			return unmapMatcher(matcher);
		}
		
		public function handleView(view:DisplayObject, type:Class):void
		{
			_handler.handleView(view, type);
		}
		
		public function mediate(item:Object):void
		{
			const type:Class = item.constructor;
			_handler.handleItem(item, type);
		}
		
		public function unmediate(item:Object):void
		{
			_factory.removeMediators(item);
		}
		
		/*============================================================================*/
		/* Private Functions                                                          */
		/*============================================================================*/
		
		private function createMapper(matcher:ITypeMatcher, viewType:Class = null):IMediatorMapper
		{
			return new StarlingMediatorMapper(matcher.createTypeFilter(), _handler);
		}
	}
}