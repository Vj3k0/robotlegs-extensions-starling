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
	
	import robotlegs.bender.extensions.mediatorMap.api.IMediatorFactory;
	import robotlegs.bender.extensions.mediatorMap.api.IMediatorMapping;
	import robotlegs.bender.extensions.mediatorMap.api.IStarlingMediatorViewHandler;
	import robotlegs.bender.extensions.mediatorMap.dsl.IMediatorMapper;
	import robotlegs.bender.extensions.mediatorMap.dsl.IMediatorMappingConfig;
	import robotlegs.bender.extensions.mediatorMap.dsl.IMediatorMappingFinder;
	import robotlegs.bender.extensions.mediatorMap.dsl.IMediatorUnmapper;

	public class StarlingMediatorMapper implements IMediatorMapper, IMediatorMappingFinder, IMediatorUnmapper
	{

		/*============================================================================*/
		/* Private Properties                                                         */
		/*============================================================================*/

		private const _mappings:Dictionary = new Dictionary();

		private var _matcher:Matcher;

		private var _handler:IStarlingMediatorViewHandler;

		private var _manager:IMediatorFactory;

		private var _viewType:Class;

		/*============================================================================*/
		/* Constructor                                                                */
		/*============================================================================*/

		public function StarlingMediatorMapper(matcher:Matcher, handler:IStarlingMediatorViewHandler, manager:IMediatorFactory, viewType:Class = null)
		{
			_matcher = matcher;
			_handler = handler;
			_manager = manager;
			_viewType = viewType;
		}

		/*============================================================================*/
		/* Public Functions                                                           */
		/*============================================================================*/

		public function toMediator(mediatorClass:Class):IMediatorMappingConfig
		{
			return _mappings[mediatorClass] ||= createMapping(mediatorClass);
		}

		public function forMediator(mediatorClass:Class):IMediatorMapping
		{
			return _mappings[mediatorClass];
		}

		public function fromMediator(mediatorClass:Class):void
		{
			const mapping:IMediatorMapping = _mappings[mediatorClass];
			delete _mappings[mediatorClass];
			_handler.removeMapping(mapping);
		}

		public function fromMediators():void
		{
			for each (var mapping:IMediatorMapping in _mappings)
			{
				delete _mappings[mapping.mediatorClass];
				_handler.removeMapping(mapping);
			}
		}

		/*============================================================================*/
		/* Private Functions                                                          */
		/*============================================================================*/

		private function createMapping(mediatorClass:Class):StarlingMediatorMapping
		{
			const mapping:StarlingMediatorMapping = new StarlingMediatorMapping(_matcher, mediatorClass, _manager, _viewType);
			_handler.addMapping(mapping);
			return mapping;
		}
	}
}
