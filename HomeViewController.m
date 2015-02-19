//
//  HomeViewController.m
//  SmartAgent
//
//  Created by Dhanam on 09/02/15.
//  Copyright (c) 2015 suhasoft. All rights reserved.
//

#import "HomeViewController.h"

@interface HomeViewController ()
@property NSString *soapMessage;
@property NSString *currentElement;

@property NSMutableData *webResponseData;
@end

@implementation HomeViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
   userID = [[NSUserDefaults standardUserDefaults]
                        stringForKey:@"userID"];
    NSLog(@"userID == %@",userID);
  //  [self userlistmobile];

    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
