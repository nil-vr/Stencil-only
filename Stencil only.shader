Shader "Stencil only"
{
    Properties
    { 
        [Enum(UnityEngine.Rendering.CullMode)] _Cull("Cull", Float) = 2
        [Enum(UnityEngine.Rendering.CompareFunction)] _ZTest("ZTest", Float) = 4
        _ZBias("ZBias", Float) = 0.0

        [IntRange] _StencilRef("Stencil Reference Value", Range(0, 255)) = 7
        [IntRange] _StencilReadMask ("Stencil ReadMask Value", Range(0, 255)) = 1
        [IntRange] _StencilWriteMask ("Stencil WriteMask Value", Range(0, 255)) = 255
        [Enum(UnityEngine.Rendering.StencilOp)] _StencilPassOp("Stencil Pass Op", Float) = 2
        [Enum(UnityEngine.Rendering.StencilOp)] _StencilFailOp("Stencil Fail Op", Float) = 0
        [Enum(UnityEngine.Rendering.StencilOp)] _StencilZFailOp("Stencil ZFail Op", Float) = 0
        [Enum(UnityEngine.Rendering.CompareFunction)] _StencilCompareFunction("Stencil Compare Function", Float) = 4
	}

    SubShader
    {
        Tags
        {
            "RenderType" = "Opaque"
            "Queue" = "Geometry+10"
            // Ensure shader fallback is invisible.
            "VRCFallback"="Hidden"
        }

        // Disable writing to color buffer.
        ColorMask 0
        // Disable writing to depth buffer.
        ZWrite false

        Cull [_Cull]
        ZTest [_ZTest]
        Offset [_ZBias], [_ZBias]

        Stencil
        {
            Ref [_StencilRef]
            ReadMask [_StencilReadMask]
            WriteMask [_StencilWriteMask]
            Comp [_StencilCompareFunction]
            Pass [_StencilPassOp]
            Fail [_StencilFailOp]
            ZFail [_StencilZFailOp]
        }
        
        CGINCLUDE
        struct appdata
        {
            float4 vertex: POSITION;
        };
        struct v2f
        {
            float4 pos: SV_POSITION;
        };
        v2f vert(appdata v)
        {
            v2f o;
            o.pos = UnityObjectToClipPos(v.vertex);
            return o;
        }
        half4 frag(v2f i): COLOR
        {
            return half4(0, 0, 0, 0);
        }
        ENDCG
        
        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            ENDCG
        }
    }
}
