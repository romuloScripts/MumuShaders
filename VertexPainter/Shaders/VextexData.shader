﻿Shader "Vertex Data" {
			    Properties {	_MainTex ("Texture", 2D) = "white" {} } 
				Category {
				Tags { "Queue"="Geometry"}
					Lighting Off
					BindChannels {
					Bind "Color", color
					Bind "Vertex", vertex
					Bind "TexCoord", texcoord
				} 
				SubShader { 
					Pass { 
					SetTexture [_MainTex] { 
						combine primary + primary 
					} 
					} 
				} 
				SubShader { 
					Pass { 
					SetTexture [_MainTex] {
						constantColor (1,1,1,1)
						combine texture lerp(texture) constant
					}
				}
				}
}
}