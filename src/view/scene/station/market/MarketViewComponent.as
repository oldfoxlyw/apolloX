package view.scene.station.market
{
	import flash.display.DisplayObjectContainer;
	import flash.events.MouseEvent;
	
	import mediator.scene.station.MarketViewMediator;
	
	import utils.liteui.component.Button;
	import utils.liteui.component.Label;
	import utils.liteui.component.TreeNode;
	import utils.liteui.component.TreeView;
	import utils.liteui.core.Component;
	import utils.resource.ResourcePool;
	
	public class MarketViewComponent extends Component
	{
		private var _btnClose: Button;
		private var _caption: Label;
		
		public function MarketViewComponent()
		{
			super(ResourcePool.getResource("assets.scene1Station.market.view") as DisplayObjectContainer);
			
			_btnClose = getUI(Button, "btnClose") as Button;
			_caption = getUI(Label, "caption") as Label;
			
			sortChildIndex();
			_btnClose.addEventListener(MouseEvent.CLICK, onBtnCloseClick);
		}
		
		private function onBtnCloseClick(evt: MouseEvent): void
		{
			ApplicationFacade.getInstance().sendNotification(MarketViewMediator.MARKET_DISPOSE_NOTE);
		}
		
		public function showComponent(): void
		{
			var tree: TreeView = new TreeView();
			tree.x = 39;
			tree.y = 141;
			tree.width = 306;
			tree.height = 412;
			
			addChild(tree);
			
			var item: TreeNode = new TreeNode();
			item.caption = "测试一下";
			tree.add(item);
			
			item = new TreeNode();
			item.caption = "123";
			tree.add(item);
			
			item = new TreeNode();
			item.caption = "123fgndfgn3";
			tree.add(item);
		}
	}
}