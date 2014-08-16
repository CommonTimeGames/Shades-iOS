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

#define kHighScoreDefaultKey @"highScore"
#define kLeaderboardIdentifier @"com.commontimegames.Shades.HighScores"

#import <GameKit/GameKit.h>
#import "SHGameCenterManager.h"

@interface SHGameCenterManager () <GKGameCenterControllerDelegate>

@end

@implementation SHGameCenterManager

+(instancetype)sharedInstance
{
    static SHGameCenterManager *instance = nil;
    
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] init];
    });
    
    return instance;
}

-(void)signIn
{
    GKLocalPlayer *localPlayer = [GKLocalPlayer localPlayer];
    
    localPlayer.authenticateHandler = ^(UIViewController *viewController, NSError *error){
        if (viewController != nil)
        {
            [self.delegate gameCenterManager:self needsToAuthenticateWithViewController:viewController];
        }
    };
}

-(void)submitScore:(int)score
{
    NSInteger highScore =
        [[NSUserDefaults standardUserDefaults]
            integerForKey:kHighScoreDefaultKey];
    
    if(score > highScore){
        [self showBannerWithTitle: @"Congratulations!"
                       andMessage:@"You have a new high score!"];
        
        [[NSUserDefaults standardUserDefaults] setInteger:score
                                                   forKey:kHighScoreDefaultKey];
        
    }
    
    [self submitScoreToGameCenter:score];
}

-(void)showLeaderboard
{
    GKLocalPlayer *player = [GKLocalPlayer localPlayer];
    
    if(!player.isAuthenticated){
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Game Center Unavailable" message:@"Please sign in to Game Center to use leaderboards."
                                                       delegate:nil
                                              cancelButtonTitle:@"Cancel"
                                              otherButtonTitles:nil];
        [alert show];
        return;
    }
    
    GKGameCenterViewController *gameCenterController =
                [[GKGameCenterViewController alloc] init];
    
    if (gameCenterController != nil)
    {
        gameCenterController.gameCenterDelegate = self;
        [self.delegate gameCenterManager:self
      needsToPresentGameCenterController:gameCenterController];
    }
}

-(void)submitScoreToGameCenter:(int)score
{
    GKLocalPlayer *player = [GKLocalPlayer localPlayer];
    
    if(!player.isAuthenticated){
        return;
    }
    
    GKScore *scoreReporter = [[GKScore alloc]
                                initWithLeaderboardIdentifier:kLeaderboardIdentifier];
    scoreReporter.value = score;
    scoreReporter.context = 0;
    
    [GKScore reportScores:@[scoreReporter] withCompletionHandler:^(NSError *error) {
        if(error){
            NSLog(@"Error reporting score: %@", [error localizedDescription]);
        }
    }];
}

-(void)showBannerWithTitle:(NSString *)title andMessage:(NSString *)message;
{
    [GKNotificationBanner showBannerWithTitle:title
                                      message:message
                            completionHandler:NULL];
}

-(void)gameCenterViewControllerDidFinish:(GKGameCenterViewController *)gameCenterViewController
{
    [self.delegate gameCenterManager:self
  needsToDismissGameCenterController:gameCenterViewController];
}

@end
