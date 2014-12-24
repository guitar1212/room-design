package com.infy.util
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.utils.Dictionary;
	import flash.utils.getTimer;
	
	/**
	 * 处理各种定时器相关需求的类<br>
	 * 不推荐直接使用flash.util包中的定时方法或定时类，频繁使用的情况下会有内存泄露<br>
	 * 故有此类产生
	 * @author Magmaster
	 * 修改 by Jerry 2012/1/13 ，新增 更改間隔 跟 重設時間
	 */	
	public class TimerManager
	{
		private static var m_instance:TimerManager = null;
		
		private var m_timerDict:Dictionary;
		private var m_spt:Sprite;
		
		private var m_key:int = 0;
		
		static private const LAST_TIME:String = "lastTime";
		static private const INTERVAL:String = "interval";
		
		static public const RETURN_INVOKE_TIMES:String = "invoke";
		static public const RETURN_DELTA_TIME:String = "deltatime";
		
		static public const ACTIVED:String = "actived";
		/**
		 * singleton实例 
		 * @return 
		 * 
		 */		
		public static function get instance():TimerManager
		{
			if(m_instance == null)
				m_instance = new TimerManager();
				
			return m_instance;
		}
		
		
		/**
		 * 构造函数 
		 * 
		 */		
		public function TimerManager()
		{
			this.m_timerDict = new Dictionary();
			
			this.m_spt = new Sprite();
			this.m_spt.addEventListener(Event.ENTER_FRAME, this.onEnterFrame);
		}
		
		
		/**
		 * 主心跳，所有的调度在这个方法里面进行<br>
		 * <font color='red'>使用者无需关心此方法，也不要主动调用！</font> 
		 * @param event
		 * 
		 */		
		public function onEnterFrame(event:Event):void
		{
			var data:Dictionary;
			for each(data in this.m_timerDict)
			{
				if(data[ACTIVED] == false) continue;
				
				var invokeTimes:int = data["invoke_times"];
				var count:int = data["count"];
				if( count >= 0 && invokeTimes >= count  )
				{
					this.remove(data["key"]);
					continue;
				}
				
				var lastTime:int = data[LAST_TIME];
				var interval:int = data[INTERVAL];
				var realInterval:Number = getTimer()-lastTime;
				if( realInterval < interval ) 
				{
					continue
				}
				
				data["invoke_times"] = invokeTimes+1;
				data[LAST_TIME] = lastTime + realInterval;
				var f:Function = data["callback"];
				
				var param:Array = data["param"];
				
				if(param.length == 0)
					f();
				else if(param[0] == RETURN_INVOKE_TIMES)
					f(data["invoke_times"]);
				else if(param[0] == RETURN_DELTA_TIME)
					f(interval);
				else
					f.apply (null, param);
				
			}
		}
		
		/**
		 * 注册外部回调函数，按照指定的间隔和次数进行调用<br>
		 * 但是精度受到 frame rate 和 所有已注册列表中函数的处理时长影响（单线程程序的通病） <br>
		 * 实际上设置小于一帧所需时间的调用间隔是没有意义的，因为实际的调用的间隔必然是上一帧实际的处理时间
		 * @param callback		需要被定时回调的外部函数
		 * @param interval		回调间隔，单位：ms, 只能保证外部函数实际被调用间隔的 <font color='red'>平均值尽量逼近</font> 此参数的设定
		 * @param count			回调次数，默认为1，如果想一直触发回调，请把此参数设置为负数，比如－1
		 * @param param			客户环境变量，回调函数被调用时会传回此参数
		 * @return 				callback标识，大于等于0的int类型，在remove时传入用于删除永久性的callback，-1表明注册出错
		 */		
		public function register(
			callback:Function,
			interval:int,
			count:int = 1,
			...cbkfuncArgs):int
		{
			if(callback == null)
			{	
				return -1;
			}
			
			var data:Dictionary = new Dictionary();
			data["callback"] = callback;
			data[INTERVAL] = interval;
			data["count"] = count;
			data["param"] = cbkfuncArgs;
			
			data["key"] = this.m_key;
			
			var curTime:int = getTimer();
			data["start_time"] = curTime;
			data[LAST_TIME] = curTime;
			data["invoke_times"] = 0;
			data[ACTIVED] = true;
			
			this.m_timerDict[this.m_key] = data;
			this.m_key++;
			
			return this.m_key-1;
		}

		/**
		 * 删除已经注册的定时函数 
		 * @param key		在register时返回的唯一标识
		 * 
		 */		
		public function remove(key:int):void
		{
			if(this.m_timerDict[key] == null) return;
			
			var data:Dictionary = this.m_timerDict[key];
			delete this.m_timerDict[key];
			delete data["callback"];
		}
		
		/**
		 * 重新記時
		 * 
		 */
		public function resetTime(key:int):void
		{
			var data:Dictionary = this.m_timerDict[key];
			if( data == null) return;
			
			data[LAST_TIME] = getTimer();
		}
		
		/**
		 * 重設觸發間隔
		 * 
		 */
		public function setInterval(key:int, interval:int ,resetTime:Boolean ):void
		{
			var data:Dictionary = this.m_timerDict[key];
			if( data == null) return;
			
			data[INTERVAL] = interval;
			if(resetTime)
				data[LAST_TIME] = getTimer();
		}
		
		/**
		 *	停止Iimer運作 
		 * @param key
		 * 
		 */		
		public function stop(key:int):void
		{
			var data:Dictionary = this.m_timerDict[key];
			if( data == null) return;
			
			data[ACTIVED] = false;
		}
		
		/**
		 *	重新開啟Iimer 
		 * @param key
		 * 
		 */		
		public function start(key:int):void
		{
			var data:Dictionary = this.m_timerDict[key];
			if( data == null) return;
			
			data[ACTIVED] = true;
			data[LAST_TIME] = getTimer();
		}
		
		/**
		 * 释放资源，清除帧监听 
		 * 
		 */		
		public function release():void
		{
			this.m_spt.removeEventListener(Event.ENTER_FRAME, this.onEnterFrame);
			
			for each(var data:Dictionary in this.m_timerDict)
			{
				delete this.m_timerDict[data["key"]];
				delete data["callback"];
			}
			
			this.m_spt = null;
			this.m_timerDict = null;
			m_instance = null;
		}
	}
}