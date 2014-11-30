package tutorial.picking
{
	import away3d.bounds.BoundingSphere;
	import away3d.core.pick.PickingColliderType;
	import away3d.entities.Mesh;
	import away3d.events.MouseEvent3D;
	import away3d.materials.ColorMaterial;
	import away3d.primitives.CubeGeometry;
	import away3d.primitives.SphereGeometry;
	
	import flash.events.KeyboardEvent;
	import flash.geom.Vector3D;
	import flash.text.TextField;
	
	public class PickingTutorialListing03 extends PickingTutorialListingBase
	{
		public function PickingTutorialListing03() {
			super();
		}
		
		private var _inactiveMaterial:ColorMaterial;
		private var _activeMaterial:ColorMaterial;
		private var _msg:TextField;
		private var _usingBoundsCollider:Boolean = false;
		private var _sphere:Mesh;
		
		override protected function onSetup():void {
			
			_cameraController.panAngle = 46;
			_cameraController.tiltAngle = 10;
			
			// Init materials.
			_activeMaterial = new ColorMaterial( 0xFF0000 );
			_activeMaterial.lightPicker = _lightPicker;
			_inactiveMaterial = new ColorMaterial( 0xCCCCCC );
			_inactiveMaterial.lightPicker = _lightPicker;
			
			// Create 2 objects.
			var cube:Mesh = new Mesh( new CubeGeometry(), _inactiveMaterial );
			cube.x = -75;
			_view.scene.addChild( cube );
			_sphere = new Mesh( new SphereGeometry(), _inactiveMaterial );
			_sphere.x = 75;
			_view.scene.addChild( _sphere );
			
			// Enable mouse interactivity.
			cube.mouseEnabled = true;
			_sphere.mouseEnabled = true;
			_sphere.showBounds = true;
			
			// Msg.
			_msg = new TextField();
			_msg.textColor = 0xFFFFFF;
			_msg.selectable = false;
			_msg.mouseEnabled = false;
			_msg.width = 540;
			_msg.height = 100;
			addChild( _msg );
			
			// Choose picking precision ( either solution works ).
			_sphere.pickingCollider = PickingColliderType.AS3_FIRST_ENCOUNTERED;
						_sphere.bounds = new BoundingSphere();
						BoundingSphere( _sphere.bounds ).fromSphere( new Vector3D(), 50 ); // Make sure radius is not calculated from a cube volume.
			updateMsg( "AS3_FIRST_ENCOUNTERED" );
			
			// Keyboard listeners.
			stage.addEventListener( KeyboardEvent.KEY_UP, onStageKeyUp );
			
			// Attach mouse event listeners.
			cube.addEventListener( MouseEvent3D.MOUSE_OVER, onObjectMouseOver );
			cube.addEventListener( MouseEvent3D.MOUSE_OUT, onObjectMouseOut );
			_sphere.addEventListener( MouseEvent3D.MOUSE_OVER, onObjectMouseOver );
			_sphere.addEventListener( MouseEvent3D.MOUSE_OUT, onObjectMouseOut );
		}
		
		private function onStageKeyUp( event:KeyboardEvent ):void {
			if( _usingBoundsCollider ) {
				_sphere.pickingCollider = PickingColliderType.AS3_FIRST_ENCOUNTERED;
				updateMsg( "AS3_FIRST_ENCOUNTERED" );
			}
			else {
				_sphere.pickingCollider = PickingColliderType.BOUNDS_ONLY;
				updateMsg( "BOUNDS_ONLY" );
			}
			_usingBoundsCollider = !_usingBoundsCollider;
		}
		
		private function updateMsg( type:String ):void {
			_msg.text = "PickingColliderType: " + type + "\n";
			_msg.text += "Press SPACE to change type ( click to gain focus ).";
		}
		
		private function onObjectMouseOver( event:MouseEvent3D ):void {
			event.target.material = _activeMaterial;
		}
		
		private function onObjectMouseOut( event:MouseEvent3D ):void {
			event.target.material = _inactiveMaterial;
		}
	}
}