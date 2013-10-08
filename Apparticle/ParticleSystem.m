//
// Apparticle
// http://pjer.ca/apparticle
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

#import "cocos2d.h"

#import "ParticleSystem.h"

#import <objc/runtime.h>

@interface ParticleSystem ()

@property (strong) NSImage *image;

@end

@implementation ParticleSystem

- (id)initWithTotalParticles:(NSUInteger)numberOfParticles
{
    if (self = [super initWithTotalParticles:numberOfParticles]) {
        self.dirty = NO;
    }
    return self;
}

- (void)restart:(ccTime)delta
{
    [self resetSystem];
}

#pragma KVO

+ (NSSet *)keyPathsForValuesAffectingValueForKey:(NSString *)key
{
    NSMutableSet *keys = [[super keyPathsForValuesAffectingValueForKey:key] mutableCopy];
    
    if ([key isEqualToString:@"dirty"]) {
        unsigned int count;
        Class classes[] = {[self class], [CCParticleSystemQuad class], [CCParticleSystem class]};
        for (int j = 0; j < 3; j++) {
            objc_property_t *properties = class_copyPropertyList(classes[j], &count);
            for (size_t i = 0; i < count; i++) {
                NSString *property = [NSString stringWithCString:property_getName(properties[i])
                                                        encoding:NSASCIIStringEncoding];
                if (![property isEqualToString:@"dirty"])
                    [keys addObject: property];
            }
            free(properties);
        }
        
    } else if ([@[@"modeGravity", @"modeRadius",
                  @"gravity", @"gravityX", @"gravityY", @"speed", @"speedVar", @"radialAccel", @"radialAccelVar", @"tangentialAccel", @"tangentialAccelVar",
                  @"startRadius", @"startRadiusVar", @"endRadius", @"endRadiusVar", @"rotatePerSecond", @"rotatePerSecondVar"] containsObject:key]) {
        [keys addObject:@"emitterMode"];
        
    } else if ([key isEqualToString:@"positionVariationX"] || [key isEqualToString:@"positionVariationY"]) {
        [keys addObject:@"posVar"];
        
    } else if ([key isEqualToString:@"gravityX"] || [key isEqualToString:@"gravityY"]) {
        [keys addObject:@"gravity"];
        
    } else if ([key isEqualToString:@"partStartColor"]) {
        [keys addObject:@"startColor"];
        
    } else if ([key hasPrefix:@"startColor"] && [key hasSuffix:@"Variation"]) {
        [keys addObject:@"startColorVar"];
        
    } else if ([key isEqualToString:@"partEndColor"]) {
        [keys addObject:@"endColor"];
        
    } else if ([key hasPrefix:@"endColor"] && [key hasSuffix:@"Variation"]) {
        [keys addObject:@"endColorVar"];
        
    } else if ([key isEqualToString:@"blendSource"] || [key isEqualToString:@"blendDestination"]) {
        [keys addObject:@"blendFunc"];
        
    }
    
    return keys;
}

#pragma mark Mode

- (BOOL)isModeGravity
{
    return self.emitterMode == kCCParticleModeGravity;
}

- (BOOL)isModeRadius
{
    return self.emitterMode == kCCParticleModeRadius;
}

#pragma mark Tab - General

/*
- (void)setTotalParticles:(NSUInteger)v
{
    [self runAction:[CCCallBlock actionWithBlock:^{
        [self willChangeValueForKey:@"totalParticles"];
        [super setTotalParticles:v];
        [self didChangeValueForKey:@"totalParticles"];
    }]];
}
*/

- (void)setDuration:(float)v
{
    [self unschedule:@selector(restart:)];
    [super setDuration:v];
    [self resetSystem];
    if (v > -1) {
        [self schedule:@selector(restart:) interval:v + 0.5f];
    }
}

- (CGFloat)positionVariationX
{
    return self.posVar.x;
}

- (void)setPositionVariationX:(CGFloat)v
{
    self.posVar = ccp(v, self.posVar.y);
}

- (CGFloat)positionVariationY
{
    return self.posVar.y;
}

- (void)setPositionVariationY:(CGFloat)v
{
    self.posVar = ccp(self.posVar.x, v);
}

#pragma mark Tab - Gravity

- (CGFloat)gravityX
{
    return [self isModeGravity] ? self.gravity.x : 0.0f;
}

- (void)setGravityX:(CGFloat)v
{
    if ([self isModeGravity]) self.gravity = ccp(v, self.gravity.y);
}

- (CGFloat)gravityY
{
    return [self isModeGravity] ? self.gravity.y : 0.0f;
}

- (void)setGravityY:(CGFloat)v
{
    self.gravity = ccp(self.gravity.x, v);
}

- (float)speed
{
    return [self isModeGravity] ? [super speed] : 0.0f;
}

- (float)speedVar
{
    return [self isModeGravity] ? [super speedVar] : 0.0f;
}

- (float)radialAccel
{
    return [self isModeGravity] ? [super radialAccel] : 0.0f;
}

