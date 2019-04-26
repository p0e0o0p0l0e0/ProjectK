-- 作者：黄伟
-- 时间：2017/11/14
-- 描述：LuaNGUIForm包装类
-- ======================================

LuaNGUIForm = class("LuaNGUIForm", LuaObject)

-- 构造函数
-- Param:C# LuaNGUIForm实例
-- Param:uiFormParams
-- ======================================
function LuaNGUIForm:Ctor(form, owner, uiFormParams)
	LuaNGUIForm.super.Ctor(self)

	self.form = form
	self.owner = owner
	self.transform = self.form.gameObject.transform
	self.LuaScriptName = form.LuaScriptName
	self.GeneralFormData = form.GeneralFormData
	self.UISubForms = form.UISubForms
	self.UIElements = form.UIElements
	self.GameObjects = form.GameObjects
	self.Transforms = form.Transforms
	self.UIPanels = form.UIPanels
	self.UILabels = form.UILabels
	self.UIInputs = form.UIInputs
	self.UIButtons = form.UIButtons
	self.UIToggles = form.UIToggles
	self.UISprites = form.UISprites
	self.UITextures = form.UITextures
	self.UIProgressBars = form.UIProgressBars
	self.UISliders = form.UISliders
	self.UIScrollBars = form.UIScrollBars
	self.UIScrollViews = form.UIScrollViews
	self.UIGrids = form.UIGrids
	self.UITables = form.UITables
	self.UITweeners = form.UITweeners
	self.UIWidgets = form.UIWidgets
	self.visible = false
    self.form.LuaScriptTable = self;
	self:__OnInit(uiFormParams)
end

-- 获取组件
-- ======================================
function LuaNGUIForm:GetComponent(type)
	return self.form:GetComponent(type)
end

-- 播放音效
-- ======================================
function LuaNGUIForm:PlayUISound(id)
	--self.form:PlayUISound(id)
	--return self.form:GetLastUISoundSerialId()
	GameEntry.Wwise:PlaySound(id)
	return 0
end

-- 停止音效
-- ======================================
function LuaNGUIForm:StopUISound(serialId)
	--return self.form:StopUISound(serialId)
	return 0
end

-- 停止上一个音效
-- ======================================
function LuaNGUIForm:StopLastUISound()
    --self.form:StopLastUISound()
end

-- 设置Active
-- ======================================
function LuaNGUIForm:SetActive(active)
	self.form.Visible = active
end

-- 获取sid
-- ======================================
function LuaNGUIForm:GetSid()
	return self.form.UIForm.SerialId
end

-- 关闭
-- ======================================
function LuaNGUIForm:Close()
	self.form:Close()
end

-- 关闭所有
function LuaNGUIForm:CloseAll()
	if self.form.CloseAll ~= nil then
		self.form:CloseAll()
	end
end

-- 打开子界面
-- ======================================
function LuaNGUIForm:OpenUISubForm(uiSubFormName, userData)
	self.form:OpenUISubForm(uiSubFormName, userData)
end

-- 子界面是否打开
-- ======================================
function LuaNGUIForm:UISubFormIsOpen(uiSubFormName)
	return self.form:UISubFormIsOpen(uiSubFormName)
end

-- 关闭子界面
-- ======================================
function LuaNGUIForm:CloseUISubForm(uiSubFormName, userData)
	self.form:CloseUISubForm(uiSubFormName, userData)
end

-- 获得子界面
-- ======================================
function LuaNGUIForm:GetUISubForm(uiSubFormName)
	self.form:GetUISubForm(uiSubFormName)
end

-- 获取界面所在层级
-- ======================================
function LuaNGUIForm:GetLayer()
	return self.form.gameObject.layer
end

-- 修改环境光
-- ======================================
function LuaNGUIForm:ChangeAmbientLight(r, g, b)
	self.isChangeAmbientLight = true

	self.cachedAmbientLight = Color(r, g, b)
	self:ApplyAmbientLight()
end

-- 应用环境光
-- ======================================
function LuaNGUIForm:ApplyAmbientLight()
	if self.isChangeAmbientLight then
		GameEntry.Environment:ModifyAmbientLight(self.cachedAmbientLight)
	end
end

-- 还原环境光
-- ======================================
function LuaNGUIForm:RevertAmbientLight()
	if self.isChangeAmbientLight then
		GameEntry.Environment:RevertAmbientLight()
	end
end

-- 绑定至Npc
-- ======================================
function LuaNGUIForm:BindToNpc( npcGuid, distance, func, entity )
	local npcData = GameEntry.DataCache.Entity:GetMonsterCharacterDataByGuid(npcGuid)
	local npcEntity = GameEntry.Entity:GetEntity(npcData.Id)
	local DistanceListener = require("Utility/DistanceListener")
	local callback = func or handler(self, self.Close)
	self.listener = DistanceListener.New()
	self.listener:Initialize(npcEntity.transform, entity or GameEntry.Entity:GetMyPlayerCharacter().transform, callback)
	self.listener.TriggerDistance = distance or self.listener.TriggerDistance
	self.listener:StartListen()
end

-- 从Npc解绑
-- ======================================
function LuaNGUIForm:UnbindFromNpc()
	if self.listener then
		self.listener:Clear()
	end
end

function LuaNGUIForm:__OnInit(uiFormParams)
	if self.OnInit then
		self:OnInit(uiFormParams)
    end
end

function LuaNGUIForm:__OnOpen(uiFormParams)
	self:SubscribeEvent(PS.StartChangeSceneEventArgs.EventId, handler(self, self.__OnStartChangeScene))
	self:SubscribeEvent(PS.ChangeSceneCompleteEventArgs.EventId, handler(self, self.__OnChangeSceneComplete))

	LuaEntry.UIAssistant:Register(self.form.UIForm, self)
	self.visible = true
	self.isChangeAmbientLight = false

	if self.OnOpen then
		self:OnOpen(uiFormParams)
	end
