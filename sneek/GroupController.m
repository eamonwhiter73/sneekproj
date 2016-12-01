//
//  LeaderboardController.m
//  sneek
//
//  Created by Eamon White on 11/25/15.
//  Copyright © 2015 Eamon White. All rights reserved.
//

#import "GroupController.h"
#import <Parse/Parse.h>

@interface GroupController () {
    NSMutableArray *tableData;
    NSMutableArray *matchesForUser;
    NSMutableArray *entries;
    int countUsers;
    NSArray *sortedFirstArray;
    NSArray *sortedSecondArray;
    UIButton *backToMap;
    NSDictionary *dictionary;
    UILabel *leaderboardtit;
    UILabel *username;
    UILabel *matches;
    UIView *tableHolder;
    NSNumber *screenWidth;
    NSUserDefaults *userdefaults;
}
@end


@implementation GroupController {}

@synthesize myViewController;

- (void)viewDidLoad {
    userdefaults = [NSUserDefaults standardUserDefaults];
    
    [self.view setBackgroundColor:[UIColor colorWithRed:156.0f/255.0f green:214.0f/255.0f blue:215.0f/255.0f alpha:1.0f]];
    tableData = [[NSMutableArray alloc] init];
    sortedFirstArray = [[NSArray alloc] init];
    matchesForUser = [[NSMutableArray alloc] init];
    [matchesForUser addObject:[userdefaults objectForKey:@"pfuser"]];
    
    screenWidth = @([UIScreen mainScreen].bounds.size.width);
    CGRect tablehold = CGRectZero;
    CGRect tableviewhold = CGRectZero;
    CGRect tableviewscore = CGRectZero;
    CGRect leaderboardtitrect = CGRectZero;
    CGRect userrect = CGRectZero;
    CGRect matchesrect = CGRectZero;
    CGRect backtomaprect = CGRectZero;
    
    NSMutableParagraphStyle *style =  [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
    style.alignment = NSTextAlignmentCenter;
    
    NSAttributedString *attrString = [[NSAttributedString alloc] initWithString:@"GROUP GAMES" attributes:@{ NSParagraphStyleAttributeName : style, NSForegroundColorAttributeName : [UIColor colorWithRed:156.0f/255.0f green:214.0f/255.0f blue:215.0f/255.0f alpha:1.0f], NSFontAttributeName : [UIFont fontWithName:@"HelveticaNeue-Bold" size:20.0]}];
    
    username = [[UILabel alloc] initWithFrame:userrect];
    matches = [[UILabel alloc] initWithFrame:matchesrect];
    backToMap = [[UIButton alloc] initWithFrame:backtomaprect];
    
    if([screenWidth intValue] == 320) {
        tablehold = CGRectMake(10, 120, 300, 368);
        tableviewhold = CGRectMake(0, 0, 140, 368);
        tableviewscore = CGRectMake(160, 0, 140, 368);
        leaderboardtitrect = CGRectMake(0, 20, 320, 60);
        userrect = CGRectMake(10, 90, 140, 20);
        matchesrect = CGRectMake(170, 90, 140, 20);
        matches.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:14.0];
        username.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:14.0];
        backtomaprect = CGRectMake(10, 498, 300, 60);
        backToMap.titleLabel.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:20.0];
    }
    if([screenWidth intValue] == 375) {
        tablehold = CGRectMake(10, 140, 355, 432);
        tableviewhold = CGRectMake(0, 0, 270, 432);
        tableviewscore = CGRectMake(285, 0, 70, 432);
        leaderboardtitrect = CGRectMake(0, 20, 375, 60);
        userrect = CGRectMake(10, 105, 140, 20);
        username.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:14.0];
        matchesrect = CGRectMake(224, 105, 140, 20);
        matches.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:14.0];
        backtomaprect = CGRectMake(10, 585, 355, 72);
        backToMap.titleLabel.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:20.0];
    }
    if([screenWidth intValue] == 414) {
        tablehold = CGRectMake(10, 154, 394, 477);
        tablehold = CGRectMake(0, 0, 298, 477);
        tableviewscore = CGRectMake(317, 0, 77, 477);
        leaderboardtitrect = CGRectMake(0, 22, 414, 80);
        userrect = CGRectMake(10, 116, 154, 22);
        username.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:14.0];
        matchesrect = CGRectMake(247, 116, 154, 22);
        matches.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:14.0];
        backtomaprect = CGRectMake(10, 645.5, 394, 80);
        backToMap.titleLabel.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:20.0];
    }
    if([screenWidth intValue] == 768){
        tablehold = CGRectMake(20, 215, 727, 663);
        tableviewhold = CGRectMake(0, 0, 607, 663);
        tableviewscore = CGRectMake(627, 0, 100, 663);
        
        leaderboardtitrect = CGRectMake(0, 30, 768, 110.5);
        attrString = [[NSAttributedString alloc] initWithString:@"GROUP GAMES" attributes:@{ NSParagraphStyleAttributeName : style, NSForegroundColorAttributeName : [UIColor colorWithRed:156.0f/255.0f green:214.0f/255.0f blue:215.0f/255.0f alpha:1.0f], NSFontAttributeName : [UIFont fontWithName:@"HelveticaNeue-Bold" size:48.0]}];
        
        userrect = CGRectMake(20, 161, 287, 30);
        username.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:20.0];
        matchesrect = CGRectMake(459, 161, 287, 30);
        matches.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:20.0];
        backtomaprect = CGRectMake(20, 898, 727, 110.5);
        backToMap.titleLabel.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:42.0];
    }
    if([screenWidth intValue] == 1024){
        tablehold = CGRectMake(27, 287, 969, 885);
        tableviewhold = CGRectMake(0, 0, 737, 885);
        tableviewscore = CGRectMake(778, 0, 191, 885);
        
        leaderboardtitrect = CGRectMake(0, 20, 1024, 200);
        attrString = [[NSAttributedString alloc] initWithString:@"GROUP GAMES" attributes:@{ NSParagraphStyleAttributeName : style, NSForegroundColorAttributeName : [UIColor colorWithRed:156.0f/255.0f green:214.0f/255.0f blue:215.0f/255.0f alpha:1.0f], NSFontAttributeName : [UIFont fontWithName:@"HelveticaNeue-Bold" size:72.0]}];
        
        userrect = CGRectMake(27, 215, 382, 73);
        username.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:36.0];
        matchesrect = CGRectMake(612, 215, 382, 73);
        matches.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:36.0];
        
        backtomaprect = CGRectMake(27, 1198, 969, 147);
        backToMap.titleLabel.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:54.0];
    }
    
    tableHolder = [[UIView alloc] initWithFrame:tablehold];
    tableHolder.layoutMargins = UIEdgeInsetsZero;
    [self.view addSubview:tableHolder];
    
    _tableView = [[UITableView alloc] initWithFrame:tableviewhold];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.tag = 1;
    _tableView.separatorColor = [UIColor colorWithRed:218.0f/255.0f green:247.0f/255.0f blue:220.0f/255.0f alpha:1.0f];
    _tableView.backgroundColor = [UIColor clearColor];
    _tableView.separatorInset = UIEdgeInsetsZero;
    _tableView.layoutMargins = UIEdgeInsetsZero;
    if([_tableView respondsToSelector:@selector(setCellLayoutMarginsFollowReadableWidth:)])
    {
        _tableView.cellLayoutMarginsFollowReadableWidth = NO;
    }
    [tableHolder addSubview:_tableView];
    
    _tableViewScore = [[UITableView alloc] initWithFrame:tableviewscore];
    _tableViewScore.delegate = self;
    _tableViewScore.dataSource = self;
    _tableViewScore.tag = 2;
    _tableViewScore.separatorColor = [UIColor clearColor];
    _tableViewScore.backgroundColor = [UIColor colorWithRed:218.0f/255.0f green:247.0f/255.0f blue:220.0f/255.0f alpha:1.0f];
    _tableViewScore.layer.masksToBounds = true;
    CGSize scrollableSize = CGSizeMake(140, 368);
    [_tableViewScore setContentSize:scrollableSize];
    if([_tableViewScore respondsToSelector:@selector(setCellLayoutMarginsFollowReadableWidth:)])
    {
        _tableViewScore.cellLayoutMarginsFollowReadableWidth = NO;
    }
    [tableHolder addSubview:_tableViewScore];
    
    leaderboardtit = [[UILabel alloc] initWithFrame:leaderboardtitrect];
    leaderboardtit.backgroundColor = [UIColor colorWithRed:218.0f/255.0f green:247.0f/255.0f blue:220.0f/255.0f alpha:1.0f];
    leaderboardtit.numberOfLines = 0;
    leaderboardtit.attributedText = attrString;
    [self.view addSubview:leaderboardtit];
    
    [username setFrame:userrect];
    username.backgroundColor = [UIColor clearColor];
    username.textColor = [UIColor colorWithRed:218.0f/255.0f green:247.0f/255.0f blue:220.0f/255.0f alpha:1.0f];
    NSDictionary *underlineAttribute = @{NSUnderlineStyleAttributeName: @(NSUnderlineStyleSingle)};
    username.attributedText = [[NSAttributedString alloc] initWithString:@"USERS"
                                                              attributes:underlineAttribute];
    username.textAlignment = NSTextAlignmentLeft;
    [self.view addSubview:username];
    
    [matches setFrame:matchesrect];
    matches.backgroundColor = [UIColor clearColor];
    NSDictionary *underlineAttribute2 = @{NSUnderlineStyleAttributeName: @(NSUnderlineStyleSingle)};
    matches.attributedText = [[NSAttributedString alloc] initWithString:@"ADDED"
                                                             attributes:underlineAttribute2];
    matches.textColor = [UIColor colorWithRed:218.0f/255.0f green:247.0f/255.0f blue:220.0f/255.0f alpha:1.0f];
    matches.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:matches];
    
    [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"SimpleTableItem"];
    [_tableViewScore registerClass:[UITableViewCell class] forCellReuseIdentifier:@"SimpleTableItem"];
    
    PFQuery *query = [PFQuery queryWithClassName:@"_User"];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (!error) {
                for (PFObject *object in objects) {
                    [tableData addObject:[object valueForKey:@"username"]];
                }
                /*NSSortDescriptor * descriptor = [[NSSortDescriptor alloc] initWithKey:@"matches" ascending:NO selector:@selector(localizedStandardCompare:)];
                NSArray *entrieshold = [entries sortedArrayUsingDescriptors:@[descriptor]];*/
                
                //FIGURE OUT GROUP BACKEND
                
                [_tableView reloadData];
                //[_tableViewScore reloadData]; //*********PROBABLY NEED THIS**************
                
            }else{
                NSLog(@"%@", [error description]);
            }
        });
    }];
    
    if([userdefaults objectForKey:@"idbyuser"]) {
        PFQuery *query2 = [PFQuery queryWithClassName:@"GroupGame"];
        [query2 whereKey:@"idbyuser" equalTo:[userdefaults objectForKey:@"idbyuser"]];
        [query2 findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
            if (!error) {
                // The find succeeded.
                NSLog(@"Successfully retrieved %lu scores.", (unsigned long)objects.count);
                // Do something with the found objects
                for (PFObject *object in objects) {
                    NSDictionary *yy = [object objectForKey:@"usersAndPoints"];
                    for(id key in yy) {
                        [matchesForUser addObject:key];
                    }
                }
                
                [_tableViewScore reloadData]; //*********PROBABLY NEED THIS**************

            } else {
                // Log details of the failure
                NSLog(@"Error: %@ %@", error, [error userInfo]);
            }
        }];
    }

    [backToMap setFrame:backtomaprect];
    backToMap.backgroundColor = [UIColor colorWithRed:218.0f/255.0f green:247.0f/255.0f blue:220.0f/255.0f alpha:1.0f];
    [backToMap setTitleColor:[UIColor colorWithRed:156.0f/255.0f green:214.0f/255.0f blue:215.0f/255.0f alpha:1.0f] forState:UIControlStateNormal];
    [backToMap addTarget:self action:@selector(dismiss) forControlEvents:UIControlEventTouchUpInside];
    [backToMap setTitle:@"SAVE AND START" forState:UIControlStateNormal];
    backToMap.layer.masksToBounds = true;
    backToMap.layer.cornerRadius = 5.0;
    [self.view addSubview:backToMap];
}

