using System.Collections;
using System.Collections.Generic;
using UnityEngine;

namespace ProjectK
{
    public partial class GameStart
    {
        public static LuaComponent Lua
        {
            private set;
            get;
        }

        private static void InitCustomComponent()
        {
            Lua = UnityGameFramework.Runtime.GameEntry.GetComponent<LuaComponent>();
        }
    }
}
