//
//  IDASingleton.h
//  Inventory Detail
//
//  Created by Austen Johnson on 5/26/14.
//  Copyright (c) 2014 Austen Johnson. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface IDASingleton : NSObject

+ (IDASingleton *)sharedCollection;

-(void)addListItem:(NSString *)boxItem;
-(void)removeListItem:(NSString *)boxItem;
- (void)setSelectedBox:(NSMutableDictionary *)box;
- (void)removeBoxItem:(NSMutableDictionary *)box;
- (void)saveData;

- (NSArray *)allBoxItems;
- (NSMutableDictionary *)newBox;
- (NSMutableDictionary *)currentBox;
- (NSMutableDictionary *)selectedBox;

@end
