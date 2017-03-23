//
//  IFLordKelvinFilter.m
//  STFilterTools
//
//  Created by Richard Liu on 15/5/27.
//  Copyright (c) 2015年 深圳食探网络科技有限公司. All rights reserved.


#import "IFLordKelvinFilter.h"

NSString *const kLordKelvinShaderString = SHADER_STRING
(
 precision lowp float;
 
 varying highp vec2 textureCoordinate;
 
 uniform sampler2D inputImageTexture;
 uniform sampler2D inputImageTexture2;
 
 void main()
 {
     vec3 texel = texture2D(inputImageTexture, textureCoordinate).rgb;
     
     vec2 lookup;
     lookup.y = .5;
     
     lookup.x = texel.r;
     texel.r = texture2D(inputImageTexture2, lookup).r;
     
     lookup.x = texel.g;
     texel.g = texture2D(inputImageTexture2, lookup).g;
     
     lookup.x = texel.b;
     texel.b = texture2D(inputImageTexture2, lookup).b;
     
     gl_FragColor = vec4(texel, 1.0);
 }
);

@implementation IFLordKelvinFilter

- (id)init;
{
    if (!(self = [super initWithFragmentShaderFromString:kLordKelvinShaderString]))
    {
		return nil;
    }
    
    return self;
}

@end
