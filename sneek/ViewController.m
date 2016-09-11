//
//  ViewController.m
//  sneek
//
//  Created by Eamon White on 11/25/15.
//  Copyright © 2015 Eamon White. All rights reserved.
//

#import "ViewController.h"
#import "SignUpController.h"
#import <Parse/Parse.h>
#import "AFHTTPSessionManager.h"
#import "LeaderboardController.h"
#import "Tutorial.h"
#import "RespTutorial.h"

@import GoogleMaps;

typedef void (^CompletionHandlerType)();

@interface ViewController () {
    GMSMapView *mapView_;
    BOOL firstLocationUpdate_;
    bool add;
    CLLocationManager *locationManager;
    UIImageView *image;
    UIButton *respondButton;
    UIButton *xButton;
    UIButton *leaderboard;
    UIButton *leadbut;
    UIButton *tome;
    UIButton *camerabut;
    bool isResponding;
    GMSMarker *staticMarker;
    NSNumber *staticCount;
    UILabel *matchesNumber;
    UILabel *myMatches;
    NSNumber *matched;
    NSString *staticObjectId;
    NSString *newtitle;
    UIView *menu;
    UIView *statusback;
    PFObject *deleteObjectId;
    NSString *letters;
    NSString* r;
    UIAlertController *deviceNotFoundAlertController;
    UIAlertAction *deviceNotFoundAlert;
    UIImagePickerController *picker;
    NSUserDefaults *userdefaults;
    NSArray* placesObjects;
    UILabel *notclose;
    int gotahit;
    Tutorial *first;
    RespTutorial *resptute;
    UILabel *tute;
}

@end

@implementation ViewController {}

