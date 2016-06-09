//
//  MainModel.h
//  BionimeProject
//
//  Created by 陳泓諺 on 2016/6/8.
//  Copyright © 2016年 陳泓諺. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MainModel : NSObject

+ (MainModel*) shareInstance;
@property (nonatomic, strong) NSArray *itemsToDisplay;
@property (nonatomic, strong) NSMutableArray *parsedItems;
@property (nonatomic, strong) NSString *dateString;
@property (nonatomic, strong) NSString *summaryString;
@property (nonatomic, strong) NSMutableArray *weeklyArray;

@end
