package view.scene.station.repair
{
	import flash.display.DisplayObjectContainer;
	import flash.display.MovieClip;
	
	import parameters.station.RepairItemListParameter;
	
	import utils.language.LanguageManager;
	import utils.liteui.component.CaptionButton;
	import utils.liteui.component.ImageContainer;
	import utils.liteui.component.Label;
	import utils.liteui.core.Component;
	import utils.resource.ResourcePool;
	
	public class RepairListItemComponent extends Component
	{
		private var _avatar: ImageContainer;
		private var _lblShipName: Label;
		private var _sheildIcon: MovieClip;
		private var _armorIcon: MovieClip;
		private var _constructIcon: MovieClip;
		private var _lblSheild: Label;
		private var _lblArmor: Label;
		private var _lblConstruction: Label;
		private var _lblCost: Label;
		private var _lblComplete: Label;
		private var _btnRepair: CaptionButton;
		private var _info: RepairItemListParameter;
		
		public function RepairListItemComponent()
		{
			super(ResourcePool.getResource("assets.scene1Station.repair.ListItem") as DisplayObjectContainer);
			
			_avatar = getUI(ImageContainer, "avatar") as ImageContainer;
			_lblShipName = getUI(Label, "shipName") as Label;
			_sheildIcon = getSkin("sheildIcon") as MovieClip;
			_armorIcon = getSkin("armorIcon") as MovieClip;
			_constructIcon = getSkin("constructIcon") as MovieClip;
			_lblSheild = getUI(Label, "sheild") as Label;
			_lblArmor = getUI(Label, "armor") as Label;
			_lblConstruction = getUI(Label, "construction") as Label;
			_lblCost = getUI(Label, "cost") as Label;
			_lblComplete = getUI(Label, "complete") as Label;
			_btnRepair = getUI(CaptionButton, "btnRepair") as CaptionButton;
			
			sortChildIndex();
			
			_lblComplete.visible = false;
		}

		public function get info():RepairItemListParameter
		{
			return _info;
		}

		public function set info(value:RepairItemListParameter):void
		{
			if(value != null)
			{
				_info = value;
				
				_avatar.source = value.avatar;
				_lblSheild.text = value.currentSheild.toString() + " / " + value.maxSheild.toString() + " (" + Math.floor((value.currentSheild / value.maxSheild * 100)) + "%)";
				_lblArmor.text = value.currentArmor.toString() + " / " + value.maxArmor.toString() + " (" + Math.floor((value.currentArmor / value.maxArmor * 100)) + "%)";
				_lblConstruction.text = value.currentConstruct.toString() + " / " + value.maxConstruct.toString() + " (" + Math.floor((value.currentConstruct / value.maxConstruct * 100)) + "%)";
				if(value.cost > 0)
				{
					_lblCost.text = value.cost.toString() + " ISK";
					_lblComplete.visible = false;
					_btnRepair.visible = true;
				}
				else
				{
					_lblCost.text = LanguageManager.getInstance().lang("repair_cost_free");
					_lblComplete.visible = true;
					_btnRepair.visible = false;
				}
			}
		}
	}
}