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
#import "AFHTTPRequestOperation.h"
#import "AFHTTPRequestOperationManager.h"
#import "LeaderboardController.h"
@import GoogleMaps;

typedef void (^CompletionHandlerType)();

@interface ViewController ()

@end


@implementation ViewController {
    GMSMapView *mapView_;
    BOOL firstLocationUpdate_;
    bool success;
    bool add;
    CLLocationManager *locationManager;
    UIImageView *image;
    UIButton *respondButton;
    UIButton *xButton;
    UIButton *leaderboard;
    UIButton *leadbut;
    UIButton *tome;
    bool isResponding;
    GMSMarker *staticMarker;
    NSNumber *staticCount;
    UILabel *matchesNumber;
    UILabel *myMatches;
    NSNumber *matched;
    NSString *staticObjectId;
    UIProgressView *progBar;
    UIView *menu;
    UIView *statusback;
}

- (void)viewDidLoad {
    // Create a GMSCameraPosition that tells the map to display the
    // coordinate -33.86,151.20 at zoom level 6.
    GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:42.36
                                                            longitude:-71.06
                                                                 zoom:8];
    mapView_ = [GMSMapView mapWithFrame:CGRectZero camera:camera];
    mapView_.settings.compassButton = NO;
    //mapView_.settings.myLocationButton = YES;
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
                initMarker.map = mapView_;
            }
            
        }else{
            NSLog([error description]);
        }
    }];
    
    progBar = [[UIProgressView alloc] initWithProgressViewStyle:UIProgressViewStyleBar];
    [progBar setFrame:CGRectMake(60, 264, 200, 20)];
    [self.view addSubview:progBar];
    progBar.hidden = YES;
    
    UILabel *instructions1;
    instructions1 = [[UILabel alloc] initWithFrame:CGRectMake(19, 150, 300, 40)];
    instructions1.text = @"TAP SCREEN TO LEAVE SNEEK!";
    instructions1.textColor = [UIColor orangeColor];
    [instructions1 setFont:[UIFont fontWithName:@"Arial-BoldMT" size:18]];
    [self.view addSubview:instructions1];
    
    [self performSelector:@selector(delayForDissapear:) withObject:instructions1 afterDelay:5.0];
    
    UILabel *instructions2;
    instructions2 = [[UILabel alloc] initWithFrame:CGRectMake(19, 190, 300, 40)];
    instructions2.text = @"TAP MARKER TITLE FOR INFO!";
    instructions2.textColor = [UIColor orangeColor];
    [instructions2 setFont:[UIFont fontWithName:@"Arial-BoldMT" size:18.5]];
    [self.view addSubview:instructions2];
    
    [self performSelector:@selector(delayForDissapear:) withObject:instructions2 afterDelay:5.0];
    
    image = [[UIImageView alloc] initWithFrame:CGRectMake(10, 30, 300, 426)];
    [image setHidden:YES];
    image.layer.masksToBounds = true;
    image.layer.cornerRadius = 10.0;
    [self.view addSubview:image];
    
    respondButton = [[UIButton alloc] initWithFrame:CGRectMake(10, 466, 300, 92)];
    respondButton.backgroundColor = [UIColor colorWithRed:156.0f/255.0f green:214.0f/255.0f blue:215.0f/255.0f alpha:1.0f];
    [respondButton setTitle:@"MATCH IT" forState:UIControlStateNormal];
    respondButton.titleLabel.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:24.0];
    [respondButton setTitleColor:[UIColor colorWithRed:218.0f/255.0f green:247.0f/255.0f blue:220.0f/255.0f alpha:1.0f] forState:UIControlStateNormal];
    [respondButton addTarget:self action:@selector(openCamera) forControlEvents:UIControlEventTouchUpInside];
    [respondButton setHidden:YES];
    respondButton.layer.masksToBounds = true;
    respondButton.layer.cornerRadius = 10.0;
    [self.view addSubview:respondButton];
    
    xButton = [[UIButton alloc] initWithFrame:CGRectMake(292, 23, 25, 25)];
    xButton.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"xbutton"]];
    [xButton addTarget:self action:@selector(close) forControlEvents:UIControlEventTouchUpInside];
    [xButton setHidden:YES];
    [self.view addSubview:xButton];
    
    menu = [[UIView alloc] initWithFrame:CGRectMake(92.5, 494, 135, 54)];
    menu.backgroundColor = [UIColor colorWithRed:156.0f/255.0f green:214.0f/255.0f blue:215.0f/255.0f alpha:0.9f];
    menu.layer.masksToBounds = true;
    menu.layer.cornerRadius = 10.0;
    [self.view addSubview:menu];
    
    leadbut = [[UIButton alloc] initWithFrame:CGRectMake(19, 7, 39.5, 39.5)];
    leadbut.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"leadbut"]];
    [leadbut addTarget:self action:@selector(leaderboardOpen) forControlEvents:UIControlEventTouchUpInside];
    [menu addSubview:leadbut];
    
    tome = [[UIButton alloc] initWithFrame:CGRectMake(76, 7, 39.5, 39.5)];
    tome.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"tome"]];
    [tome addTarget:self action:@selector(centerloc) forControlEvents:UIControlEventTouchUpInside];
    [menu addSubview:tome];
    
    /*leaderboard = [[UIButton alloc] initWithFrame:CGRectMake(80, 518, 160, 30)];
    leaderboard.backgroundColor = [UIColor colorWithRed:224.0f/255.0f green:100.0f/255.0f blue:82.0f/255.0f alpha:0.9f];
    [leaderboard addTarget:self action:@selector(leaderboardOpen) forControlEvents:UIControlEventTouchUpInside];
    [leaderboard setTitle:@"LEADERBOARD" forState:UIControlStateNormal];
    leaderboard.layer.masksToBounds = true;
    leaderboard.layer.cornerRadius = 8.0;
    [self.view addSubview:leaderboard];*/
    
    NSMutableParagraphStyle *style =  [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
    style.alignment = NSTextAlignmentJustified;
    style.firstLineHeadIndent = 5.0f;
    style.headIndent = 5.0f;
    style.tailIndent = -5.0f;
    
    NSAttributedString *attrText = [[NSAttributedString alloc] initWithString:@"MY MATCHES" attributes:@{ NSParagraphStyleAttributeName : style, NSForegroundColorAttributeName : [UIColor colorWithRed:211.0f/255.0f green:243.0f/255.0f blue:219.0f/255.0f alpha:1.0f], NSFontAttributeName : [UIFont fontWithName:@"HelveticaNeue-Bold" size:16.0]}];
    
    myMatches = [[UILabel alloc] initWithFrame:CGRectMake(67.5, 40, 185, 30)];
    myMatches.backgroundColor = [UIColor colorWithRed:156.0f/255.0f green:214.0f/255.0f blue:215.0f/255.0f alpha:0.9f];
    myMatches.numberOfLines = 0;
    myMatches.layer.masksToBounds = true;
    myMatches.layer.cornerRadius = 3.0f;
    myMatches.attributedText = attrText;
    [self.view addSubview:myMatches];
    
    matchesNumber = [[UILabel alloc] initWithFrame:CGRectMake(120, 5, 60, 20)];
    matchesNumber.backgroundColor = [UIColor colorWithRed:211.0f/255.0f green:243.0f/255.0f blue:219.0f/255.0f alpha:1.0f];
    matchesNumber.textAlignment = NSTextAlignmentCenter;
    matchesNumber.textColor = [UIColor colorWithRed:156.0f/255.0f green:214.0f/255.0f blue:215.0f/255.0f alpha:1.0f];
    NSUserDefaults *userdefaults = [NSUserDefaults standardUserDefaults];
    NSUInteger matches = [userdefaults integerForKey:@"matches"];
    matchesNumber.text = [[NSString alloc] initWithFormat:@"%lu", (unsigned long)matches];
    [myMatches addSubview:matchesNumber];
    
    statusback = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 20)];
    statusback.backgroundColor = [UIColor colorWithRed:156.0f/255.0f green:214.0f/255.0f blue:215.0f/255.0f alpha:1.0f];
    [self.view addSubview:statusback];
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
        //mapView_.settings.myLocationButton = NO;
        [matchesNumber setHidden:YES];
        [myMatches setHidden:YES];
        [menu setHidden:YES];
    });
    
    staticMarker = marker;
    
    PFQuery *query = [PFQuery queryWithClassName:@"MapPoints"];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            for (PFObject *object in objects) {
                NSLog(@"%@", object.objectId);
                PFGeoPoint *point = [object objectForKey:@"location"];
                NSLog([object valueForKey:@"title"]);
                NSLog(marker.title);
                NSLog([[NSString alloc] initWithFormat:@"%f", marker.position.longitude]);
                NSLog([[NSString alloc] initWithFormat:@"%f", marker.position.latitude]);
                NSLog([[NSString alloc] initWithFormat:@"%f", point.longitude]);
                NSLog([[NSString alloc] initWithFormat:@"%f", point.latitude]);
                
                if([object valueForKey:@"title"]==marker.title && marker.position.latitude == point.latitude && marker.position.longitude == point.longitude) {
                    
                    staticObjectId = object.objectId;
                    staticCount = [object valueForKey:@"count"];
                    
                    NSString * downloadURL = @"http://www.eamondev.com/sneekback/getimage.php";
                    NSLog(@"downloadImageURL: %@", downloadURL);
                    
                    NSString *queryStringss = [NSString stringWithFormat:@"%@", downloadURL];
                    queryStringss = [queryStringss stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
                    _manager = [AFHTTPRequestOperationManager manager];
                    _manager.responseSerializer=[AFJSONResponseSerializer serializerWithReadingOptions:NSJSONReadingAllowFragments];
                    
                    NSString *usernameEncoded = marker.title;
                    
                    NSDictionary *params = @{@"username": usernameEncoded, @"count": [object valueForKey:@"count"]};
                    
                    NSMutableURLRequest *request = [[AFHTTPRequestSerializer serializer] requestWithMethod:@"POST" URLString:downloadURL parameters:params error:&error];
                    
                    AFHTTPRequestOperation *requestOperation = [_manager HTTPRequestOperationWithRequest:request success:^(AFHTTPRequestOperation *operation, id responseObject) {
                        NSLog(@"operation success: %@\n %@", operation, responseObject);
                        
                        NSData *decodedData = [[NSData alloc] initWithBase64EncodedString:responseObject[@"image"] options:0];
                        image.image = [UIImage imageWithData:decodedData scale:300/2448];
                        dispatch_async(dispatch_get_main_queue(), ^(void){
                            [progBar setHidden:YES];
                            [image setHidden:NO];
                            [respondButton setHidden:NO];
                            [xButton setHidden:NO];
                        });
                    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                        NSLog(@"Error: %@", error);
                    }];
                    
                    [requestOperation setDownloadProgressBlock:^(NSUInteger bytesRead, long long totalBytesRead, long long totalBytesExpectedToRead) {
                            progBar.hidden = NO;
                            double percentDone = ((double)totalBytesRead / (double)totalBytesExpectedToRead) * -.000001;
                            NSLog(@"progress updated(percentDone) : %f", percentDone);
                            [progBar setProgress:percentDone];
                    }];
                    
                    [requestOperation start];
                    
                    /*[_manager POST:queryStringss parameters:params success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
                        
                        //CANT GET TO WORK!!!
                        
                        [operation setUploadProgressBlock:^(NSUInteger bytesWritten, long long totalBytesWritten, long long totalBytesExpectedToWrite) {
                            float prog = (totalBytesWritten / (totalBytesExpectedToWrite * 1.0f) * 100);
                            dispatch_async(dispatch_get_main_queue(), ^(void){
                                [progBar setProgress:prog];
                            });
                            NSLog(@"%f%% Uploaded", (totalBytesWritten / (totalBytesExpectedToWrite * 1.0f) * 100));
                        }];
                        
                        NSLog(@"Success: %@ ***** %@", operation.responseString, responseObject);
                                            }
                    failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                        NSLog(@"Error: %@ ***** %@", operation.responseString, error);
                    }];*/
                }
                else {
                    NSLog(@"*** Just looking through pics, no error ***");
                }
            }
        }else{
            NSLog([error description]);
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
        [matchesNumber setHidden:NO];
        [myMatches setHidden:NO];
        [menu setHidden:NO];

    });
}

