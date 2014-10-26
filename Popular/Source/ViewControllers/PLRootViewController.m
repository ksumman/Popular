//
//  PLViewController.m
//  Popular
//
//  Created by Kumar Summan on 10/25/14.
//  Copyright (c) 2014 Kumar Summan. All rights reserved.
//

#import "PLRootViewController.h"
#import "PLDataModel.h"
#import "PLLoginViewController.h"
#import "PLMediaCollectionViewController.h"
#import "UIColor+Popular.h"

/*--------------------------------------------------------------------------------*/
@interface PLRootViewController()<PLLoginDelegate>

@property (strong, nonatomic) PLLoginViewController *loginViewController;
@property (strong, nonatomic) PLMediaCollectionViewController *mediaCollectionViewController;

@end

@implementation PLRootViewController

/*--------------------------------------------------------------------------------*/
- (void)viewDidLoad
{
    [super viewDidLoad];

    self.view.backgroundColor = [UIColor plLightGrayColor];

    // TODO: check if access token is valid

    // if not, show loginViewController
//    [self showLoginViewController];


    // else show the popular images
    [self showMediaCollectionViewController];
}

/*--------------------------------------------------------------------------------*/
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
-(void) showMediaCollectionViewController
{
    // if not, show loginViewController
    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main"
                                                             bundle:[NSBundle mainBundle]];
    self.mediaCollectionViewController = [mainStoryboard instantiateViewControllerWithIdentifier:@"PLMediaCollectionViewController"];

    [self addChildViewController:self.mediaCollectionViewController];
    [self.view addSubview:self.mediaCollectionViewController.view];
    [self.mediaCollectionViewController didMoveToParentViewController:self];
}

/*--------------------------------------------------------------------------------*/
#pragma mark - PLLoginDelegate Callbacks
/*--------------------------------------------------------------------------------*/
-(void) loginComplete
{
    [self removeLoginViewController];
    [self showMediaCollectionViewController];
}

@end
