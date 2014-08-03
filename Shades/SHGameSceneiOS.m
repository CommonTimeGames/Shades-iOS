//
//  SHGameSceneMobile.m
//  Shades
//
//  Created by Nigel Brady on 8/2/14.
//  Copyright (c) 2014 Common Time Games. All rights reserved.
//

#import "SHGameSceneiOS.h"

@implementation SHGameSceneiOS

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    /* Called when a touch begins */
    for (UITouch *touch in touches) {
        CGPoint location = [touch locationInNode:self];
        NSLog(@"Touch location: %.1f, %.1f", location.x, location.y);
        [self userDidTouchLocation:location];
    }
}

@end