- (void)openCamera {
    if (! [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        
        UIAlertController *deviceNotFoundAlertController = [UIAlertController alertControllerWithTitle:@"NO DEVICE" message:@"Camera is not available" preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction* deviceNotFoundAlert = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
        
        [deviceNotFoundAlertController addAction:deviceNotFoundAlert];
        
    } else {
        isResponding = true;
        
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.delegate = self;
        picker.modalPresentationStyle = UIModalPresentationCurrentContext;
        picker.sourceType = UIImagePickerControllerSourceTypeCamera;
        self.imagePickerController = picker;
        [self presentViewController:self.imagePickerController animated:YES completion:nil];
    }
}

- (void)mapView:(GMSMapView *)mapView
didTapAtCoordinate:(CLLocationCoordinate2D)coordinate {
    NSLog(@"You tapped at %f,%f", coordinate.latitude, coordinate.longitude);
    
    if (! [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        
        UIAlertController *deviceNotFoundAlertController = [UIAlertController alertControllerWithTitle:@"NO DEVICE" message:@"Camera is not available" preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction* deviceNotFoundAlert = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
        
        [deviceNotFoundAlertController addAction:deviceNotFoundAlert];
        
    } else {
        
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.delegate = self;
        picker.modalPresentationStyle = UIModalPresentationCurrentContext;
        picker.sourceType = UIImagePickerControllerSourceTypeCamera;
        self.imagePickerController = picker;
        [self presentViewController:self.imagePickerController animated:YES completion:nil];
    }
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    if(!isResponding) {
    
        UIImageWriteToSavedPhotosAlbum(info[UIImagePickerControllerOriginalImage], nil, nil, nil);
    
        NSString * uploadURL = @"http://www.eamondev.com/sneekback/upload.php";
        NSLog(@"uploadImageURL: %@", uploadURL);
        NSData *imageData = UIImageJPEGRepresentation(info[UIImagePickerControllerOriginalImage], 0.5);
    
        NSString *queryStringss = [NSString stringWithFormat:@"%@",uploadURL];
        queryStringss = [queryStringss stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
        _manager = [AFHTTPRequestOperationManager manager];
        //manager.responseSerializer.acceptableContentTypes = nil;
        _manager.responseSerializer=[AFJSONResponseSerializer serializerWithReadingOptions:NSJSONReadingAllowFragments];
        _manager.responseSerializer.acceptableContentTypes = [_manager.responseSerializer.acceptableContentTypes setByAddingObject:@"text/html"];
        _manager.responseSerializer.acceptableContentTypes = [_manager.responseSerializer.acceptableContentTypes setByAddingObject:@"text/plain"];
        
        NSUserDefaults *userdefaults = [NSUserDefaults standardUserDefaults];
        
        NSString *usernameEncoded = [[userdefaults objectForKey:@"pfuser"] stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
        
        NSDictionary *params = @{@"username": usernameEncoded, @"count": [userdefaults valueForKey:@"count"]};
        
        [picker dismissViewControllerAnimated:YES completion:NULL];
        
        [_manager POST:queryStringss parameters:params constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
            [formData appendPartWithFileData:imageData name:@"file" fileName:@"file.jpeg" mimeType:@"image/jpeg"];
            }
              success:^(AFHTTPRequestOperation *operation, id responseObject) {
                  NSLog(@"Success: %@ ***** %@", operation.responseString, responseObject);
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
                      
                      GMSMarker *marker3 = [[GMSMarker alloc] init];
                      marker3.position = mapView_.myLocation.coordinate;
                      marker3.title = [userdefaults objectForKey:@"pfuser"];
                      marker3.icon = [UIImage imageNamed:@"marker"];
                      marker3.map = mapView_;
                      
                      PFGeoPoint *point = [PFGeoPoint geoPointWithLatitude:mapView_.myLocation.coordinate.latitude longitude:mapView_.myLocation.coordinate.longitude];
                      
                      PFObject *pointstore = [PFObject objectWithClassName:@"MapPoints"];
                      pointstore[@"title"] = [userdefaults objectForKey:@"pfuser"];
                      pointstore[@"location"] = point;
                      pointstore[@"count"] = stored;
                      pointstore[@"matched"] = matched;
                      
                      [pointstore saveEventually:^(BOOL succeeded, NSError *error) {
                          
                          if (error) {
                              NSLog(@"Error");
                          }
                          else {
                              /*dispatch_async(dispatch_get_main_queue(), ^(void){
                                  mapView_.settings.myLocationButton = YES;
                              });*/
                          }
                      }];
                  }
                  else {
                      UIAlertController *match = [UIAlertController alertControllerWithTitle:@"PLEASE MOVE A LITTLE" message:@"Your current location has already been explored!" preferredStyle:UIAlertControllerStyleAlert];
                      
                      UIAlertAction* matchAlert = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
                      
                      [match addAction:matchAlert];
                      
                      [self presentViewController:match animated:NO completion:NULL];
                      add = true;
                  }
                  
                  isResponding = false;
              }
              failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                  NSLog(@"Error: %@ ***** %@", operation.responseString, error);
                  isResponding = false;
              }];
    }
    else {
        
        dispatch_async(dispatch_get_main_queue(), ^(void){
            [myMatches setHidden:YES];
            [matchesNumber setHidden:YES];
        });
        
        /*PFQuery *query = [PFQuery queryWithClassName:@"MapPoints"];
        [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
            if (!error) {
                for (PFObject *object in objects) {
                    NSLog(@"%@", object.objectId);
                    if([object valueForKey:@"matched"]==[[NSNumber alloc] initWithBool:YES]) {
                        UIAlertController *match = [UIAlertController alertControllerWithTitle:@"ALREADY MATCHED!" message:@"Sorry, someone got to this one first!" preferredStyle:UIAlertControllerStyleAlert];
                        
                        //REMOVE POINT ONCE MATCHED!
                        
                        UIAlertAction* matchAlert = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
                        
                        [match addAction:matchAlert];
                        
                        [self presentViewController:match animated:NO completion:NULL];
                    }
                }
            }
            else {
                NSLog(@"matching error");
            }
        }];*/
        
        UIImageWriteToSavedPhotosAlbum(info[UIImagePickerControllerOriginalImage], nil, nil, nil);
        
        NSString * uploadURL = @"http://www.eamondev.com/sneekback/respond.php";
        NSLog(@"uploadImageURL: %@", uploadURL);
        NSData *imageData = UIImageJPEGRepresentation(info[UIImagePickerControllerOriginalImage], 0.5);
        
        NSString *queryStringss = [NSString stringWithFormat:@"%@",uploadURL];
        queryStringss = [queryStringss stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
        _manager = [AFHTTPRequestOperationManager manager];
        //manager.responseSerializer.acceptableContentTypes = nil;
        _manager.responseSerializer=[AFJSONResponseSerializer serializerWithReadingOptions:NSJSONReadingAllowFragments];
        _manager.responseSerializer.acceptableContentTypes = [_manager.responseSerializer.acceptableContentTypes setByAddingObject:@"text/html"];
        _manager.responseSerializer.acceptableContentTypes = [_manager.responseSerializer.acceptableContentTypes setByAddingObject:@"text/plain"];
        
        NSUserDefaults *userdefaults = [NSUserDefaults standardUserDefaults];
        
        NSString *usernameEncoded = [[userdefaults objectForKey:@"pfuser"]stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
        
        NSDictionary *params = @{@"username": staticMarker.title, @"challenger": usernameEncoded, @"count": staticCount};
        
        [picker dismissViewControllerAnimated:YES completion:NULL];
        
        [_manager POST:queryStringss parameters:params constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
            [formData appendPartWithFileData:imageData name:@"file" fileName:usernameEncoded mimeType:@"image/jpeg"];
        }
               success:^(AFHTTPRequestOperation *operation, id responseObject) {
                   NSLog(@"Success: %@ ***** %@", operation.responseString, responseObject);
                
                   //if(operation.response.statusCode == 200) {
                   dispatch_async(dispatch_get_main_queue(), ^(void){
                       [image setHidden:YES];
                       [respondButton setHidden:YES];
                       [xButton setHidden:YES];
                       [myMatches setHidden:NO];
                       [matchesNumber setHidden:NO];
                       [menu setHidden:NO];
                   });
                   
                   PFObject *object = [PFObject objectWithoutDataWithClassName:@"MapPoints"
                                                                      objectId:staticObjectId];
                   [object deleteEventually];
                   
                   staticMarker.map = nil;
                   
                   UIAlertController *match = [UIAlertController alertControllerWithTitle:@"A MATCH!" message:@"This perspective is no longer, because you matched it!" preferredStyle:UIAlertControllerStyleAlert];
                   
                   UIAlertAction* matchAlert = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
                   
                   [match addAction:matchAlert];
                   
                   [self presentViewController:match animated:NO completion:NULL];
                   
                   NSUInteger matches = [userdefaults integerForKey:@"matches"];
                   matches++;
                   [userdefaults setInteger:matches forKey:@"matches"];
                   
                   matchesNumber.text = [[NSString alloc] initWithFormat:@"%lu", (unsigned long)matches];
                   
                   NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
                   
                   PFUser *currentUser = [PFUser currentUser];
                   if (currentUser) {
                       NSLog(@"there is a current user");
                       
                       [currentUser setValue:matchesNumber.text forKey:@"matches"];
                       
                       [currentUser saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                           if (!error) {
                               // The currentUser saved successfully.
                           } else {
                               // There was an error saving the currentUser.
                           }
                       }];
                   } else {
                       [PFUser logInWithUsernameInBackground:[userDefaults objectForKey:@"pfuser"] password:[userDefaults objectForKey:@"pfpass"]
                                                       block:^(PFUser *user, NSError *error) {
                                                           if (user) {
                                                               NSLog(@"user logged in");
                                                               
                                                               [user setObject:matchesNumber.text forKey:@"matches"];
                                                               
                                                               [user saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                                                                   if (!error) {
                                                                       // The currentUser saved successfully.
                                                                   } else {
                                                                       // There was an error saving the currentUser.
                                                                   }
                                                               }];
                                                               // Do stuff after successful login.
                                                           } else {
                                                               NSLog(@"login failed");
                                                               // The login failed. Check error to see why.
                                                           }
                                                       }];
                   }

                   isResponding = false;
               }
               failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                   NSLog(@"Error: %@ ***** %@", operation.responseString, error);
                   
                   UIAlertController *notAMatch = [UIAlertController alertControllerWithTitle:@"NOT A MATCH!" message:@"If at first you don't succeed..." preferredStyle:UIAlertControllerStyleAlert];
                   
                   UIAlertAction* notAMatchAlert = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
                   
                   [notAMatch addAction:notAMatchAlert];
                   
                   [self presentViewController:notAMatch animated:NO completion:NULL];
                   
                   isResponding = false;
               }
         ];
    }
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    if(!isResponding) {
        dispatch_async(dispatch_get_main_queue(), ^(void){
            [matchesNumber setHidden:NO];
            [myMatches setHidden:NO];
        });
    }
    else {
        //
    }
    
    [picker dismissViewControllerAnimated:YES completion:NULL];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    NSLog(@"*** memory warning ***");
    // Dispose of any resources that can be recreated.
}

@end
