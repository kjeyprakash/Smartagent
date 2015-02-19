//
//  ViewController.h
//  SmartAgent
//
//  Created by Dhanam on 06/02/15.
//  Copyright (c) 2015 suhasoft. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController<NSXMLParserDelegate>

@property (weak, nonatomic) IBOutlet UILabel *resultLabel;
@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;

@property (weak, nonatomic) IBOutlet UITextField *celsiusText;
@property (weak, nonatomic) IBOutlet UITextField *passwordtext;
@end



