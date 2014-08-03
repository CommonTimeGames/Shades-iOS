/*
 #
 # Copyright 2007 Nigel Brady, Konstantin Uroskin
 #
 # Licensed under the Apache License, Version 2.0 (the "License");
 # you may not use this file except in compliance with the License.
 # You may obtain a copy of the License at
 #
 # http://www.apache.org/licenses/LICENSE-2.0
 #
 # Unless required by applicable law or agreed to in writing, software
 # distributed under the License is distributed on an "AS IS" BASIS,
 # WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 # See the License for the specific language governing permissions and
 # limitations under the License.
 
 */
#import "SHTitleSceneiOS.h"
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

-(void)quitGame
{
    SKTransition *reveal = [SKTransition flipVerticalWithDuration:1.0];
    
    // Configure the view.
    SKView * skView = (SKView *)self.view;
    
    // Create and configure the scene.
    SKScene * scene = [SHTitleSceneiOS sceneWithSize:skView.bounds.size];
    scene.scaleMode = SKSceneScaleModeResizeFill;
    
    [self.view presentScene:scene transition:reveal];
}

@end
