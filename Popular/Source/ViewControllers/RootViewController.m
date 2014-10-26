//
//  ViewController.m
//  Popular
//
//  Created by Kumar Summan on 10/25/14.
//  Copyright (c) 2014 Kumar Summan. All rights reserved.
//

#import "RootViewController.h"
#import "PLDataModel.h"
#import "PLLoginViewController.h"

/*--------------------------------------------------------------------------------*/
@interface RootViewController()<PLLoginDelegate>

@property (strong, nonatomic) PLLoginViewController *loginViewController;

@end

@implementation RootViewController

/*--------------------------------------------------------------------------------*/
- (void)viewDidLoad
{
    [super viewDidLoad];

    self.view.backgroundColor = [UIColor blueColor];

    
    // TODO: check if access token is valid
    
    // if not, show loginViewController
    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main"
                                                             bundle:[NSBundle mainBundle]];
    self.loginViewController = [mainStoryboard instantiateViewControllerWithIdentifier:@"PLLoginViewController"];
    [self addChildViewController:self.loginViewController];
    [self.view addSubview:self.loginViewController.view];
    [self.loginViewController didMoveToParentViewController:self];

    // else show the popular images
}

-(void) showLoginViewController
{
    // if not, show loginViewController
    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main"
                                                             bundle:[NSBundle mainBundle]];
    self.loginViewController = [mainStoryboard instantiateViewControllerWithIdentifier:@"PLLoginViewController"];
    self.loginViewController.delegate = self;

    [self addChildViewController:self.loginViewController];
    [self.view addSubview:self.loginViewController.view];
    [self.loginViewController didMoveToParentViewController:self];
}

/*--------------------------------------------------------------------------------*/
-(void) removeLoginViewController
{
    [self.loginViewController willMoveToParentViewController:nil];
    [self.loginViewController.view removeFromSuperview];
   	[self.loginViewController removeFromParentViewController];
    self.loginViewController = nil;
}

/*--------------------------------------------------------------------------------*/
#pragma mark - PLLoginDelegate Callbacks
/*--------------------------------------------------------------------------------*/
-(void) loginComplete
{
    [self removeLoginViewController];
    
    //TODO: show images
}

@end
