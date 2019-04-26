using GameFramework.Fsm;
using GameFramework.Procedure;

namespace ProjectK
{
    public class ProcedureMain : ProcedureBase
    {
        protected override void OnEnter(IFsm<IProcedureManager> procedureOwner)
        {
            base.OnEnter(procedureOwner);
            UnityEngine.Debug.LogError("123");
        }
    }
}