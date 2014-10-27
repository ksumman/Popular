//
//  PLImageViewController.m
//  Popular
//
//  Created by Kumar Summan on 10/26/14.
//  Copyright (c) 2014 Kumar Summan. All rights reserved.
//

#import "PLImageViewController.h"
#import "UIColor+Popular.h"

@interface PLImageViewController()

@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UIButton *likeButton;
@property (weak, nonatomic) IBOutlet UILabel *likeCountLabel;

@end

@implementation PLImageViewController

/*--------------------------------------------------------------------------------*/
#pragma mark - ViewController LifeCycle
/*--------------------------------------------------------------------------------*/
-(void) viewDidLoad
{
    [super viewDidLoad];

    self.likeCountLabel.textColor = [UIColor lightGrayColor];
    self.likeCountLabel.text = [self likesCountLabelText: self.mediaItem.likesCount];
    [self.likeCountLabel sizeToFit];

    self.likeButton.layer.cornerRadius = 4.0;
    [self.likeButton setTitle:@"Like" forState:UIControlStateNormal];
    [self.likeButton setTitleColor:[UIColor darkGrayColor] forState: UIControlStateNormal];
    [self.likeButton setTitle:@"Liked" forState:UIControlStateSelected];
    [self.likeButton setTitleColor:[UIColor plThemeColor1] forState:UIControlStateSelected];
    self.likeButton.selected = [_mediaItem likeStatus];

    // Show the low-res image while the standard-res image is being downloaded
    self.imageView.image = [self.mediaItem lowResImage];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        UIImage *standardResImage = [self.mediaItem standardResImage];
        dispatch_sync(dispatch_get_main_queue(), ^{
            self.imageView.image = standardResImage;
        });
    });

    // handle tap to dismiss image-view-controller.
    UIGestureRecognizer *tapGR = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                         action:@selector(handleTap:)];
    [self.view addGestureRecognizer:tapGR];
}


/*--------------------------------------------------------------------------------*/
-(void) dealloc
{
    self.mediaItem = nil;
}

/*--------------------------------------------------------------------------------*/
#pragma mark - MediaItem
/*--------------------------------------------------------------------------------*/
-(void) setMediaItem:(PLMediaItem *)mediaItem
{
    // remove observer from old mediaItem
    [_mediaItem removeObserver:self forKeyPath:@"likesCount"];
    [_mediaItem removeObserver:self forKeyPath:@"likeStatus"];

    _mediaItem = mediaItem;
    self.likeCountLabel.text = [self likesCountLabelText: self.mediaItem.likesCount];
    self.likeButton.selected = [_mediaItem likeStatus];

    // add self as an observer to the likesCount of the media item
    [_mediaItem addObserver:self
                 forKeyPath:@"likesCount"
                    options:NSKeyValueObservingOptionNew
                    context:nil];
    [_mediaItem addObserver:self
                 forKeyPath:@"likeStatus"
                    options:NSKeyValueObservingOptionNew
                    context:nil];
}

/*--------------------------------------------------------------------------------*/
-(NSString *) likesCountLabelText: (NSInteger) likeCount
{
    NSString *likesCountText = [NSString stringWithFormat: @"%ld likes", likeCount];
    return likesCountText;
}


/*--------------------------------------------------------------------------------*/
-(void) observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary *)change
                       context:(void *)context
{
    if([object isEqual: self.mediaItem])
    {
        if([keyPath isEqualToString: @"likesCount"])
        {
            self.likeCountLabel.text = [self likesCountLabelText: self.mediaItem.likesCount];
        }
        else if([keyPath isEqualToString: @"likeStatus"])
        {
            self.likeButton.selected = self.mediaItem.likeStatus;
        }
    }
}

/*--------------------------------------------------------------------------------*/
#pragma mark - Handle Actions
/*--------------------------------------------------------------------------------*/
- (IBAction)likeButtonTapped:(id)sender
{
    self.likeButton.selected = !self.likeButton.selected;
    //    [[PLDataModel defaultDataModel] toggleLikeStatus: self.mediaItem];
}

/*--------------------------------------------------------------------------------*/
-(void) handleTap: (UIGestureRecognizer *) gestureRecognizer
{
    if(gestureRecognizer.state == UIGestureRecognizerStateEnded &&
       gestureRecognizer.numberOfTouches == 1)
    {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

@end
