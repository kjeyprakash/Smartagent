//
//  ProfileViewController.h
//  SmartAgent
//
//  Created by Dhanam on 09/02/15.
//  Copyright (c) 2015 suhasoft. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ProfileViewController : UIViewController
{
    NSString *userID;
    NSString *username;
     NSString *pswrd;
    NSString *email;
    NSString *mobileno;
}
@property (weak, nonatomic) IBOutlet UILabel *password;

@property (weak, nonatomic) IBOutlet UIImageView *profileImageView;


@property (weak, nonatomic) IBOutlet UIButton *changepassword;

@property (weak, nonatomic) IBOutlet UIButton *updateprofile;


@property (weak, nonatomic) IBOutlet UILabel *agentname;
@property (weak, nonatomic) IBOutlet UILabel *cearegnumber;

@property (weak, nonatomic) IBOutlet UILabel *companynumber;
@property (weak, nonatomic) IBOutlet UILabel *mobilenumber;
@property (weak, nonatomic) IBOutlet UILabel *emailid;
@end