- (void)viewDidLoad {
    userdefaults = [NSUserDefaults standardUserDefaults];
    NSNumber *screenWidth = @([UIScreen mainScreen].bounds.size.width);
    
    // Create a GMSCameraPosition that tells the map to display the
    // coordinate -33.86,151.20 at zoom level 6.
    GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:42.36
                                                            longitude:-71.06
                                                                 zoom:8];
    mapView_ = [GMSMapView mapWithFrame:CGRectZero camera:camera];
    mapView_.settings.compassButton = NO;
    mapView_.settings.indoorPicker = YES;
    
    dispatch_async(dispatch_get_main_queue(), ^(void){
        mapView_.myLocationEnabled = YES;
    });
    
    [mapView_ addObserver:self
               forKeyPath:@"myLocation"
                  options:NSKeyValueObservingOptionNew
                  context:NULL];
    
    self.view = mapView_;
    
    mapView_.delegate = self;
    
    NSLog([userdefaults objectForKey:@"new"]);
    
    first = [[Tutorial alloc] init];
    first.myViewController = self;
    first.tag = 99;
    
    if([[[NSString alloc] initWithString:[userdefaults objectForKey:@"new"]] isEqualToString:@"new"]) {
        NSLog(@"in tutu");
        if([screenWidth intValue] == 320) {
            first = [[Tutorial alloc] initWithFrame:CGRectMake(0, 0, 320, 568)];
            resptute = [[RespTutorial alloc] initWithFrame:CGRectMake(0, 0, 320, 568)];
        }
        else if([screenWidth intValue] == 375) {
            first = [[Tutorial alloc] initWithFrame:CGRectMake(0, 0, 375, 667)];
            resptute = [[RespTutorial alloc] initWithFrame:CGRectMake(0, 0, 320, 568)];

        }
        else if([screenWidth intValue] == 414) {
            first = [[Tutorial alloc] initWithFrame:CGRectMake(0, 0, 414, 737)];
            resptute = [[RespTutorial alloc] initWithFrame:CGRectMake(0, 0, 320, 568)];

        }
        else if([screenWidth intValue] == 768) {
            first = [[Tutorial alloc] initWithFrame:CGRectMake(0, 0, 768, 1024)];
            resptute = [[RespTutorial alloc] initWithFrame:CGRectMake(0, 0, 320, 568)];

        }
        else if([screenWidth intValue] == 1024) { //IPAD
            first = [[Tutorial alloc] initWithFrame:CGRectMake(0, 0, 1024, 1366)];
            resptute = [[RespTutorial alloc] initWithFrame:CGRectMake(0, 0, 320, 568)];

        }
        first.backgroundColor = [UIColor colorWithRed:0.0f/255.0f green:0.0f/255.0f blue:0.0f/255.0f alpha:0.4f];
        resptute.backgroundColor = [UIColor colorWithRed:0.0f/255.0f green:0.0f/255.0f blue:0.0f/255.0f alpha:0.4f];

        [self.view addSubview:first];
        [self.view addSubview:resptute];
        [resptute setHidden:YES];
    }
    else {
        PFQuery *query = [PFQuery queryWithClassName:@"MapPoints"];
        [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
            if (!error) {
                for (PFObject *object in objects) {
                    NSLog(@"%@", object.objectId);
                    PFGeoPoint *point = [object objectForKey:@"location"];
                    
                    GMSMarker *initMarker = [GMSMarker markerWithPosition:CLLocationCoordinate2DMake(point.latitude, point.longitude)];
                    initMarker.title = [object valueForKey:@"title"];
                    initMarker.appearAnimation = kGMSMarkerAnimationPop;
                    initMarker.icon = [UIImage imageNamed:@"marker"];
                    initMarker.userData = @{@"marker_id":[object objectForKey:@"marker_id"]};
                    initMarker.map = mapView_;
                }
            }else{
                NSLog([error description]);
            }
        }];
    }
    
    UIActivityIndicatorView *indicator = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    indicator.frame = CGRectMake(0.0, 0.0, 40.0, 40.0);
    indicator.center = self.view.center;
    [self.view addSubview:indicator];
    [indicator bringSubviewToFront:self.view];
    [UIApplication sharedApplication].networkActivityIndicatorVisible = TRUE;

    deviceNotFoundAlert = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
    
    letters  = @"abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXZY0123456789";
    
    tute = [[UILabel alloc] init];
    
    if([screenWidth intValue] == 320) {
        tute.frame = CGRectMake(20, 90, 280, 120);
    }
    else if([screenWidth intValue] == 375) {
        tute.frame = CGRectMake(23, 105, 328, 141);
        
    }
    else if([screenWidth intValue] == 414) {
        tute.frame = CGRectMake(26, 116, 362, 155.5);
    }
    else if([screenWidth intValue] == 768) {
        tute.frame = CGRectMake(48, 161, 671.7, 216.4);
    }
    else if([screenWidth intValue] == 1024) { //IPAD
        tute.frame = CGRectMake(64, 215, 895.6, 288.7);
    }
    
    tute.text = @"TAP THE MARKER, THEN TAP THE INFO WINDOW POPUP";
    tute.numberOfLines = 0;
    tute.textAlignment = NSTextAlignmentCenter;
    [tute setFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:24.0]];
    tute.textColor = [UIColor colorWithRed:0.0f/255.0f green:0.0f/255.0f blue:0.0f/255.0f alpha:1.0f];
    [tute setHidden:YES];
    [self.view addSubview:tute];
    
    
    if([screenWidth intValue] == 320) {
        image = [[UIImageView alloc] initWithFrame:CGRectMake(10, 30, 300, 426)];
        image.layer.cornerRadius = 10.0;
    }
    else if([screenWidth intValue] == 375) {
        image = [[UIImageView alloc] initWithFrame:CGRectMake(10, 30, 355, 500)];
        image.layer.cornerRadius = 10.0;
    }
    else if([screenWidth intValue] == 414) {
        image = [[UIImageView alloc] initWithFrame:CGRectMake(10, 30, 394, 860)];
        image.layer.cornerRadius = 10.0;
    }
    else if([screenWidth intValue] == 768) {
        image = [[UIImageView alloc] initWithFrame:CGRectMake(20, 46, 727, 768)];
        image.layer.cornerRadius = 7.5;
    }
    else if([screenWidth intValue] == 1024) { //IPAD
        image = [[UIImageView alloc] initWithFrame:CGRectMake(27, 60, 969, 1009)];
        image.layer.cornerRadius = 5.0;
    }
    [image setHidden:YES];
    image.layer.masksToBounds = true;
    [self.view addSubview:image];
    
    if([screenWidth intValue] == 320) {
        respondButton = [[UIButton alloc] initWithFrame:CGRectMake(10, 466, 300, 92)];
        respondButton.layer.cornerRadius = 10.0;
        respondButton.titleLabel.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:36.0];


    }
    else if([screenWidth intValue] == 375) {
        respondButton = [[UIButton alloc] initWithFrame:CGRectMake(10, 547, 355, 92)];
        respondButton.layer.cornerRadius = 10.0;
        respondButton.titleLabel.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:36.0];


    }
    else if([screenWidth intValue] == 414) {
        respondButton = [[UIButton alloc] initWithFrame:CGRectMake(10, 900, 392, 170)];
        respondButton.layer.cornerRadius = 10.0;
        respondButton.titleLabel.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:36.0];


    }
    else if([screenWidth intValue] == 768) {
        respondButton = [[UIButton alloc] initWithFrame:CGRectMake(20, 840, 727, 141)];
        respondButton.layer.cornerRadius = 7.5;
        respondButton.titleLabel.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:36.0];

        
    }
    else if([screenWidth intValue] == 1024) { //IPAD
        respondButton = [[UIButton alloc] initWithFrame:CGRectMake(27, 1096, 969, 230)];
        respondButton.layer.cornerRadius = 5.0;
        respondButton.titleLabel.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:72.0];


    }
    respondButton.backgroundColor = [UIColor colorWithRed:156.0f/255.0f green:214.0f/255.0f blue:215.0f/255.0f alpha:1.0f];
    [respondButton setTitle:@"MATCH IT" forState:UIControlStateNormal];
    [respondButton setTitleColor:[UIColor colorWithRed:218.0f/255.0f green:247.0f/255.0f blue:220.0f/255.0f alpha:1.0f] forState:UIControlStateNormal];
    [respondButton addTarget:self action:@selector(openCamera) forControlEvents:UIControlEventTouchUpInside];
    [respondButton setHidden:YES];
    respondButton.layer.masksToBounds = true;
    [self.view addSubview:respondButton];
    
    if([screenWidth intValue] == 320) {
        xButton = [[UIButton alloc] initWithFrame:CGRectMake(292, 23, 25, 25)];
    }
    else if([screenWidth intValue] == 375) {
        xButton = [[UIButton alloc] initWithFrame:CGRectMake(342, 23, 25, 25)];
    }
    else if([screenWidth intValue] == 414) {
        xButton = [[UIButton alloc] initWithFrame:CGRectMake(379, 25, 50, 50)];
    }
    else if([screenWidth intValue] == 768) {
        xButton = [[UIButton alloc] initWithFrame:CGRectMake(734.5, 35, 25, 25)];
    }
    else if([screenWidth intValue] == 1024) { //IPAD
        xButton = [[UIButton alloc] initWithFrame:CGRectMake(983.5, 47, 25, 25)];
    }
    xButton.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"xbutton"]];
    [xButton addTarget:self action:@selector(close) forControlEvents:UIControlEventTouchUpInside];
    [xButton setHidden:YES];
    [self.view addSubview:xButton];
    
    if([screenWidth intValue] == 320) {
        menu = [[UIView alloc] initWithFrame:CGRectMake(58.75, 494, 202.5, 54)];
    }
    else if([screenWidth intValue] == 375) {
        menu = [[UIView alloc] initWithFrame:CGRectMake(86.25, 593, 202.5, 54)];
    }
    else if([screenWidth intValue] == 414) {
        menu = [[UIView alloc] initWithFrame:CGRectMake(104, 654, 205, 73)];
    }
    else if([screenWidth intValue] == 768) {
        menu = [[UIView alloc] initWithFrame:CGRectMake(177, 873, 415, 111)];
    }
    else if([screenWidth intValue] == 1024) { //IPAD
        menu = [[UIView alloc] initWithFrame:CGRectMake(235.5, 1214, 553, 110.5)];
    }
    menu.backgroundColor = [UIColor colorWithRed:156.0f/255.0f green:214.0f/255.0f blue:215.0f/255.0f alpha:0.9f];
    menu.layer.masksToBounds = true;
    menu.layer.cornerRadius = 10.0;
    [self.view addSubview:menu];
    
    if([screenWidth intValue] == 320) {
        leadbut = [[UIButton alloc] initWithFrame:CGRectMake(19, 7, 39.5, 39.5)];
        leadbut.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"leadbut"]];

    }
    else if([screenWidth intValue] == 375) {
        leadbut = [[UIButton alloc] initWithFrame:CGRectMake(19, 7, 39.5, 39.5)];
        leadbut.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"leadbut"]];

    }
    else if([screenWidth intValue] == 414) {
        leadbut = [[UIButton alloc] initWithFrame:CGRectMake(10, 10, 53, 53)];
        leadbut.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"leadbut"]];

    }
    else if([screenWidth intValue] == 768) {
        leadbut = [[UIButton alloc] initWithFrame:CGRectMake(30, 15, 82, 82)];
        leadbut.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"leadbutipadp"]];
        
    }
    else if([screenWidth intValue] == 1024) { //IPAD
        leadbut = [[UIButton alloc] initWithFrame:CGRectMake(52, 14, 82, 82)];
        leadbut.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"leadbutipadp"]];

    }
    
    [leadbut addTarget:self action:@selector(leaderboardOpen) forControlEvents:UIControlEventTouchUpInside];
    [menu addSubview:leadbut];
    
    if([screenWidth intValue] == 320) {
        tome = [[UIButton alloc] initWithFrame:CGRectMake(141.25, 7, 39.5, 39.5)];
        tome.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"tome"]];

    }
    else if([screenWidth intValue] == 375) {
        tome = [[UIButton alloc] initWithFrame:CGRectMake(141.25, 7, 39.5, 39.5)];
        tome.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"tome"]];

    }
    else if([screenWidth intValue] == 414) {
        tome = [[UIButton alloc] initWithFrame:CGRectMake(142.5, 10, 53, 53)];
        tome.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"tome"]];

    }
    else if([screenWidth intValue] == 768) {
        tome = [[UIButton alloc] initWithFrame:CGRectMake(303, 15, 82, 82)];
        tome.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"tomeipadp"]];
        
    }
    else if([screenWidth intValue] == 1024) { //IPAD
        tome = [[UIButton alloc] initWithFrame:CGRectMake(419, 14, 82, 82)];
        tome.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"tomeipadp"]];

    }
    [tome addTarget:self action:@selector(centerloc) forControlEvents:UIControlEventTouchUpInside];
    [menu addSubview:tome];
    
    
    if([screenWidth intValue] == 320) {
        camerabut = [[UIButton alloc] initWithFrame:CGRectMake(78.375, 5.5, 43, 43)];
        camerabut.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"camerabut"]];

    }
    else if([screenWidth intValue] == 375) {
        camerabut = [[UIButton alloc] initWithFrame:CGRectMake(78.375, 5.5, 43, 43)];
        camerabut.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"camerabut"]];

    }
    else if([screenWidth intValue] == 414) {
        camerabut = [[UIButton alloc] initWithFrame:CGRectMake(72, 5.5, 62, 62)];
        camerabut.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"camerabut"]];

    }
    else if([screenWidth intValue] == 768) {
        camerabut = [[UIButton alloc] initWithFrame:CGRectMake(163.5, 11.5, 88, 88)];
        camerabut.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"camerabutipadp"]];
        
    }
    else if([screenWidth intValue] == 1024) { //IPAD
        camerabut = [[UIButton alloc] initWithFrame:CGRectMake(232.5, 11, 88, 88)];
        camerabut.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"camerabutipadp"]];

    }
    
    [camerabut addTarget:self action:@selector(dropSneek) forControlEvents:UIControlEventTouchUpInside];
    [menu addSubview:camerabut];
    
    NSMutableParagraphStyle *style =  [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
    style.alignment = NSTextAlignmentJustified;
    style.firstLineHeadIndent = 5.0f;
    style.headIndent = 5.0f;
    style.tailIndent = -5.0f;
    
    NSAttributedString *attrText = [[NSAttributedString alloc] initWithString:@"MY MATCHES" attributes:@{ NSParagraphStyleAttributeName : style, NSForegroundColorAttributeName : [UIColor colorWithRed:211.0f/255.0f green:243.0f/255.0f blue:219.0f/255.0f alpha:1.0f], NSFontAttributeName : [UIFont fontWithName:@"HelveticaNeue-Bold" size:16.0]}];
    
    if([screenWidth intValue] == 320) {
        myMatches = [[UILabel alloc] initWithFrame:CGRectMake(67.5, 40, 185, 30)];
        myMatches.layer.cornerRadius = 3.0f;

    }
    else if([screenWidth intValue] == 375) {
        myMatches = [[UILabel alloc] initWithFrame:CGRectMake(95, 40, 185, 30)];
        myMatches.layer.cornerRadius = 3.0f;

    }
    else if([screenWidth intValue] == 414) {
        myMatches = [[UILabel alloc] initWithFrame:CGRectMake(105, 44, 204, 33)];
        myMatches.layer.cornerRadius = 3.0f;

    }
    else if([screenWidth intValue] == 768) {
        myMatches = [[UILabel alloc] initWithFrame:CGRectMake(195, 61, 379, 51)];
        myMatches.layer.cornerRadius = 5.5f;
        attrText = [[NSAttributedString alloc] initWithString:@"MY MATCHES" attributes:@{ NSParagraphStyleAttributeName : style, NSForegroundColorAttributeName : [UIColor colorWithRed:211.0f/255.0f green:243.0f/255.0f blue:219.0f/255.0f alpha:1.0f], NSFontAttributeName : [UIFont fontWithName:@"HelveticaNeue-Bold" size:32.0]}];
        
    }
    else if([screenWidth intValue] == 1024) { //IPAD
        myMatches = [[UILabel alloc] initWithFrame:CGRectMake(300, 109, 425, 60)];
        myMatches.layer.cornerRadius = 8.0f;
        attrText = [[NSAttributedString alloc] initWithString:@"MY MATCHES" attributes:@{ NSParagraphStyleAttributeName : style, NSForegroundColorAttributeName : [UIColor colorWithRed:211.0f/255.0f green:243.0f/255.0f blue:219.0f/255.0f alpha:1.0f], NSFontAttributeName : [UIFont fontWithName:@"HelveticaNeue-Bold" size:32.0]}];

    }
    myMatches.backgroundColor = [UIColor colorWithRed:156.0f/255.0f green:214.0f/255.0f blue:215.0f/255.0f alpha:0.9f];
    myMatches.numberOfLines = 0;
    myMatches.layer.masksToBounds = true;
    myMatches.attributedText = attrText;
    [self.view addSubview:myMatches];
    
    if([screenWidth intValue] == 320) {
        matchesNumber = [[UILabel alloc] initWithFrame:CGRectMake(120, 5, 60, 20)];
        matchesNumber.layer.cornerRadius = 3.0f;
        [matchesNumber setFont:[UIFont systemFontOfSize:16]];

    }
    else if([screenWidth intValue] == 375) {
        matchesNumber = [[UILabel alloc] initWithFrame:CGRectMake(120, 5, 60, 20)];
        matchesNumber.layer.cornerRadius = 3.0f;
        [matchesNumber setFont:[UIFont systemFontOfSize:16]];

    }
    else if([screenWidth intValue] == 414) {
        matchesNumber = [[UILabel alloc] initWithFrame:CGRectMake(120, 7, 77, 20)];
        matchesNumber.layer.cornerRadius = 3.0f;
        [matchesNumber setFont:[UIFont systemFontOfSize:16]];

    }
    else if([screenWidth intValue] == 768) {
        matchesNumber = [[UILabel alloc] initWithFrame:CGRectMake(229, 6, 144.5, 39)];
        matchesNumber.layer.cornerRadius = 3.0f;
        [matchesNumber setFont:[UIFont systemFontOfSize:32]];
        
    }
    else if([screenWidth intValue] == 1024) { //IPAD
        matchesNumber = [[UILabel alloc] initWithFrame:CGRectMake(228, 10, 189, 41)];
        matchesNumber.layer.cornerRadius = 8.0f;
        [matchesNumber setFont:[UIFont systemFontOfSize:32]];

    }
    matchesNumber.backgroundColor = [UIColor colorWithRed:211.0f/255.0f green:243.0f/255.0f blue:219.0f/255.0f alpha:1.0f];
    matchesNumber.textAlignment = NSTextAlignmentCenter;
    matchesNumber.textColor = [UIColor colorWithRed:156.0f/255.0f green:214.0f/255.0f blue:215.0f/255.0f alpha:1.0f];
    matchesNumber.layer.masksToBounds = true;
    
    if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])  {
        //
    }
    else {
        picker = [[UIImagePickerController alloc] init];
        picker.delegate = self;
        picker.modalPresentationStyle = UIModalPresentationCurrentContext;
        picker.sourceType = UIImagePickerControllerSourceTypeCamera;
        self.imagePickerController = picker;
    }
    
    NSUInteger matches = [userdefaults integerForKey:@"matches"];
    matchesNumber.text = [[NSString alloc] initWithFormat:@"%lu", (unsigned long)matches];
    [myMatches addSubview:matchesNumber];
    
    if([screenWidth intValue] == 320) {
        statusback = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 20)];
    }
    else if([screenWidth intValue] == 375) {
        statusback = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 375, 20)];
    }
    else if([screenWidth intValue] == 414) {
        statusback = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 414, 20)];
    }
    else if([screenWidth intValue] == 768) {
        statusback = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 768, 20)];
    }
    else if([screenWidth intValue] == 1024) { //IPAD
        statusback = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 1024, 20)];
    }
    statusback.backgroundColor = [UIColor colorWithRed:156.0f/255.0f green:214.0f/255.0f blue:215.0f/255.0f alpha:1.0f];
    [self.view addSubview:statusback];
    
    notclose = [[UILabel alloc] init];
    notclose.textAlignment = NSTextAlignmentCenter;
    
    if([screenWidth intValue] == 320) {
        [notclose setFrame:CGRectMake(10, 466, 300, 92)];
        notclose.layer.cornerRadius = 10.0;
        [notclose setFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:14.0]];
        
        
    }
    else if([screenWidth intValue] == 375) {
        [notclose setFrame:CGRectMake(10, 547, 355, 92)];
        notclose.layer.cornerRadius = 10.0;
        [notclose setFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:14.0]];
        
        
    }
    else if([screenWidth intValue] == 414) {
        [notclose setFrame:CGRectMake(10, 900, 392, 170)];
        notclose.layer.cornerRadius = 10.0;
        [notclose setFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:14.0]];
        
        
    }
    else if([screenWidth intValue] == 768) {
        [notclose setFrame:CGRectMake(20, 840, 727, 141)];
        notclose.layer.cornerRadius = 7.5;
        [notclose setFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:14.0]];
        
        
    }
    else if([screenWidth intValue] == 1024) { //IPAD
        [notclose setFrame:CGRectMake(27, 1096, 969, 230)];
        notclose.layer.cornerRadius = 5.0;
        [notclose setFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:28.0]];
        
        
    }

    notclose.backgroundColor = [UIColor colorWithRed:156.0f/255.0f green:214.0f/255.0f blue:215.0f/255.0f alpha:1.0f];
    [notclose setText:@"YOU NEED TO BE WITHIN 300 FEET"];
    notclose.textColor = [UIColor colorWithRed:218.0f/255.0f green:247.0f/255.0f blue:220.0f/255.0f alpha:1.0f];
    [notclose setHidden:YES];
    notclose.layer.masksToBounds = true;
    [self.view addSubview:notclose];
    
    if([[[NSString alloc] initWithString:[userdefaults objectForKey:@"new"]] isEqualToString:@"new"]) {
        [self.view bringSubviewToFront:first];
    }
}

