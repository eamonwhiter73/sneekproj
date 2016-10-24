//
//  LeaderboardController.m
//  sneek
//
//  Created by Eamon White on 11/25/15.
//  Copyright © 2015 Eamon White. All rights reserved.
//

#import "LeaderboardController.h"
#import <Parse/Parse.h>

@interface LeaderboardController () {
    NSMutableArray *tableData;
    NSMutableArray *matchesForUser;
    NSMutableArray *entries;
    NSArray *transfer;
    int countUsers;
    NSArray *sortedFirstArray;
    NSArray *sortedSecondArray;
    UIButton *backToMap;
    NSDictionary *dictionary;
    UILabel *leaderboardtit;
    UILabel *username;
    UILabel *matches;
    UIView *tableHolder;
}
@end


@implementation LeaderboardController {}

- (void)viewDidLoad {

    [self.view setBackgroundColor:[UIColor colorWithRed:156.0f/255.0f green:214.0f/255.0f blue:215.0f/255.0f alpha:1.0f]];
    tableData = [[NSMutableArray alloc] init];
    matchesForUser = [[NSMutableArray alloc] init];
    sortedFirstArray = [[NSArray alloc] init];
    sortedSecondArray = [[NSArray alloc] init];
    
    NSNumber *screenWidth = @([UIScreen mainScreen].bounds.size.width);

    if([screenWidth intValue] == 320) {
        tableHolder = [[UIView alloc] initWithFrame:CGRectMake(10, 120, 300, 368)];
    }
    else if([screenWidth intValue] == 375) {
        tableHolder = [[UIView alloc] initWithFrame:CGRectMake(10, 140, 355, 432)];
    }
    else if([screenWidth intValue] == 414) {
        tableHolder = [[UIView alloc] initWithFrame:CGRectMake(10, 154, 394, 477)];
    }
    else if([screenWidth intValue] == 768){
        tableHolder = [[UIView alloc] initWithFrame:CGRectMake(20, 215, 727, 663)];
    }
    else if([screenWidth intValue] == 1024){
        tableHolder = [[UIView alloc] initWithFrame:CGRectMake(27, 287, 969, 885)];
    }
    tableHolder.layoutMargins = UIEdgeInsetsZero;
    [self.view addSubview:tableHolder];

    if([screenWidth intValue] == 320) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 230, 368) style:UITableViewStylePlain];
    }
    else if([screenWidth intValue] == 375) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 270, 432) style:UITableViewStylePlain];
    }
    else if([screenWidth intValue] == 414) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 298, 477) style:UITableViewStylePlain];
    }
    else if([screenWidth intValue] == 768) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 607, 663) style:UITableViewStylePlain];
    }
    else if([screenWidth intValue] == 1024) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 737, 885) style:UITableViewStylePlain];
    }
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
    
    
    if([screenWidth intValue] == 320) {
        _tableViewScore = [[UITableView alloc] initWithFrame:CGRectMake(240, 0, 60, 368) style:UITableViewStylePlain];
    }
    else if([screenWidth intValue] == 375) {
        _tableViewScore = [[UITableView alloc] initWithFrame:CGRectMake(285, 0, 70, 432) style:UITableViewStylePlain];
    }
    else if([screenWidth intValue] == 414) {
        _tableViewScore = [[UITableView alloc] initWithFrame:CGRectMake(317, 0, 77, 477) style:UITableViewStylePlain];
    }
    else if([screenWidth intValue] == 768) {
        _tableViewScore = [[UITableView alloc] initWithFrame:CGRectMake(627, 0, 100, 663) style:UITableViewStylePlain];
    }
    else if([screenWidth intValue] == 1024) {
        _tableViewScore = [[UITableView alloc] initWithFrame:CGRectMake(778, 0, 191, 885) style:UITableViewStylePlain];
    }
    _tableViewScore.delegate = self;
    _tableViewScore.dataSource = self;
    _tableViewScore.tag = 2;
    _tableViewScore.separatorColor = [UIColor clearColor];
    _tableViewScore.backgroundColor = [UIColor colorWithRed:218.0f/255.0f green:247.0f/255.0f blue:220.0f/255.0f alpha:1.0f];
    _tableViewScore.layer.masksToBounds = true;
    _tableViewScore.layer.cornerRadius = 5.0;
    CGSize scrollableSize = CGSizeMake(60, 368);
    [_tableViewScore setContentSize:scrollableSize];
    [tableHolder addSubview:_tableViewScore];
    
    NSMutableParagraphStyle *style =  [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
    style.alignment = NSTextAlignmentCenter;
    
    NSAttributedString *attrString = [[NSAttributedString alloc] initWithString:@"LEADERBOARD" attributes:@{ NSParagraphStyleAttributeName : style, NSForegroundColorAttributeName : [UIColor colorWithRed:156.0f/255.0f green:214.0f/255.0f blue:215.0f/255.0f alpha:1.0f], NSFontAttributeName : [UIFont fontWithName:@"HelveticaNeue-Bold" size:20.0]}];
    
    if([screenWidth intValue] == 320) {
        leaderboardtit = [[UILabel alloc] initWithFrame:CGRectMake(0, 20, 320, 60)];
    }
    else if([screenWidth intValue] == 375) {
        leaderboardtit = [[UILabel alloc] initWithFrame:CGRectMake(0, 20, 375, 60)];
    }
    else if([screenWidth intValue] == 414) {
        leaderboardtit = [[UILabel alloc] initWithFrame:CGRectMake(0, 22, 414, 80)];
    }
    else if([screenWidth intValue] == 768) {
        leaderboardtit = [[UILabel alloc] initWithFrame:CGRectMake(0, 30, 768, 110.5)];
        attrString = [[NSAttributedString alloc] initWithString:@"LEADERBOARD" attributes:@{ NSParagraphStyleAttributeName : style, NSForegroundColorAttributeName : [UIColor colorWithRed:156.0f/255.0f green:214.0f/255.0f blue:215.0f/255.0f alpha:1.0f], NSFontAttributeName : [UIFont fontWithName:@"HelveticaNeue-Bold" size:48.0]}];

    }
    else if([screenWidth intValue] == 1024) {
        leaderboardtit = [[UILabel alloc] initWithFrame:CGRectMake(0, 20, 1024, 200)];
        attrString = [[NSAttributedString alloc] initWithString:@"LEADERBOARD" attributes:@{ NSParagraphStyleAttributeName : style, NSForegroundColorAttributeName : [UIColor colorWithRed:156.0f/255.0f green:214.0f/255.0f blue:215.0f/255.0f alpha:1.0f], NSFontAttributeName : [UIFont fontWithName:@"HelveticaNeue-Bold" size:72.0]}];
    }
    leaderboardtit.backgroundColor = [UIColor colorWithRed:218.0f/255.0f green:247.0f/255.0f blue:220.0f/255.0f alpha:1.0f];
    leaderboardtit.numberOfLines = 0;
    leaderboardtit.attributedText = attrString;
    [self.view addSubview:leaderboardtit];
    
    if([screenWidth intValue] == 320) {
        username = [[UILabel alloc] initWithFrame:CGRectMake(10, 90, 140, 20)];
        username.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:14.0];

    }
    else if([screenWidth intValue] == 375) {
        username = [[UILabel alloc] initWithFrame:CGRectMake(10, 105, 140, 20)];
        username.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:14.0];

    }
    else if([screenWidth intValue] == 414) {
        username = [[UILabel alloc] initWithFrame:CGRectMake(10, 116, 154, 22)];
        username.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:14.0];

    }
    else if([screenWidth intValue] == 768) {
        username = [[UILabel alloc] initWithFrame:CGRectMake(20, 161, 287, 30)];
        username.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:20.0];
        
    }
    else if([screenWidth intValue] == 1024) {
        username = [[UILabel alloc] initWithFrame:CGRectMake(27, 215, 382, 73)];
        username.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:36.0];

    }
    username.backgroundColor = [UIColor clearColor];
    username.textColor = [UIColor colorWithRed:218.0f/255.0f green:247.0f/255.0f blue:220.0f/255.0f alpha:1.0f];
    NSDictionary *underlineAttribute = @{NSUnderlineStyleAttributeName: @(NSUnderlineStyleSingle)};
    username.attributedText = [[NSAttributedString alloc] initWithString:@"USERNAME"
                                                               attributes:underlineAttribute];
    username.textAlignment = NSTextAlignmentLeft;
    [self.view addSubview:username];
    
    if([screenWidth intValue] == 320) {
        matches = [[UILabel alloc] initWithFrame:CGRectMake(170, 90, 140, 20)];
        matches.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:14.0];
    }
    else if([screenWidth intValue] == 375) {
        matches = [[UILabel alloc] initWithFrame:CGRectMake(224, 105, 140, 20)];
        matches.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:14.0];
    }
    else if([screenWidth intValue] == 414) {
        matches = [[UILabel alloc] initWithFrame:CGRectMake(247, 116, 154, 22)];
        matches.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:14.0];
    }
    else if([screenWidth intValue] == 768) {
        matches = [[UILabel alloc] initWithFrame:CGRectMake(459, 161, 287, 30)];
        matches.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:20.0];
    }
    else if([screenWidth intValue] == 1024) {
        matches = [[UILabel alloc] initWithFrame:CGRectMake(612, 215, 382, 73)];
        matches.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:36.0];
    }
    matches.backgroundColor = [UIColor clearColor];
    NSDictionary *underlineAttribute2 = @{NSUnderlineStyleAttributeName: @(NSUnderlineStyleSingle)};
    matches.attributedText = [[NSAttributedString alloc] initWithString:@"MATCHES"
                                                             attributes:underlineAttribute2];
    matches.textColor = [UIColor colorWithRed:218.0f/255.0f green:247.0f/255.0f blue:220.0f/255.0f alpha:1.0f];
    matches.textAlignment = NSTextAlignmentRight;
    [self.view addSubview:matches];
    
    
    [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"SimpleTableItem"];
    [_tableViewScore registerClass:[UITableViewCell class] forCellReuseIdentifier:@"SimpleTableItem"];
    
    PFQuery *query = [PFQuery queryWithClassName:@"_User"];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (!error) {
                entries = [NSMutableArray new];
                for (PFObject *object in objects) {
                    NSLog(@"%@", object.objectId);
                    [tableData addObject:[object valueForKey:@"username"]];
                    [matchesForUser addObject:[object valueForKey:@"matches"]];
                    
                    NSMutableDictionary* entry = [NSMutableDictionary new];
                    
                    entry[@"username"] = [object valueForKey:@"username"];
                    entry[@"matches"] = [object valueForKey:@"matches"];
                    
                    [entries addObject:entry];
                }
                NSSortDescriptor * descriptor = [[NSSortDescriptor alloc] initWithKey:@"matches" ascending:NO selector:@selector(localizedStandardCompare:)];
                NSArray *entrieshold = [entries sortedArrayUsingDescriptors:@[descriptor]];
                transfer = [entrieshold copy];

                [_tableView reloadData];
                [_tableViewScore reloadData];
                
            }else{
                NSLog(@"%@", [error description]);
            }
        });
    }];
    
    if([screenWidth intValue] == 320) {
        backToMap = [[UIButton alloc] initWithFrame:CGRectMake(10, 498, 300, 60)];
        backToMap.titleLabel.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:20.0];

    }
    else if([screenWidth intValue] == 375) {
        backToMap = [[UIButton alloc] initWithFrame:CGRectMake(10, 585, 355, 72)];
        backToMap.titleLabel.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:20.0];

    }
    else if([screenWidth intValue] == 414) {
        backToMap = [[UIButton alloc] initWithFrame:CGRectMake(10, 645.5, 394, 80)];
        backToMap.titleLabel.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:20.0];

    }
    else if([screenWidth intValue] == 768) {
        backToMap = [[UIButton alloc] initWithFrame:CGRectMake(20, 898, 727, 110.5)];
        backToMap.titleLabel.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:42.0];
        
    }
    else if([screenWidth intValue] == 1024) {
        backToMap = [[UIButton alloc] initWithFrame:CGRectMake(27, 1198, 969, 147)];
        backToMap.titleLabel.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:54.0];

    }
    backToMap.backgroundColor = [UIColor colorWithRed:218.0f/255.0f green:247.0f/255.0f blue:220.0f/255.0f alpha:1.0f];
    [backToMap setTitleColor:[UIColor colorWithRed:156.0f/255.0f green:214.0f/255.0f blue:215.0f/255.0f alpha:1.0f] forState:UIControlStateNormal];
    [backToMap addTarget:self action:@selector(dismiss) forControlEvents:UIControlEventTouchUpInside];
    [backToMap setTitle:@"BACK TO MAP" forState:UIControlStateNormal];
    backToMap.layer.masksToBounds = true;
    backToMap.layer.cornerRadius = 5.0;
    [self.view addSubview:backToMap];
}

