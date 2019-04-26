using GameFramework.Fsm;
using GameFramework.Procedure;

namespace ProjectK
{
    public class ProcedurePreload : ProcedureBase
    {
        protected override void OnEnter(IFsm<IProcedureManager> procedureOwner)
        {
            base.OnEnter(procedureOwner);
            PreloadResources();
        }

        private void PreloadResources()
        {
            GameStart.Lua.LoadScripts();
        }

        protected override void OnUpdate(IFsm<IProcedureManager> procedureOwner, float elapseSeconds, float realElapseSeconds)
        {
            base.OnUpdate(procedureOwner, elapseSeconds, realElapseSeconds);
            if(!GameStart.Lua.IsAllLuaScriptsLoaded)
            {
                return;
            }
            ChangeState<ProcedureMain>(m_ProcedureOwner);
        }
    }
}