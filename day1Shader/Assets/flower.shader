Shader "Custom/flower" // シェーダーの名前と名前空間の定義
{
    CGINCLUDE // CGコードをインクルードする開始マーク
    

    #include <UnityShaderVariables.cginc>  //これないと_Time使えない
    #include <UnityCG.cginc>
    #include "UnityCG.cginc"

float flower(float2 p, float n, float radius, float angle, float waveAmp)
{
  float theta = atan2(p.y, p.x);
  float d = length(p) - radius + sin(theta*n + angle) * waveAmp;
  float b = 0.01 / abs(d);
  return b;
}

float4 paint(float2 uv)
{
  float2 p = uv*2. - 1.;

  float3 col = 0;
  col += flower(p, 6., .9, _Time.y*1.5, .1) * float3(.1, .01, 1.);
  col += flower(p, 3., .2, 3.14*.5-_Time.y*.3, .2) * float3(1., .5, 0.);
  col += flower(p, 4., .5, _Time.y*.3, .1) * float3(0., 1., 1.);

  // 薄い緑色の花
  col +=
    min( flower(p, 18., .7, -_Time.y*10., .01), 1.) * .1 *
    float3(.1, .6, .1);

  col += flower(p, 55., .05, _Time.y*100., .1) * float3(1., .1, .1);
  return float4(col, 1);
}



    ENDCG // CGコードのインクルード終了マーク
    SubShader // サブシェーダーの定義開始
    {
        Pass // パスの定義開始
        {
            CGPROGRAM // CGプログラムの開始マーク
            #pragma vertex vert // 頂点シェーダーの関数を指定
            #pragma fragment frag // フラグメントシェーダーの関数を指定
            
            

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
