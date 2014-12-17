package src
{
	import flash.filters.*;
	import flash.display.*;
	import flash.utils.getDefinitionByName;
	/**
	 * UI相关辅助功能
	 * @author Player
	 * 
	 */
	public class UIColorMatrixFilter 
	{
		
		static private var m_UIColorMatrixFilter:UIColorMatrixFilter = null;
		
		private var m_grayFilter:ColorMatrixFilter = null;
		
		private var m_highlightFilter:ColorMatrixFilter = null;
		
		private var m_redFilter:ColorMatrixFilter = null;
		
		private var m_redGlowFilters:Array = null;
		private var m_whiteGlowFilters:Array = null;
		
		/**
		 * 唯一实例
		 * @return 
		 * 
		 */
		static public function get instance():UIColorMatrixFilter
		{
			if (m_UIColorMatrixFilter == null)
			{
				m_UIColorMatrixFilter= new UIColorMatrixFilter();
			}
			return m_UIColorMatrixFilter;
			
		}
		
		/**
		 * 构造方法。为了保持singleton特性，构造方法不应该被调用。
		 * @return 
		 * 
		 */
		public function UIColorMatrixFilter() 
		{
			var matrix:Array = new Array();
			matrix = matrix.concat([0.3, 0.59, 0.11, 0, 0]); // red
			matrix = matrix.concat([0.3, 0.59, 0.11, 0, 0]); // green
			matrix = matrix.concat([0.3, 0.59, 0.11, 0, 0]); // blue
			matrix = matrix.concat([0, 0, 0, 1, 0]); // alpha
			m_grayFilter = new ColorMatrixFilter(matrix);
			
			matrix = new Array();
			matrix = matrix.concat([1, 0, 0, 0, 20]); // red
			matrix = matrix.concat([0, 1, 0, 0, 20]); // green
			matrix = matrix.concat([0, 0, 1, 0, 20]); // blue
			matrix = matrix.concat([0, 0, 0, 2, 0]); // alpha
			m_highlightFilter = new ColorMatrixFilter(matrix);
			
			matrix = new Array();
			matrix = matrix.concat([1, 0, 0, 0, 64]); // red
			matrix = matrix.concat([0, 1, 0, 0, 0]); // green
			matrix = matrix.concat([0, 0, 1, 0, 0]); // blue
			matrix = matrix.concat([0, 0, 0, 1, 0]); // alpha
			m_redFilter = new ColorMatrixFilter(matrix);
			
			//紅色光暈
			m_redGlowFilters = new Array();
			m_redGlowFilters[0] = new GlowFilter(0xFF0000,1,10,5,5);	
			//白色光暈
			m_whiteGlowFilters = new Array();
			m_whiteGlowFilters[0] = new GlowFilter(0xFFFFFF,0.7,10,5,5);	
		}
		
		/**
		 * 灰度处理的过滤器
		 * @return 
		 * 
		 */
		public function get grayFilter():ColorMatrixFilter
		{
			return m_grayFilter;
		}
		/**
		 * 高亮处理的过滤器
		 * @return 
		 * 
		 */
		public function get highlightFilter():ColorMatrixFilter
		{
			return m_highlightFilter;
		}
		/**
		 * 红色处理的过滤器
		 * @return 
		 * 
		 */
		public function get redFilter():ColorMatrixFilter
		{
			return m_redFilter;
		}
		
		/**
		 * 表现紅色光晕的过滤器 
		 * @return 
		 * 
		 */
		public function get redGlowFilters():Array
		{
			return m_redGlowFilters;
		}
		/**
		 * 表现白色光晕的过滤器 
		 * @return 
		 * 
		 */
		public function get whiteGlowFilters():Array
		{
			return m_whiteGlowFilters;
		}
		
	}
}