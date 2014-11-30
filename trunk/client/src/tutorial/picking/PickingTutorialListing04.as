package tutorial.picking
{
	import away3d.animators.SkeletonAnimationSet;
	//import away3d.animators.SkeletonAnimationState;
	import away3d.animators.SkeletonAnimator;
	import away3d.animators.data.Skeleton;
	import away3d.animators.states.SkeletonClipState;
	import away3d.core.pick.PickingColliderType;
	import away3d.core.pick.PickingType;
	import away3d.entities.Mesh;
	import away3d.entities.SegmentSet;
	import away3d.events.AssetEvent;
	import away3d.events.MouseEvent3D;
	import away3d.library.AssetLibrary;
	import away3d.library.assets.AssetType;
	import away3d.loaders.parsers.MD5AnimParser;
	import away3d.loaders.parsers.MD5MeshParser;
	import away3d.materials.ColorMaterial;
	import away3d.materials.TextureMaterial;
	import away3d.primitives.LineSegment;
	import away3d.primitives.SphereGeometry;
	import away3d.textures.BitmapTexture;
	
	import flash.events.KeyboardEvent;
	import flash.geom.Vector3D;
	import flash.text.TextField;
	
	public class PickingTutorialListing04 extends PickingTutorialListingBase
	{
		public function PickingTutorialListing04() {
			super();
		}
		
		// Textures.
		// body diffuse map
		[Embed(source="../embeds/hellknight_diffuse.jpg")]
		private var BodyDiffuse:Class;
		// body normal map
		[Embed(source="../embeds/hellknight_normals.png")]
		private var BodyNormals:Class;
		// body specular map
		[Embed(source="../embeds/hellknight_specular.png")]
		private var BodySpecular:Class;
		
		// Mesh.
		[Embed(source="../embeds/hellknight.md5mesh", mimeType="application/octet-stream")]
		private var HellKnight_Mesh:Class;
		
		// Animations.
		[Embed(source="../embeds/walk7.md5anim", mimeType="application/octet-stream")]
		private var HellKnight_Walk7:Class;
		
		private var _bodyMaterial:TextureMaterial;
		private var _animator:SkeletonAnimator;
		private var _animationSet:SkeletonAnimationSet;
		private var _skeleton:Skeleton;
		private var _mesh:Mesh;
		private var _msg:TextField;
		private var _usingShaderPicking:Boolean = true;
		private var _ghostMesh:Mesh;
		private var _locationTracer:Mesh;
		private var _normalTracer:SegmentSet;
		
		override protected function onSetup():void {
			
			// Msg.
			_msg = new TextField();
			_msg.textColor = 0xFFFFFF;
			_msg.selectable = false;
			_msg.mouseEnabled = false;
			_msg.width = 540;
			_msg.height = 100;
			addChild( _msg );
			
			// Choose global picking method
			_view.mousePicker = PickingType.SHADER;
			//			_view.forceMouseMove = true;
			updateMsg( "SHADER" );
			
			// Init materials.
			_bodyMaterial = new TextureMaterial( new BitmapTexture( new BodyDiffuse().bitmapData ) );
			_bodyMaterial.specularMap = new BitmapTexture( new BodySpecular().bitmapData );
			_bodyMaterial.normalMap = new BitmapTexture( new BodyNormals().bitmapData );
			_bodyMaterial.lightPicker = _lightPicker;
			
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
			
			// Init Objects.
			loadModel();
			
			// Keyboard listeners.
			stage.addEventListener( KeyboardEvent.KEY_UP, onStageKeyUp );
			
		}
		
		private function onStageKeyUp( event:KeyboardEvent ):void {
			if( _usingShaderPicking ) {
				_view.mousePicker = PickingType.RAYCAST_BEST_HIT;
				updateMsg( "RAYCAST" );
			}
			else {
				_view.mousePicker = PickingType.SHADER;
				updateMsg( "SHADER" );
			}
			_usingShaderPicking = !_usingShaderPicking;
			_ghostMesh.visible = !_usingShaderPicking;
		}
		
		private function updateMsg( type:String ):void {
			_msg.text = "PickingType: " + type + "\n";
			_msg.text += "Press SPACE to change type ( click to gain focus ).";
		}
		
		private function loadModel():void {
			AssetLibrary.addEventListener( AssetEvent.ASSET_COMPLETE, onAssetComplete );
			AssetLibrary.loadData( new HellKnight_Mesh(), null, null, new MD5MeshParser() );
		}
		
		private function onAssetComplete( event:AssetEvent ):void {
			if( event.asset.assetType == AssetType.MESH ) {
				// Initialize material.
				_mesh = event.asset as Mesh;
				_mesh.y = -100;
				_mesh.scale( 2 );
				_mesh.material = _bodyMaterial;
				_view.scene.addChild( _mesh );
				// Add a clone to the scene to depict the non animated geometry.
				_ghostMesh = _mesh.clone() as Mesh;
				_ghostMesh.geometry = _mesh.geometry.clone();
				_ghostMesh.material = new ColorMaterial( 0xFFFFFF, 0.2 );
				_ghostMesh.visible = false;
				_view.scene.addChild( _ghostMesh );
				// Set up interactivity.
				_mesh.pickingCollider = PickingColliderType.PB_BEST_HIT;
				//				_mesh.pickingCollider = PickingColliderType.AS3_BEST_HIT;
				// Apply interactivity.
				_mesh.mouseEnabled = _mesh.mouseChildren = _mesh.shaderPickingDetails = true;
				// Set up mouse listeners.
				_mesh.addEventListener( MouseEvent3D.MOUSE_OVER, onMeshMouseOver );
				_mesh.addEventListener( MouseEvent3D.MOUSE_OUT, onMeshMouseOut );
				_mesh.addEventListener( MouseEvent3D.MOUSE_MOVE, onMeshMouseMove );
				
			} else if( event.asset.assetType == AssetType.SKELETON ) {
				_skeleton = event.asset as Skeleton;
			} else if( event.asset.assetType == AssetType.ANIMATION_SET ) {
				_animationSet = event.asset as SkeletonAnimationSet;
				_animator = new SkeletonAnimator( _animationSet, _skeleton );
				_animator.playbackSpeed = 0.1;
				//apply animator to mesh
				_mesh.animator = _animator;
				//initialise animation data
				AssetLibrary.loadData( new HellKnight_Walk7(), null, "walk7", new MD5AnimParser() );
			}
			else if( event.asset.assetType == AssetType.ANIMATION_STATE ) {
				/*var state:SkeletonClipState = event.asset as SkeletonClipState;
				var name:String = event.asset.assetNamespace;
				_animationSet.addState( name, state );
				_animator.play( name );
				_animator.updateRootPosition = false;*/
			}
		}
		
		private function onMeshMouseMove( event:MouseEvent3D ):void {
			// Update tracers.
			_locationTracer.position = event.scenePosition;
			_normalTracer.position = _locationTracer.position;
			var normal:Vector3D = event.sceneNormal.clone();
			normal.scaleBy( 25 );
			var lineSegment:LineSegment = _normalTracer.getSegment( 0 ) as LineSegment;
			lineSegment.end = normal.clone();
		}
		
		private function onMeshMouseOut( event:MouseEvent3D ):void {
			_locationTracer.visible = _normalTracer.visible = false;
		}
		
		private function onMeshMouseOver( event:MouseEvent3D ):void {
			_locationTracer.visible = _normalTracer.visible = true;
		}
	}
}