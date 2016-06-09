//
//  DataBaseModel.h
//  VeryHive
//
//  Created by 陳泓諺 on 2015/11/9.
//  Copyright © 2015年 Xuan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FMDB.h"

@interface DataBaseModel : NSObject

+ (DataBaseModel*) shareInstance;
- (void)create;
@property (nonatomic, strong) FMDatabase *db;
- (void)deleteDataBaseByTableName:(NSString*)tableName;
-(NSArray*)readDataBaseByTableName:(NSString*)tableName;
- (void)insertDataBaseByToday:(NSString*)todayString Time:(NSString*)timeString Status:(NSString*)statusString TempMin:(NSString*)tempMinString TempMax:(NSString*)tempMaxString Rain:(NSString*)rainString TableName:(NSString*)tableName;
- (void) insertDataBaseByInfo:(NSString*)infoString TableName:(NSString*)tableName;



-(NSArray*)rreadDataBaseByTableName:(NSString*)tableName;

@end
