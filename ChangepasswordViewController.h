//
//  ChangepasswordViewController.h
//  SmartAgent
//
//  Created by Dhanam on 09/02/15.
//  Copyright (c) 2015 suhasoft. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ChangepasswordViewController : UIViewController 
{
    NSString *userID;
    NSString *username;
    NSString *pswrd;
}

@property (weak, nonatomic) IBOutlet UITextField *agentname;

@property (weak, nonatomic) IBOutlet UITextField *currentpassword;
@property (weak, nonatomic) IBOutlet UITextField *newpassword;
@property (weak, nonatomic) IBOutlet UITextField *confirmpassword;

@end
