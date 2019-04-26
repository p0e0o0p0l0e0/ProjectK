-- 全局常量
-- ======================================

Global = {}

Global.MAX_ITEM_PARAM 		= 	3

Global.MAX_ITEMATTR_COUNT	=	16

Global.MAX_ITEM_CREATORNAME	=	32

Global.MAX_ITEMATTR_COUNT   = 16
Global.MAX_GEM_COUNT        = 4
Global.MAX_GEM_ATTR_COUNT   = 1
Global.MAX_IMAKE_ATTA_NUM   = 3 -- 手工装备属性数量
Global.ITEM_EXT_INFO =
{
    IEI_BIND_INFO = 0x00000001,  -- 绑定信息
    IEI_IDEN_INFO = 0x00000002,  -- 鉴定信息
    IEI_PLOCK_INFO = 0x00000004, -- 二级密码已经处理
    IEI_BLUE_ATTR = 0x00000008,  -- 是否有蓝属性
    IEI_CREATOR = 0x00000010,   -- 是否有创造者
    IEI_APTITUDE = 0x00000020,  -- 是否显示资质
    IEI_LOCK_INFO = 0x00000040, -- 锁定信息（和绑定不同）
}
Global.PreBattleScore = 0--GameEntry.DataCache.Entity.MyPlayerCharacterData.BattleScore每次变化之前的战力

Global.MAX_USERNAME = 30