- (void)leaderboardOpen {
    [self presentViewController:[[LeaderboardController alloc] init] animated:YES completion:nil];
}

- (void)centerloc {
    CLLocation *location = mapView_.myLocation;
    if (location) {
        [mapView_ animateToLocation:location.coordinate];
    }
}

- (void)mapView:(GMSMapView *)mapView didTapInfoWindowOfMarker:(GMSMarker *)marker {
    
    dispatch_async(dispatch_get_main_queue(), ^(void){
        [matchesNumber setHidden:YES];
        [myMatches setHidden:YES];
        [menu setHidden:YES];
        [tute setHidden:YES];
    });
    
    gotahit = 0;
    
    staticMarker = marker;
    
    NSLog(@"****gettingtapped****");
    //NSLog([marker.userData objectForKey:@"marker_id"]);
    
    UIActivityIndicatorView *indicator = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    indicator.frame = CGRectMake(0.0, 0.0, 40.0, 40.0);
    indicator.center = self.view.center;
    [self.view addSubview:indicator];
    [indicator bringSubviewToFront:self.view];
    [UIApplication sharedApplication].networkActivityIndicatorVisible = TRUE;
    
    //AREA CHECK
    
    // User's location
    PFGeoPoint *userGeoPoint = [PFGeoPoint geoPointWithLatitude:mapView.myLocation.coordinate.latitude longitude:mapView.myLocation.coordinate.longitude];
    // Create a query for places
    PFQuery *querygeo = [PFQuery queryWithClassName:@"MapPoints"];
    // Interested in locations near user.
    [querygeo whereKey:@"location" nearGeoPoint:userGeoPoint withinMiles:0.0568];
    // Limit what could be a lot of points.
    querygeo.limit = 10;
    // Final list of objects
    
    [querygeo findObjectsInBackgroundWithBlock:^(NSArray * _Nullable objects, NSError * _Nullable error) {
       //placesObjects = [[NSArray alloc] initWithArray:objects];

        for(PFGeoPoint* object in objects) {
            NSLog (@"**** location location ****");
            NSLog ([[object valueForKey:@"location"] description]);
            
            PFGeoPoint *storin = [object valueForKey:@"location"];
            NSLog(@"****storin****");
            NSLog([[NSString alloc] initWithFormat:@"%f", storin.latitude]);
            NSLog([[NSString alloc] initWithFormat:@"%f", storin.longitude]);
            
            #define fequal(a,b) (fabs((a) - (b)) < FLT_EPSILON)
            
            if(fequal((float)storin.latitude, (float)marker.position.latitude) && fequal((float)storin.longitude, (float)marker.position.longitude))  {
                
                gotahit = 1;
                
                PFQuery *query = [PFQuery queryWithClassName:@"MapPoints"];
                [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
                    if (!error) {
                        for (PFObject *object in objects) {
                            NSLog(@"%@", object.objectId);
                            deleteObjectId = object;
                            
                            if([[object valueForKey:@"title"] isEqualToString:marker.title] && [[[NSString alloc] initWithFormat:@"%@", [marker.userData objectForKey:@"marker_id"]] isEqualToString:[[NSString alloc] initWithFormat:@"%@", [object objectForKey:@"marker_id"]]]) {
                                
                                staticObjectId = [object valueForKey:@"marker_id"];
                                staticCount = [object valueForKey:@"count"];
                                
                                PFQuery *query = [PFQuery queryWithClassName:@"MapPoints"];
                                [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
                                    if (!error) {
                                        NSLog(@"ran query");
                                        for (PFObject *object in objects) {
                                            if([[object valueForKey:@"marker_id"] isEqualToString:staticObjectId]) {
                                                //PFObject *object = [objects firstObject];
                                                NSLog(@"%@ ***** OBJECT ID", object.objectId);
                                                newtitle = [object valueForKey:@"title"];
                                                NSLog(@"***newtitle****");
                                                NSLog(newtitle);
                                            }
                                        }
                                        
                                    }else{
                                        NSLog([error description]);
                                    }
                                }];
                                
                                NSString * downloadURL = @"http://www.eamondev.com/sneekback/getimage.php";
                                NSLog(@"downloadImageURL: %@", downloadURL);
                                
                                NSString *queryStringss = [NSString stringWithFormat:@"%@", downloadURL];
                                queryStringss = [queryStringss stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
                                
                                _manager = [AFHTTPSessionManager manager];
                                _manager.responseSerializer=[AFJSONResponseSerializer serializerWithReadingOptions:NSJSONReadingAllowFragments];
                                _manager.responseSerializer.acceptableContentTypes = [_manager.responseSerializer.acceptableContentTypes setByAddingObject:@"text/html"];
                                _manager.responseSerializer.acceptableContentTypes = [_manager.responseSerializer.acceptableContentTypes setByAddingObject:@"text/plain"];
                                
                                NSString *usernameEncoded = marker.title;
                                
                                NSDictionary *params = @{@"username": usernameEncoded, @"count": [object valueForKey:@"count"]};
                                
                                [indicator startAnimating];
                                
                                [_manager POST:@"http://www.eamondev.com/sneekback/getimage.php" parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                                    
                                    
                                    
                                    NSLog([responseObject description]);
                                    
                                    NSData *decodedData = [[NSData alloc] initWithBase64EncodedString:responseObject[@"image"] options:0];
                                    image.image = [UIImage imageWithData:decodedData scale:300/2448];
                                    dispatch_async(dispatch_get_main_queue(), ^(void){
                                        [image setHidden:NO];
                                        [respondButton setHidden:NO];
                                        [xButton setHidden:NO];
                                    });
                                    
                                    if([[[NSString alloc] initWithString:[userdefaults objectForKey:@"new"]] isEqualToString:@"new"]) {
                                        NSLog(@"in tutu");
                                        dispatch_async(dispatch_get_main_queue(), ^(void){

                                            [resptute setHidden:NO];
                                            [self.view bringSubviewToFront:resptute];
                                            
                                        });
                                    }
                                    
                                    [indicator stopAnimating];
                                    
                                } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                                    deviceNotFoundAlertController = [UIAlertController alertControllerWithTitle:@"HMMM" message:@"Maybe your connection is bad" preferredStyle:UIAlertControllerStyleAlert];
                                    
                                    [deviceNotFoundAlertController addAction:deviceNotFoundAlert];
                                    NSLog(@"Error: %@", error);
                                    [indicator stopAnimating];
                                }];
                            }
                            else {
                                NSLog(@"*** something not matching  ***");
                            }
                        }
                    }else{
                        NSLog([error description]);
                    }
                }];
                
            }
            else {

                //
                NSLog(@"**** IN ELSE IN ELSE ****");
                
            }
        }
        
        NSLog([[NSString alloc] initWithFormat:@"%i", gotahit]);
        
        if(gotahit == 0) {
            
            
            //deviceNotFoundAlertController = [UIAlertController alertControllerWithTitle:@"ALMOST THERE" message:@"You need to get closer." preferredStyle:UIAlertControllerStyleAlert];
            //[deviceNotFoundAlertController addAction:deviceNotFoundAlert];
            
            PFQuery *query = [PFQuery queryWithClassName:@"MapPoints"];
            [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
                if (!error) {
                    for (PFObject *object in objects) {
                        NSLog(@"%@", object.objectId);
                        deleteObjectId = object;
                        
                        if([[object valueForKey:@"title"] isEqualToString:marker.title] && [[[NSString alloc] initWithFormat:@"%@", [marker.userData objectForKey:@"marker_id"]] isEqualToString:[[NSString alloc] initWithFormat:@"%@", [object objectForKey:@"marker_id"]]]) {
                            
                            staticObjectId = [object valueForKey:@"marker_id"];
                            staticCount = [object valueForKey:@"count"];
                            
                            PFQuery *query = [PFQuery queryWithClassName:@"MapPoints"];
                            [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
                                if (!error) {
                                    NSLog(@"ran query");
                                    for (PFObject *object in objects) {
                                        if([[object valueForKey:@"marker_id"] isEqualToString:staticObjectId]) {
                                            //PFObject *object = [objects firstObject];
                                            NSLog(@"%@ ***** OBJECT ID", object.objectId);
                                            newtitle = [object valueForKey:@"title"];
                                            NSLog(@"***newtitle****");
                                            NSLog(newtitle);
                                        }
                                    }
                                    
                                }else{
                                    NSLog([error description]);
                                }
                            }];
                            
                            NSString * downloadURL = @"http://www.eamondev.com/sneekback/getimage.php";
                            NSLog(@"downloadImageURL: %@", downloadURL);
                            
                            NSString *queryStringss = [NSString stringWithFormat:@"%@", downloadURL];
                            queryStringss = [queryStringss stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
                            
                            _manager = [AFHTTPSessionManager manager];
                            _manager.responseSerializer=[AFJSONResponseSerializer serializerWithReadingOptions:NSJSONReadingAllowFragments];
                            _manager.responseSerializer.acceptableContentTypes = [_manager.responseSerializer.acceptableContentTypes setByAddingObject:@"text/html"];
                            _manager.responseSerializer.acceptableContentTypes = [_manager.responseSerializer.acceptableContentTypes setByAddingObject:@"text/plain"];
                            
                            NSString *usernameEncoded = marker.title;
                            
                            NSDictionary *params = @{@"username": usernameEncoded, @"count": [object valueForKey:@"count"]};
                            
                            [indicator startAnimating];
                            
                            
                            
                            [_manager POST:@"http://www.eamondev.com/sneekback/getimage.php" parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                                
                                NSData *decodedData = [[NSData alloc] initWithBase64EncodedString:responseObject[@"image"] options:0];
                                image.image = [UIImage imageWithData:decodedData scale:300/2448];
                                dispatch_async(dispatch_get_main_queue(), ^(void){
                                    [image setHidden:NO];
                                    [respondButton setHidden:YES];
                                    [notclose setHidden:NO];
                                    [xButton setHidden:NO];
                                });
                                
                                if([[[NSString alloc] initWithString:[userdefaults objectForKey:@"new"]] isEqualToString:@"new"]) {
                                    dispatch_async(dispatch_get_main_queue(), ^(void){
                                        [resptute setHidden:NO];
                                    });
                                }
                                
                                [indicator stopAnimating];
                                
                            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                                deviceNotFoundAlertController = [UIAlertController alertControllerWithTitle:@"HMMM" message:@"Maybe your connection is bad" preferredStyle:UIAlertControllerStyleAlert];
                                
                                [deviceNotFoundAlertController addAction:deviceNotFoundAlert];

                                NSLog(@"Error: %@", error);
                                [indicator stopAnimating];
                            }];
                        }
                        else {
                            NSLog(@"*** something not matching  ***");
                        }
                    }
                }else{
                    NSLog([error description]);
                }
            }];
            
        }

    }];
}

