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

#import "AppDelegate.h"

#import "NamedImageView.h"

#import "FileFormatCocos2d.h"

enum {
    SaveBeforeModeNone = 0,
    SaveBeforeModeQuit = 1,
    SaveBeforeModeOpen = 2
};
typedef NSUInteger SaveBeforeMode;

@interface AppDelegate ()

@property SaveBeforeMode saveBeforeMode;

@end

@implementation AppDelegate

@synthesize window=window_, glView=glView_;

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    [NSColorPanel sharedColorPanel].showsAlpha = YES;
    
    self.saveBeforeMode = SaveBeforeModeNone;
    
	CCDirectorMac *director = (CCDirectorMac*) [CCDirector sharedDirector];

	// enable FPS and SPF
	//[director setDisplayStats:YES];
	
	// connect the OpenGL view with the director
	[director setView:glView_];

	// EXPERIMENTAL stuff.
	// 'Effects' don't work correctly when autoscale is turned on.
	// Use kCCDirectorResize_NoScale if you don't want auto-scaling.
	[director setResizeMode:kCCDirectorResize_NoScale];
	
	// Enable "moving" mouse event. Default no.
	[window_ setAcceptsMouseMovedEvents:NO];
	
	// Center main window
	[window_ center];
    [self.window setDocumentEdited:NO];
    
    self.stage = [StageLayer node];
    
    CCScene *scene = [CCScene node];
    [scene addChild:self.stage];
    
    [self.stage.part addObserver:self forKeyPath:@"dirty" options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:nil];
    
    [director runWithScene:scene];
}

- (BOOL)applicationShouldTerminateAfterLastWindowClosed: (NSApplication *) theApplication
{
	return YES;
}

- (NSApplicationTerminateReply)applicationShouldTerminate:(NSApplication *)sender
{
    if (![self.window isDocumentEdited])
        return NSTerminateNow;
    NSAlert *alert = [NSAlert alertWithMessageText:@"Save the current particle system?" defaultButton:@"Save" alternateButton:@"Discard" otherButton:@"Cancel" informativeTextWithFormat:@"You can save or discard the current changes before leaving."];
    [alert beginSheetModalForWindow:self.window modalDelegate:self didEndSelector:@selector(quitAlertDidEnd:returnCode:contextInfo:) contextInfo:nil];
    return NSTerminateLater;
}

- (void)quitAlertDidEnd:(NSAlert *)alert returnCode:(NSInteger)returnCode contextInfo:(void *)contextInfo
{
    switch (returnCode) {
        case NSAlertDefaultReturn:
            self.saveBeforeMode = SaveBeforeModeQuit;
            [self performSelectorOnMainThread:@selector(save:) withObject:self waitUntilDone:NO];
            break;
        case NSAlertAlternateReturn:
            [[NSApplication sharedApplication] replyToApplicationShouldTerminate:YES];
            break;
        case NSAlertOtherReturn:
        default:
            [[NSApplication sharedApplication] replyToApplicationShouldTerminate:NO];
            break;
    }
}

- (void)openAlertDidEnd:(NSAlert *)alert returnCode:(NSInteger)returnCode contextInfo:(void *)contextInfo
{
    switch (returnCode) {
        case NSAlertDefaultReturn:
            self.saveBeforeMode = SaveBeforeModeOpen;
            [self performSelectorOnMainThread:@selector(save:) withObject:self waitUntilDone:NO];
            break;
        case NSAlertAlternateReturn:
            [self.window setDocumentEdited:NO];
            [self performSelectorOnMainThread:@selector(open:) withObject:self waitUntilDone:NO];
            break;
        case NSAlertOtherReturn:
        default:
            break;
    }
}

- (void)applicationWillTerminate:(NSNotification *)notification
{
	[[CCDirector sharedDirector] end];
}

- (BOOL)showStats
{
    CCDirectorMac *director = (CCDirectorMac*) [CCDirector sharedDirector];
    return director.displayStats;
}

- (void)setShowStats:(BOOL)v
{
    CCDirectorMac *director = (CCDirectorMac*) [CCDirector sharedDirector];
    director.displayStats = v;
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    [self.window setDocumentEdited:YES];
}

