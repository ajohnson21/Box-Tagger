//
//  IDAExistingFileTVC.m
//  Inventory Detail
//
//  Created by Austen Johnson on 5/27/14.
//  Copyright (c) 2014 Austen Johnson. All rights reserved.
//

#import "IDAExistingFileTVC.h"
#import "IDASingleton.h"
#import "IDATableViewCell.h"
#import "IDAChooseRoomVC.h"

@interface IDAExistingFileTVC () <UITextFieldDelegate>

@end

@implementation IDAExistingFileTVC
{
    UITextField * searchFile;
    UIBarButtonItem * button1;
    UIBarButtonItem * button2;
    UIBarButtonItem * flexible;
    NSMutableArray * searchedItems;
    UILabel *roomLabel;
}

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {

        UIImageView *backgroundImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bg"]];
        backgroundImage.frame = CGRectMake(0, -100, 320, 520);
        [self.view addSubview:backgroundImage];
        [self.view sendSubviewToBack:backgroundImage];
        
        self.tableView.separatorColor = [UIColor colorWithWhite:1.0 alpha:0.2];

        UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapScreen)];
        [self.view addGestureRecognizer:tap];

    }
    return self;
}

-(void)tapScreen
{
    [searchFile resignFirstResponder];
}

-(void)viewDidAppear:(BOOL)animated
{
    [searchFile becomeFirstResponder];
}

- (void)viewWillAppear:(BOOL)animated
{
    self.navigationController.navigationBarHidden = NO;
    self.navigationController.navigationBar.translucent = NO;
    self.navigationController.toolbar.translucent = NO;
    
    // clears out empty boxes
    
    for (NSMutableDictionary * box in [[[IDASingleton sharedCollection] allBoxItems] copy])
    {
        if ([box[@"id"] isEqualToString:@""])
        {
            [[IDASingleton sharedCollection] removeBoxItem:box];
        }
    }
    NSLog(@"%@",[[IDASingleton sharedCollection] allBoxItems]);
    
    self.navigationItem.hidesBackButton = YES;
    [self.tableView setContentInset:UIEdgeInsetsMake(80,0,0,0)];
    self.tableView.rowHeight = 35;
    self.tableView.allowsMultipleSelectionDuringEditing = NO;

    searchFile = [[UITextField alloc] initWithFrame:CGRectMake(0, 0, 220, 30)];
    searchFile.backgroundColor = [UIColor lightGrayColor];
    searchFile.placeholder = @"Add or Search";
    searchFile.autocorrectionType = FALSE;
    searchFile.autocapitalizationType = UITextAutocapitalizationTypeNone;
    searchFile.backgroundColor = [UIColor lightGrayColor];
    searchFile.keyboardType = UIKeyboardTypeTwitter;
    self.navigationItem.titleView = searchFile;
    
    UIBarButtonItem * submitButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSearch target:self action:@selector(searchFile:)];
    submitButton.tintColor = [UIColor blackColor];
    self.navigationItem.rightBarButtonItem = submitButton;
    [self setNeedsStatusBarAppearanceUpdate];
    
    UIBarButtonItem * addItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addItem:)];
    addItem.tintColor = [UIColor blackColor];
    self.navigationItem.leftBarButtonItem = addItem;
    [self setNeedsStatusBarAppearanceUpdate];

    
    button1 = [[UIBarButtonItem alloc] initWithTitle:@"Delete" style:UIBarButtonItemStylePlain target:self action:@selector(deleteTabPressed)];
    button1.tintColor = [UIColor colorWithRed:0.933f green:0.000f blue:0.145f alpha:1.0f];
    button2 = [[UIBarButtonItem alloc] initWithTitle:@"Cancel" style:UIBarButtonItemStylePlain target:self action:@selector(cancelTabPressed)];
    button2.tintColor = [UIColor colorWithRed:0.933f green:0.000f blue:0.145f alpha:1.0f];
    flexible = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
    
    self.navigationController.toolbarHidden = NO;
    [self setToolbarItems:@[flexible, button1, flexible, button2, flexible] animated:YES];
}

