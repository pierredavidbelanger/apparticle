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

#import "StageLayer.h"

#import "FileFormatCocos2d.h"

@implementation StageLayer

-(id) init
{
	if (self = [super initWithColor:ccc4(0, 0, 0, 255) fadingTo:ccc4(0, 0, 0, 255)]) {
        CGSize size = [[CCDirector sharedDirector] winSize];
        self.part = [self particleWithTotalParticles:2000];
        FileFormatCocos2d *fileFormat = [[FileFormatCocos2d alloc] init];
        [fileFormat readParticleSystem:self.part fromURL:[[NSBundle mainBundle] URLForResource:@"default" withExtension:@"plist"]];
        self.part.position = ccpMult(ccp(size.width, size.height), 0.5);
        self.part.textureImage = [NSImage imageNamed:@"fire.png"];
        self.part.textureName = @"fire.png";
        [self addChild:self.part];
        self.mouseEnabled = YES;
	}
	return self;
}

- (ParticleSystem *)particleWithTotalParticles:(NSUInteger)totalParticles
{
    return [ParticleSystem particleWithTotalParticles:totalParticles];
}

- (BOOL)ccMouseUp:(NSEvent *)event
{
    self.part.positionType = kCCPositionTypeRelative;
    self.part.position = [[CCDirector sharedDirector] convertEventToGL:event];
    return YES;
}

- (BOOL)ccMouseDragged:(NSEvent *)event
{
    self.part.positionType = kCCPositionTypeFree;
    self.part.position = [[CCDirector sharedDirector] convertEventToGL:event];
    return YES;
}

#pragma mark Tab - Stage

- (NSColor *)layerStartColor
{
    ccColor3B c = self.startColor;
    return [NSColor colorWithDeviceRed:c.r / 255.0f green:c.g / 255.0f blue:c.b / 255.0f alpha:1.0f];
}

- (void)setLayerStartColor:(NSColor *)c
{
    self.startColor = ccc3((GLubyte)(c.redComponent * 255.0f), (GLubyte)(c.greenComponent * 255.0f), (GLubyte)(c.blueComponent * 255.0f));
}

- (NSColor *)layerEndColor
{
    ccColor3B c = self.endColor;
    return [NSColor colorWithDeviceRed:c.r / 255.0f green:c.g / 255.0f blue:c.b / 255.0f alpha:1.0f];
}

- (void)setLayerEndColor:(NSColor *)c
{
    self.endColor = ccc3((GLubyte)(c.redComponent * 255.0f), (GLubyte)(c.greenComponent * 255.0f), (GLubyte)(c.blueComponent * 255.0f));
}

@end
