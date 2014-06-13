//
//  IDATableViewCell.m
//  Inventory Detail
//
//  Created by Austen Johnson on 5/26/14.
//  Copyright (c) 2014 Austen Johnson. All rights reserved.
//

#import "IDATableViewCell.h"

@implementation IDATableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
}

-(void)setIndex:(NSInteger)index
{
    _index = index;
}

@end