- (void)dismiss {
    NSMutableString *stringstore = [[NSMutableString alloc] initWithString:@""];
    NSString *forend;
    for(NSString* string in matchesForUser) {
        [stringstore appendString:string];
    }
    forend = [[NSString alloc] initWithString:stringstore];
    NSLog(@"stringstore******: %@", forend);
    
    UIAlertController __block *deviceNotFoundAlertController;
    UIAlertAction *deviceNotFoundAlert  = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];;
    
    
    NSMutableArray *starter = [[NSMutableArray alloc] init];
    
    [matchesForUser enumerateObjectsUsingBlock:^(id object, NSUInteger idx, BOOL *stop) {
        [starter addObject:[[NSArray alloc] init]];
    }];
    
    NSDictionary *userspoints = [[NSDictionary alloc] initWithObjects:starter forKeys:matchesForUser];
    PFObject *groupGame = [PFObject objectWithClassName:@"GroupGame"];
    groupGame[@"usersAndPoints"] = userspoints;
    groupGame[@"idbyuser"] = forend;
    [groupGame saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (succeeded) {
            
            matchesForUser = nil;
            
            [userdefaults setObject:forend forKey:@"idbyuser"];
            [userdefaults synchronize];
            
            [userdefaults setValue:0 forKey:@"groupcount"];
            
            [self dismissViewControllerAnimated:YES completion:^{
                [[myViewController mapView_] clear];
                
                deviceNotFoundAlertController = [UIAlertController alertControllerWithTitle:@"MARKERS" message:@"Only markers from your group game will be visible to you. To view all markers, tap the show all markers button in the top left corner of the screen." preferredStyle:UIAlertControllerStyleAlert];
                [deviceNotFoundAlertController addAction:deviceNotFoundAlert];
                [myViewController presentViewController:deviceNotFoundAlertController animated:NO completion:NULL];
            }];
        } else {
            UIAlertController *deviceNotFoundAlertController = [UIAlertController alertControllerWithTitle:@"NOT SAVED" message:@"Your game was not saved, try again." preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *deviceNotFoundAlert = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
            [deviceNotFoundAlertController addAction:deviceNotFoundAlert];
            [self presentViewController:deviceNotFoundAlertController animated:NO completion:NULL];
        }
    }];
    
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if(tableView == _tableView)
        return [tableData count];
    else
        return [matchesForUser count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    /*static NSString *simpleTableIdentifier = @"SimpleTableItem";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];*/
    
    NSString *CellIdentifier = [NSString stringWithFormat:@"%ld,%ld",(long)indexPath.section,(long)indexPath.row];
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    if(tableView.tag == 1) {
        cell.textLabel.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:16.0];
        cell.textLabel.textColor = [UIColor colorWithRed:218.0f/255.0f green:247.0f/255.0f blue:220.0f/255.0f alpha:1.0f];
        cell.backgroundColor = [UIColor colorWithRed:156.0f/255.0f green:214.0f/255.0f blue:215.0f/255.0f alpha:1.0f];
        cell.layoutMargins = UIEdgeInsetsZero;
        cell.preservesSuperviewLayoutMargins = NO;
        
        if (cell == nil) {
            NSString *CellIdentifier = [NSString stringWithFormat:@"%ld,%ld",(long)indexPath.section,(long)indexPath.row];
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        }
        
        UILabel *contentV = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 230, 44)];
        contentV.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:16.0];
        contentV.tag = 100;
        if([screenWidth intValue] == 1024) {
            contentV = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 737, 44)];
            contentV.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:32.0];
            cell.textLabel.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:32.0];
        }
        else if([screenWidth intValue] == 768) {
            contentV = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 607, 44)];
            contentV.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:16.0];
            cell.textLabel.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:16.0];
        }
        
        contentV.textColor = [UIColor colorWithRed:218.0f/255.0f green:247.0f/255.0f blue:220.0f/255.0f alpha:1.0f];
        contentV.backgroundColor = [UIColor colorWithRed:156.0f/255.0f green:214.0f/255.0f blue:215.0f/255.0f alpha:1.0f];
        
        cell.contentView.layoutMargins = UIEdgeInsetsZero;
        
        NSString *username2 = [tableData objectAtIndex:indexPath.row];
        
        contentV.text = username2;
        [cell.contentView addSubview:contentV];
        
        return cell;
    }
    else {
        cell.textLabel.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:16.0];
        if([screenWidth intValue] == 1024) {
            cell.textLabel.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:32.0];
        }
        else if([screenWidth intValue] == 768) {
            cell.textLabel.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:16.0];
        }
        cell.textLabel.textColor = [UIColor colorWithRed:153.0f/255.0f green:211.0f/255.0f blue:212.0f/255.0f alpha:1.0f];
        cell.backgroundColor = [UIColor colorWithRed:218.0f/255.0f green:247.0f/255.0f blue:220.0f/255.0f alpha:1.0f];
        cell.textLabel.textAlignment = NSTextAlignmentCenter;
        
        if (cell == nil) {
            NSString *CellIdentifier = [NSString stringWithFormat:@"%ld,%ld",(long)indexPath.section,(long)indexPath.row];
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        }
        NSLog(@"indexpath.row: %ld", indexPath.row);
        NSLog(@"matchesforusercount: %ld", [matchesForUser count]);
        if([matchesForUser count] > indexPath.row) {
            NSString *matchAmount = [matchesForUser objectAtIndex:indexPath.row];
            cell.textLabel.text = matchAmount;
        }
        
        return cell;
    }
}

- (void) tableView: (UITableView *) tableView didSelectRowAtIndexPath: (NSIndexPath *) indexPath {
    
    if(tableView.tag == 1) {
        UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        UILabel *label = (UILabel*)[cell viewWithTag:100];
        
        if (![matchesForUser containsObject:[label text]]) {
            NSLog(@"%@", [label text]);
            [matchesForUser addObject:[label text]];
        }
        
        NSLog(@"%@", [matchesForUser description]);
        
        [_tableView reloadData];
        [_tableViewScore reloadData];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    NSLog(@"*** memory warning ***");
    // Dispose of any resources that can be recreated.
}

@end
