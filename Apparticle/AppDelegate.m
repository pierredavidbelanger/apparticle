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

@interface AppDelegate ()

@property (weak) IBOutlet NSMenu *openPresetMenu;
@property (strong) NSArray<NSString *> *presets;

@end

@implementation AppDelegate

@synthesize window=window_, glView=glView_;

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    [NSColorPanel sharedColorPanel].showsAlpha = YES;
    
    [self populateOpenPresetMenu];
    
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
    [self doSaveFlowWithPromptThenCallback:^(NSModalResponse returnCode) {
        BOOL terminate = returnCode == NSAlertDefaultReturn || returnCode == NSAlertAlternateReturn;
        [[NSApplication sharedApplication] replyToApplicationShouldTerminate:terminate];
    }];
    return NSTerminateLater;
}

- (void)applicationWillTerminate:(NSNotification *)notification
{
    // http://stackoverflow.com/questions/15932716/cocos2d-mac-shutdown-and-startup-at-runtime
    //[[CCDirector sharedDirector] performSelector:@selector(end) onThread:[[CCDirector sharedDirector] runningThread] withObject:nil waitUntilDone:YES];
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

- (void)reshape:(CGSize)size
{
    [self.stage reshape:size];
}

- (IBAction)open:(id)sender {
    [self doOpenFlowWithPreset:nil thenCallback:^(NSModalResponse returnCode) {
        // ignore return code
    }];
}

- (IBAction)openPreset:(id)sender {
    NSMenuItem *item = sender;
    [self doOpenFlowWithPreset:self.presets[item.tag] thenCallback:^(NSModalResponse returnCode) {
        // ignore return code
    }];
}

- (IBAction)save:(id)sender {
    [self doSaveFlowWithoutPromptThenCallback:^(NSModalResponse returnCode) {
        // ignore return code
    }];
}

- (IBAction)reportAnIssue:(id)sender {
    [NSWorkspace.sharedWorkspace openURL:[NSURL URLWithString:@"https://github.com/pierredavidbelanger/apparticle/issues/new?labels=bug"]];
}

- (IBAction)requestAFeature:(id)sender {
    [NSWorkspace.sharedWorkspace openURL:[NSURL URLWithString:@"https://github.com/pierredavidbelanger/apparticle/issues/new?labels=enhancement"]];
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

#pragma mark AppDelegate - Impl

- (void)populateOpenPresetMenu {
    self.presets = @[@"CCParticleFire", @"CCParticleFireworks", @"CCParticleSun",
                     @"CCParticleGalaxy", @"CCParticleFlower", @"CCParticleMeteor",
                     @"CCParticleSpiral", @"CCParticleExplosion", @"CCParticleSmoke",
                     @"CCParticleSnow", @"CCParticleRain"];
    for (int i = 0; i < self.presets.count; i++) {
        NSMenuItem *item = [[NSMenuItem alloc] initWithTitle:self.presets[i] action:@selector(openPreset:) keyEquivalent:@""];
        item.tag = i;
        [self.openPresetMenu addItem:item];
    }
}


- (void)doSaveToRepresentedURL {
    FileFormatCocos2d *fileFormat = [[FileFormatCocos2d alloc] init];
    [fileFormat writeParticleSystem:self.stage.part toURL:[self.window representedURL]];
    [self.window setDocumentEdited:NO];
    [self.window setTitleWithRepresentedFilename:[[self.window representedURL] path]];
}

- (void)doSaveFlowWithoutPromptThenCallback:(void (^)(NSModalResponse returnCode))callback {
    if (![self.window representedURL]) {
        NSSavePanel *p = [NSSavePanel savePanel];
        p.title = @"Save the current particle system";
        p.allowedFileTypes = @[@"plist"];
        [p beginSheetModalForWindow:self.window completionHandler:^(NSInteger result) {
            if (result == NSFileHandlingPanelOKButton) {
                [self.window setRepresentedURL:p.URL];
                [self doSaveToRepresentedURL];
            }
            callback(NSAlertDefaultReturn);
        }];
    } else {
        [self doSaveToRepresentedURL];
        callback(NSAlertDefaultReturn);
    }
}

- (void)doSaveFlowWithPromptThenCallback:(void (^)(NSModalResponse returnCode))callback {
    NSAlert *alert = [NSAlert alertWithMessageText:@"Save the current particle system?"
                                     defaultButton:@"Save" alternateButton:@"Discard" otherButton:@"Cancel"
                         informativeTextWithFormat:@"You can save or discard the current changes."];
    if ([self.window isDocumentEdited]) {
        [alert beginSheetModalForWindow:self.window completionHandler:^(NSModalResponse returnCode) {
            switch (returnCode) {
                case NSAlertDefaultReturn:
                    [self doSaveFlowWithoutPromptThenCallback:callback];
                    break;
                default:
                    callback(returnCode);
                    break;
            }
        }];
    } else {
        callback(NSAlertDefaultReturn);
    }
}

- (void)doOpenFromRepresentedURL {
    FileFormatCocos2d *fileFormat = [[FileFormatCocos2d alloc] init];
    [fileFormat readParticleSystem:self.stage.part fromURL:[self.window representedURL]];
    [self.window setDocumentEdited:NO];
    [self.window setTitleWithRepresentedFilename:[[self.window representedURL] path]];
}

- (void)doOpenFromPreset:(NSString *)preset {
    FileFormatCocos2d *fileFormat = [[FileFormatCocos2d alloc] init];
    [fileFormat readParticleSystem:self.stage.part fromPreset:preset];
    [self.window setDocumentEdited:NO];
    [self.window setTitle:preset];
}

-(void)doOpenFlowWithPreset:(NSString *)preset thenCallback:(void (^)(NSModalResponse returnCode))callback {
    [self doSaveFlowWithPromptThenCallback:^(NSModalResponse returnCode) {
        if (returnCode == NSAlertDefaultReturn || returnCode == NSAlertAlternateReturn) {
            if (!preset) {
                NSOpenPanel *p = [NSOpenPanel openPanel];
                p.title = @"Open a particle system";
                p.allowedFileTypes = @[@"plist"];
                [p beginSheetModalForWindow:self.window completionHandler:^(NSInteger result) {
                    if (result == NSFileHandlingPanelOKButton) {
                        [self.window setRepresentedURL:p.URL];
                        [self doOpenFromRepresentedURL];
                    }
                }];
            } else {
                [self.window setRepresentedURL:nil];
                [self doOpenFromPreset:preset];
            }
        }
    }];
}

@end
