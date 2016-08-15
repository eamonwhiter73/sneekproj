//
//  SignUpController.m
//  sneek
//
//  Created by Eamon White on 11/25/15.
//  Copyright © 2015 Eamon White. All rights reserved.
//

#import "SignUpController.h"
#import "ViewController.h"
#import <Parse/Parse.h>

@interface SignUpController () {
    UITextField *textFieldLoc;
    UITextField *passwordTextField;
    UITextField *emailFieldLoc;
    CLLocationManager *locationManager;
}

@end


@implementation SignUpController {
}

- (void)enableMyLocation
{
    CLAuthorizationStatus status = [CLLocationManager authorizationStatus];
    
    if (status == kCLAuthorizationStatusNotDetermined) {
        [self requestLocationAuthorization];
    }
    else if (status == kCLAuthorizationStatusDenied || status == kCLAuthorizationStatusRestricted) {
        return; // we weren't allowed to show the user's location so don't enable
    }
    else {
        //
    }
}

// Ask the CLLocationManager for location authorization,
// and be sure to retain the manager somewhere on the class

- (void)requestLocationAuthorization
{
    locationManager = [[CLLocationManager alloc] init];
    [locationManager requestAlwaysAuthorization];
}

// Handle the authorization callback. This is usually
// called on a background thread so go back to main.

- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status
{
    if (status != kCLAuthorizationStatusNotDetermined) {
        [self performSelectorOnMainThread:@selector(enableMyLocation) withObject:nil waitUntilDone:[NSThread isMainThread]];
        
        locationManager.delegate = nil;
        locationManager = nil;
    }
}

- (void)viewDidLoad {
    NSLog(@"in viewdidload");
    //DO BY SCREEN SIZE
    NSNumber *screenWidth = @([UIScreen mainScreen].bounds.size.width);
    //NSLog([[NSString alloc] initWithFormat:@"%@", screenWidth]);
    
    if([screenWidth intValue] == 320) {
        NSLog(@"in block for back320");
        [self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"LaunchImage568"]]];
    }
    else if([screenWidth intValue] == 375) {
        NSLog(@"in block for back");
        [self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"LaunchImage667"]]];
    }
    else {
        NSLog(@"in block for backbig");
        [self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"LaunchImage568"]]];
    }
    
    //[self.view setBackgroundColor:[UIColor blueColor]];//colorWithPatternImage:[UIImage imageNamed:@"LaunchImage568"]]];

    [self enableMyLocation];
    
    textFieldLoc = [[UITextField alloc] initWithFrame:CGRectMake(10, 370, 300, 40)];
    textFieldLoc.borderStyle = UITextBorderStyleRoundedRect;
    textFieldLoc.font = [UIFont systemFontOfSize:15];
    textFieldLoc.placeholder = @"enter username";
    textFieldLoc.autocorrectionType = UITextAutocorrectionTypeNo;
    textFieldLoc.keyboardType = UIKeyboardTypeDefault;
    textFieldLoc.returnKeyType = UIReturnKeyDone;
    textFieldLoc.clearButtonMode = UITextFieldViewModeWhileEditing;
    textFieldLoc.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    textFieldLoc.delegate = self;
    textFieldLoc.tag = 1;
    [self.view addSubview:textFieldLoc];
    
    emailFieldLoc = [[UITextField alloc] initWithFrame:CGRectMake(10, 470, 300, 40)];
    emailFieldLoc.borderStyle = UITextBorderStyleRoundedRect;
    emailFieldLoc.font = [UIFont systemFontOfSize:15];
    emailFieldLoc.placeholder = @"enter email";
    emailFieldLoc.autocorrectionType = UITextAutocorrectionTypeNo;
    emailFieldLoc.keyboardType = UIKeyboardTypeDefault;
    emailFieldLoc.returnKeyType = UIReturnKeyDone;
    emailFieldLoc.clearButtonMode = UITextFieldViewModeWhileEditing;
    emailFieldLoc.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    emailFieldLoc.delegate = self;
    emailFieldLoc.tag = 3;
    [self.view addSubview:emailFieldLoc];

    CGRect passwordTextFieldFrame = CGRectMake(10, 420, 300, 40);
    passwordTextField = [[UITextField alloc] initWithFrame:passwordTextFieldFrame];
    passwordTextField.placeholder = @"enter password";
    passwordTextField.backgroundColor = [UIColor whiteColor];
    passwordTextField.textColor = [UIColor blackColor];
 	   passwordTextField.font = [UIFont systemFontOfSize:14.0f];
    passwordTextField.borderStyle = UITextBorderStyleRoundedRect;
    passwordTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    passwordTextField.returnKeyType = UIReturnKeyDone;
    passwordTextField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    passwordTextField.tag = 2;
    passwordTextField.delegate = self;
    passwordTextField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    [self.view addSubview:passwordTextField];
    
    UIButton *signUpButton = [[UIButton alloc] initWithFrame:CGRectMake(10, 520, 300, 40)];
    signUpButton.backgroundColor = [UIColor blueColor];
    [signUpButton setTitle:@"SIGN UP" forState:UIControlStateNormal];
    [signUpButton addTarget:self action:@selector(createUser) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:signUpButton];
    
    NSUserDefaults *userdefaults = [NSUserDefaults standardUserDefaults];
    [userdefaults setInteger:0 forKey:@"matches"];
    
}

