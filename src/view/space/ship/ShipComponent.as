package view.space.ship
{
	import controller.space.effects.CreateRocketEffectsCommand;
	
	import enum.EnumEquipmentType;
	
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	
	import parameters.ship.ShipParameter;
	
	import utils.HotkeyManager;
	import utils.events.LoaderEvent;
	import utils.loader.ResourceLoadManager;
	import utils.loader.XMLLoader;
	import utils.resource.ResourcePool;
	
	import view.render.ShipEngineRender;
	import view.render.ShipStopRender;
	import view.space.MovableComponent;
	
	public class ShipComponent extends MovableComponent
	{
		protected var _info: ShipParameter;
		protected var _effectLayer: Sprite;
		protected var _configXML: XML;
		
		public function ShipComponent(parameter:ShipParameter=null)
		{
			super();
			if(parameter != null)
			{
				_info = parameter;
				_direction = parameter.direction;
				_posX = parameter.x;
				_posY = parameter.y;
				_lastPosX = parameter.x;
				_lastPosY = parameter.y;
			}
			
			registerEquipments();
			loadResourceConfig();
		}
		
		public function get info():ShipParameter
		{
			return _info;
		}
		
		public function set info(value:ShipParameter):void
		{
			_info = value;
		}
		
		protected function registerEquipments(): void
		{
			if(!ApplicationFacade.getInstance().hasCommand(CreateRocketEffectsCommand.INIT_NOTE))
			{
				ApplicationFacade.getInstance().registerCommand(CreateRocketEffectsCommand.INIT_NOTE, CreateRocketEffectsCommand);
			}
			if(!ApplicationFacade.getInstance().hasCommand(CreateRocketEffectsCommand.SHOW_NOTE))
			{
				ApplicationFacade.getInstance().registerCommand(CreateRocketEffectsCommand.SHOW_NOTE, CreateRocketEffectsCommand);
			}
			
			for(var i: int = 0; i<_info.equipments.length; i++)
			{
				if(_info.equipments[i] != null && _info.equipments[i].equipmentType == EnumEquipmentType.ROCKET)
				{
					ApplicationFacade.getInstance().sendNotification(CreateRocketEffectsCommand.INIT_NOTE, _info.equipments[i].resourceId);
					HotkeyManager.instance.registerHotkey(112, CreateRocketEffectsCommand.SHOW_NOTE, CreateRocketEffectsCommand, _info.equipments[i].resourceId);	//F1
				}
			}
		}
		
		protected function loadResourceConfig(): void
		{
			ResourceLoadManager.load("resources/ship/xml/ship" + info.shipResource + ".xml", false, "", onConfigLoaded);
		}
		
		protected function onConfigLoaded(evt: LoaderEvent): void
		{
			var _loader: XMLLoader = evt.loader as XMLLoader;
			_configXML = _loader.configXML;
			
			loadResource();
		}
		
		override protected function loadResource(): void
		{
			ResourceLoadManager.load("ship15_resource", false, "", onResourceLoaded);
		}
		
		protected function onResourceLoaded(evt: LoaderEvent): void
		{
			_graphic = ResourcePool.getResource("space.ship.Ship" + _info.shipResource) as MovieClip;
			_graphic.gotoAndStop(_direction);
			addChild(_graphic);
			
			_effectLayer = new Sprite();
			addChild(_effectLayer);
			
			if(_configXML != null)
			{
				if(_configXML.hasOwnProperty("float") && _configXML.float[0] == "true")
				{
					addRender(new ShipStopRender());
				}
				if(_configXML.hasOwnProperty("engines") && _configXML.engines.hasOwnProperty("engine"))
				{
					addRender(new ShipEngineRender());
				}
			}
		}

		public function get effectLayer():Sprite
		{
			return _effectLayer;
		}

		public function get configXML():XML
		{
			return _configXML;
		}
	}
}