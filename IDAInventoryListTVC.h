//
//  IDAInventoryListTVC.h
//  Inventory Detail
//
//  Created by Austen Johnson on 5/26/14.
//  Copyright (c) 2014 Austen Johnson. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface IDAInventoryListTVC : UITableViewController

@property (nonatomic) NSString * roomTag;
-(int)getUniqueBoxID:(int)from to:(int)to;

@end
