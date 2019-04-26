-- 作者：黄伟
-- 时间：2017/11/15
-- 描述：加载Hotfix
-- https://github.com/Tencent/xLua/blob/master/Assets/XLua/Doc/hotfix.md
-- ======================================

-- 修改xlua.hotfix方法
-- 在hotfix的时候记录下hotfix的类或方法
-- ======================================
local hotfixTable = {}
local hotfix = xlua.hotfix
xlua.hotfix = function(class, method, func)
	hotfix(class, method, func)
	hotfixTable[class] = hotfixTable[class] or {}
	if type(method) == "table" then
		for _, m in pairs(method) do
			if type(m) == "function" then
				table.insert(hotfixTable[class], m)
			end
		end
	elseif type(method) == "string" then
		table.insert(hotfixTable[class], method)
	end
end

-- 增加xlua.clear方法
-- 反注册hotfix的类或者方法，避免报错
-- ======================================
xlua.clear = function()
	for class, methods in pairs(hotfixTable) do
		for _, method in ipairs(methods) do
			hotfix(class, method, nil)
		end
	end
end
