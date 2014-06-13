//
//  IDAInventoryListTVC.m
//  Inventory Detail
//
//  Created by Austen Johnson on 5/26/14.
//  Copyright (c) 2014 Austen Johnson. All rights reserved.
//

#import "IDAInventoryListTVC.h"
#import "IDAChooseRoomVC.h"
#import "IDATableViewCell.h"
#import "IDASingleton.h"

@interface IDAInventoryListTVC ()

@end

@implementation IDAInventoryListTVC
{
    UITextField * addNewItem;
    UIBarButtonItem * button1;
    UIBarButtonItem * button2;
    UIBarButtonItem * flexible;
}

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self)
    {
        UIImageView *backgroundImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bg"]];
        backgroundImage.frame = CGRectMake(0, -100, 320, 480);
        [self.view addSubview:backgroundImage];
        [self.view sendSubviewToBack:backgroundImage];
        
        self.tableView.separatorColor = [UIColor colorWithWhite:1.0 alpha:0.2];
        
        UITapGestureRecognizer * tap2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapScreen)];
        [self.view addGestureRecognizer:tap2];

    }
    return self;
}

-(void)tapScreen
{
    [addNewItem resignFirstResponder];
}

-(void)viewDidAppear:(BOOL)animated
{
    [addNewItem becomeFirstResponder];
}

- (void)viewWillAppear:(BOOL)animated
{
    self.navigationController.navigationBarHidden = NO;
    self.tableView.allowsMultipleSelectionDuringEditing = NO;
    [self.tableView setContentInset:UIEdgeInsetsMake(100,0,0,0)];
    self.tableView.rowHeight = 35;
    
    UILabel *roomLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, -80, 320, 50)];
    roomLabel.backgroundColor = [UIColor clearColor];
    roomLabel.textAlignment = NSTextAlignmentCenter;
    roomLabel.font = [UIFont fontWithName:@"DamascusMedium" size:40];
    roomLabel.textColor = [UIColor whiteColor];
    roomLabel.text = [NSString stringWithFormat:@"%@", self.roomTag];
    [self.view addSubview:roomLabel];

    addNewItem = [[UITextField alloc] initWithFrame:CGRectMake(0, 0, 220, 30)];
    addNewItem.backgroundColor = [UIColor lightGrayColor];
    addNewItem.placeholder = @"New Item";
    addNewItem.autocorrectionType = FALSE;
    addNewItem.autocapitalizationType = UITextAutocapitalizationTypeNone;
    addNewItem.keyboardType = UIKeyboardTypeTwitter;

    self.navigationItem.titleView = addNewItem;
    
    UIBarButtonItem * submitButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector (newItem)];
    submitButton.tintColor = [UIColor blackColor];
    self.navigationItem.rightBarButtonItem = submitButton;
    [self setNeedsStatusBarAppearanceUpdate];
    
    button1 = [[UIBarButtonItem alloc] initWithTitle:@"Save" style:UIBarButtonItemStylePlain target:self action:@selector(saveTabPressed)];
    button1.tintColor = [UIColor colorWithRed:0.933f green:0.000f blue:0.145f alpha:1.0f];
    button2 = [[UIBarButtonItem alloc] initWithTitle:@"Cancel" style:UIBarButtonItemStylePlain target:self action:@selector(cancelTabPressed)];
    button2.tintColor = [UIColor colorWithRed:0.933f green:0.000f blue:0.145f alpha:1.0f];
    flexible = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
    
    self.navigationController.toolbarHidden = NO;
    [self setToolbarItems:@[flexible, button1, flexible, button2, flexible] animated:YES];
}

- (void)cancelTabPressed
{
    [[IDASingleton sharedCollection] removeBoxItem:[[IDASingleton sharedCollection] currentBox]];
    [[IDASingleton sharedCollection] removeBoxItem:[[IDASingleton sharedCollection] selectedBox]];
    [[IDASingleton sharedCollection] setSelectedBox:nil];

    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (void)newItem
{
    NSString *newItem = addNewItem.text;
    addNewItem.text = @"";

    [[IDASingleton sharedCollection] addListItem:newItem];
    
    [self.tableView reloadData];
    [addNewItem resignFirstResponder];
}

- (void)saveTabPressed
{
    int boxID = [self getUniqueBoxID:10001 to:99999];
    
    NSString *strBoxID = [NSString stringWithFormat:@"%d",boxID];
    NSLog(@"%@",strBoxID);
    [[IDASingleton sharedCollection] currentBox][@"id"] = strBoxID;
    
    [[IDASingleton sharedCollection] saveData];
    
    NSLog(@"what is in currentBox %@", [[IDASingleton sharedCollection] currentBox]);
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle: @"Your box number is" message:[NSString stringWithFormat:@"%@", strBoxID] delegate: nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alert show];
    
    [self.navigationController popToRootViewControllerAnimated:YES];

}

-(int)getUniqueBoxID:(int)from to:(int)to
{
    int boxID = (int)from + arc4random() % (to-from+0);
    return boxID;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[[IDASingleton sharedCollection] currentBox][@"items"] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    IDATableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    
    if (cell == nil) cell = [[IDATableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    
    cell.textLabel.text = [[IDASingleton sharedCollection] currentBox][@"items"][indexPath.row];
    cell.backgroundColor = [UIColor clearColor];
    cell.contentView.backgroundColor = [UIColor clearColor];
//    cell.textLabel.textAlignment = NSTextAlignmentCenter;
    cell.textLabel.font = [UIFont fontWithName:@"AmericanTypewriter-CondensedLight" size:32];
    cell.textLabel.textColor = [UIColor whiteColor];

    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete)
    {
        [[[IDASingleton sharedCollection] currentBox][@"items"] removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
        [self.tableView reloadData];
    }
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    addNewItem.placeholder = @"";
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    addNewItem.placeholder = @" Enter item here";
}

@end
