//------------------------------------------------------------------------------
//  Copyright (c) 2011 the original author or authors. All Rights Reserved. 
// 
//  NOTICE: You are permitted to use, modify, and distribute this file 
//  in accordance with the terms of the license agreement accompanying it. 
//------------------------------------------------------------------------------

package robotlegs.extensions.starlingViewMap.impl
{
	import robotlegs.bender.extensions.mediatorMap.api.IMediatorMap;
	import robotlegs.extensions.starlingViewMap.api.IStarlingViewMap;
	
	import starling.core.Starling;
	import starling.display.DisplayObject;
	import starling.display.DisplayObjectContainer;
	import starling.events.Event;

	/**
	 * 
	 * StarlingViewMap Impl
	 * 
	 * @author jamieowen
	 */
	public class StarlingViewMap implements IStarlingViewMap
	{
		/*============================================================================*/
		/* Private Properties                                                         */
		/*============================================================================*
		 * 
		 */
		[Inject]
		public var starling:Starling;
		
		[Inject]
		public var mediatorMap:IMediatorMap;
		
				
		/*============================================================================*/
		/* Private Properties                                                         */
		/*============================================================================*/
		
		
		
		/*============================================================================*/
		/* Constructor
		/*============================================================================*/
		
		public function StarlingViewMap()
		{
			
		}
		
		[PostConstruct]
		public function init():void
		{	
			// listen for display object events
			starling.stage.addEventListener( Event.ADDED, onStarlingAdded );
			starling.stage.addEventListener( Event.REMOVED, onStarlingRemoved );
			
			// adds stage as view to allow a Starling Stage Mediator.
			starling.addEventListener( Event.ROOT_CREATED, onRootCreated );
		}
		
		/*============================================================================*/
		/* Public Methods
		/*============================================================================*/
		
		public function addStarlingView(view : DisplayObject) : void
		{
			mediatorMap.mediate(view);
			
			//modify by jim 2016.2.16
			//由于添加了父级对象，不会触发Event.ADDED事件
			//所以要手动添加子级别的对象
			var container:DisplayObjectContainer = view as DisplayObjectContainer;
			if (container)
			{
				for (var i:Number = 0 ; i < container.numChildren ; i ++)
					addStarlingView(container.getChildAt(i));
			}
		}

		public function removeStarlingView(view : DisplayObject) : void
		{
			mediatorMap.unmediate(view);
			//modify by jim 2016.2.16
			//由于移除了父级对象，不会触发Event.REMOVED事件
			//所以要手动移除子级别的对象
			var container:DisplayObjectContainer = view as DisplayObjectContainer;
			if (container)
			{
				for (var i:Number = 0 ; i < container.numChildren ; i ++)
					removeStarlingView(container.getChildAt(i));
			}
		}
		
		/*============================================================================*/
		/* Private Methods
		/*============================================================================*/
		
		private function onStarlingAdded( event:Event ):void
		{
			addStarlingView( event.target as DisplayObject );
		}
		
		private function onStarlingRemoved( event:Event ):void
		{
			removeStarlingView( event.target as DisplayObject );
		}
		
		private function onRootCreated( event:Event ):void
		{
			starling.removeEventListener( Event.ROOT_CREATED, onRootCreated );
			
			addStarlingView( starling.stage );
		}
	}
}
