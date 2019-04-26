using GameFramework;
using GameFramework.Fsm;
using GameFramework.Procedure;
using UnityEngine;
using ProcedureOwner = GameFramework.Fsm.IFsm<GameFramework.Procedure.IProcedureManager>;

public abstract class ProcedureBase : GameFramework.Procedure.ProcedureBase
{
    protected ProcedureOwner m_ProcedureOwner = null;

    protected override void OnEnter(ProcedureOwner procedureOwner)
    {
        base.OnEnter(procedureOwner);
        m_ProcedureOwner = procedureOwner;
    }
}
