//
//  DataBaseModel.m
//  VeryHive
//
//  Created by 陳泓諺 on 2015/11/9.
//  Copyright © 2015年 Xuan. All rights reserved.
//

#import "DataBaseModel.h"

@implementation DataBaseModel

+ (DataBaseModel*) shareInstance {
    static DataBaseModel *dataBaseModel = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        dataBaseModel = [[DataBaseModel alloc] init];
    });
    return dataBaseModel;
}

- (instancetype) init {
    self = [super init];
    if (self) {
        
    }
    return self;
}

- (void)create {
    [self openDataBase];
    if (![self.db executeUpdate:@"CREATE TABLE IF NOT EXISTS TODAYMORNING (TODAY text, Time text, Status text, TempMin text, TempMax text, Rain text)"]) {
        NSLog(@"could not create table:%@",[self.db lastErrorMessage]);
    }
    if (![self.db executeUpdate:@"CREATE TABLE IF NOT EXISTS TODAYNIGHT (TODAY text, Time text, Status text, TempMin text, TempMax text, Rain text)"]) {
        NSLog(@"could not create table:%@",[self.db lastErrorMessage]);
    }
    if (![self.db executeUpdate:@"CREATE TABLE IF NOT EXISTS WEEK (Info text)"]) {
        NSLog(@"could not create table:%@",[self.db lastErrorMessage]);
    }
//    if (![[NSUserDefaults standardUserDefaults] objectForKey:@"check"]) {
//        for (int i = 0 ; i <4 ; i ++) {
//        [self insertDataBaseByUserName:@"fuck" Message:@"msg" Time:@"2015-06-06" TableName:@"TYPEONE"];
//        [self insertDataBaseByUserName:@"you" Message:@"msg" Time:@"2015-10-06" TableName:@"TYPETWO"];
//        [self insertDataBaseByUserName:@"SQL" Message:@"msg" Time:@"2015-11-06" TableName:@"TYPETHREE"];
//
//        }
//        [[NSUserDefaults standardUserDefaults] setObject:@"did" forKey:@"check"];
//    }
    [self.db close];
}

-(NSArray*)readDataBaseByTableName:(NSString*)tableName {
    [self openDataBase];
    NSMutableArray* items = [NSMutableArray arrayWithCapacity:0];
    NSString *quary = [NSString stringWithFormat:@"SELECT UserName, Message, Time from %@", tableName];
    FMResultSet *rs = [self.db executeQuery:quary];
    
    while ([rs next]) {
        NSString *message = [rs stringForColumn:@"Message"];
        NSString *userName = [rs stringForColumn:@"UserName"];
        NSString *time = [rs stringForColumn:@"Time"];
        
        [items addObject:[NSDictionary dictionaryWithObjectsAndKeys:userName, @"UserName", message, @"Message", time, @"Time",  nil]];
    }
    
    [rs close];
    return items;
}

-(NSArray*)rreadDataBaseByTableName:(NSString*)tableName {
    [self openDataBase];
    NSMutableArray* items = [NSMutableArray arrayWithCapacity:0];
    NSString *quary = [NSString stringWithFormat:@"SELECT UserName from %@", tableName];
    FMResultSet *rs = [self.db executeQuery:quary];
    
    while ([rs next]) {
//        NSString *message = [rs stringForColumn:@"Message"];
        NSString *userName = [rs stringForColumn:@"UserName"];
//        NSString *time = [rs stringForColumn:@"Time"];
        
        [items addObject:[NSDictionary dictionaryWithObjectsAndKeys:userName, @"UserName",  nil]];
    }
    
    [rs close];
    return items;
}

- (void) insertDataBaseByInfo:(NSString*)infoString TableName:(NSString*)tableName {
    [self openDataBase];
    
    NSString * SQLexecute = [NSString stringWithFormat:@"INSERT INTO %@ (Info) VALUES ('%@')", tableName, infoString];
    //    NSLog(@"%@", SQLexecute);
    [self.db executeUpdate:SQLexecute];
    [self.db close];
}

