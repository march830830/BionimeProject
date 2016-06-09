//
//  MainController.m
//  BionimeProject
//
//  Created by 陳泓諺 on 2016/6/8.
//  Copyright © 2016年 陳泓諺. All rights reserved.
//

#import "MainController.h"
#import "HeaderView.h"
#import "MWFeedParser.h"
#import "NSString+HTML.h"
#import "MainModel.h"

@interface MainController ()<UITableViewDataSource,UITableViewDelegate,MWFeedParserDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) HeaderView *headerView;
@property (nonatomic, strong) MWFeedParser *feedParser;
@property (nonatomic, strong) NSMutableArray *tempArray;

@end

@implementation MainController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.headerView = [[UINib nibWithNibName:@"HeaderView" bundle:nil] instantiateWithOwner:nil options:nil][0];
    self.headerView.frame = CGRectMake(0, 0, CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame));
    self.tableView.tableHeaderView = self.headerView;
    
    NSURL *feedURL = [NSURL URLWithString:@"http://www.cwb.gov.tw/rss/forecast/36_08.xml"];
    self.feedParser = [[MWFeedParser alloc] initWithFeedURL:feedURL];
    self.feedParser.delegate = self;
    self.feedParser.feedParseType = ParseTypeFull; // Parse feed info and all items
    self.feedParser.connectionType = ConnectionTypeAsynchronously;
    [self.feedParser parse];
 
}

- (void)updateTableWithParsedItems {
    [MainModel shareInstance].itemsToDisplay = [[MainModel shareInstance].parsedItems sortedArrayUsingDescriptors:[NSArray arrayWithObject:[[NSSortDescriptor alloc] initWithKey:@"date"
                                                                                ascending:NO]]];
    self.tableView.userInteractionEnabled = YES;
    
    NSArray *todayArray = [NSArray array];
    NSMutableArray *todayDataArray = [NSMutableArray array];
    MWFeedItem *todayItem = [[MainModel shareInstance].itemsToDisplay objectAtIndex:0];
    self.headerView.todayInfoLabel.text = todayItem.title;
    self.headerView.todaySummaryLabel.text = todayItem.summary;
    if (todayItem.summary) {
        todayArray = [todayItem.summary componentsSeparatedByString:@" <br> "];
        
        for (int i = 0; i < todayArray.count; i ++) {
            [todayDataArray addObject:[[todayArray objectAtIndex:i] componentsSeparatedByString:@" "]];
        }
    }
    NSLog(@"today = %@",todayDataArray[0][0]);
    NSLog(@"today = %@",todayDataArray[0][1]);
    NSLog(@"today = %@",todayDataArray[0][2]);
    NSLog(@"today = %@",todayDataArray[0][3]);
    NSLog(@"today = %@",todayDataArray[0][4]);
    NSLog(@"today = %@",todayDataArray[0][5]);
    NSLog(@"today = %@",todayDataArray[0][6]);
    NSLog(@"today = %@",todayDataArray[0][7]);

    NSLog(@"today = %@",todayDataArray[1][0]);
    NSLog(@"today = %@",todayDataArray[1][1]);
    NSLog(@"today = %@",todayDataArray[1][2]);
    NSLog(@"today = %@",todayDataArray[1][3]);
    NSLog(@"today = %@",todayDataArray[1][4]);
    NSLog(@"today = %@",todayDataArray[1][5]);
    NSLog(@"today = %@",todayDataArray[1][6]);
    NSLog(@"today = %@",todayDataArray[1][7]);
//    NSLog(@"today = %@",todayArray[1]);

//
    
    MWFeedItem *weeklyItem = [[MainModel shareInstance].itemsToDisplay objectAtIndex:1];
    [MainModel shareInstance].summaryString = weeklyItem.summary;
    [MainModel shareInstance].dateString = weeklyItem.title;
    NSArray *weeklyArray = [NSArray array];
    if ([MainModel shareInstance].summaryString) {
        weeklyArray = [[MainModel shareInstance].summaryString componentsSeparatedByString:@"<BR> "];
        
        for (int i = 0; i< weeklyArray.count; i ++) {
            [[MainModel shareInstance].weeklyArray addObject:[[weeklyArray objectAtIndex:i] componentsSeparatedByString:@" "]];
        }
        
//        NSLog(@"%@",[MainModel shareInstance].weeklyArray);

    }

    [self.tableView reloadData];
}

#pragma mark MWFeedParserDelegate

- (void)feedParserDidStart:(MWFeedParser *)parser {
    //    NSLog(@"Started Parsing: %@", parser.url);
}

- (void)feedParser:(MWFeedParser *)parser didParseFeedInfo:(MWFeedInfo *)info {
//        NSLog(@"infoTitle: “%@”", info.title);
//        NSLog(@"infoSummary: “%@”", info.summary);
    
    self.title = info.title;
}

- (void)feedParser:(MWFeedParser *)parser didParseFeedItem:(MWFeedItem *)item {
//        NSLog(@"itemTitle: “%@”", item.title);
//        NSLog(@"itemSummary: “%@”", item.summary);
    //    NSLog(@"Parsed Feed author: “%@”", item.author);
    //    NSLog(@"Parsed Feed date: “%@”", item.date);
    
    if (item) [[MainModel shareInstance].parsedItems addObject:item];
}
//
- (void)feedParserDidFinish:(MWFeedParser *)parser {
    //    NSLog(@"Finished Parsing%@", (parser.stopped ? @" (Stopped)" : @""));
    [self updateTableWithParsedItems];
}

- (void)feedParser:(MWFeedParser *)parser didFailWithError:(NSError *)error {
    NSLog(@"Finished Parsing With Error: %@", error);
    //    if (parsedItems.count == 0) {
    //        self.title = @"Failed"; // Show failed message in title
    //    } else {
    //        // Failed but some items parsed, so show and inform of error
    //        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Parsing Incomplete"
    //                                                        message:@"There was an error during the parsing of this feed. Not all of the feed items could parsed."
    //                                                       delegate:nil
    //                                              cancelButtonTitle:@"Dismiss"
    //                                              otherButtonTitles:nil];
    //        [alert show];
    //    }
    //    [self updateTableWithParsedItems];
}


- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [MainModel shareInstance].weeklyArray.count;
}

- (UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *identify = @"cellIdentifier";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identify];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identify];
    }
    
    cell.textLabel.text = [MainModel shareInstance].weeklyArray[indexPath.row];
    cell.textLabel.numberOfLines = 0;
    
    return cell;
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 80;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
