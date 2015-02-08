//
//  PRDatabaseHelper.m
//  kanjijigoku
//
//  Created by Pawel Rusin on 2/7/15.
//  Copyright (c) 2015 Pawel Rusin. All rights reserved.
//

#import "PRDatabaseHelper.h"
#import <sqlite3.h>

#define PR_DB_LOCATION @"http://serwer1456650.home.pl/clientDB.db"

@implementation PRDatabaseHelper
{
    sqlite3 *_database;
}

-(id)init
{
    if(self == [super init])
    
    {
        NSURL *url = [NSURL URLWithString:PR_DB_LOCATION];
        NSError *error;
        NSString *dbString = [[NSString alloc] initWithContentsOfURL:url encoding:NSUTF8StringEncoding error:&error];
        
        if (sqlite3_open([dbString UTF8String], &_database) != SQLITE_OK)
        {
            NSLog(@"Failed to open database!");
        }else
        {
            NSLog(@"Read db ok!");
        }
        
        return self;
    }
    
    return nil;
}



-(void)importDatabase
{
    
}

-(void)importCharactersTable
{
    NSString *query = @"SELECT * FROM znaki ORDER BY ID ASC";
    sqlite3_stmt *statement;
    if (sqlite3_prepare_v2(_database, [query UTF8String], -1, &statement, nil) == SQLITE_OK) {
        while (sqlite3_step(statement) == SQLITE_ROW) {
            
            char *kanji = (char *)sqlite3_column_text(statement, 0);
            char *alternateKanji = (char *) sqlite3_column_text(statement, 1);
            int strokeCount = sqlite3_column_int(statement, 2);
            int radical = sqlite3_column_int(statement, 3);
            int alternateRadical = sqlite3_column_int(statement, 4);
            char *meaning = (char *)sqlite3_column_text(statement, 5);
            // skipping columns with index 6 (pinyin) and 7 (nanori)
            char *note = (char *)sqlite3_column_text(statement, 8);
            char *releatedKanji = (char *)sqlite3_column_text(statement, 9);
            int lesson = sqlite3_column_int(statement, 10);
            int level = sqlite3_column_int(statement, 11);
            int kanjiId = sqlite3_column_int(statement, 12);
            
            //int = sqlite3_column_int(statement, 2);
            //int stateChars = (char *) sqlite3_column_text(statement, 3);

            //[retval addObject:info];

        }
        sqlite3_finalize(statement);
    }
}

-(void)dealloc
{
    sqlite3_close(_database);
}

@end
