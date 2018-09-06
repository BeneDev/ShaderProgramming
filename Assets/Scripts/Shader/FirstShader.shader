// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

Shader "Custom/FirstShader" // The path, the shader will go in
{
	// Properties to change in Inspector get written here
	Properties{
		_Color("Color", Color) = (1,1,1,1)
		_MainTex("Albedo (RGB)", 2D) = "white" {}
		_Glossiness("Smoothness", Range(0,1)) = 0.5
		_Metallic("Metallic", Range(0,1)) = 0.0
		_Amplitude("Amplitude", Range(0, 10)) = 1
		_WaveLenght("WaveLenght", float) = 1
		_Speed("Speed", float) = 1
	}

		// Shaders can have different subshaders. You can use this to show materials differently on different platforms
			SubShader
		{
			// Subshaders can have several passes. Passes contain of two different programms. One Vertex for reading the geometry of the mesh. Changing the position for water or something. 
			// Fragments are for the spaces between the vertexes. For Colors and stuff
			Pass
			{
				CGPROGRAM //Between CGPROGRAM and ENDCG is the programm to excecute

				// Declare the two programs
				#pragma vertex VertexProgram
				#pragma fragment FragmentProgram

				float4 _Color;
				/*Texture2D _MainTex;
				float _Glossiness;
				float _Metallic;*/
				float _Amplitude;
				float _WaveLenght;
				float _Speed;

				// Define the two programs. In here is what code will get called. float4 for 4x4 transformation matrix, to comprehend 4dimensional data. This gets called for every vertex of the mesh
				float4 VertexProgram(float4 position : POSITION, out float3 localPosition : TEXCOORD0) : SV_POSITION // This is no inheritance. SV = System Value. For missing semantic errors
				{
					localPosition = position.xyz; // Set the out paremeter

					// Make the vertexes wave over time
					float k = 2 * 3.14 / _WaveLenght;
					position.y = sin(k * (position.y * _Time.y) * _Speed) * _Amplitude; // Make the vertexes move over time

					return UnityObjectToClipPos(position); // Get the position relative to the camera, so the mesh is rendered in world space
				}

				//Output from vertex program should be input for fragment program. First transform the vertexes and then color it

				// This gets called for every pixel, the mesh is shown on. Between the vertexes there is an interpolation, to set the color between the vertexes
				float4 FragmentProgram(float4 position : SV_POSITION, float3 localPosition : TEXCOORD0) : SV_TARGET // Where the color gets targeted
				{
					//return _Color;
					return float4(localPosition, 1) * _Color;
				}

				ENDCG
			}
	}
}