- (void)createUser {
    PFUser *user = [PFUser user];
    user.username = textFieldLoc.text;
    user.password = passwordTextField.text;
    user.email = emailFieldLoc.text;
    [user setObject:@"0" forKey:@"matches"];
    
    // other fields can be set just like with PFObject
    
    [user signUpInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (!error) {   // Hooray! Let them use the app now.
            NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
            [userDefaults setObject:user.username forKey:@"pfuser"];
            [userDefaults setObject:user.password forKey:@"pfpass"];
            [userDefaults setObject:user.email forKey:@"pfemail"];
            [userDefaults setInteger:0 forKey:@"count"];
            [userDefaults synchronize];
            
            [self dismissViewControllerAnimated:YES completion:nil];
            
            ViewController* map = [[ViewController alloc] init];
            [[[[UIApplication sharedApplication] delegate] window] setRootViewController:map];
        } else {   NSString *errorString = [error userInfo][@"error"];   // Show the errorString somewhere and let the user try again.
            NSLog(errorString);
        }
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    NSLog(@"*** memory warning ***");
    // Dispose of any resources that can be recreated.
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    NSLog(@"touchesBegan:withEvent:");
    [self.view endEditing:YES];
    [super touchesBegan:touches withEvent:event];
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    NSLog(@"textFieldShouldBeginEditing");
    textField.backgroundColor = [UIColor colorWithRed:220.0f/255.0f green:220.0f/255.0f blue:220.0f/255.0f alpha:1.0f];
    return YES;
}

- (void) animateTextView:(BOOL) up
{
    const int movementDistance = 216; // tweak as needed
    const float movementDuration = 0.3f; // tweak as needed
    int movement= movement = (up ? -movementDistance : movementDistance);
    NSLog(@"%d",movement);
    
    [UIView beginAnimations: @"anim" context: nil];
    [UIView setAnimationBeginsFromCurrentState: YES];
    [UIView setAnimationDuration: movementDuration];
    self.view.frame = CGRectOffset(self.view.frame, 0, movement);
    [UIView commitAnimations];
}

- (void)textFieldDidBeginEditing:(UITextField *)textField{
    NSLog(@"textFieldDidBeginEditing");
    [self animateTextView: YES];
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField{
    NSLog(@"textFieldShouldEndEditing");
    textField.backgroundColor = [UIColor whiteColor];
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField{
    NSLog(@"textFieldDidEndEditing");
    [self animateTextView:NO];
}

- (BOOL)textFieldShouldClear:(UITextField *)textField{
    NSLog(@"textFieldShouldClear:");
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    NSLog(@"textFieldShouldReturn:");
    if (textField.tag == 1) {
        passwordTextField = (UITextField *)[self.view viewWithTag:2];
        [passwordTextField becomeFirstResponder];
    }
    else {
        [textField resignFirstResponder];
    }
    return YES;
}

@end
