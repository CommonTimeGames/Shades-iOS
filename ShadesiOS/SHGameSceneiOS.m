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
#import <Social/Social.h>
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

-(void)gameOver
{
    [[SHGameCenterManager sharedInstance] submitScore:self.score];
}

-(void)quitGame
{
    [super quitGame];
    SKTransition *reveal = [SKTransition flipVerticalWithDuration:1.0];
    
    // Configure the view.
    SKView * skView = (SKView *)self.view;
    
    // Create and configure the scene.
    SHTitleSceneiOS * scene = [SHTitleSceneiOS sceneWithSize:skView.bounds.size];
    scene.scaleMode = SKSceneScaleModeFill;
    scene.viewController = self.viewController;
    
    [self.view presentScene:scene transition:reveal];
}

-(void)tweet
{
    [self postToSocialNetworkOfType:SLServiceTypeTwitter];
}

-(void)postToFacebook
{
    [self postToSocialNetworkOfType:SLServiceTypeFacebook];
}

-(void)postToSocialNetworkOfType:(NSString *)serviceType
{
    //  Create an instance of the Tweet Sheet
    SLComposeViewController *tweetSheet = [SLComposeViewController
                                           composeViewControllerForServiceType:
                                           serviceType];
    
    // Sets the completion handler.  Note that we don't know which thread the
    // block will be called on, so we need to ensure that any required UI
    // updates occur on the main queue
    tweetSheet.completionHandler = ^(SLComposeViewControllerResult result) {
        switch(result) {
                //  This means the user cancelled without sending the Tweet
            case SLComposeViewControllerResultCancelled:
                NSLog(@"Cancelled tweet...");
                break;
                //  This means the user hit 'Send'
            case SLComposeViewControllerResultDone:
                NSLog(@"Sent tweet!");
                break;
        }
    };
    
    //  Set the initial body of the Tweet
    NSString *text =
    [NSString stringWithFormat:@"I just lasted %d rounds in #Shades!"
     @" What's your high score?", self.score];
    
    [tweetSheet setInitialText:text];
    
    //  Add an URL to the Tweet.  You can add multiple URLs.
    if (![tweetSheet
          addURL:[NSURL URLWithString:@"http://kuroskin.github.io/Shades/shades.html"]]){
        NSLog(@"Unable to add the URL!");
    }
    
    //  Presents the Tweet Sheet to the user
    [self.viewController presentViewController:tweetSheet animated:NO completion:^{
        NSLog(@"Tweet sheet has been presented.");
    }];
}


@end
