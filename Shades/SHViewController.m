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
#import "SHViewController.h"
#import "SHGameSceneiOS.h"

@implementation SHViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Configure the view.
    SKView * skView = (SKView *)self.view;
    
    // Create and configure the scene.
    SHTitleSceneiOS * scene = [SHTitleSceneiOS sceneWithSize:skView.bounds.size];
    scene.scaleMode = SKSceneScaleModeResizeFill;
    scene.viewController = self;

    // Present the scene.
    [skView presentScene:scene];
}

- (BOOL)shouldAutorotate
{
    return YES;
}

- (NSUInteger)supportedInterfaceOrientations
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        return UIInterfaceOrientationMaskPortrait;
    } else {
        return UIInterfaceOrientationMaskPortrait;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

@end
