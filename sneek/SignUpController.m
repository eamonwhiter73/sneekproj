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

@interface NSString (emailValidation)
- (BOOL)isValidEmail;
@end

@implementation NSString (emailValidation)
-(BOOL)isValidEmail
{
    BOOL stricterFilter = NO; // Discussion http://blog.logichigh.com/2010/09/02/validating-an-e-mail-address/
    NSString *stricterFilterString = @"^[A-Z0-9a-z\\._%+-]+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2,4}$";
    NSString *laxString = @"^.+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2}[A-Za-z]*$";
    NSString *emailRegex = stricterFilter ? stricterFilterString : laxString;
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:self];
}
@end


@interface SignUpController () {
    UITextField *textFieldLoc;
    UITextField *passwordTextField;
    UITextField *emailFieldLoc;
    CLLocationManager *locationManager;
    NSUserDefaults *userdefaults;
}

@end

@implementation SignUpController {}

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
    NSNumber *screenWidth = @([UIScreen mainScreen].bounds.size.width);
    
    if([screenWidth intValue] == 320) {
        [self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"LaunchImage568"]]];
    }
    else if([screenWidth intValue] == 375) {
        [self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"LaunchImage667"]]];
    }
    else {
        [self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"LaunchImage1242"]]];
    }

    [self enableMyLocation];
    
    if([screenWidth intValue] == 320) {
        textFieldLoc = [[UITextField alloc] initWithFrame:CGRectMake(59.5, 310, 201, 40)];
    }
    else if([screenWidth intValue] == 375) {
        textFieldLoc = [[UITextField alloc] initWithFrame:CGRectMake(70, 364, 235.5, 40)];
    }
    else {
        textFieldLoc = [[UITextField alloc] initWithFrame:CGRectMake(77, 402, 260, 40)];
    }
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
    
    if([screenWidth intValue] == 320) {
        emailFieldLoc = [[UITextField alloc] initWithFrame:CGRectMake(59.5, 410, 201, 40)];
    }
    else if([screenWidth intValue] == 375) {
        emailFieldLoc = [[UITextField alloc] initWithFrame:CGRectMake(70, 481, 235.5, 40)];
    }
    else {
        emailFieldLoc = [[UITextField alloc] initWithFrame:CGRectMake(77, 531, 260, 40)];
    }
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

    CGRect passwordTextFieldFrame;
    if([screenWidth intValue] == 320) {
        passwordTextFieldFrame = CGRectMake(59.5, 360, 201, 40);
    }
    else if([screenWidth intValue] == 375) {
        passwordTextFieldFrame = CGRectMake(70, 423, 235.5, 40);
    }
    else {
        passwordTextFieldFrame = CGRectMake(77, 467, 260, 40);
    }
    passwordTextField = [[UITextField alloc] initWithFrame:passwordTextFieldFrame];
    passwordTextField.secureTextEntry = YES;
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
    
    UIButton *signUpButton;
    if([screenWidth intValue] == 320) {
        signUpButton = [[UIButton alloc] initWithFrame:CGRectMake(59.5, 460, 201, 40)];
    }
    else if([screenWidth intValue] == 375) {
        signUpButton = [[UIButton alloc] initWithFrame:CGRectMake(70, 540, 235.5, 40)];
    }
    else {
        signUpButton = [[UIButton alloc] initWithFrame:CGRectMake(77, 596, 260, 40)];
    }
    signUpButton.backgroundColor = [UIColor colorWithRed:218.0f/255.0f green:247.0f/255.0f blue:220.0f/255.0f alpha:1.0f];
    signUpButton.layer.masksToBounds = true;
    signUpButton.layer.cornerRadius = 5.0;
    [signUpButton setTitle:@"SIGN UP" forState:UIControlStateNormal];
    signUpButton.titleLabel.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:24.0];
    [signUpButton setTitleColor:[UIColor colorWithRed:156.0f/255.0f green:214.0f/255.0f blue:215.0f/255.0f alpha:1.0f] forState:UIControlStateNormal];
    [signUpButton addTarget:self action:@selector(createUser) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:signUpButton];
    
    userdefaults = [NSUserDefaults standardUserDefaults];
    [userdefaults setInteger:0 forKey:@"matches"];
    
}

- (void)createUser {
    PFUser *user = [PFUser user];
    user.username = textFieldLoc.text;
    user.password = passwordTextField.text;
    if([emailFieldLoc.text isValidEmail]) {
        user.email = emailFieldLoc.text;
    }
    else {
        UIAlertController *match = [UIAlertController alertControllerWithTitle:@"SORRY" message:@"You didn't enter a valid email." preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction* matchAlert = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
        
        [match addAction:matchAlert];
        
        [self presentViewController:match animated:NO completion:NULL];
        
        return;
    }
    [user setObject:@"0" forKey:@"matches"];
    
    [user signUpInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (!error) {   // Hooray! Let them use the app now.
            [userdefaults setObject:user.username forKey:@"pfuser"];
            [userdefaults setObject:user.password forKey:@"pfpass"];
            [userdefaults setObject:user.email forKey:@"pfemail"];
            [userdefaults setInteger:0 forKey:@"count"];
            [userdefaults synchronize];
            
            [self dismissViewControllerAnimated:YES completion:nil];
            
            ViewController* map = [[ViewController alloc] init];
            [[[[UIApplication sharedApplication] delegate] window] setRootViewController:map];
        } else {
            NSString *errorString = [[NSString alloc] initWithFormat:@"%@", [error userInfo][@"error"]];
            NSLog(errorString);
        }
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
    [super touchesBegan:touches withEvent:event];
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    textField.backgroundColor = [UIColor colorWithRed:220.0f/255.0f green:220.0f/255.0f blue:220.0f/255.0f alpha:1.0f];
    return YES;
}

- (void) animateTextView:(BOOL) up
{
    const int movementDistance = 216;
    const float movementDuration = 0.3f;
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
