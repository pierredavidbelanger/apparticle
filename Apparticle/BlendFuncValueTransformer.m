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

#import "BlendFuncValueTransformer.h"

#import "cocos2d.h"

@implementation BlendFuncValueTransformer

- (id)transformedValue:(id)value
{
    NSNumber *n = value;
    switch (n.unsignedIntValue) {
        case GL_ZERO:
            return @"GL_ZERO";
        case GL_ONE:
            return @"GL_ONE";
        case GL_SRC_COLOR:
            return @"GL_SRC_COLOR";
        case GL_ONE_MINUS_SRC_COLOR:
            return @"GL_ONE_MINUS_SRC_COLOR";
        case GL_SRC_ALPHA:
            return @"GL_SRC_ALPHA";
        case GL_ONE_MINUS_SRC_ALPHA:
            return @"GL_ONE_MINUS_SRC_ALPHA";
        case GL_DST_ALPHA:
            return @"GL_DST_ALPHA";
        case GL_ONE_MINUS_DST_ALPHA:
            return @"GL_ONE_MINUS_DST_ALPHA";
        case GL_DST_COLOR:
            return @"GL_DST_COLOR";
        case GL_ONE_MINUS_DST_COLOR:
            return @"GL_ONE_MINUS_DST_COLOR";
        case GL_SRC_ALPHA_SATURATE:
            return @"GL_SRC_ALPHA_SATURATE";
    }
    return value;
}

- (id)reverseTransformedValue:(id)value
{
    NSString *s = value;
    unsigned int i = GL_ZERO;
    if ([s isEqualToString:@"GL_ZERO"])
        i = GL_ZERO;
    else if ([s isEqualToString:@"GL_ONE"])
        i = GL_ONE;
    else if ([s isEqualToString:@"GL_SRC_COLOR"])
        i = GL_SRC_COLOR;
    else if ([s isEqualToString:@"GL_ONE_MINUS_SRC_COLOR"])
        i = GL_ONE_MINUS_SRC_COLOR;
    else if ([s isEqualToString:@"GL_SRC_ALPHA"])
        i = GL_SRC_ALPHA;
    else if ([s isEqualToString:@"GL_ONE_MINUS_SRC_ALPHA"])
        i = GL_ONE_MINUS_SRC_ALPHA;
    else if ([s isEqualToString:@"GL_DST_ALPHA"])
        i = GL_DST_ALPHA;
    else if ([s isEqualToString:@"GL_ONE_MINUS_DST_ALPHA"])
        i = GL_ONE_MINUS_DST_ALPHA;
    else if ([s isEqualToString:@"GL_DST_COLOR"])
        i = GL_DST_COLOR;
    else if ([s isEqualToString:@"GL_ONE_MINUS_DST_COLOR"])
        i = GL_ONE_MINUS_DST_COLOR;
    else if ([s isEqualToString:@"GL_SRC_ALPHA_SATURATE"])
        i = GL_SRC_ALPHA_SATURATE;
    return @(i);
}

@end
