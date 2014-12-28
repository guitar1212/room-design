package tutorial.picking
{

	import flash.events.KeyboardEvent;
	import flash.geom.Matrix3D;
	import flash.geom.Vector3D;
	import flash.text.TextField;
	
	import away3d.containers.ObjectContainer3D;
	import away3d.core.base.CompactSubGeometry;
	import away3d.core.base.Geometry;
	import away3d.core.pick.PickingColliderType;
	import away3d.core.pick.PickingType;
	import away3d.entities.Mesh;
	import away3d.entities.SegmentSet;
	import away3d.events.MouseEvent3D;
	import away3d.materials.ColorMaterial;
	import away3d.primitives.ConeGeometry;
	import away3d.primitives.CubeGeometry;
	import away3d.primitives.LineSegment;
	import away3d.primitives.SphereGeometry;

	public class PickingTutorialListing05 extends PickingTutorialListingBase
	{
		public function PickingTutorialListing05() {
		 	super();
		}

		private var _msg:TextField;
		private var _usingBestHit:Boolean = true;
		private var _locationTracer:Mesh;
		private var _normalTracer:SegmentSet;
		private var _locationHint:ObjectContainer3D;

		override protected function onSetup():void {

			_cameraController.panAngle = 158;
			_cameraController.tiltAngle = 6;

			// To trace picking positions.
			_locationTracer = new Mesh( new SphereGeometry( 5 ), new ColorMaterial( 0x00FF00 ) );
			_locationTracer.mouseEnabled = _locationTracer.mouseChildren = false;
			_locationTracer.visible = false;
			_view.scene.addChild( _locationTracer );

			// To trace picking normals.
			_normalTracer = new SegmentSet();
			_normalTracer.mouseEnabled = _normalTracer.mouseChildren = false;
			var lineSegment:LineSegment = new LineSegment( new Vector3D(), new Vector3D(), 0xFFFFFF, 0xFFFFFF, 3 );
			_normalTracer.addSegment( lineSegment );
			_normalTracer.visible = false;
			_view.scene.addChild( _normalTracer );

			// To help locating the hit.
			_locationHint = new ObjectContainer3D();
			var locationHintMesh:Mesh = new Mesh( new ConeGeometry( 15, 100 ), new ColorMaterial( 0xFFFF00 ) );
			locationHintMesh.mouseEnabled = locationHintMesh.mouseChildren = false;
			locationHintMesh.name = "location hint";
			locationHintMesh.rotationX += 90;
			_locationHint.visible = false;
			_locationHint.addChild( locationHintMesh );
			_view.scene.addChild( _locationHint );

			createObjects();

			// Msg.
			_msg = new TextField();
			_msg.textColor = 0xFFFFFF;
			_msg.selectable = false;
			_msg.mouseEnabled = false;
			_msg.width = 540;
			_msg.height = 100;
			addChild( _msg );

			_view.mousePicker = PickingType.RAYCAST_BEST_HIT;
			updateMsg( "RAYCAST_BEST_HIT" );

			// Keyboard listeners.
			stage.addEventListener( KeyboardEvent.KEY_UP, onStageKeyUp );
		}

		private function onStageKeyUp( event:KeyboardEvent ):void {
			if( !_usingBestHit ) {
				_view.mousePicker = PickingType.RAYCAST_BEST_HIT;
				updateMsg( "RAYCAST_BEST_HIT" );
			}
			else {
				_view.mousePicker = PickingType.RAYCAST_FIRST_ENCOUNTERED;
				updateMsg( "RAYCAST_FIRST_ENCOUNTERED" );
			}
			_usingBestHit = !_usingBestHit;
		}

		private function updateMsg( type:String ):void {
			_msg.text = "PickingType: " + type + "\n";
			_msg.appendText("Press SPACE to change type ( click to gain focus ).");
		}

		private function createObjects():void {

			var i:uint;

			var material:ColorMaterial = new ColorMaterial( 0xCCCCCC );
			material.lightPicker = _lightPicker;
			var cubeGeometry:CubeGeometry = new CubeGeometry();

			// Create a series of non-independent aligned cubes.
			var sharedGeometry:Geometry = new Geometry();
			var cubeSubGeometry:CompactSubGeometry = cubeGeometry.subGeometries[ 0 ].clone() as CompactSubGeometry;
			var sharedMesh:Mesh = new Mesh( sharedGeometry, material );
			sharedMesh.pickingCollider = PickingColliderType.AS3_FIRST_ENCOUNTERED;
			sharedMesh.showBounds = true;
			_view.scene.addChild( sharedMesh );
			var indices:Array = [ 9, 4, 7, 5, 2, 1, 8, 3, 0, 6 ]; // Used to scramble the sub-meshes.
			for( i = 0; i < 10; i++ ) {
				var subGeom:CompactSubGeometry = cubeSubGeometry.clone() as CompactSubGeometry;
				var translateMatrix:Matrix3D = new Matrix3D();
				translateMatrix.appendRotation( rand( -180, 180 ), Vector3D.X_AXIS );
				translateMatrix.appendRotation( rand( -180, 180 ), Vector3D.Y_AXIS );
				translateMatrix.appendRotation( rand( -180, 180 ), Vector3D.Z_AXIS );
				translateMatrix.appendTranslation( rand( -50, 50 ), rand( -50, 50 ), 150 * indices[ i ] );
				subGeom.applyTransformation( translateMatrix );
				sharedGeometry.addSubGeometry( subGeom );
			}
			sharedMesh.mouseEnabled = true;
			sharedMesh.addEventListener( MouseEvent3D.MOUSE_OVER, onObjectMouseOver );
			sharedMesh.addEventListener( MouseEvent3D.MOUSE_OUT, onObjectMouseOut );
			sharedMesh.addEventListener( MouseEvent3D.MOUSE_MOVE, onMeshMouseMove );
		}

		private function onMeshMouseMove( event:MouseEvent3D ):void {
			// Update tracers.
			_locationTracer.position = event.scenePosition;
			_normalTracer.position = _locationTracer.position;
			var normal:Vector3D = event.sceneNormal.clone();
			normal.scaleBy( 25 );
			var lineSegment:LineSegment = _normalTracer.getSegment( 0 ) as LineSegment;
			lineSegment.end = normal.clone();
			normal.scaleBy( 5 );
			_locationHint.position = _locationTracer.position.add( new Vector3D( 0, 100, 0 ) );
			_locationHint.lookAt( _locationTracer.position );
		}

		private function onObjectMouseOver( event:MouseEvent3D ):void {
			_locationTracer.visible = _normalTracer.visible = _locationHint.visible = true;
		}

		private function onObjectMouseOut( event:MouseEvent3D ):void {
			_locationTracer.visible = _normalTracer.visible = _locationHint.visible = false;
		}

		private function rand(min:Number, max:Number):Number
		{
		    return (max - min)*Math.random() + min;
		}
	}
}
