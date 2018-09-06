Shader "Custom/Waves" {
	Properties {
		_Color ("Color", Color) = (1,1,1,1)
		_MainTex ("Albedo (RGB)", 2D) = "white" {}
		_Glossiness("Smoothness", Range(0,1)) = 0.5
		_Metallic("Metallic", Range(0,1)) = 0.0
		_Amplitude("Amplitude", Range(0, 10)) = 1
		_WaveLenght("WaveLenght", float) = 1
		_Speed("Speed", float) = 1
	}
		SubShader{
		Tags { "RenderType" = "Opaque" }
		LOD 200

		//Cull Off

		CGPROGRAM
		// Physically based Standard lighting model, and enable shadows on all light types
		#pragma surface surf Standard fullforwardshadows vertex:Vert addshadow

		// Use shader model 3.0 target, to get nicer looking lighting
		#pragma target 3.0

		sampler2D _MainTex;

		struct Input {
			float2 uv_MainTex;
		};

		half _Glossiness;
		half _Metallic;
		fixed4 _Color;
		float _Amplitude;
		float _WaveLenght;
		float _Speed;

		// Add instancing support for this shader. You need to check 'Enable Instancing' on materials that use the shader.
		// See https://docs.unity3d.com/Manual/GPUInstancing.html for more information about instancing.
		// #pragma instancing_options assumeuniformscaling
		UNITY_INSTANCING_BUFFER_START(Props)
			// put more per-instance properties here
		UNITY_INSTANCING_BUFFER_END(Props)

		void Vert(inout appdata_full vertexData)
		{
			float3 p = vertexData.vertex.xyz;
			float k = 2 * UNITY_PI / _WaveLenght;
			float f = k * (p.x - _Speed * _Time.y);

			p.x += _Amplitude * cos(f);
			p.y = sin(f) * _Amplitude;

			float3 tangent = normalize(float3(1 - k * _Amplitude * sin(f), k * _Amplitude * cos(f), 0));
			float3 normal = float3(-tangent.y, tangent.x, 0);

			vertexData.vertex.xyz = p;
			vertexData.normal = normal;
		}

		void surf (Input IN, inout SurfaceOutputStandard o) {
			// Albedo comes from a texture tinted by color
			fixed4 c = tex2D (_MainTex, IN.uv_MainTex) * _Color;
			o.Albedo = c.rgb;
			// Metallic and smoothness come from slider variables
			o.Metallic = _Metallic;
			o.Smoothness = _Glossiness;
			o.Alpha = c.a;
		}
		ENDCG
	}
	FallBack "Diffuse"
}
