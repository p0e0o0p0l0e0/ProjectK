﻿-- 作者：黄伟
-- 时间：2018/3/7
-- 描述：Lua对象池
-- ======================================

LuaObjectPool = class("LuaObjectPool", LuaObject)

function LuaObjectPool:Ctor( type, name )
	LuaObject.Ctor(self)

	self.pool = {}
	self.type = type
	self.name = name
	self.capacity = 0
	self.usedCount = 0
end

function LuaObjectPool:SetCapacity( capacity )
	self.capacity = capacity
end

function LuaObjectPool:GetCapacity()
	return self.capacity
end

function LuaObjectPool:GetUsedCount()
	return self.usedCount
end

function LuaObjectPool:Spawn( ... )
	local obj = self:GetUnusedObj()
	if obj ~= nil then
		obj:Reset(...)
		obj.used = true
		self.usedCount = self.usedCount + 1
		return obj
	end
	if #self.pool >= self.capacity then
		Log.Warning("LuaObjectPool spawn failed! pool is full.")
		return nil
	end
	local obj = self.type.New(...)
	obj.used = true
	table.insert(self.pool, obj)
	self.usedCount = self.usedCount + 1
	return obj
end

function LuaObjectPool:Unspawn( usedObj )
	for _, obj in ipairs(self.pool) do
		if obj == usedObj and obj.used then
			obj:Clear()
			obj.used = false
			self.usedCount = self.usedCount - 1
			break
		end
	end
end

function LuaObjectPool:GetUnusedObj()
	for _, obj in ipairs(self.pool) do
		if obj.used == false then
			return obj
		end
	end
	return nil
end

function LuaObjectPool:IsFull()
	return self.usedCount >= self.capacity
end

function LuaObjectPool:Clear()
	for _, obj in ipairs(self.pool) do
		obj:Destroy()
	end
	self.pool = {}
end
