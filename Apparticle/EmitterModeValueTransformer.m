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

#import "EmitterModeValueTransformer.h"

#import "cocos2d.h"

@implementation EmitterModeValueTransformer

- (id)transformedValue:(id)value
{
    NSNumber *n = value;
    switch (n.unsignedIntValue) {
        case kCCParticleModeGravity:
            return @"Gravity";
        case kCCParticleModeRadius:
            return @"Radius";
    }
    return value;
}

- (id)reverseTransformedValue:(id)value
{
    NSString *s = value;
    unsigned int i = kCCParticleModeGravity;
    if ([s isEqualToString:@"Gravity"])
        i = kCCParticleModeGravity;
    else if ([s isEqualToString:@"Radius"])
        i = kCCParticleModeRadius;
    return @(i);
}

@end
