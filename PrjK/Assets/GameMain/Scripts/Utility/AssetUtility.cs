using GameFramework;
using UnityEngine;

namespace ProjectK
{
    public class AssetUtility
    {
        public static string GetLuaScriptAsset(string assetName)
        {
            if (GameStart.Base.EditorResourceMode)
            {
                return Utility.Path.GetCombinePath(Application.dataPath, "GameMain/LuaScripts", assetName + ".lua");
            }
            else
            {
                return Utility.Text.Format("Assets/GameMain/LuaScripts/{0}.lua.bytes", assetName);
            }
        }
    }
}