#pragma mark AppDelegate - IBActions

- (IBAction)toggleFullScreen: (id)sender
{
	CCDirectorMac *director = (CCDirectorMac*) [CCDirector sharedDirector];
	[director setFullScreen: ! [director isFullScreen] ];
}

- (void)doOpen
{
    FileFormatCocos2d *fileFormat = [[FileFormatCocos2d alloc] init];
    [fileFormat readParticleSystem:self.stage.part fromURL:[self.window representedURL]];
    [self.window setDocumentEdited:NO];
    [self.window setTitleWithRepresentedFilename:[[self.window representedURL] path]];
}

- (IBAction)open:(id)sender {
    if ([self.window isDocumentEdited]) {
        NSAlert *alert = [NSAlert alertWithMessageText:@"Save the current particle system?" defaultButton:@"Save" alternateButton:@"Discard" otherButton:@"Cancel" informativeTextWithFormat:@"You can save or discard the current changes before opening an other file."];
        [alert beginSheetModalForWindow:self.window modalDelegate:self didEndSelector:@selector(openAlertDidEnd:returnCode:contextInfo:) contextInfo:nil];
    } else {
        NSOpenPanel *p = [NSOpenPanel openPanel];
        p.title = @"Open a particle system";
        p.allowedFileTypes = @[@"plist"];
        [p beginSheetModalForWindow:self.window completionHandler:^(NSInteger result) {
            if (result == NSFileHandlingPanelOKButton) {
                [self.window setRepresentedURL:p.URL];
                [self doOpen];
            }
        }];
    }
}

- (void)doSave
{
    FileFormatCocos2d *fileFormat = [[FileFormatCocos2d alloc] init];
    [fileFormat writeParticleSystem:self.stage.part toURL:[self.window representedURL]];
    [self.window setDocumentEdited:NO];
    [self.window setTitleWithRepresentedFilename:[[self.window representedURL] path]];
}

- (void)doAfterSave
{
    if (self.saveBeforeMode == SaveBeforeModeQuit) {
        [[NSApplication sharedApplication] replyToApplicationShouldTerminate:YES];
    } else if (self.saveBeforeMode == SaveBeforeModeOpen) {
        //[self open:self];
        [self performSelectorOnMainThread:@selector(open:) withObject:self waitUntilDone:NO];
    }
    self.saveBeforeMode = SaveBeforeModeNone;
}

- (IBAction)save:(id)sender {
    if (![self.window representedURL]) {
        NSSavePanel *p = [NSSavePanel savePanel];
        p.title = @"Save the current particle system";
        p.allowedFileTypes = @[@"plist"];
        [p beginSheetModalForWindow:self.window completionHandler:^(NSInteger result) {
            if (result == NSFileHandlingPanelOKButton) {
                [self.window setRepresentedURL:p.URL];
                [self doSave];
            }
            [self doAfterSave];
        }];
    } else {
        [self doSave];
        [self doAfterSave];
    }
}

- (IBAction)imageDragPerformed:(id)sender {
    NSLog(@"imageDragPerformed:%@", sender);
    NamedImageView *imageView = sender;
    self.stage.part.textureName = imageView.fileName;
}

#pragma mark AppDelegate - NSSplitViewDelegate

- (BOOL)splitView:(NSSplitView *)splitView canCollapseSubview:(NSView *)subview
{
    return NO;
}

- (CGFloat)splitView:(NSSplitView *)splitView constrainMinCoordinate:(CGFloat)proposedMinimumPosition ofSubviewAt:(NSInteger)dividerIndex
{
    return MAX(proposedMinimumPosition, 400);
}

- (CGFloat)splitView:(NSSplitView *)splitView constrainMaxCoordinate:(CGFloat)proposedMaximumPosition ofSubviewAt:(NSInteger)dividerIndex
{
    return MIN(proposedMaximumPosition, splitView.frame.size.width / 2);
}

- (void)splitViewWillResizeSubviews:(NSNotification *)notification
{
    NSDisableScreenUpdates();
}

- (void)splitViewDidResizeSubviews:(NSNotification *)notification
{
    [window_ flushWindow];
    NSEnableScreenUpdates();
}

@end
