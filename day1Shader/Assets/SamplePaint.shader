Shader "Custom/SamplePaint" // シェーダーの名前と名前空間の定義
{
    CGINCLUDE // CGコードをインクルードする開始マーク

    #include <UnityShaderVariables.cginc>  //これないと_Time使えない

    float4 paint(float2 uv)
    {
        float t = _Time.y; // 経過時間を取得
        float3 col = float3(
            sin(t * 2.0), // 赤色の強度を時間に応じて変化
            sin(t * 1.2 + 1.3), // 緑色の強度を時間に応じて変化
            sin(-t * 2.1 - 2.0)); // 青色の強度を時間に応じて変化
        col = col * 0.5 + 0.5; // 色の範囲を0から1に正規化
        return float4(col, 1); // 計算された色と不透明度を返す
    }

    ENDCG // CGコードのインクルード終了マーク
    SubShader // サブシェーダーの定義開始
    {
        Pass // パスの定義開始
        {
            CGPROGRAM // CGプログラムの開始マーク
            #pragma vertex vert // 頂点シェーダーの関数を指定
            #pragma fragment frag // フラグメントシェーダーの関数を指定

            #include "UnityCG.cginc" // Unityの共通シェーダーライブラリをインクルード

            // 構造体の定義
            struct appdata // 頂点シェーダーの入力構造体
            {
                float4 vertex : POSITION; // 頂点座標
                float2 texcoord : TEXCOORD0; // テクスチャ座標
            };
            
            struct fin // フラグメントシェーダーへの入力構造体
            {
                float4 vertex : SV_POSITION; // スクリーン上の頂点座標
                float2 texcoord : TEXCOORD0; // テクスチャ座標
            };

            // 頂点シェーダー
            fin vert(appdata v) // 頂点データを処理する関数
            {
                fin o; // 出力用の構造体を作成
                o.vertex = UnityObjectToClipPos(v.vertex); // ワールド座標をクリップ座標に変換
                o.texcoord = v.texcoord; // テクスチャ座標をそのまま渡す
                return o; // 変換結果を返す
            }

            // フラグメントシェーダー
            float4 frag(fin IN) : SV_TARGET // ピクセルごとの出力を処理する関数
            {
                return paint(IN.texcoord.xy); // 計算された色を返す
            }
            ENDCG // CGプログラムの終了マーク
        }
    }
}
