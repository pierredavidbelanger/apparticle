//
// Apparticle
// http://apparticle.pjer.ca
//
// Created by Pierre-David Bélanger <pierredavidbelanger@gmail.com>
// Copyright (c) 2013 PjEr.ca. All rights reserved.
//
// This file is part of Apparticle.
//
// Apparticle is free software: you can redistribute it and/or modify
// it under the terms of the GNU General Public License as published by
// the Free Software Foundation, either version 3 of the License, or
// (at your option) any later version.
//
// Apparticle is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU General Public License for more details.
//
// You should have received a copy of the GNU General Public License
// along with Apparticle.  If not, see <http://www.gnu.org/licenses/>.
//

#import "FileFormatCocos2d.h"

#import "NSData+Base64.h"
#import "GZIP.h"

@implementation FileFormatCocos2d

- (void)writeParticleSystem:(ParticleSystem *)part toURL:(NSURL *)url
{
    NSMutableDictionary *d = [NSMutableDictionary dictionary];
    
    d[@"maxParticles"] = @(part.totalParticles);
    
    d[@"emissionRate"] = @(part.emissionRate);
    
    d[@"duration"] = @(part.duration);
    
    d[@"sourcePositionx"] = @(part.position.x);
    d[@"sourcePositiony"] = @(part.position.y);
    d[@"sourcePositionVariancex"] = @(part.posVar.x);
    d[@"sourcePositionVariancey"] = @(part.posVar.y);
    
    d[@"particleLifespan"] = @(part.life);
    d[@"particleLifespanVariance"] = @(part.lifeVar);
    
    d[@"angle"] = @(part.angle);
    d[@"angleVariance"] = @(part.angleVar);
    
    d[@"startParticleSize"] = @(part.startSize);
    d[@"startParticleSizeVariance"] = @(part.startSizeVar);
    d[@"finishParticleSize"] = @(part.endSize);
    d[@"finishParticleSizeVariance"] = @(part.endSizeVar);
    
    d[@"rotationStart"] = @(part.startSpin);
    d[@"rotationStartVariance"] = @(part.startSpinVar);
    d[@"rotationEnd"] = @(part.endSpin);
    d[@"rotationEndVariance"] = @(part.endSpinVar);
    
    d[@"emitterType"] = @(part.emitterMode);
    
    if ([part isModeGravity]) {
        
        d[@"gravityx"] = @(part.gravity.x);
        d[@"gravityy"] = @(part.gravity.y);
        
        d[@"speed"] = @(part.speed);
        d[@"speedVariance"] = @(part.speedVar);
        
        d[@"radialAcceleration"] = @(part.radialAccel);
        d[@"radialAccelVariance"] = @(part.radialAccelVar);
        
        d[@"tangentialAcceleration"] = @(part.tangentialAccel);
        d[@"tangentialAccelVariance"] = @(part.tangentialAccelVar);
        
    } else if ([part isModeRadius]) {
        
        d[@"maxRadius"] = @(part.startRadius);
        d[@"maxRadiusVariance"] = @(part.startRadiusVar);
        
        d[@"minRadius"] = @(part.endRadius);
        d[@"minRadiusVariance"] = @(part.endRadiusVar);
        
        d[@"rotatePerSecond"] = @(part.rotatePerSecond);
        d[@"rotatePerSecondVariance"] = @(part.rotatePerSecondVar);
        
    }
    
    d[@"textureFileName"] = part.textureName;
    
    if (part.textureEmbedded) {
        
        d[@"textureImageData"] = [[[part.textureImage TIFFRepresentation] gzippedData] base64Encoding_xcd];
        
    } else {
    
        NSString *folder = [[url path] stringByDeletingLastPathComponent];
        NSString *textureFileName = [folder stringByAppendingPathComponent:part.textureName];
        if (![[NSFileManager defaultManager] fileExistsAtPath:textureFileName]) {
            // todo: save part.textureImage to textureFileName ...
        }
    
    }
    
    d[@"startColorRed"] = @(part.startColor.r);
    d[@"startColorGreen"] = @(part.startColor.g);
    d[@"startColorBlue"] = @(part.startColor.b);
    d[@"startColorAlpha"] = @(part.startColor.a);
    d[@"startColorVarianceRed"] = @(part.startColorVar.r);
    d[@"startColorVarianceGreen"] = @(part.startColorVar.g);
    d[@"startColorVarianceBlue"] = @(part.startColorVar.b);
    d[@"startColorVarianceAlpha"] = @(part.startColorVar.a);
    
    d[@"finishColorRed"] = @(part.endColor.r);
    d[@"finishColorGreen"] = @(part.endColor.g);
    d[@"finishColorBlue"] = @(part.endColor.b);
    d[@"finishColorAlpha"] = @(part.endColor.a);
    d[@"finishColorVarianceRed"] = @(part.endColorVar.r);
    d[@"finishColorVarianceGreen"] = @(part.endColorVar.g);
    d[@"finishColorVarianceBlue"] = @(part.endColorVar.b);
    d[@"finishColorVarianceAlpha"] = @(part.endColorVar.a);
    
    d[@"blendFuncSource"] = @(part.blendFunc.src);
    d[@"blendFuncDestination"] = @(part.blendFunc.dst);
    
    [d writeToURL:url atomically:YES];
}