- (void)addItem:(UIButton *)sender
{
    if ([[IDASingleton sharedCollection] selectedBox])
    {
        NSString * newItem = searchFile.text;
        searchFile.text = @"";
        
        [[IDASingleton sharedCollection] addListItem:newItem];
        
        [self.tableView reloadData];
        [searchFile resignFirstResponder];
    }
    else
    {
        if ([searchFile.text isEqual:@""])  return;
       
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle: @"Alert" message: @"Choose a box to add that item to" delegate: nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        
        searchFile.text = @"";
//        NSLog(@"There is no box to add your item to");
    }
}

- (void)searchFile:(UIBarButtonItem *)sender
{
    if ([searchFile.text  isEqual: @""]) { return;}
    
    BOOL boxFound = NO;
    
    searchedItems = [@[] mutableCopy];
    
    NSString * searchValue = searchFile.text;
    
    if ([searchValue intValue] > 0)
    {
        // is box_id
        roomLabel.text = @"";
        for (NSMutableDictionary * box in [[IDASingleton sharedCollection] allBoxItems])
        {
//            NSLog(@"%@",box[@"id"]);
//            NSLog(@"%@",searchFile.text);
            
            if ([box[@"id"] isEqualToString:searchFile.text])
            {
                [[IDASingleton sharedCollection] setSelectedBox:box];
                [self.tableView reloadData];
                
                boxFound = YES;
                
                searchFile.text = @"";
            }
        }
    }
else
    {
        roomLabel.text = @"";
        // is box item
        NSMutableArray * holdBoxIds = [@[] mutableCopy];

        for (NSMutableDictionary * box in [[IDASingleton sharedCollection] allBoxItems])
        {
            for (NSString * item in box[@"items"])
            {
//                NSLog(@"%@",item);
//                NSLog(@"%@",searchFile.text);
                
                if ([item isEqualToString:searchFile.text])
                {
                    [holdBoxIds addObject:box[@"id"]];
                    
                    [[IDASingleton sharedCollection] setSelectedBox:box];

//                    NSLog(@"searched items %@", searchedItems);
                    
                    [self.tableView reloadData];
                    
                    boxFound = YES;
                }
            }
        }
        if ([holdBoxIds count] > 0)
        {
            roomLabel.text = @"";
            NSString * msgStr = [holdBoxIds componentsJoinedByString:@"\n"];
            
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Your item is in box number" message:[NSString stringWithFormat:@"%@", msgStr] delegate: nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert show];
        }
        searchFile.text = @"";
    }
    
    if (!boxFound)
    {
        roomLabel.text = @"";
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle: @"Alert" message: @"There is no box with that number" delegate: nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        searchFile.text = @"";
    } else {
        roomLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, -50, 320, 50)];
        roomLabel.backgroundColor = [UIColor clearColor];
        roomLabel.textAlignment = NSTextAlignmentCenter;
        roomLabel.font = [UIFont fontWithName:@"DamascusMedium" size:34];
        roomLabel.textColor = [UIColor whiteColor];
        roomLabel.text = [NSString stringWithFormat:@"%@",[[IDASingleton sharedCollection] selectedBox][@"room"]];
        [self.view addSubview:roomLabel];
    }
    
    [searchFile resignFirstResponder];
    
}

- (void)deleteTabPressed
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle: @"Alert" message: @"Are you sure you want to delete this box?" delegate: self cancelButtonTitle:@"Yes" otherButtonTitles:@"No", nil];
    [alert show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == [alertView cancelButtonIndex])
    {
//        NSLog(@"Yes");
        [[IDASingleton sharedCollection] removeBoxItem:[[IDASingleton sharedCollection] selectedBox]];
        
        [self.tableView reloadData];
        roomLabel.text = @"";
    }
    else
    {
//        NSLog(@"No");
    }
}

- (void)cancelTabPressed
{
    [[IDASingleton sharedCollection] setSelectedBox:nil];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[[IDASingleton sharedCollection] selectedBox][@"items"] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    
    if (cell == nil) cell = [[IDATableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    
    cell.textLabel.text = [[IDASingleton sharedCollection] selectedBox][@"items"][indexPath.row];
    cell.contentView.backgroundColor = [UIColor clearColor];
    cell.backgroundColor = [UIColor clearColor];
    cell.textLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:28];
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
        [[[IDASingleton sharedCollection] selectedBox][@"items"] removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
        [self.tableView reloadData];
    }
}

@end
