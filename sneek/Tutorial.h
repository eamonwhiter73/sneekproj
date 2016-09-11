//tutorial.h
#import <UIKit/UIKit.h>
#import "ViewController.h"

@protocol MyViewDelegate
- (void)dropSneek;
@end

@interface Tutorial : UIView <UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@property (weak) ViewController *myViewController; //weak or assign depending if you are using ARC or not, and ViewController should be the class of your view controller

@end