- (void)readParticleSystem:(ParticleSystem *)part fromURL:(NSURL *)url
{
    CGPoint p;
    ccColor4F c;
    ccBlendFunc b;
    
    NSDictionary *d = [NSDictionary dictionaryWithContentsOfURL:url];
    
    part.totalParticles = [d[@"maxParticles"] floatValue];
    
    part.duration = [d[@"duration"] floatValue];
    
    p.x = [d[@"sourcePositionx"] doubleValue];
    p.y =[d[@"sourcePositiony"] doubleValue];
    part.position = p;
    p.x = [d[@"sourcePositionVariancex"] doubleValue];
    p.y =[d[@"sourcePositionVariancey"] doubleValue];
    part.posVar = p;
    
    part.life = [d[@"particleLifespan"] floatValue];
    part.lifeVar = [d[@"particleLifespanVariance"] floatValue];
    
    if (d[@"emissionRate"])
        part.emissionRate = [d[@"emissionRate"] floatValue];
    else
        part.emissionRate = part.totalParticles / part.life;
    
    part.angle = [d[@"angle"] floatValue];
    part.angleVar = [d[@"angleVariance"] floatValue];
    
    part.startSize = [d[@"startParticleSize"] floatValue];
    part.startSizeVar = [d[@"startParticleSizeVariance"] floatValue];
    part.endSize = [d[@"finishParticleSize"] floatValue];
    part.endSizeVar = [d[@"finishParticleSizeVariance"] floatValue];
    
    part.startSpin = [d[@"rotationStart"] floatValue];
    part.startSpinVar = [d[@"rotationStartVariance"] floatValue];
    part.endSpin = [d[@"rotationEnd"] floatValue];
    part.endSpinVar = [d[@"rotationEndVariance"] floatValue];
    
    part.emitterMode = [d[@"emitterType"] integerValue];
    
    if ([part isModeGravity]) {
        
        p.x = [d[@"gravityx"] doubleValue];
        p.y =[d[@"gravityy"] doubleValue];
        part.gravity = p;
        
        part.speed = [d[@"speed"] floatValue];
        part.speedVar = [d[@"speedVariance"] floatValue];
        
        part.radialAccel = [d[@"radialAcceleration"] floatValue];
        part.radialAccelVar = [d[@"radialAccelVariance"] floatValue];
        
        part.tangentialAccel = [d[@"tangentialAcceleration"] floatValue];
        part.tangentialAccelVar = [d[@"tangentialAccelVariance"] floatValue];
        
    } else if ([part isModeRadius]) {
        
        part.startRadius = [d[@"maxRadius"] floatValue];
        part.startRadiusVar = [d[@"maxRadiusVariance"] floatValue];
        
        part.endRadius = [d[@"minRadius"] floatValue];
        part.endRadiusVar = [d[@"minRadiusVariance"] floatValue];
        
        part.rotatePerSecond = [d[@"rotatePerSecond"] floatValue];
        part.rotatePerSecondVar = [d[@"rotatePerSecondVariance"] floatValue];
        
    }
    
    part.textureName = d[@"textureFileName"];
    
    if (d[@"textureImageData"]) {
        
        part.textureEmbedded = YES;
        
        part.textureImage = [[NSImage alloc] initWithData:[[NSData dataWithBase64Encoding_xcd:[d[@"textureImageData"] description]] gunzippedData]];
        
    } else {
        
        part.textureEmbedded = NO;
        
        NSString *folder = [[url path] stringByDeletingLastPathComponent];
        NSString *textureFileName = [folder stringByAppendingPathComponent:part.textureName];
        if ([[NSFileManager defaultManager] fileExistsAtPath:textureFileName]) {
            part.textureImage = [[NSImage alloc] initWithContentsOfFile:textureFileName];
        }
        
    }
    
    c.r = [d[@"startColorRed"] floatValue];
    c.g = [d[@"startColorGreen"] floatValue];
    c.b = [d[@"startColorBlue"] floatValue];
    c.a = [d[@"startColorAlpha"] floatValue];
    part.startColor = c;
    c.r = [d[@"startColorVarianceRed"] floatValue];
    c.g = [d[@"startColorVarianceGreen"] floatValue];
    c.b = [d[@"startColorVarianceBlue"] floatValue];
    c.a = [d[@"startColorVarianceAlpha"] floatValue];
    part.startColorVar = c;
    
    c.r = [d[@"finishColorRed"] floatValue];
    c.g = [d[@"finishColorGreen"] floatValue];
    c.b = [d[@"finishColorBlue"] floatValue];
    c.a = [d[@"finishColorAlpha"] floatValue];
    part.endColor = c;
    c.r = [d[@"finishColorVarianceRed"] floatValue];
    c.g = [d[@"finishColorVarianceGreen"] floatValue];
    c.b = [d[@"finishColorVarianceBlue"] floatValue];
    c.a = [d[@"finishColorVarianceAlpha"] floatValue];
    part.endColorVar = c;
    
    b.src = [d[@"blendFuncSource"] unsignedIntValue];
    b.dst = [d[@"blendFuncDestination"] unsignedIntValue];
    part.blendFunc = b;
}

@end
