//tutorial.h
#import <UIKit/UIKit.h>
#import "ViewController.h"

@protocol MyViewDelegate
- (void)openCamera;
@end

@interface RespTutorial : UIView <UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@property (weak) ViewController *myViewController;

@end