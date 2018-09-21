Shader "Custom/Blurr"
{
	Properties
	{ //variables inside editor
		_BlurRadius("Blur Radius", Range(0.0,20.0)) = 1
		_Intensity("Blurr Intensity)",Range(0.0,1.0)) = 0.01
		
	}
		SubShader
		{
			Tags
			{
			  "Queue" = "Transparent"
			}

			GrabPass{} //get object and everthing behind object render it and send it to the horizontal pass

			
			//For the outline
			Pass{ //only renders once
				Name "HORIZONTALBLUR"
				CGPROGRAM // allows communication between tow languages: shader lab and nvidia C for grahics

				//Function Defines = defines the name for the vertex and fragment functions
				#pragma vertex vert//Define for the building fucntion(shape)
				#pragma fragment frag//Define for coloring fucntion(color)

				//Inlcudes
				#include "UnityCG.cginc" //Built in shader functions

				//Structures - Can get data like - vetices, normals, color, uv
			

				struct v2f //vertex to fragment(fragment info)
				{
					float4 vertex : SV_POSITION;
					float4 uvgrab : TEXCOORD0;
				};

				//Imports- Reimport property form shader lab to nvidia cg
				float _BlurRadius;
				float _Intensity;
				sampler2D _GrabTexture; //everything behind object
				float4 _GrabTexture_TexelSize;
			

				//Vertex Function
				v2f vert(appdata_base IN)
				{
					v2f OUT;
					OUT.vertex = UnityObjectToClipPos(IN.vertex); //take object from object space to camera clip space--ie appear on screen
					#if UNITY_UV_START_AT_TOP
						float scale = -1.0;
					#else
						float scale = 1.0;
					#endif
					OUT.uvgrab.xy = (float2(OUT.vertex.x, OUT.vertex.y *scale) + OUT.vertex.w) * 0.5; //only gets what is behind object instead of whole screen project on each face of the object
					OUT.uvgrab.zw = OUT.vertex.zw;
					return OUT;
				}

				

					half4 frag(v2f IN) : COLOR //change texture color
				{
					half4 texcol = tex2Dproj(_GrabTexture, UNITY_PROJ_COORD(IN.uvgrab)); 
					half4 texsum = half4(0, 0, 0, 0);
					#define GRABPIXEL(weight, kernelx) tex2Dproj(_GrabTexture, UNITY_PROJ_COORD(float4(IN.uvgrab.x + _GrabTexture_TexelSize.x * kernelx * _BlurRadius, IN.uvgrab.y,IN.uvgrab.z,IN.uvgrab.w))) * weight;//baiscaly gets pixels average aroudn it kernalx = pixel on x axis
					//pixels on horizontal axis
					texsum += GRABPIXEL(0.05, -4.0);
					texsum += GRABPIXEL(0.09, -3.0);
					texsum += GRABPIXEL(0.12, -3.0);
					texsum += GRABPIXEL(0.15, -1.0);
					texsum += GRABPIXEL(0.18, -0.0);
					texsum += GRABPIXEL(0.15, 1.0);
					texsum += GRABPIXEL(0.12, 2.0);
					texsum += GRABPIXEL(0.09, 3.0);
					texsum += GRABPIXEL(0.05, 4.0);
					
					texcol = lerp(texcol, texsum, _Intensity);//interpolation between nonblurred and fully blurred
					return texcol;
				}

				ENDCG
			}

			GrabPass{} //get object and everthing behind object render it and send it to the horizontal pass

			
			//For the outline
			Pass{ //only renders once
				Name "VERTICALBLUR"
				CGPROGRAM // allows communication between tow languages: shader lab and nvidia C for grahics

				//Function Defines = defines the name for the vertex and fragment functions
				#pragma vertex vert//Define for the building fucntion(shape)
				#pragma fragment frag//Define for coloring fucntion(color)

				//Inlcudes
				#include "UnityCG.cginc" //Built in shader functions

				//Structures - Can get data like - vetices, normals, color, uv


				struct v2f //vertex to fragment(fragment info)
				{
					float4 vertex : SV_POSITION;
					float4 uvgrab : TEXCOORD0;
				};

				//Imports- Reimport property form shader lab to nvidia cg
				float _BlurRadius;
				float _Intensity;
				sampler2D _GrabTexture; //everything behind object
				float4 _GrabTexture_TexelSize;


				//Vertex Function
				v2f vert(appdata_base IN)
				{
					v2f OUT;
					OUT.vertex = UnityObjectToClipPos(IN.vertex); //take object from object space to camera clip space--ie appear on screen
					#if UNITY_UV_START_AT_TOP
						float scale = -1.0;
					#else
						float scale = 1.0;
					#endif
					OUT.uvgrab.xy = (float2(OUT.vertex.x, OUT.vertex.y *scale) + OUT.vertex.w) * 0.5; //only gets what is behind object instead of whole screen project on each face of the object
					OUT.uvgrab.zw = OUT.vertex.zw;
					return OUT;
				}

				

					half4 frag(v2f IN) : COLOR //change texture color
				{
					half4 texcol = tex2Dproj(_GrabTexture, UNITY_PROJ_COORD(IN.uvgrab));
					half4 texsum = half4(0, 0, 0, 0);
					#define GRABPIXEL(weight, kernely) tex2Dproj(_GrabTexture, UNITY_PROJ_COORD(float4(IN.uvgrab.x, IN.uvgrab.y +  _GrabTexture_TexelSize.y * kernely * _BlurRadius,IN.uvgrab.z, IN.uvgrab.w))) * weight;//baiscaly gets pixels average aroudn it kernalx = pixel on x axis
					//pixels on horizontal axis
					texsum += GRABPIXEL(0.05, -4.0);
					texsum += GRABPIXEL(0.09, -3.0);
					texsum += GRABPIXEL(0.12, -3.0);
					texsum += GRABPIXEL(0.15, -1.0);
					texsum += GRABPIXEL(0.18, 0.0);
					texsum += GRABPIXEL(0.15, 1.0);
					texsum += GRABPIXEL(0.12, 2.0);
					texsum += GRABPIXEL(0.09, 3.0);
					texsum += GRABPIXEL(0.05, 4.0);

					texcol = lerp(texcol, texsum, _Intensity);//interpolation between nonblurred and fully blurred
					return texcol;
				}

				ENDCG
			}
		
		}
}