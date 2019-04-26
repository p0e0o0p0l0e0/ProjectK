using System.Collections;
using System.Collections.Generic;
using UnityEngine;

namespace ProjectK
{
    public partial class GameStart : MonoBehaviour
    {
        // Start is called before the first frame update
        private void Start()
        {
            InitBuiltinComponent();
            InitCustomComponent();
        }
    }
}
