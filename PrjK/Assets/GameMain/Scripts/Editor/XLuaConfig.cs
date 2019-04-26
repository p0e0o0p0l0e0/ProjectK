using System.Collections.Generic;
using XLua;

namespace ProjectK.Editor
{
    public static class XLuaConfig
    {
        [CSObjectWrapEditor.GenPath]
        public static readonly string XLuaGenPath = GameFramework.Utility.Path.GetCombinePath(UnityEngine.Application.dataPath, "GameMain/Scripts/Lua/XLuaGen/");

        [LuaCallCSharp]
        public static readonly List<System.Type> LuaCallCSharp = new List<System.Type>()
        {
            // 添加 NOT_GEN_WARNING 预编译以收集使用了 C# 反射的代码
            // 插件类 - 将其添加到此处，注意区分名字空间
            // Project-S - 直接在对应的类名上增加 [XLua.LuaCallCSharp]

            #region System

            typeof(System.Delegate),
            typeof(System.Object),
            typeof(System.Type),
            typeof(System.DateTime),

            #endregion System
        };

        [CSharpCallLua]
        public static readonly List<System.Type> CSharpCallLua = new List<System.Type>()
        {
            // 系统
            typeof(System.Action),
            typeof(System.Action<bool>),
            typeof(System.Action<object>),
            typeof(System.Action<UnityEngine.GameObject>),
        };

        // 黑名单
        [BlackList]
        public static readonly List<List<string>> BlackList = new List<List<string>>()
        {
            // 需要屏蔽的编辑器代码列在这里，避免打包编译错误。
            // 由于考虑到有可能需要把重载函数的其中一个重载列入黑名单，配置方式比较复杂。
            // 对于每个成员，在第一层List有一个条目，第二层List是个string的列表。
            // 第一个string是类型的全路径名，第二个string是成员名。
            // 如果成员是一个方法，还需要从第三个string开始，把其参数的类型全路径全列出来。
            // 例如：
            // new List<string>(){"UnityEngine.GameObject", "networkView"},
            // new List<string>(){"System.IO.FileInfo", "GetAccessControl", "System.Security.AccessControl.AccessControlSections"},
            new List<string>() {"System.Type", "IsSZArray"},
            new List<string>() {"UnityEngine.MonoBehaviour", "runInEditMode"},
        };
    }
}
