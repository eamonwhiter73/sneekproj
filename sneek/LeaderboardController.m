//
//  LeaderboardController.m
//  sneek
//
//  Created by Eamon White on 11/25/15.
//  Copyright © 2015 Eamon White. All rights reserved.
//

#import "LeaderboardController.h"
#import <Parse/Parse.h>

@interface LeaderboardController ()

@end


@implementation LeaderboardController {
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

- (void)viewDidLoad {

    [self.view setBackgroundColor:[UIColor colorWithRed:153.0f/255.0f green:211.0f/255.0f blue:212.0f/255.0f alpha:1.0f]];
    tableData = [[NSMutableArray alloc] init];
    matchesForUser = [[NSMutableArray alloc] init];
    sortedFirstArray = [[NSArray alloc] init];
    sortedSecondArray = [[NSArray alloc] init];
    
    tableHolder = [[UIView alloc] initWithFrame:CGRectMake(10, 120, 230, 368)];
    tableHolder.layoutMargins = UIEdgeInsetsZero;
    [self.view addSubview:tableHolder];

    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 230, 368) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.tag = 1;
    _tableView.separatorColor = [UIColor colorWithRed:218.0f/255.0f green:247.0f/255.0f blue:220.0f/255.0f alpha:1.0f];
    _tableView.backgroundColor = [UIColor colorWithRed:153.0f/255.0f green:211.0f/255.0f blue:212.0f/255.0f alpha:1.0f];
    _tableView.separatorInset = UIEdgeInsetsZero;
    _tableView.layoutMargins = UIEdgeInsetsZero;
    if([_tableView respondsToSelector:@selector(setCellLayoutMarginsFollowReadableWidth:)])
    {
        _tableView.cellLayoutMarginsFollowReadableWidth = NO;
    }
    //_tableView.layer.masksToBounds = true;
    //_tableView.layer.cornerRadius = 8.0;
    [tableHolder addSubview:_tableView];
    
    _tableViewScore = [[UITableView alloc] initWithFrame:CGRectMake(250, 120, 60, self.view.frame.size.height - 200) style:UITableViewStylePlain];
    _tableViewScore.delegate = self;
    _tableViewScore.dataSource = self;
    _tableViewScore.tag = 2;
    _tableViewScore.separatorColor = [UIColor clearColor];
    _tableViewScore.backgroundColor = [UIColor colorWithRed:218.0f/255.0f green:247.0f/255.0f blue:220.0f/255.0f alpha:1.0f];
    //_tableViewScore.layer.masksToBounds = true;
    //_tableViewScore.layer.cornerRadius = 8.0;
    CGSize scrollableSize = CGSizeMake(60, 368);
    [_tableViewScore setContentSize:scrollableSize];
    [self.view addSubview:_tableViewScore];
    
    NSMutableParagraphStyle *style =  [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
    style.alignment = NSTextAlignmentCenter;
    
    NSAttributedString *attrString = [[NSAttributedString alloc] initWithString:@"LEADERBOARD" attributes:@{ NSParagraphStyleAttributeName : style, NSForegroundColorAttributeName : [UIColor colorWithRed:153.0f/255.0f green:211.0f/255.0f blue:212.0f/255.0f alpha:1.0f], NSFontAttributeName : [UIFont fontWithName:@"HelveticaNeue-Bold" size:20.0]}];

    leaderboardtit = [[UILabel alloc] initWithFrame:CGRectMake(0, 20, 320, 60)];
    leaderboardtit.backgroundColor = [UIColor colorWithRed:218.0f/255.0f green:247.0f/255.0f blue:220.0f/255.0f alpha:1.0f];
    leaderboardtit.numberOfLines = 0;
    leaderboardtit.attributedText = attrString;
    [self.view addSubview:leaderboardtit];
    
    username = [[UILabel alloc] initWithFrame:CGRectMake(10, 90, 140, 20)];
    username.backgroundColor = [UIColor colorWithRed:153.0f/255.0f green:211.0f/255.0f blue:212.0f/255.0f alpha:1.0f];
    username.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:14.0];
    username.textColor = [UIColor colorWithRed:218.0f/255.0f green:247.0f/255.0f blue:220.0f/255.0f alpha:1.0f];
    NSDictionary *underlineAttribute = @{NSUnderlineStyleAttributeName: @(NSUnderlineStyleSingle)};
    username.attributedText = [[NSAttributedString alloc] initWithString:@"USERNAME"
                                                               attributes:underlineAttribute];
    username.textAlignment = NSTextAlignmentLeft;
    [self.view addSubview:username];
    
    matches = [[UILabel alloc] initWithFrame:CGRectMake(170, 90, 140, 20)];
    matches.backgroundColor = [UIColor colorWithRed:153.0f/255.0f green:211.0f/255.0f blue:212.0f/255.0f alpha:1.0f];
    matches.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:14.0];
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
                    
                    //transfer = entries;
                }
                NSSortDescriptor * descriptor = [[NSSortDescriptor alloc] initWithKey:@"matches" ascending:NO selector:@selector(localizedStandardCompare:)];
                NSArray *entrieshold = [entries sortedArrayUsingDescriptors:@[descriptor]];
                transfer = [entrieshold copy];
                
                /*transfer = [entries sortedArrayUsingComparator:^NSComparisonResult(NSDictionary* a, NSDictionary* b) {
                    NSDate *first  = [a objectForKey:@"matches"];
                    NSDate *second = [b objectForKey:@"matches"];
                    NSLog(first);
                    NSLog(second);
                    return [first compare:second];
                }];*/
                //dictionary = [NSDictionary dictionaryWithObjects:matchesForUser forKeys:tableData];
                //sortedFirstArray = [dictionary allKeys];
                //sortedSecondArray = [dictionary objectsForKeys:sortedFirstArray notFoundMarker:[NSNull null]];
                //sortedSecondArray = [sortedSecondArray sortedArrayUsingSelector: @selector(compare:)];
                [_tableView reloadData];
                [_tableViewScore reloadData];
                
            }else{
                NSLog([error description]);
            }
            
            NSLog(@"***tabledata***");
            NSLog([NSString stringWithFormat:@"%lu", (unsigned long)[tableData count]]);
            NSLog(@"***matchesdata***");
            NSLog([NSString stringWithFormat:@"%lu", (unsigned long)[matchesForUser count]]);
        });
    }];
    
    /*dictionary = [NSDictionary dictionaryWithObjects:matchesForUser forKeys:tableData];
    sortedFirstArray = [[dictionary allKeys] sortedArrayUsingSelector:@selector(compare:)];
    sortedSecondArray = [dictionary objectsForKeys:sortedFirstArray notFoundMarker:[NSNull null]];*/
    
    backToMap = [[UIButton alloc] initWithFrame:CGRectMake(10, 498, 300, 60)];
    backToMap.backgroundColor = [UIColor colorWithRed:218.0f/255.0f green:247.0f/255.0f blue:220.0f/255.0f alpha:1.0f];
    backToMap.titleLabel.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:20.0];
    [backToMap setTitleColor:[UIColor colorWithRed:153.0f/255.0f green:211.0f/255.0f blue:212.0f/255.0f alpha:1.0f] forState:UIControlStateNormal];
    [backToMap addTarget:self action:@selector(dismiss) forControlEvents:UIControlEventTouchUpInside];
    [backToMap setTitle:@"BACK TO MAP" forState:UIControlStateNormal];
    //backToMap.layer.masksToBounds = true;
    //backToMap.layer.cornerRadius = 8.0;
    [self.view addSubview:backToMap];
}

