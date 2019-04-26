using GameFramework.Resource;
using System;
using System.Collections.Generic;
using System.IO;
using UnityEngine;
using UnityGameFramework.Runtime;

namespace ProjectK
{
    public class LuaComponent : GameFrameworkComponent
    {
        private const string LuaScriptListFileName = "Assets/GameMain/LuaScripts/LuaScriptList.txt";

        private static string[] m_LineSplit = new string[] { "\r\n", "\r", "\n" };
        private Dictionary<string, bool> m_LoadedFlags = new Dictionary<string, bool>();
        private readonly Dictionary<string, byte[]> m_LuaScriptCache = new Dictionary<string, byte[]>();

        private LoadAssetCallbacks m_LoadLuaScriptListCallbacks = null;
        private LoadAssetCallbacks m_LoadLuaScriptCallbacks = null;

        public bool IsAllLuaScriptsLoaded
        {
            get
            {
                if (!GameStart.Base.EditorResourceMode && m_LoadedFlags.Count <= 0)
                {
                    return false;
                }

                foreach (KeyValuePair<string, bool> loadedFlag in m_LoadedFlags)
                {
                    if (!loadedFlag.Value)
                    {
                        return false;
                    }
                }

                return true;
            }
        }

        private void Start()
        {
            m_LoadLuaScriptListCallbacks = new LoadAssetCallbacks(LoadLuaScriptListSuccessCallback, LoadLuaScriptListFailureCallback);
            m_LoadLuaScriptCallbacks = new LoadAssetCallbacks(LoadLuaScriptSuccessCallback, LoadLuaScriptFailureCallback);
        }

        public void LoadScripts()
        {
            if (GameStart.Base.EditorResourceMode)
            {

            }
            else
            {
                GameStart.Resource.LoadAsset(LuaScriptListFileName, Constant.AssetPriority.LuaScriptAsset, m_LoadLuaScriptListCallbacks);
            }
        }

        private void LoadLuaScriptListSuccessCallback(string luaScriptListAssetName, object asset, float duration, object userData)
        {
            TextAsset luaScriptList = asset as TextAsset;
            if (luaScriptList == null)
            {
                Log.Error("Lua component load lua script list asset failure, which is not a TextAsset.");
                return;
            }

            string[] luaScriptNames = luaScriptList.text.Split(m_LineSplit, StringSplitOptions.None);
            for (int i = 0; i < luaScriptNames.Length; i++)
            {
                LoadScript(luaScriptNames[i]);
            }

            GameStart.Resource.UnloadAsset(luaScriptList);
        }

        private void LoadLuaScriptListFailureCallback(string luaScriptListAssetName, LoadResourceStatus status, string errorMessage, object userData)
        {
            Log.Error("Lua component load lua script list asset failure, status is '{0}', error message is '{1}'.", status.ToString(), errorMessage);
        }

        private void LoadScript(string luaScriptName, object userData = null)
        {
            if (string.IsNullOrEmpty(luaScriptName))
            {
                Log.Warning("Lua script name is invalid.");
                return;
            }

            string luaScriptAssetName = AssetUtility.GetLuaScriptAsset(luaScriptName);
            if (GameStart.Base.EditorResourceMode)
            {
                if (!File.Exists(luaScriptAssetName))
                {
                    Log.Error("Can not find lua script '{0}'.", luaScriptAssetName);
                    return;
                }

                InternalLoadLuaScript(luaScriptName, luaScriptAssetName, File.ReadAllBytes(luaScriptAssetName), 0f, userData);
            }
            else
            {
                m_LoadedFlags.Add(luaScriptName, false);
                GameStart.Resource.LoadAsset(luaScriptAssetName, Constant.AssetPriority.LuaScriptAsset, m_LoadLuaScriptCallbacks, new LuaScriptInfo(luaScriptName, userData));
            }
        }

        private void LoadLuaScriptSuccessCallback(string luaScriptAssetName, object asset, float duration, object userData)
        {
            TextAsset luaScriptAsset = asset as TextAsset;
            if (luaScriptAsset == null)
            {
                Log.Warning("Lua script asset '{0}' is invalid.", luaScriptAssetName);
                return;
            }

            LuaScriptInfo luaScriptInfo = (LuaScriptInfo)userData;
            InternalLoadLuaScript(luaScriptInfo.LuaScriptName, luaScriptAssetName, luaScriptAsset.bytes, duration, luaScriptInfo.UserData);
            GameStart.Resource.UnloadAsset(luaScriptAsset);

            m_LoadedFlags[luaScriptInfo.LuaScriptName] = true;
        }

        private void LoadLuaScriptFailureCallback(string luaScriptAssetName, LoadResourceStatus status, string errorMessage, object userData)
        {
            Log.Error("Load lua script failure, asset name '{0}', status '{1}', error message '{2}'.", luaScriptAssetName, status.ToString(), errorMessage);
        }

        private void InternalLoadLuaScript(string luaScriptName, string luaScriptAssetName, byte[] bytes, float duration, object userData)
        {
            if (bytes[0] == 239 && bytes[1] == 187 && bytes[2] == 191)
            {
                // 处理UFT-8 BOM头
                bytes[0] = bytes[1] = bytes[2] = 32;
            }
            if (m_LuaScriptCache.ContainsKey(luaScriptName))
            {
                m_LuaScriptCache[luaScriptName] = bytes;
            }
            else
            {
                m_LuaScriptCache.Add(luaScriptName, bytes);
            }
            Log.Info("Load lua script '{0}' OK, use '{1:F2}' seconds.", luaScriptName, duration);
        }

        private sealed class LuaScriptInfo
        {
            private readonly string m_LuaScriptName;
            private readonly object m_UserData;

            public LuaScriptInfo(string luaScriptName, object userData)
            {
                m_LuaScriptName = luaScriptName;
                m_UserData = userData;
            }

            public string LuaScriptName
            {
                get
                {
                    return m_LuaScriptName;
                }
            }

            public object UserData
            {
                get
                {
                    return m_UserData;
                }
            }
        }
    }
}