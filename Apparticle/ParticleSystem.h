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

#import "CCParticleSystemQuad.h"

#import "cocos2d.h"

@interface ParticleSystem : CCParticleGalaxy

@property BOOL dirty;

//@property NSUInteger emitterMode;
@property (readonly, getter = isModeGravity) BOOL modeGravity;
@property (readonly, getter = isModeRadius) BOOL modeRadius;

//@property NSUInteger totalParticles;
//@property float duration;
@property CGFloat positionVariationX;
@property CGFloat positionVariationY;

@property CGFloat gravityX;
@property CGFloat gravityY;

@property (strong) NSImage *textureImage;
@property (strong) NSString *textureName;
@property BOOL textureEmbedded;
@property (strong) NSColor *partStartColor;
@property CGFloat startColorRedVariation;
@property CGFloat startColorGreenVariation;
@property CGFloat startColorBlueVariation;
@property CGFloat startColorAlphaVariation;
@property (strong) NSColor *partEndColor;
@property CGFloat endColorRedVariation;
@property CGFloat endColorGreenVariation;
@property CGFloat endColorBlueVariation;
@property CGFloat endColorAlphaVariation;
@property unsigned int blendSource;
@property unsigned int blendDestination;

@end
