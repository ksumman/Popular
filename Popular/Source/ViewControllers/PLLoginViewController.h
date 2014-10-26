//
//  PLLoginViewController.h
//  Popular
//
//  Created by Kumar Summan on 10/25/14.
//  Copyright (c) 2014 Kumar Summan. All rights reserved.
//

#import <UIKit/UIKit.h>

/*--------------------------------------------------------------------------------*/
@protocol PLLoginDelegate <NSObject>

-(void) loginComplete;

@end

/*--------------------------------------------------------------------------------*/
@interface PLLoginViewController : UIViewController

@property (weak, nonatomic) id<PLLoginDelegate> delegate;

@end
