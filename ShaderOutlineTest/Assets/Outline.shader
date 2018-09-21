Shader "Custom/Outline"
{
	Properties
	{ //variables inside editor
		_MainTex("Main Texture (RGB)",2D) = "white" {}
		_Color("Color",Color) = (1,1,1,1) //allows for color property
		_OutlineTex("Outline Texture",2D) = "white" {}
		_OutlineColor("Outline Color", Color) = (1,1,1,1)
		_OutlineWidth("Outline Width", Range(1.0,10.0)) = 1.1
	}
		SubShader
		{
			Tags
			{
			  "Queue" = "Transparent"
			}
			//For the outline
			Pass{ //only renders once
				Name "OUTLINE"
				ZWrite Off //for transparent objects
				CGPROGRAM // allows communication between tow languages: shader lab and nvidia C for grahics

				//Function Defines = defines the name for the vertex and fragment functions
				#pragma vertex vert//Define for the building fucntion(shape)
				#pragma fragment frag//Define for coloring fucntion(color)

				//Inlcudes
				#include "UnityCG.cginc" //Built in shader functions

				//Structures - Can get data like - vetices, normals, color, uv
				struct appdata //how vertex function gets information
				{
					float4 vertex : POSITION;
					float uv : TEXCOORD0; //Textured coordinates
				};

				struct v2f //vertex to fragment(fragment info)
				{
					float4 pos : SV_POSITION;
					float2 uv : TEXCOORD0;
				};

				//Imports- Reimport property form shader lab to nvidia cg
				float _OutlineWidth;
				float4 _OutlineColor;
				sampler2D _OutlineTex;

				//Vertex Function
				v2f vert(appdata IN)
				{
					IN.vertex.xyz *= _OutlineWidth;
					v2f OUT;
					OUT.pos = UnityObjectToClipPos(IN.vertex); //take object from object space to camera clip space--ie appear on screen
					OUT.uv = IN.uv;
					return OUT;
				}

				//Fragment function
				fixed4 frag(v2f IN) : SV_Target //Color of final image
				{
					float4 texColor = tex2D(_OutlineTex,IN.uv);//gets texture and wraps it aorpudn the object
					return texColor * _OutlineColor;
				}

				ENDCG
			}
			Pass{ //only renders once
				Name "OBJECT"
				CGPROGRAM // allows communication between tow languages: shader lab and nvidia C for grahics

				//Function Defines = defines the name for the vertex and fragment functions
				#pragma vertex vert//Define for the building fucntion(shape)
				#pragma fragment frag//Define for coloring fucntion(color)

				//Inlcudes
				#include "UnityCG.cginc" //Built in shader functions

				//Structures - Can get data like - vetices, normals, color, uv
				struct appdata //how vertex function gets information
				{
					float4 vertex : POSITION;
					float uv : TEXCOORD0; //Textured coordinates
				};

				struct v2f //vertex to fragment(fragment info)
				{
					float4 pos : SV_POSITION;
					float2 uv : TEXCOORD0;
				};

				//Imports- Reimport property form shader lab to nvidia cg
				float4 _Color;
				sampler2D _MainTex;

				//Vertex Function
				v2f vert(appdata IN)
				{
					v2f OUT;
					OUT.pos = UnityObjectToClipPos(IN.vertex); //take object from object space to camera clip space--ie appear on screen
					OUT.uv = IN.uv;
					return OUT;
				}

				//Fragment function
				fixed4 frag(v2f IN) : SV_Target //Color of final image
				{
					float4 texColor = tex2D(_MainTex,IN.uv);//gets texture and wraps it aorpudn the object
					return texColor * _Color;
				}

				ENDCG
			}

			
		}
}