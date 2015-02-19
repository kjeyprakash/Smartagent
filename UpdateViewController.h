//
//  UpdateViewController.h
//  SmartAgent
//
//  Created by Dhanam on 09/02/15.
//  Copyright (c) 2015 suhasoft. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UpdateViewController : UIViewController
{
    NSString *userID;
    NSString *username;
    NSString *email;
    NSString *mobile;
    
}
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (nonatomic,strong) NSString *email_format;


@property (weak, nonatomic) IBOutlet UITextField *agentname;
@property (weak, nonatomic) IBOutlet UITextField *estateagentname;
@property (weak, nonatomic) IBOutlet UITextField *designation;
@property (weak, nonatomic) IBOutlet UITextField *mobileno;
@property (weak, nonatomic) IBOutlet UITextField *emailaddress;

@end
