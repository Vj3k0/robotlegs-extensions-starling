package robotlegs.bender.bundles.starling
{
	
	import robotlegs.bender.bundles.shared.config.StarlingContextViewListenerConfig;
	import robotlegs.bender.extensions.commandMap.CommandMapExtension;
	import robotlegs.bender.extensions.contextView.StarlingContextViewExtension;
	import robotlegs.bender.extensions.eventCommandMap.EventCommandMapExtension;
	import robotlegs.bender.extensions.eventDispatcher.EventDispatcherExtension;
	import robotlegs.bender.extensions.localEventMap.LocalEventMapExtension;
	import robotlegs.bender.extensions.logging.TraceLoggingExtension;
	import robotlegs.bender.extensions.mediatorMap.StarlingMediatorMapExtension;
	import robotlegs.bender.extensions.modularity.StarlingModularityExtension;
	import robotlegs.bender.extensions.stageSync.StarlingStageSyncExtension;
	import robotlegs.bender.extensions.viewManager.ManualStageObserverExtension;
	import robotlegs.bender.extensions.viewManager.StarlingStageObserverExtension;
	import robotlegs.bender.extensions.viewManager.StarlingViewManagerExtension;
	import robotlegs.bender.framework.context.api.IContext;
	import robotlegs.bender.framework.context.api.IContextConfig;
	
	public class StarlingBundle implements IContextConfig
	{
		public function configureContext(context:IContext):void
		{
			context.require(
				TraceLoggingExtension,
				StarlingContextViewExtension,
				EventDispatcherExtension,
				StarlingModularityExtension,
				StarlingStageSyncExtension,
				CommandMapExtension,
				EventCommandMapExtension,
				LocalEventMapExtension,
				StarlingViewManagerExtension,
				StarlingStageObserverExtension,
				ManualStageObserverExtension,
				StarlingMediatorMapExtension,
				StarlingContextViewListenerConfig);
		}
	}
}