//
//  TDatabaseManager.h
//  SQLiteDatabase
//
//  Created by NguyenThanhLuan on 11/05/2017.
//  Copyright © 2017 Olala. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>

@interface TDatabaseManager : NSObject

@property (nonatomic, strong) NSString *documentsDirectory;
@property (nonatomic, strong) NSString *databaseFilename;

@property (nonatomic, strong) NSMutableArray *arrResults;
@property (nonatomic, strong) NSMutableArray *arrColumnNames;

@property (nonatomic) int affectedRows;
@property (nonatomic) long long lastInsertedRowID;

+ (TDatabaseManager *) sharedInstance;

-(instancetype)initWithDatabaseFilename:(NSString *)dbFilename;

-(NSArray *)loadDataFromDB:(NSString *)query;

-(void)runQuery:(const char *)query isQueryExecutable:(BOOL)queryExecutable;
-(void)copyDatabaseIntoDocumentsDirectory;
-(void)executeQuery:(NSString*) query;
-(BOOL)open:(NSString*) dbFile;
-(void)close;

@end
