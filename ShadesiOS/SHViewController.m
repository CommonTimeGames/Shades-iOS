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

#import "SHGameCenterManager.h"
#import "SHGameCenterManagerDelegate.h"
#import "SHTitleSceneiOS.h"
#import "SHViewController.h"
#import "SHGameSceneiOS.h"
#import <GameKit/GameKit.h>
#import <iAd/iAd.h>

@interface SHViewController () <ADBannerViewDelegate, SHGameCenterManagerDelegate>

@property (nonatomic, strong) ADBannerView *banner;

@end

@implementation SHViewController

-(void)viewDidLoad
{
    [super viewDidLoad];

    // Configure the view.
    SKView * skView = (SKView *)self.view;
    
    //Configure Game Center Manager
    SHGameCenterManager *manager = [SHGameCenterManager sharedInstance];
    manager.delegate = self;
    
    //Add iAd banner
    self.banner = [[ADBannerView alloc] initWithFrame:CGRectZero];
    
    self.banner.requiredContentSizeIdentifiers =
        [NSSet setWithObject:ADBannerContentSizeIdentifierPortrait];
    
    self.banner.currentContentSizeIdentifier = ADBannerContentSizeIdentifierPortrait;
    self.banner.delegate = self;
    
    CGRect adFrame = self.banner.frame;
    adFrame.origin.y = self.view.frame.size.height-self.banner.frame.size.height;
    self.banner.frame = adFrame;
    self.banner.hidden = YES;
    
    [skView addSubview:self.banner];

    // Create and configure the scene.
    SHTitleSceneiOS * scene = [SHTitleSceneiOS sceneWithSize:skView.bounds.size];
    scene.scaleMode = SKSceneScaleModeFill;
    scene.viewController = self;

    // Present the scene.
    [skView presentScene:scene];
    [manager signIn];
}

-(BOOL)shouldAutorotate
{
    return YES;
}

-(NSUInteger)supportedInterfaceOrientations
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        return UIInterfaceOrientationMaskPortrait;
    } else {
        return UIInterfaceOrientationMaskPortrait;
    }
}

-(void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

-(void)bannerViewDidLoadAd:(ADBannerView *)banner
{
    banner.hidden = NO;
}

- (void)bannerView:(ADBannerView *)banner didFailToReceiveAdWithError:(NSError *)error
{
    NSLog(@"Failed to receive ad: %@", [error localizedDescription]);
    banner.hidden = YES;
}

-(void)gameCenterManager:(SHGameCenterManager *)manager
needsToAuthenticateWithViewController:(UIViewController *)controller{
    [self presentViewController:controller animated:YES completion:NULL];
}

-(void)gameCenterManager:(SHGameCenterManager *)manager
needsToDismissGameCenterController:(GKGameCenterViewController *)controller
{
    [controller dismissViewControllerAnimated:YES completion:NULL];
}

-(void)gameCenterManager:(SHGameCenterManager *)manager
needsToPresentGameCenterController:(GKGameCenterViewController *)controller
{
    [self presentViewController:controller animated:YES completion:NULL];
}

@end