- (void)insertDataBaseByToday:(NSString*)todayString Time:(NSString*)timeString Status:(NSString*)statusString TempMin:(NSString*)tempMinString TempMax:(NSString*)tempMaxString Rain:(NSString*)rainString TableName:(NSString*)tableName {
    [self openDataBase];

    NSString * SQLexecute = [NSString stringWithFormat:@"INSERT INTO %@ (Today,Time,Status,TempMin,TempMax,Rain) VALUES ('%@','%@','%@','%@','%@','%@')", tableName, todayString,timeString,statusString,tempMinString,tempMaxString,rainString];
//    NSLog(@"%@", SQLexecute);
    [self.db executeUpdate:SQLexecute];
    [self.db close];

}

- (void)updateDataBaseByUserName:(NSString*)userName Message:(NSString*)message TableName:(NSString*)tableName {
    [self openDataBase];
    NSString *SQLexecute = [NSString stringWithFormat:@"UPDATE %@ SET %@ = \"%@\" ",tableName,userName,message];
    [self.db executeUpdate:SQLexecute];
    [self.db close];
    
}

- (void)deleteDataBaseByTableName:(NSString*)tableName {
    [self openDataBase];
    if ([tableName isEqualToString:@"WEEK"]) {
        NSMutableArray* items = [NSMutableArray arrayWithCapacity:0];
        NSString *quary = [NSString stringWithFormat:@"SELECT Info from %@", tableName];
        FMResultSet *rs = [self.db executeQuery:quary];
        
        while ([rs next]) {
            NSString *info = [rs stringForColumn:@"Info"];
            
            [items addObject:[NSDictionary dictionaryWithObjectsAndKeys:info, @"Info",  nil]];
        }
        
        [rs close];
        for (NSDictionary *deleteDic in items) {
            NSString *SQLexecute = [NSString stringWithFormat:@"DELETE FROM %@ WHERE Info = '%@'",tableName,deleteDic[@"Info"]];
            [self.db executeUpdate:SQLexecute];
        }
        [self.db close];
    } else {
        NSMutableArray* items = [NSMutableArray arrayWithCapacity:0];
        NSString *quary = [NSString stringWithFormat:@"SELECT Today,Time,Status,TempMin,TempMax,Rain from %@", tableName];
        FMResultSet *rs = [self.db executeQuery:quary];
        
        while ([rs next]) {
            NSString *today = [rs stringForColumn:@"Today"];
            NSString *time = [rs stringForColumn:@"Time"];
            NSString *status = [rs stringForColumn:@"Status"];
            NSString *tempMin = [rs stringForColumn:@"TempMin"];
            NSString *tempMax = [rs stringForColumn:@"TempMax"];
            NSString *rain = [rs stringForColumn:@"Rain"];
            
            [items addObject:[NSDictionary dictionaryWithObjectsAndKeys:today, @"Today", time, @"Time", status, @"Status", tempMin, @"TempMin", tempMax, @"TempMax", rain, @"Rain",  nil]];
        }
        
        [rs close];
        for (NSDictionary *deleteDic in items) {
            NSString *SQLexecute = [NSString stringWithFormat:@"DELETE FROM %@ WHERE Today = '%@' AND Time = '%@' AND Status = '%@' AND TempMin = '%@' AND TempMax = '%@' AND Rain = '%@'",tableName,deleteDic[@"Today"],deleteDic[@"Time"],deleteDic[@"Status"],deleteDic[@"TempMin"],deleteDic[@"TempMax"],deleteDic[@"Rain"]];
            [self.db executeUpdate:SQLexecute];
        }
        [self.db close];
    }
}

- (void) openDataBase {
    NSString *document = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask ,YES)[0];
    NSString *dbpath = [document stringByAppendingPathComponent:@"MYDataBase.db"];
    self.db = [FMDatabase databaseWithPath:dbpath];
    [self.db open];
    NSLog(@"%@",dbpath);
}

//- (NSString*)readDataBaseByUserName:(NSString*)userName Message:(NSString*)message TableName:(NSString*)tableName {
//    [self openDataBase];
//    NSString *SQLexecute = [NSString stringWithFormat:@"SELECT %@ FROM %@ WHERE",FieldName,tableName];
//    NSString* result = [self.db stringForQuery:SQLexecute];
//    [self.db close];
//    return result;
//}

@end
