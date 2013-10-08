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

#import "cocos2d.h"

#import "StageLayer.h"

@interface AppDelegate : NSObject <NSApplicationDelegate, NSSplitViewDelegate>

@property (weak) IBOutlet NSWindow	*window;
@property (weak) IBOutlet CCGLView	*glView;

@property BOOL showStats;

@property (strong) StageLayer *stage;

- (IBAction)toggleFullScreen:(id)sender;

- (IBAction)open:(id)sender;
- (IBAction)save:(id)sender;

- (IBAction)imageDragPerformed:(id)sender;

@end