- (void)dismiss {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [tableData count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *simpleTableIdentifier = @"SimpleTableItem";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    
    NSNumber *screenWidth = @([UIScreen mainScreen].bounds.size.width);

    if(tableView.tag == 1) {
        cell.textLabel.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:16.0];
        cell.textLabel.textColor = [UIColor colorWithRed:218.0f/255.0f green:247.0f/255.0f blue:220.0f/255.0f alpha:1.0f];
        cell.backgroundColor = [UIColor colorWithRed:156.0f/255.0f green:214.0f/255.0f blue:215.0f/255.0f alpha:1.0f];
        cell.layoutMargins = UIEdgeInsetsZero;
        cell.preservesSuperviewLayoutMargins = NO;
        
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
        }
       

        UILabel *contentV = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 230, 44)];
        contentV.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:16.0];
        if([screenWidth intValue] == 1024) {
            contentV = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 737, 44)];
            contentV.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:32.0];
            cell.textLabel.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:32.0];
        }
        else if([screenWidth intValue] == 768) {
            NSLog(@"entered 768 block");
            contentV = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 607, 44)];
            contentV.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:16.0];
            cell.textLabel.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:16.0];
        }
        
        contentV.textColor = [UIColor colorWithRed:218.0f/255.0f green:247.0f/255.0f blue:220.0f/255.0f alpha:1.0f];
        contentV.backgroundColor = [UIColor colorWithRed:156.0f/255.0f green:214.0f/255.0f blue:215.0f/255.0f alpha:1.0f];

        cell.contentView.layoutMargins = UIEdgeInsetsZero;

        NSString *username2 = [[transfer objectAtIndex:indexPath.row] valueForKey:@"username"];
        
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
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
        }
        
        NSString *matchAmount = [[transfer objectAtIndex:indexPath.row] valueForKey:@"matches"];
        
        cell.textLabel.text = matchAmount;
        
        return cell;
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView;
{
    UITableView *slaveTable = nil;
    
    if (_tableView == scrollView) {
        slaveTable = _tableViewScore;
    } else if (_tableViewScore == scrollView) {
        slaveTable = _tableView;
    }
    
    [slaveTable setContentOffset:scrollView.contentOffset];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    NSLog(@"*** memory warning ***");
    // Dispose of any resources that can be recreated.
}

@end
