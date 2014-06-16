//
//  IDASingleton.m
//  Inventory Detail
//
//  Created by Austen Johnson on 5/26/14.
//  Copyright (c) 2014 Austen Johnson. All rights reserved.
//

#import "IDASingleton.h"

@interface IDASingleton ()

@property (nonatomic) NSMutableArray * boxItems;

@end

@implementation IDASingleton
{
    NSMutableDictionary *selectedBox;
    NSMutableDictionary *currentBox;
    NSMutableDictionary * newBox;
}

+(IDASingleton *)sharedCollection
{
    static dispatch_once_t create;
    static IDASingleton * singleton = nil;
    
    dispatch_once(&create, ^{
        singleton = [[IDASingleton alloc] init];
    });
    return singleton;
}

-(id)init
{
    self = [super init];
    if(self)
    {
        [self loadBoxItems];
    }
    return self;
}

- (void)addListItem:(NSString *)boxItem
{
    [[self currentBox][@"items"] addObject:boxItem];
    [self saveData];
}

- (void)removeListItem:(NSString *)boxItem
{
    [[self currentBox][@"items"] removeObject:boxItem];
    [self saveData];
}

- (void)removeBoxItem:(NSMutableDictionary *)box
{
//    NSLog(@"%@", box);
    [self.boxItems removeObjectIdenticalTo:box];
    selectedBox = nil;
    
    [self saveData];
}

- (NSMutableArray *)boxItems
{
    if(_boxItems == nil)
    {
        _boxItems = [@[] mutableCopy];
    }
    return _boxItems;
}

-(NSArray *)allBoxItems
{
    return [self.boxItems copy];
}

- (void)saveData
{
    NSString * path = [self listArchivePath];
    NSData * data = [NSKeyedArchiver archivedDataWithRootObject:self.boxItems];
    [data writeToFile:path options:NSDataWritingAtomic error:nil];
}

- (NSString *) listArchivePath
{
    NSArray* documentDirectories = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString * documentDirectory = documentDirectories[0];
    return [documentDirectory stringByAppendingPathComponent:@"myBoxes.data"];
}

- (void) loadBoxItems
{
    NSString * path = [self listArchivePath];
    if ([[NSFileManager defaultManager]fileExistsAtPath:path])
    {
        self.boxItems = [NSKeyedUnarchiver unarchiveObjectWithFile:path];
    }
//    NSLog(@"is this stuff loading %@", path);
}

- (NSMutableDictionary *)newBox
{
    newBox = [@{
                                      @"id" : @"",
                                      @"size": @"",
                                      @"room" : @"",
                                      @"items" : [@[] mutableCopy],
                                      } mutableCopy];
    NSLog(@"new box %@",newBox);
    
    [self.boxItems addObject:newBox];
    [self saveData];
    
    return newBox;
}

-(NSMutableDictionary *)currentBox
{
    return [self.boxItems lastObject];
}

- (void)setSelectedBox:(NSMutableDictionary *)box
{
    selectedBox = box;
}

- (NSMutableDictionary *)selectedBox
{
    return selectedBox;
}

@end
