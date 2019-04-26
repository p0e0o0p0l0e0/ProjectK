-- 作者：黄伟
-- 时间：2017/11/14
-- 描述：LuaNGUIFormFactory
-- ======================================

function OnInit(userData)
	-- if IsEditor and GameEntry.Base.EditorResourceMode and GameEntry.Lua.LuaEditMode then
	-- 	Class = ReimportScript(self.LuaScriptName);
	-- else
	-- 	Class = require(self.LuaScriptName)
	-- end
	Class = require(self.LuaScriptName)
	object = Class.New(self, owner, userData)
end

function OnOpen(userData)
	object:__OnOpen(userData)
end

function OnClose(userData)
	object:__OnClose(userData)
end

function OnPause()
	object:__OnPause()
end

function OnResume()
	object:__OnResume()
end

function OnCover()
	object:__OnCover()
end

function OnReveal()
	object:__OnReveal()
end

function OnRefocus(userData)
	object:__OnRefocus(userData)
end

function OnDepthChanged(uiGroupDepth, depthInUIGroup)
	object:__OnDepthChanged(uiGroupDepth, depthInUIGroup)
end

function OnClick(gameObject)
	object:__OnClick(gameObject)
end

function OnToggle(gameObject)
	object:__OnToggle(gameObject)
end

function OnInputChange(gameObject)
	object:__OnInputChange(gameObject)
end

function OnPress(gameObject)
	object:__OnPress(gameObject)
end

function OnRelease(gameObject)
	object:__OnRelease(gameObject)
end

function OnDragStart(gameObject)
	object:__OnDragStart(gameObject)
end

function OnDragOver(gameObject)
	object:__OnDragOver(gameObject)
end

function OnDragOut(gameObject)
	object:__OnDragOut(gameObject)
end

function OnDragEnd(gameObject)
	object:__OnDragEnd(gameObject)
end

function OnValueChange(gameObject)
	object:__OnValueChange(gameObject)
end

function OnEvent(userData)
	object:__OnEvent(userData)
end

function OnDestroy()
	object:__OnDestroy()
end

function OnTweenFinished(gameObject)
	object:__OnTweenFinished(gameObject)
end

function OnSubFormEnable()
	object:__OnSubFormEnable()
end

function OnSubFormDisable()
	object:__OnSubFormDisable()
end

function OnClickWithFuncName(gameObject, funcName)
	object:__OnClickWithFuncName(gameObject, funcName)
end

function OnDeselect(gameObject)
    object:__OnDeselect(gameObject)
end

function OnShowCoinTip(gameObject,type)
	object:__OnShowCoinTip(gameObject,type)
end

function OnJumpCoin(gameObject,type)
	object:__OnJumpCoin(gameObject,type)
end

function OnApplicationQuit()
	object:__OnApplicationQuit()
end