- (void)delayForDissapear:(UILabel*)label {
    [label removeFromSuperview];
}

- (void)dealloc {
    [mapView_ removeObserver:self
                  forKeyPath:@"myLocation"
                     context:NULL];
}

- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary *)change
                       context:(void *)context {
    if (!firstLocationUpdate_) {
        // If the first location update has not yet been recieved, then jump to that
        // location.
        firstLocationUpdate_ = YES;
        CLLocation *location = [change objectForKey:NSKeyValueChangeNewKey];
        mapView_.camera = [GMSCameraPosition cameraWithTarget:location.coordinate
                                                         zoom:14];
    }
}

- (void)close {
    dispatch_async(dispatch_get_main_queue(), ^(void){
        [respondButton setHidden:YES];
        [xButton setHidden:YES];
        [image setHidden:YES];
        [notclose setHidden:YES];
        [matchesNumber setHidden:NO];
        [myMatches setHidden:NO];
        [menu setHidden:NO];
    });
}

- (void)openCamera {
    if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        deviceNotFoundAlertController = [UIAlertController alertControllerWithTitle:@"NO DEVICE" message:@"Camera is not available" preferredStyle:UIAlertControllerStyleAlert];
        [deviceNotFoundAlertController addAction:deviceNotFoundAlert];
        [tute removeFromSuperview];
    } else {
        isResponding = true;
        if([[[NSString alloc] initWithString:[userdefaults objectForKey:@"new"]] isEqualToString:@"new"]) {
            dispatch_async(dispatch_get_main_queue(), ^(void){
                [resptute setHidden:YES];
            });
        }
        [self presentViewController:self.imagePickerController animated:YES completion:nil];
    }
}

