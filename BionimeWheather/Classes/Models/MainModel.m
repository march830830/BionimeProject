//
//  MainModel.m
//  BionimeProject
//
//  Created by 陳泓諺 on 2016/6/8.
//  Copyright © 2016年 陳泓諺. All rights reserved.
//

#import "MainModel.h"

@implementation MainModel

+ (MainModel*) shareInstance {
    static MainModel *mainModel = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        mainModel = [[MainModel alloc] init];
     });
    return mainModel;
}



- (instancetype) init {
    self = [super init];
    if (self) {
        self.itemsToDisplay = [NSArray array];
        self.weeklyArray = [NSMutableArray array];

        
        self.parsedItems = [NSMutableArray array];
    }
    return self;
}

@end
