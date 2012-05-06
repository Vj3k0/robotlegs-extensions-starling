//------------------------------------------------------------------------------
//  Copyright (c) 2011 the original author or authors. All Rights Reserved. 
// 
//  NOTICE: You are permitted to use, modify, and distribute this file 
//  in accordance with the terms of the license agreement accompanying it. 
//------------------------------------------------------------------------------

package robotlegs.bender.extensions.mediatorMap.api
{
	import robotlegs.bender.extensions.matching.ITypeMatcher;
	import robotlegs.bender.extensions.mediatorMap.dsl.IMediatorMapper;
	import robotlegs.bender.extensions.mediatorMap.dsl.IMediatorUnmapper;

	public interface IStarlingMediatorMap
	{
		function mapMatcher(matcher:ITypeMatcher):IMediatorMapper;
		
		function map(type:Class):IMediatorMapper;
		
		function unmapMatcher(matcher:ITypeMatcher):IMediatorUnmapper;
		
		function unmap(type:Class):IMediatorUnmapper;
		
		function mediate(item:Object):void;
		
		function unmediate(item:Object):void;
	}
}