- (void)dropSneek {
    isResponding = false;
    UIActivityIndicatorView *indicator = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    indicator.frame = CGRectMake(0.0, 0.0, 40.0, 40.0);
    indicator.center = self.view.center;
    [self.view addSubview:indicator];
    [indicator bringSubviewToFront:self.view];
    [UIApplication sharedApplication].networkActivityIndicatorVisible = TRUE;
    
    if([[[NSString alloc] initWithString:[userdefaults objectForKey:@"new"]] isEqualToString:@"new"]) {

        [first removeFromSuperview];        
    }



    if (! [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        deviceNotFoundAlertController = [UIAlertController alertControllerWithTitle:@"NO DEVICE" message:@"Camera is not available" preferredStyle:UIAlertControllerStyleAlert];
        [deviceNotFoundAlertController addAction:deviceNotFoundAlert];
    } else {
        [indicator startAnimating];
    
        [self presentViewController:self.imagePickerController animated:YES completion:^{
            [indicator stopAnimating];
        }];
    }
}

-(NSString *)randomStringWithLength:(int)len {
    
    NSMutableString *randomString = [NSMutableString stringWithCapacity: len];
    
    for (int i=0; i<len; i++) {
        [randomString appendFormat: @"%C", [letters characterAtIndex: arc4random_uniform((int)[letters length])]];
    }
    
    return randomString;
}

- (void)imagePickerController:(UIImagePickerController *)pickery didFinishPickingMediaWithInfo:(NSDictionary *)info {
    UIActivityIndicatorView *indicator = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    indicator.frame = CGRectMake(0.0, 0.0, 40.0, 40.0);
    indicator.center = self.view.center;
    [self.view addSubview:indicator];
    [indicator bringSubviewToFront:self.view];
    [UIApplication sharedApplication].networkActivityIndicatorVisible = TRUE;

    if(!isResponding) {
        
        [indicator startAnimating];
    
        UIImageWriteToSavedPhotosAlbum(info[UIImagePickerControllerOriginalImage], nil, nil, nil);
    
        NSString * uploadURL = @"http://www.eamondev.com/sneekback/upload.php";
        NSLog(@"uploadImageURL: %@", uploadURL);
        NSData *imageData = UIImageJPEGRepresentation(info[UIImagePickerControllerOriginalImage], 0.5);
    
        NSString *queryStringss = [NSString stringWithFormat:@"%@",uploadURL];
        queryStringss = [queryStringss stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
        
        _manager = [AFHTTPSessionManager manager];
        _manager.responseSerializer=[AFJSONResponseSerializer serializerWithReadingOptions:NSJSONReadingAllowFragments];
        _manager.responseSerializer.acceptableContentTypes = [_manager.responseSerializer.acceptableContentTypes setByAddingObject:@"text/html"];
        _manager.responseSerializer.acceptableContentTypes = [_manager.responseSerializer.acceptableContentTypes setByAddingObject:@"text/plain"];
        
        NSString *usernameEncoded = [[userdefaults objectForKey:@"pfuser"] stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
        
        NSDictionary *params = @{@"username": usernameEncoded, @"count": [userdefaults valueForKey:@"count"]};
        
        [pickery dismissViewControllerAnimated:YES completion:NULL];
        
        PFQuery *quer = [PFQuery queryWithClassName:@"MapPoints"];
        [quer findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
            if (!error) {
                r = [[NSString alloc] initWithString:[self randomStringWithLength:8]];
                for (PFObject *object in objects) {
                    while([r isEqualToString:[[NSString alloc] initWithFormat:@"%@", [object objectForKey:@"marker_id"]]]) {
                        r = [[NSString alloc] initWithString:[self randomStringWithLength:8]];
                    }
                }
            }
            else {
                NSLog(@"*** SOMETHING IS WRONG ***");
                NSLog([error description]);
            }
        }];

        [_manager POST:@"http://www.eamondev.com/sneekback/upload.php" parameters:params constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
            [formData appendPartWithFileData:imageData name:@"file" fileName:@"file.jpg" mimeType:@"image/jpeg"];
        } progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            
            NSLog(@"Success: ***** %@", responseObject);
            NSUInteger count = [userdefaults integerForKey:@"count"];
            NSNumber *stored = [NSNumber numberWithInteger:count];
            count++;
            [userdefaults setInteger:count forKey:@"count"];
            
            add = true;
            
            PFQuery *query = [PFQuery queryWithClassName:@"MapPoints"];
            [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
                if (!error) {
                    for (PFObject *object in objects) {
                        NSLog(@"%@", object.objectId);
                        if(mapView_.myLocation.coordinate.latitude == [[object objectForKey:@"location"] latitude] && mapView_.myLocation.coordinate.longitude == [[object objectForKey:@"location"] longitude]) {
                            
                            add = false;
                        }
                    }
                    
                }else{
                    NSLog([error description]);
                }
            }];
            
            if(add) {
                
                matched = [[NSNumber alloc] initWithBool:NO];
                
                PFGeoPoint *point = [PFGeoPoint geoPointWithLatitude:mapView_.myLocation.coordinate.latitude longitude:mapView_.myLocation.coordinate.longitude];
                
                PFObject *pointstore = [PFObject objectWithClassName:@"MapPoints"];
                pointstore[@"title"] = [userdefaults objectForKey:@"pfuser"];
                pointstore[@"location"] = point;
                pointstore[@"count"] = stored;
                pointstore[@"matched"] = matched;
                pointstore[@"marker_id"] = r;
                
                [pointstore saveEventually:^(BOOL succeeded, NSError *error) {
                    
                    if (error) {
                        NSLog(@"Error");
                    }
                    else {
                        GMSMarker *marker3 = [[GMSMarker alloc] init];
                        marker3.position = mapView_.myLocation.coordinate;
                        marker3.title = [userdefaults objectForKey:@"pfuser"];
                        marker3.icon = [UIImage imageNamed:@"marker"];
                        marker3.userData = @{@"marker_id":r};
                        marker3.map = mapView_;
                    }
                }];
                
                
                [[PFInstallation currentInstallation] setObject:[PFUser currentUser] forKey:@"user"];
                [[PFInstallation currentInstallation] saveEventually];
                
                [indicator stopAnimating];
                
                if([[[NSString alloc] initWithString:[userdefaults objectForKey:@"new"]] isEqualToString:@"new"]) {
                    dispatch_async(dispatch_get_main_queue(), ^(void){
                        [tute setHidden:NO];
                    });
                }
            }
            else {
                [indicator stopAnimating];
                deviceNotFoundAlertController = [UIAlertController alertControllerWithTitle:@"PLEASE MOVE A LITTLE" message:@"Your current location has already been explored!" preferredStyle:UIAlertControllerStyleAlert];
                
                [deviceNotFoundAlertController addAction:deviceNotFoundAlert];
                
                [self presentViewController:deviceNotFoundAlertController animated:NO completion:NULL];
                add = true;
            }
            
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            NSLog(@"Error: %@ *****", error);
            [indicator stopAnimating];
            deviceNotFoundAlertController = [UIAlertController alertControllerWithTitle:@"SORRY" message:@"Either you are taking a nude picture, or your connection is bad" preferredStyle:UIAlertControllerStyleAlert];
            
            [deviceNotFoundAlertController addAction:deviceNotFoundAlert];
            
            [self presentViewController:deviceNotFoundAlertController animated:NO completion:NULL];

            
        }];
        
    }
    else {
        [tute removeFromSuperview];
        
        dispatch_async(dispatch_get_main_queue(), ^(void){
            [myMatches setHidden:YES];
            [matchesNumber setHidden:YES];
        });
        
        UIImageWriteToSavedPhotosAlbum(info[UIImagePickerControllerOriginalImage], nil, nil, nil);
        
        NSString * uploadURL = @"http://www.eamondev.com/sneekback/respond.php";
        NSLog(@"uploadImageURL: %@", uploadURL);
        NSData *imageData = UIImageJPEGRepresentation(info[UIImagePickerControllerOriginalImage], 0.5);
        
        NSString *queryStringss = [NSString stringWithFormat:@"%@",uploadURL];
        queryStringss = [queryStringss stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
        
        _manager = [AFHTTPSessionManager manager];
        _manager.responseSerializer=[AFHTTPResponseSerializer serializer];
        _manager.responseSerializer.acceptableContentTypes = [_manager.responseSerializer.acceptableContentTypes setByAddingObject:@"text/html"];
        _manager.responseSerializer.acceptableContentTypes = [_manager.responseSerializer.acceptableContentTypes setByAddingObject:@"text/plain"];
        
        NSString *usernameEncoded = [[userdefaults objectForKey:@"pfuser"] stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
        
        NSDictionary *params = @{@"username": staticMarker.title, @"challenger": usernameEncoded, @"count": staticCount};
        
        [pickery dismissViewControllerAnimated:YES completion:NULL];
        
        [respondButton setUserInteractionEnabled:NO];
        [respondButton setEnabled:NO];
        [xButton setUserInteractionEnabled:NO];
        [xButton setEnabled:NO];
        [indicator startAnimating];
        
        NSString* chaleng = [userdefaults objectForKey:@"pfuser"];
        
        [_manager POST:@"http://www.eamondev.com/sneekback/respond.php" parameters:params constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
            [formData appendPartWithFileData:imageData name:@"file" fileName:chaleng mimeType:@"image/jpeg"];
        } progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            
            dispatch_async(dispatch_get_main_queue(), ^(void){
                [image setHidden:YES];
                [respondButton setHidden:YES];
                [xButton setHidden:YES];
                [myMatches setHidden:NO];
                [matchesNumber setHidden:NO];
                [menu setHidden:NO];
            });
            
            staticMarker.map = nil;
            
            deviceNotFoundAlertController = [UIAlertController alertControllerWithTitle:@"A MATCH!" message:@"This perspective is no longer, because you matched it!" preferredStyle:UIAlertControllerStyleAlert];
            
            [deviceNotFoundAlertController addAction:deviceNotFoundAlert];
            
            [self presentViewController:deviceNotFoundAlertController animated:NO completion:NULL];
            
            NSUInteger matches = [userdefaults integerForKey:@"matches"];
            matches++;
            [userdefaults setInteger:matches forKey:@"matches"];
            
            matchesNumber.text = [[NSString alloc] initWithFormat:@"%lu", (unsigned long)matches];
            
            PFUser *currentUser = [PFUser currentUser];
            if (currentUser) {
                NSLog(@"there is a current user");
                
                [currentUser setValue:matchesNumber.text forKey:@"matches"];
                
                [currentUser saveInBackground];
            } else {
                [PFUser logInWithUsernameInBackground:[userdefaults objectForKey:@"pfuser"] password:[userdefaults objectForKey:@"pfpass"]
                                                block:^(PFUser *user, NSError *error) {
                                                    if (user) {
                                                        NSLog(@"user logged in");
                                                        
                                                        [user setObject:matchesNumber.text forKey:@"matches"];
                                                        
                                                        [user saveInBackground];
                                                    } else {
                                                        NSLog(@"login failed");
                                                        // The login failed. Check error to see why.
                                                    }
                                                }];
            }
            
            [deleteObjectId deleteInBackground];
            
            PFQuery *sosQuery = [PFUser query];
            [sosQuery whereKey:@"username" equalTo:newtitle];
            sosQuery.limit = 1;
            
            [sosQuery getFirstObjectInBackgroundWithBlock:^(PFObject * _Nullable object, NSError * _Nullable error) {
                [PFCloud callFunctionInBackground:@"sendpush"
                                   withParameters:@{@"user":(PFUser *)object.objectId, @"username":newtitle}];
            }];
            
            
            
            [respondButton setUserInteractionEnabled:YES];
            [respondButton setEnabled:YES];
            [xButton setUserInteractionEnabled:YES];
            [xButton setEnabled:YES];
            [indicator stopAnimating];
            
            if([[[NSString alloc] initWithString:[userdefaults objectForKey:@"new"]] isEqualToString:@"new"]) {
                [userdefaults setObject:@"old" forKey:@"new"];
            }
    
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            NSLog(@"Error: %@", error);
            NSHTTPURLResponse* z = (NSHTTPURLResponse*)task.response;
            NSLog( @"success: %ld", (long)z.statusCode );
            
            if(z.statusCode == 404) {
                deviceNotFoundAlertController = [UIAlertController alertControllerWithTitle:@"NOT A MATCH!" message:@"If at first you don't succeed..." preferredStyle:UIAlertControllerStyleAlert];
                [deviceNotFoundAlertController addAction:deviceNotFoundAlert];
                [self presentViewController:deviceNotFoundAlertController animated:NO completion:NULL];
                
                
                
                [respondButton setUserInteractionEnabled:YES];
                [respondButton setEnabled:YES];
                [xButton setUserInteractionEnabled:YES];
                [xButton setEnabled:YES];
                [indicator stopAnimating];
            }
            else {
                deviceNotFoundAlertController = [UIAlertController alertControllerWithTitle:@"OOPS!" message:@"Something went wrong, try again." preferredStyle:UIAlertControllerStyleAlert];
                [deviceNotFoundAlertController addAction:deviceNotFoundAlert];
                [self presentViewController:deviceNotFoundAlertController animated:NO completion:NULL];
                
                
                
                [respondButton setUserInteractionEnabled:YES];
                [respondButton setEnabled:YES];
                [xButton setUserInteractionEnabled:YES];
                [xButton setEnabled:YES];
                [indicator stopAnimating];
            }
        }];
    }
}


- (void)imagePickerControllerDidCancel:(UIImagePickerController *)pickery {
    if(!isResponding) {
        dispatch_async(dispatch_get_main_queue(), ^(void){
            [matchesNumber setHidden:NO];
            [myMatches setHidden:NO];
        });
    }
    else {
        //
    }
    
    [pickery dismissViewControllerAnimated:YES completion:NULL];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    NSLog(@"*** memory warning ***");
    // Dispose of any resources that can be recreated.
}

@end