- (void)dismiss {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [tableData count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if(tableView.tag == 1) {
        static NSString *simpleTableIdentifier = @"SimpleTableItem";
        
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
        cell.textLabel.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:16.0];
        cell.textLabel.textColor = [UIColor colorWithRed:218.0f/255.0f green:247.0f/255.0f blue:220.0f/255.0f alpha:1.0f];
        cell.backgroundColor = [UIColor colorWithRed:153.0f/255.0f green:211.0f/255.0f blue:212.0f/255.0f alpha:1.0f];
        cell.layoutMargins = UIEdgeInsetsZero;
        cell.preservesSuperviewLayoutMargins = NO;
        
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
        }
        
        UILabel *contentV = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 230, 44)];
        contentV.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:16.0];
        contentV.textColor = [UIColor colorWithRed:218.0f/255.0f green:247.0f/255.0f blue:220.0f/255.0f alpha:1.0f];
        contentV.backgroundColor = [UIColor colorWithRed:153.0f/255.0f green:211.0f/255.0f blue:212.0f/255.0f alpha:1.0f];

        cell.contentView.layoutMargins = UIEdgeInsetsZero;

        NSString *username2 = [[transfer objectAtIndex:indexPath.row] valueForKey:@"username"];
        
        NSLog(@"***username***");
        NSLog(username2);
        
        contentV.text = username2;
        [cell.contentView addSubview:contentV];

        return cell;
    }
    else {
        static NSString *simpleTableIdentifier = @"SimpleTableItem";
        
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
        cell.textLabel.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:16.0];
        cell.textLabel.textColor = [UIColor colorWithRed:153.0f/255.0f green:211.0f/255.0f blue:212.0f/255.0f alpha:1.0f];
        cell.backgroundColor = [UIColor colorWithRed:218.0f/255.0f green:247.0f/255.0f blue:220.0f/255.0f alpha:1.0f];
        cell.textLabel.textAlignment = NSTextAlignmentCenter;
        
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
        }
        
        NSString *matchAmount = [[transfer objectAtIndex:indexPath.row] valueForKey:@"matches"];
        NSLog(@"***matchamount***");
        NSLog(matchAmount);
        
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
