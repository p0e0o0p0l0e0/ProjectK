-- 作者：黄伟
-- 时间：2018/3/15
-- 描述：模块基类
-- ======================================

Module = class("Module", LuaObject)

function Module:Ctor()
	Module.super.Ctor(self)
end

function Module:OnApplicationPause( pause )

end

function Module:OnApplicationQuit()

end

function Module:Destroy()
	self:StopLogic()
	self._data = nil
end

function Module:Clear()
	self:StopLogic()
	self:Init()
end

-- 初始化数据绑定
-- ======================================
function Module:InitBindData()
	self._data = {}
	self._data.data = {}
	self._data.func = {}
	setmetatable(self._data, {
		__index = function( table, key )
			return table.data[key]
		end,
		__newindex = function( table, key, value )
			table.data[key] = value
			if table.func[key] ~= nil then
				for _, callback in ipairs(table.func[key]) do
					callback(table.data[key])
				end
			end
		end
	})
end

-- 绑定数据
-- @param : key 属性名
-- @param : calllback 回调
-- ======================================
function Module:BindData( key, callback )
	if self._data == nil then
		self:InitBindData()
	end
	self._data.func[key] = self._data.func[key] or {}
	table.insert(self._data.func[key], callback)
end

-- 解绑数据
-- @param : key 属性名
-- @param : calllback 回调
-- ======================================
function Module:UnbindData( key, callback )
	if self._data.func ~= nil and self._data.func[key] ~= nil then
		for i, call in ipairs(self._data.func[key]) do
			if call == callback then
				table.remove(self._data.func[key], i)
				break
			end
		end
	end
end
