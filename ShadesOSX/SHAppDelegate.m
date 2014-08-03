//
//  SHAppDelegate.m
//  ShadesOSX
//
//  Created by Nigel Brady on 8/2/14.
//  Copyright (c) 2014 Common Time Games. All rights reserved.
//

#import "SHTitleSceneOSX.h"
#import "SHAppDelegate.h"
#import "SHGameSceneOSX.h"

@implementation SHAppDelegate

@synthesize window = _window;

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    /* Pick a size for the scene */
    SKScene *scene = [SHTitleSceneOSX sceneWithSize:CGSizeMake(1024, 768)];

    /* Set the scale mode to scale to fit the window */
    scene.scaleMode = SKSceneScaleModeAspectFit;

    [self.skView presentScene:scene];
}

- (BOOL)applicationShouldTerminateAfterLastWindowClosed:(NSApplication *)sender {
    return YES;
}

@end
