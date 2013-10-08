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

#import "NamedImageView.h"

@implementation NamedImageView

+ (void)initialize {
    [self exposeBinding:@"fileName"];
}

- (BOOL)performDragOperation:(id<NSDraggingInfo>)sender
{
    BOOL r = [super performDragOperation:sender];
    if (!r) return r;
    NSPasteboard *pboard = [sender draggingPasteboard];
    NSString *plist = [pboard stringForType:NSFilenamesPboardType];
    if (!plist) return r;
    NSArray *filePaths = [NSPropertyListSerialization propertyListFromData:[plist dataUsingEncoding:NSUTF8StringEncoding]
                                                          mutabilityOption:NSPropertyListImmutable
                                                                    format:nil
                                                          errorDescription:nil];
    if (!filePaths || [filePaths count] < 1) return r;
    NSString *filePath = filePaths[0];
    self.fileName = [filePath lastPathComponent];
    return r;
}

- (void)delete:(id)sender
{
}

- (void)cut:(id)sender
{
}

@end
