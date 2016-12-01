//
//  ViewController.h
//  sneek
//
//  Created by Eamon White on 11/25/15.
//  Copyright © 2015 Eamon White. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AFHTTPSessionManager.h"
@import GoogleMaps;

@interface ViewController : UIViewController <GMSMapViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@property (nonatomic) UIImagePickerController *imagePickerController;

#if TARGET_OS_IPHONE
@property NSMutableDictionary *completionHandlerDictionary;
@property (strong, nonatomic) AFHTTPSessionManager *manager;
@property (strong, nonatomic) GMSMapView *mapView_;

- (NSString *)randomStringWithLength:(int)len;
- (void)dropSneek;
- (void)openCamera;

#endif

@end