end

function LuaNGUIForm:__OnClose(uiFormParams)
	self:StopLogic()
	self:UnbindFromNpc()
	self:RevertAmbientLight()

	LuaEntry.UIAssistant:Unregister(self.form.UIForm, self)
	self.visible = false

	if self.OnClose then
		self:OnClose(uiFormParams)
	end
end

function LuaNGUIForm:__OnPause()
	if self.OnPause then
		self:OnPause()
	end
end

function LuaNGUIForm:__OnResume()
	if self.OnResume then
		self:OnResume()
	end
end

function LuaNGUIForm:__OnCover()
	if self.OnCover then
		self:OnCover()
	end
end

function LuaNGUIForm:__OnReveal()
	if self.OnReveal then
		self:OnReveal()
	end
end

function LuaNGUIForm:__OnRefocus(uiFormParams)
	if self.OnRefocus then
		self:OnRefocus(uiFormParams)
	end
end

function LuaNGUIForm:__OnDepthChanged(uiGroupDepth, depthInUIGroup)
	if self.OnDepthChanged then
		self:OnDepthChanged(uiGroupDepth, depthInUIGroup)
	end
end

function LuaNGUIForm:__OnClick(gameObject)
	if self.OnClick then
		self:OnClick(gameObject)
	end
end

function LuaNGUIForm:__OnToggle(gameObject)
	if self.OnToggle then
		self:OnToggle(gameObject)
	end
end

function LuaNGUIForm:__OnInputChange(gameObject)
	if self.OnInputChange then
		self:OnInputChange(gameObject)
	end
end

function LuaNGUIForm:__OnPress(gameObject)
	if self.OnPress then
		self:OnPress(gameObject)
	end
end

function LuaNGUIForm:__OnRelease(gameObject)
	if self.OnRelease then
		self:OnRelease(gameObject)
	end
end

function LuaNGUIForm:__OnDragStart(gameObject)
	if self.OnDragStart then
		self:OnDragStart(gameObject)
	end
end

function LuaNGUIForm:__OnDragOver(gameObject)
	if self.OnDragOver then
		self:OnDragOver(gameObject)
	end
end

function LuaNGUIForm:__OnDragOut(gameObject)
	if self.OnDragOut then
		self:OnDragOut(gameObject)
	end
end

function LuaNGUIForm:__OnDragEnd(gameObject)
	if self.OnDragEnd then
		self:OnDragEnd(gameObject)
	end
end

function LuaNGUIForm:__OnValueChange(gameObject)
	if self.OnValueChange then
		self:OnValueChange(gameObject)
	end
end

function LuaNGUIForm:__OnEvent(userData)
	if self.OnEvent then
		self:OnEvent(userData)
	end
end

function LuaNGUIForm:__OnDestroy()
	if self.OnDestroy then
		self:OnDestroy(gameObject)
	end
end

function LuaNGUIForm:__OnStartChangeScene(sender, event)
	if self.OnStartChangeScene then
		self:OnStartChangeScene(sender, event)
	end
end

function LuaNGUIForm:__OnChangeSceneComplete(sender, event)
	if self.OnChangeSceneComplete then
		self:OnChangeSceneComplete(sender, event)
	end
end

function LuaNGUIForm:__OnTweenFinished(gameObject)
	if self.OnTweenFinished then
		self:OnTweenFinished(gameObject)
	end
end

function LuaNGUIForm:__OnSubFormEnable()
	self:ApplyAmbientLight()

	if self.OnSubFormEnable then
		self:OnSubFormEnable()
	end
end

function LuaNGUIForm:__OnSubFormDisable()
	if self.OnSubFormDisable then
		self:OnSubFormDisable()
	end
end

function LuaNGUIForm:__OnClickWithFuncName(gameObject, funcName)
	if self[funcName] == nil then
		Log.Warning(self.__cname .. " don't have function " .. funcName)
		return
	end
	self[funcName](self, gameObject)
end

function LuaNGUIForm:__OnDeselect(gameObjct)
    if self.OnDeselect then
        self:OnDeselect(gameObjct)
    end
end

function LuaNGUIForm:__OnShowCoinTip(gameObject,type)
	LuaEntry.GeneralTipsModule:ShowTipsWithGameObjectForCoin(gameObject,type)
	if self.OnShowCoinTip then
		self:OnShowCoinTip(gameObject,type)
	end
end

function LuaNGUIForm:__OnJumpCoin(gameObject,type)
	if type ==  EnumMoneyType.MONEY then
		GameEntry.UI:OpenUIFormById(UIFormEnum.ExchangeBindMoneyForm, {LuaEntry.ExchangeMoneyModule.ExchangeType.typeYinliang,LuaEntry.ExchangeMoneyModule.PASSIVETYPE.BEIBAO})
    elseif type == EnumMoneyType.JIAOZI then
		GameEntry.UI:OpenUIFormById(UIFormEnum.ExchangeBindMoneyForm, {LuaEntry.ExchangeMoneyModule.ExchangeType.typeMoney,LuaEntry.ExchangeMoneyModule.PASSIVETYPE.BEIBAO})
    elseif type == EnumMoneyType.YUANBAO then
		LuaEntry.ShopModule:OpenRechargeShop()
    elseif type == EnumMoneyType.BANGDING then
		LuaEntry.Notification:ShowToast(Lang.GetString("Common.NotOpen"))
    end
end

function LuaNGUIForm:__OnApplicationQuit()
	if self.OnApplicationQuit then
		self:OnApplicationQuit()
	end
end

return LuaNGUIForm
