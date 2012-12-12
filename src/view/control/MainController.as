package view.control
{
	import enum.EnumAction;
	import enum.EnumShipDirection;
	
	import flash.events.MouseEvent;
	import flash.geom.Point;
	
	import mediator.space.SpaceBackgroundMediator;
	
	import utils.GameManager;
	import utils.configuration.GlobalContextConfig;
	
	import view.space.background.SpaceBackgroundComponent;

	public class MainController extends BaseController
	{
		protected var _step: uint;
		protected var _path: Array;
		protected var _controlType: uint = MOUSE;
		protected var _key_w: Boolean;
		protected var _key_a: Boolean;
		protected var _key_s: Boolean;
		protected var _key_d: Boolean;
		protected var _lastAttackTime: int;
		protected var _listenerSetuped: Boolean = false;
		protected var _preSyncTimer: uint;
		protected var _currentKey: int;
		
		public static const MOUSE: uint = 1;
		public static const KEY: uint = 2;
		public static const KEY_AND_MOUSE: uint = 0;
		
		public function MainController()
		{
			super();
			_step = 1;
			_key_w = false;
			_key_a = false;
			_key_s = false;
			_key_d = false;
			_lastAttackTime = 0;
			_preSyncTimer = GlobalContextConfig.Timer;
		}
		
		override public function setupListener():void
		{
			switch(_controlType)
			{
				case MOUSE:
					setupMouseListener();
					break;
				case KEY:
					
					break;
			}
			_listenerSetuped = true;
		}
		
		private function setupMouseListener(): void
		{
			GameManager.container.addEventListener(MouseEvent.CLICK, onMouseClick, false, 0, true);
		}
		
		protected function onMouseClick(evt: MouseEvent): void
		{
			if(!isStatic)
			{
				_target.action = EnumAction.STOP;
				
				var _mediator: SpaceBackgroundMediator = ApplicationFacade.getInstance().retrieveMediator(SpaceBackgroundMediator.NAME) as SpaceBackgroundMediator;
				_endPoint = _mediator.component.getMapPosition(new Point(evt.stageX, evt.stageY));
				
				var node: Array = SpaceBackgroundComponent.AStar.find(_target.posX, _target.posY, _endPoint.x, _endPoint.y);
				if(node == null)
				{
					return;
				}
				else
				{
					_path = new Array();
					for (var i: uint = 0; i < node.length; i++)
					{
						_path.push([node[i].x, node[i].y]);
					}
				}
				_endPoint = SpaceBackgroundComponent.blockToMapPosition(new Point(_path[_path.length - 1][0], _path[_path.length - 1][1]));
				//CCommandCenter.commandMoveTo(_endPoint.x, _endPoint.y);
				_step = 1;
			}
		}
		
		public function moveTo(_x: Number, _y: Number): void
		{
			_target.action = EnumAction.STOP;
			
			var node: Array = SpaceBackgroundComponent.AStar.find(_target.posX, _target.posY, _x, _y);
			if(node == null)
			{
				return;
			}
			else
			{
				_path = new Array();
				for (var i: uint = 0; i < node.length; i++)
				{
					_path.push([node[i].x, node[i].y]);
				}
			}
			_endPoint = SpaceBackgroundComponent.blockToMapPosition(new Point(_path[_path.length - 1][0], _path[_path.length - 1][1]));
			//CCommandCenter.commandMoveTo(_endPoint.x, _endPoint.y);
			_step = 1;
		}
		
		protected function move(nextX: Number, nextY: Number): void
		{
			_target.setPos(nextX, nextY);
			
			if (_target.action != EnumAction.DIE)
			{
				_target.action = EnumAction.MOVE;
			}
		}
		
		override public function calculateAction():void
		{
			switch(_controlType)
			{
				case MOUSE:
					calculateActionMouse();
					break;
				case KEY:
					
					break;
			}
		}
		
		protected function calculateActionMouse(): void
		{
			if(!isStatic && _path != null && _path[_step] != null)
			{
				_nextPoint = _step == _path.length ? _endPoint : SpaceBackgroundComponent.blockToMapPosition(new Point(_path[_step][0], _path[_step][1]));
				
				var degress: Number = EnumShipDirection.getDegress(_nextPoint.x - _target.posX, _nextPoint.y - _target.posY);
				var angle: Number = EnumShipDirection.degressToRadians(degress);
				
				var readyX: Boolean = false;
				var readyY: Boolean = false;
				
				var speedX: Number = _target.info.speed * Math.cos(degress);
				var speedY: Number = _target.info.speed * Math.sin(degress);
				
				if (Math.abs(_target.posX - _nextPoint.x) <= speedX)
				{
					readyX = true;
					speedX = 0;
				}
				if (Math.abs(_target.posY - _nextPoint.y) <= speedY)
				{
					readyY = true;
					speedY = 0;
				}
				
				move(_target.posX + speedX, _target.posY + speedY);
				
				if (readyX && readyY)
				{
					_step++;
					if (_step >= _path.length)
					{
						_target.action = EnumAction.STOP;
						_path = null;
						_step = 1;
						//dispatchEvent(new ControllerEvent(ControllerEvent.MOVE_INTO_POSITION));
						//syncPosition(true);
					}
				}
				else
				{
					changeDirectionByAngle(angle);
				}
			}
		}
		
		protected function get isStatic(): Boolean
		{
			if (_target == null)
			{
				return false;
			}
			if (_target.action == 1)
			{
				return true;
			}
			return false;
		}
		
		override public function clear():void
		{
			_path = null;
			_endPoint = null;
		}
	}
}