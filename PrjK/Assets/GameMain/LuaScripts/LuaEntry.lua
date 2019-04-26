-- 作者：黄伟
-- 时间：2017/11/15
-- 描述：LuaEntry 实例
-- ======================================
-- local breakSocketHandle,debugXpCall = require("LuaDebugjit")("localhost",7003)

LuaEntry = {}

function LuaEntry.OnStart()
	LuaEntry.package = {}
	for key, v in pairs(package.loaded) do
		if key ~= "LuaEntry" then
			LuaEntry.package[key] = true
		end
	end
	LuaEntry.Gobal = {}
	for key, v in pairs(_G) do
		LuaEntry.Gobal[key] = true
	end

	LuaEntry.modules = {}
	LuaEntry.lateUpdateForms = {}

	LuaEntry.updateObjs = {}
    LuaEntry.updateObjs_new = {}

    require "Utility/Functions"
	require "LuaObject/LuaObject"
	require "Module/Module"
	require "Utility/InitUtility"
	require "Hotfix/InitHotfix"
	require "LuaObject/LuaObjectPool"
	require "LuaObject/LuaNGUIForm"
	require "Packet/PacketIdList"

	math.newrandomseed()	-- 初始化随机数种子

	GameEntry.UI:OpenUIFormById(UIFormEnum.ToastForm)
end

function LuaEntry.OnUpdate(deltaTime, unscaledDeltaTime)
	local objs = LuaEntry.updateObjs
	local objsNew = LuaEntry.updateObjs_new
	local numNew = #objsNew
	if numNew > 0 then
		local FindUpdateObj = LuaEntry.FindUpdateObj
		for i = 1, numNew do
			local item = objsNew[i]
			local index = FindUpdateObj(item.obj)
			if item.type == 1 and index == nil then
				table.insert(objs, item.obj)
			elseif item.type == 0 and index ~= nil then
				table.remove(objs, index)
			end
			objsNew[i] = nil
		end
	end

	for i = 1, #objs do
		local obj = objs[i]
		if obj.updateInterval and obj.updateInterval > 0 then
			obj.deltaTime = obj.deltaTime + deltaTime
			obj.updateTime = obj.updateTime + unscaledDeltaTime
			if obj.updateTime >= obj.updateInterval then
				obj:OnUpdate(obj.deltaTime, obj.updateTime)
				obj.updateTime = 0
				obj.deltaTime = 0
			end
		else
			obj:OnUpdate(deltaTime, unscaledDeltaTime)
		end
	end

	if IsEditor then
		LuaEntry.DebugCheckRestart()
	end
end

function LuaEntry.OnLateUpdate(deltaTime, unscaledDeltaTime)
	for key, form in pairs(LuaEntry.lateUpdateForms) do
		form:OnLateUpdate(deltaTime, unscaledDeltaTime)
	end
end

function LuaEntry.OnApplicationPause( pause )
	for name, module in pairs(LuaEntry.modules) do
		module:OnApplicationPause(pause)
	end
	GameEntry.Event:Fire(LuaEntry, ReferencePool.Acquire(typeof(PS.CommonEventArgs)):Fill(CommonEventType.ApplicationPause, pause))
end

function LuaEntry.OnApplicationQuit()
	for name, module in pairs(LuaEntry.modules) do
		module:OnApplicationQuit()
	end
end

function LuaEntry.OnDestroy()
	LuaEntry.Clear()
	LuaEntry.UnrequireAll()
end

function LuaEntry.FindUpdateObj(obj)
	local objs = LuaEntry.updateObjs
	for i = 1, #objs do
		if objs[i] == obj then
			return i
		end
	end
end

function LuaEntry.RegisterUpdate( obj )
	table.insert(LuaEntry.updateObjs_new, {obj=obj, type=1})
end

function LuaEntry.UnregisterUpdate( obj )
	table.insert(LuaEntry.updateObjs_new, {obj=obj, type=0})
end

function LuaEntry.RegisterLateUpdate( form )
	if LuaEntry.lateUpdateForms[form] == nil then
		LuaEntry.lateUpdateForms[form] = form
	end
end

function LuaEntry.UnregisterLateUpdate( form )
	if LuaEntry.lateUpdateForms[form] then
		LuaEntry.lateUpdateForms[form] = nil
	end
end

function LuaEntry.RegisterModule( name, file )
	if LuaEntry[name] ~= nil then
		Log.Warning("module {0} - {1} already exist", name, file)
		return
	end
	local Module = require(file)
	local mod = Module.New()
	LuaEntry[name] = mod
	LuaEntry.modules[name] = mod
	mod:Init()
end

function LuaEntry.UnregisterModule( name )
	if LuaEntry[name] ~= nil then
		LuaEntry[name]:Destroy()
		LuaEntry[name] = nil
		LuaEntry.modules[name] = nil
	end
end

function LuaEntry.UnregisterAllModule()
	for name, module in pairs(LuaEntry.modules) do
		LuaEntry[name] = nil
		module:Destroy()
	end
	LuaEntry.modules = nil
end

function LuaEntry.ReInitModules()
	for i, mod in pairs(LuaEntry.modules) do
		mod:Clear()
	end
end

function LuaEntry.Clear()
	xlua.clear()
	Lang.Clear()
	DataTable.Clear()
	LuaEntry.UnregisterAllModule()
	LuaEntry.updateObjs = nil
	LuaEntry.updateObjs_new = nil
	LuaEntry.lateUpdateForms = nil
	LuaEntry.ClearGobal()
end

function LuaEntry.ClearGobal()
	for key, v in pairs(_G) do
		if not LuaEntry.Gobal[key] then
			_G[key] = nil
		end
	end
end

function LuaEntry.UnrequireAll()
	for key, v in pairs(package.loaded) do
		if not LuaEntry.package[key] then
			package.loaded[key] = nil
		end
	end
end
