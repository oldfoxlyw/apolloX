package controller.space
{
	import enum.EnumEquipmentType;
	import enum.EnumShipDirection;
	
	import mediator.space.SpaceMainShipMediator;
	
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.command.SimpleCommand;
	
	import parameters.ship.EquipmentParameter;
	import parameters.ship.ShipParameter;
	import parameters.space.LeaveIntoSpaceParameter;
	
	public class CreateMainShipCommand extends SimpleCommand
	{
		public static const CREATE_MAIN_SHIP_NOTE: String = "CreateMainShipNote";
		
		public function CreateMainShipCommand()
		{
			super();
		}
		
		override public function execute(notification:INotification):void
		{
			if(!facade.hasMediator(SpaceMainShipMediator.NAME))
			{
				facade.registerMediator(new SpaceMainShipMediator());
			}
			
			var parameter: ShipParameter = new ShipParameter();
			parameter.id = 123435;
			parameter.speed = 6;
			parameter.x = 1100;
			parameter.y = 1900;
			parameter.direction = EnumShipDirection.RADIANS_100;
			parameter.shipResource = 15;
			
			var equipment: EquipmentParameter = new EquipmentParameter();
			equipment.resourceId = 1;
			equipment.equipmentType = EnumEquipmentType.ROCKET;
			
			parameter.equipments[1] = equipment;
			
			facade.sendNotification(SpaceMainShipMediator.SHOW_NOTE, parameter);
		}
	}
}