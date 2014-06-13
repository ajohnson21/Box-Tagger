//
//  IDAViewController.m
//  Inventory Detail
//
//  Created by Austen Johnson on 5/23/14.
//  Copyright (c) 2014 Austen Johnson. All rights reserved.
//

#import "IDAViewController.h"
#import "IDAExistingFileTVC.h"
#import "IDAChooseRoomVC.h"

@interface IDAViewController ()

@end

@implementation IDAViewController
{
    IDAChooseRoomVC * chooseRoomVC;
    IDAExistingFileTVC * existingFileTVC;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        UIImageView *backgroundImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bg"]];
        [self.view addSubview:backgroundImage];
        [self.view sendSubviewToBack:backgroundImage];
        
        UIImageView *titlePage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"logo"]];
        [titlePage setFrame:CGRectMake((self.view.frame.size.width /2) - 75, (self.view.frame.size.height /2) - 105, 150, 160)];
        [self.view addSubview:titlePage];
        
        UIButton * existingButton = [[UIButton alloc] initWithFrame:CGRectMake(60, self.view.frame.size.height /2 + 120, 200, 25)];
        existingButton.backgroundColor = [UIColor clearColor];
        [existingButton addTarget:self action:@selector(pushExistingView) forControlEvents:UIControlEventTouchUpInside];
        [existingButton setTitle:@"Find Box" forState:UIControlStateNormal];
        [existingButton.titleLabel setFont:[UIFont fontWithName:@"AmericanTypewriter-CondensedLight" size:32]];
        [self.view addSubview:existingButton];
        
        UIButton * startNewButton = [[UIButton alloc] initWithFrame:CGRectMake(60, self.view.frame.size.height /2 + 155, 200, 25)];
        startNewButton.backgroundColor = [UIColor clearColor];
        [startNewButton addTarget:self action:@selector(pushNewView) forControlEvents:UIControlEventTouchUpInside];
        [startNewButton setTitle:@"Create Box" forState:UIControlStateNormal];
        [startNewButton.titleLabel setFont:[UIFont fontWithName:@"AmericanTypewriter-CondensedLight" size:32]];
        [self.view addSubview:startNewButton];
        
    }
    return self;
}


- (void)pushNewView
{
    chooseRoomVC = [[IDAChooseRoomVC alloc] init];
    [self.navigationController pushViewController:chooseRoomVC animated:YES];
}

- (void)pushExistingView
{
    existingFileTVC = [[IDAExistingFileTVC alloc] init];
    [self.navigationController pushViewController:existingFileTVC animated:YES];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated
{
    self.navigationController.toolbarHidden = YES;
    self.navigationController.navigationBarHidden = YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
