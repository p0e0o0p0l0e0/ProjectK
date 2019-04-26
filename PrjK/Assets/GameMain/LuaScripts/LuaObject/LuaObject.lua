-- 作者：黄伟
-- 时间：2018/01/05
-- 描述：Lua Object类
-- ======================================

LuaObject = class("LuaObject")

-- 构造函数
-- ======================================
function LuaObject:Ctor()
	-- 注册Update
	self.m_IsRegisterUpdate = false

	-- 注册LateUpdate
	self.m_IsRegisterLateUpdate = false

	-- 事件订阅表
	self.m_SubscribeEvents = {}

	-- 获取引用缓存
	self.m_ReferenceCache = {}
end

-- 停止逻辑
-- ======================================
function LuaObject:StopLogic()
	self:UnregisterUpdate()
	self:UnregisterLateUpdate()
	self:UnsubscribeAllEvent()
	self:ReleaseAllReference()
end

-- 销毁
-- ======================================
function LuaObject:OnDestroy()
	self:StopLogic()

	self.m_ReferenceCache = nil
	self.m_SubscribeEvents = nil
end

-- 注册Update
-- ======================================
function LuaObject:RegisterUpdate( interval )
	if self.m_IsRegisterUpdate then
		return
	end
	self.m_IsRegisterUpdate = true
	self.updateInterval = interval or 0
	self.updateTime = 0
	self.deltaTime = 0
	LuaEntry.RegisterUpdate(self)
end

-- 反注册Update
-- ======================================
function LuaObject:UnregisterUpdate()
	if self.m_IsRegisterUpdate then
		LuaEntry.UnregisterUpdate(self)
		self.m_IsRegisterUpdate = false
	end
end

-- 注册LateUpdate
-- ======================================
function LuaObject:RegisterLateUpdate()
	if self.m_IsRegisterLateUpdate then
		return
	end
	LuaEntry.RegisterLateUpdate(self)
	self.m_IsRegisterLateUpdate = true
end

-- 反注册LateUpdate
-- ======================================
function LuaObject:UnregisterLateUpdate()
	if self.m_IsRegisterLateUpdate then
		LuaEntry.UnregisterLateUpdate(self)
		self.m_IsRegisterLateUpdate = false
	end
end

-- 订阅事件
-- param : id		事件id
-- param : handler	回调函数
-- ======================================
function LuaObject:SubscribeEvent( id, handler )
	if self.m_SubscribeEvents[id] then
		Log.Warning("Event {0}({1}) already subscribed in {2}.", GameEntry.Event:GetEventType(id).FullName, id, self.__cname)
		return
	end

	if handler == nil then
		Log.Warning("Event handler for {0}({1}) is null in {2}.", GameEntry.Event:GetEventType(id).FullName, id, self.__cname)
		return
	end

	self.m_SubscribeEvents[id] = handler
	GameEntry.Event:Subscribe(id, handler)
end

-- 退订事件
-- param : id		事件id
-- ======================================
function LuaObject:UnsubscribeEvent( id )
	if self.m_SubscribeEvents[id] == nil then
		Log.Warning("Event id {0}, name {1} not subscribed in {2}.", id, PS.EventUtility.GetEventName(id), self.__cname)
		return
	end
	if GameEntry.Event ~= nil and GameEntry.Event:Check(id, self.m_SubscribeEvents[id]) then
		GameEntry.Event:Unsubscribe(id, self.m_SubscribeEvents[id])
	end
	self.m_SubscribeEvents[id] = nil
end

-- 退订所有事件
-- ======================================
function LuaObject:UnsubscribeAllEvent()
	for id, handler in pairs(self.m_SubscribeEvents) do
		if GameEntry.Event ~= nil and GameEntry.Event:Check(id, handler) then
			GameEntry.Event:Unsubscribe(id, handler)
		end
	end
	self.m_SubscribeEvents = {}
end

-- 从引用池获取引用
-- param : t 			引用类型
-- ======================================
function LuaObject:AcquireReference( t )
	local reference = ReferencePool.Acquire(t)
	self.m_ReferenceCache[reference] = t
	return reference
end

-- 将引用归还引用池
-- param : reference 	引用
-- ======================================
function LuaObject:ReleaseReference( reference )
	if self.m_ReferenceCache[reference] == nil then
		Log.Warning("Reference {0} not found in {1}", reference.GetType(), self.__cname)
	end

	ReferencePool.Release(self.m_ReferenceCache[reference], reference)
	self.m_ReferenceCache[reference] = nil
end

-- 归还所有引用
-- ======================================
function LuaObject:ReleaseAllReference()
	for reference, t in pairs(self.m_ReferenceCache) do
		ReferencePool.Release(self.m_ReferenceCache[reference], reference)
	end
	self.m_ReferenceCache = {}
end

-- 创建一个通用事件
-- ======================================
function LuaObject:AcquireCommonEvent( type, data )
	local ref = ReferencePool.Acquire(typeof(PS.CommonEventArgs))
	ref:Fill(type, data)
	return ref
end

-- 打开通用弹窗
-- ======================================
function LuaObject:OpenDialog(fromType, mode, msg, onConfirm, onCancel, onOther, title )
	local dialogParams = ReferencePool.Acquire(typeof(PS.DialogParams))
	dialogParams.Mode = mode
	dialogParams.Title = title
	dialogParams.Message = msg
	dialogParams.OnClickOther = onOther
	dialogParams.OnClickCancel = onCancel
	dialogParams.OnClickConfirm = onConfirm
	return LuaEntry.Notification:OpenDialog(fromType, dialogParams)
end
