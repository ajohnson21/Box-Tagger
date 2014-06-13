//
//  IDAChooseRoomVC.m
//  Inventory Detail
//
//  Created by Austen Johnson on 5/23/14.
//  Copyright (c) 2014 Austen Johnson. All rights reserved.
//

#import "IDAChooseRoomVC.h"
#import "IDAInventoryListTVC.h"
#import "IDASingleton.h"

@interface IDAChooseRoomVC ()

@end

@implementation IDAChooseRoomVC
{
    UIButton * roomName;
    NSArray * roomNames;
    NSArray * roomImages;
    IDAInventoryListTVC * InventoryTVC;
    NSMutableDictionary *newBox;

}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        
        UIImageView *backgroundImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bg"]];
        [self.view addSubview:backgroundImage];
        [self.view sendSubviewToBack:backgroundImage];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    roomNames = @[@"Kitchen", @"Dining Room", @"Living Room", @"Family Room", @"Bathroom", @"Bedroom", @"Office", @"Foyer", @"Other"];
    roomImages = @[@"room1", @"room4", @"room2", @"room6", @"room8", @"room9", @"room3", @"room7", @"additem"];

    int cols = 3;
    int rows = 3;
    float width = 96;
    float height = 96;
    
    for (int r = 0; r < rows; r++)
    {
        for (int c = 0; c < cols; c++)
        {
            float squareX = ((width) * c) + 16;
            float squareY = ((height) * r) + 128;
            
            roomName = [[UIButton alloc] initWithFrame:CGRectMake(squareX + 8, squareY + 8, width - 16, height - 16)];
            roomName.backgroundColor = [UIColor lightGrayColor];
            roomName.titleLabel.font = [UIFont fontWithName:@"Avenir-Black" size:12];
            [roomName addTarget:self action:@selector(pushBeginInventory:) forControlEvents:UIControlEventTouchUpInside];
            NSString* roomNameString = roomNames[r*cols+c];
            [roomName setTitle:roomNameString forState:UIControlStateNormal];
            [roomName setTitleColor:[UIColor clearColor] forState:UIControlStateNormal];
            [roomName setImage:[UIImage imageNamed:roomImages[r*cols+c]] forState:UIControlStateNormal];
            roomName.tag = r*cols+c;
            [self.view addSubview:roomName];
        }
    }
}

-(void)viewWillAppear:(BOOL)animated
{
    self.navigationController.navigationBarHidden = NO;
    self.navigationController.toolbarHidden = YES;
}

- (void)pushBeginInventory:(UIButton *)sender
{
    newBox = [[IDASingleton sharedCollection] newBox];
    InventoryTVC = [[IDAInventoryListTVC alloc] initWithStyle:UITableViewStylePlain];
    
    InventoryTVC.roomTag = sender.titleLabel.text;
    NSLog(@"room tag %@",sender.titleLabel.text);
    [[IDASingleton sharedCollection] currentBox][@"room"] = sender.titleLabel.text;

    [self.navigationController pushViewController:InventoryTVC animated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