- (float)radialAccelVar
{
    return [self isModeGravity] ? [super radialAccelVar] : 0.0f;
}

- (float)tangentialAccel
{
    return [self isModeGravity] ? [super tangentialAccel] : 0.0f;
}

- (float)tangentialAccelVar
{
    return [self isModeGravity] ? [super tangentialAccelVar] : 0.0f;
}

#pragma mark Tab - Radius

- (float)startRadius
{
    return [self isModeRadius] ? [super startRadius] : 0.0f;
}

- (float)startRadiusVar
{
    return [self isModeRadius] ? [super startRadiusVar] : 0.0f;
}

- (float)endRadius
{
    return [self isModeRadius] ? [super endRadius] : 0.0f;
}

- (float)endRadiusVar
{
    return [self isModeRadius] ? [super endRadiusVar] : 0.0f;
}

- (float)rotatePerSecond
{
    return [self isModeRadius] ? [super rotatePerSecond] : 0.0f;
}

- (float)rotatePerSecondVar
{
    return [self isModeRadius] ? [super rotatePerSecondVar] : 0.0f;
}

#pragma mark Tab - Texture & color

- (NSImage *)textureImage
{
    return self.image;
}

- (void)setTextureImage:(NSImage *)v
{
    self.image = v;
    NSString *key = (NSString *)CFBridgingRelease(CFUUIDCreateString(NULL, CFUUIDCreate(NULL)));
    self.texture = [[CCTextureCache sharedTextureCache] addCGImage:[self.image CGImageForProposedRect:Nil context:nil hints:nil] forKey:key];
    [[CCTextureCache sharedTextureCache] removeUnusedTextures];
}

- (NSColor *)ccc4fToColor:(ccColor4F)c
{
    return [NSColor colorWithDeviceRed:c.r green:c.g blue:c.b alpha:c.a];
}

- (NSColor *)partStartColor
{
    return [self ccc4fToColor:self.startColor];
}

- (void)setPartStartColor:(NSColor *)c
{
    self.startColor = ccc4f(c.redComponent, c.greenComponent, c.blueComponent, c.alphaComponent);
}

- (CGFloat)startColorRedVariation
{
    return self.startColorVar.r;
}

- (void)setStartColorRedVariation:(CGFloat)c
{
    self.startColorVar = ccc4f(c, self.startColorVar.g, self.startColorVar.b, self.startColorVar.a);
}

- (CGFloat)startColorGreenVariation
{
    return self.startColorVar.g;
}

- (void)setStartColorGreenVariation:(CGFloat)c
{
    self.startColorVar = ccc4f(self.startColorVar.r, c, self.startColorVar.b, self.startColorVar.a);
}

- (CGFloat)startColorBlueVariation
{
    return self.startColorVar.b;
}

- (void)setStartColorBlueVariation:(CGFloat)c
{
    self.startColorVar = ccc4f(self.startColorVar.r, self.startColorVar.g, c, self.startColorVar.a);
}

- (CGFloat)startColorAlphaVariation
{
    return self.startColorVar.r;
}

- (void)setStartColorAlphaVariation:(CGFloat)c
{
    self.startColorVar = ccc4f(self.startColorVar.r, self.startColorVar.g, self.startColorVar.b, c);
}

- (NSColor *)partEndColor
{
    return [self ccc4fToColor:self.endColor];
}

- (void)setPartEndColor:(NSColor *)c
{
    self.endColor = ccc4f(c.redComponent, c.greenComponent, c.blueComponent, c.alphaComponent);
}

- (CGFloat)endColorRedVariation
{
    return self.endColorVar.r;
}

- (void)setEndColorRedVariation:(CGFloat)c
{
    self.endColorVar = ccc4f(c, self.endColorVar.g, self.endColorVar.b, self.endColorVar.a);
}

- (CGFloat)endColorGreenVariation
{
    return self.endColorVar.g;
}

- (void)setEndColorGreenVariation:(CGFloat)c
{
    self.endColorVar = ccc4f(self.endColorVar.r, c, self.endColorVar.b, self.endColorVar.a);
}

- (CGFloat)endColorBlueVariation
{
    return self.endColorVar.b;
}

- (void)setEndColorBlueVariation:(CGFloat)c
{
    self.endColorVar = ccc4f(self.endColorVar.r, self.endColorVar.g, c, self.endColorVar.a);
}

- (CGFloat)endColorAlphaVariation
{
    return self.endColorVar.r;
}

- (void)setEndColorAlphaVariation:(CGFloat)c
{
    self.endColorVar = ccc4f(self.endColorVar.r, self.endColorVar.g, self.endColorVar.b, c);
}

- (unsigned int)blendSource
{
    return self.blendFunc.src;
}

- (void)setBlendSource:(unsigned int)v
{
    self.blendFunc = (ccBlendFunc){v, self.blendFunc.dst};
}

- (unsigned int)blendDestination
{
    return self.blendFunc.dst;
}

- (void)setBlendDestination:(unsigned int)v
{
    self.blendFunc = (ccBlendFunc){self.blendFunc.src, v};
}

@end
