//
//  ChangepasswordViewController.m
//  SmartAgent
//
//  Created by Dhanam on 09/02/15.
//  Copyright (c) 2015 suhasoft. All rights reserved.
//

#import "ChangepasswordViewController.h"

@interface ChangepasswordViewController () <NSXMLParserDelegate>

    @property NSString *soapMessage;
    @property NSString *currentElement;
    @property NSMutableData *webResponseData;



@end

@implementation ChangepasswordViewController
@synthesize currentpassword,newpassword,confirmpassword;
@synthesize soapMessage,  webResponseData, currentElement;



- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
- (IBAction)back:(UIButton *)sender {
    
  //  [self dismissViewControllerAnimated:YES completion:NULL];
    
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    userID = [[NSUserDefaults standardUserDefaults]
                stringForKey:@"userID"];
    NSLog(@"userID == %@",userID);
    

    
    username = [[NSUserDefaults standardUserDefaults]
              stringForKey:@"username"];
    NSLog(@"username == %@",username);
    
    
    self.agentname.text = username;
    
    pswrd = [[NSUserDefaults standardUserDefaults]
                stringForKey:@"password"];
       NSLog(@"pswrd == %@",pswrd);
   
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    if (textField == currentpassword)
    {
        
        [textField resignFirstResponder];
        
        [newpassword becomeFirstResponder];
        
    }
    
    else if (textField == newpassword)
    {
        
        [textField resignFirstResponder];
   //     [scrollView setContentOffset:CGPointMake(0, 0)];
       
        
    }
    
    else if (textField == confirmpassword)
    {
        
        [textField resignFirstResponder];
        //     [scrollView setContentOffset:CGPointMake(0, 0)];
        [self performSelector:@selector(Changepassword:) withObject:nil];
        
    }
    
    
    return YES;
    
}



- (void) alertStatus:(NSString *)msg :(NSString *) title
{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:title message:msg delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    [alertView show];
}

- (IBAction)Changepassword:(UIButton *)sender
{
    
  
        if([[currentpassword text] isEqualToString:@""] )
        {//|| [[newpassword text] isEqualToString:@""] ||  [[confirmpassword text] isEqualToString:@""] ) {
            [self alertStatus:@"Please enter the all fileds" :@"Warning!"];
        
          }
    
    else if ([currentpassword.text isEqualToString:pswrd])
    {
       // [self alertStatus:@"password correct" :@"Warning!"];
        
        if([[newpassword text] isEqualToString:@""] ||  [[confirmpassword text] isEqualToString:@""] )
        {
            [self alertStatus:@"Please enter the newpassword and confirmpassword" :@"Failed!"];
            
        }
       else if([newpassword.text isEqualToString:confirmpassword.text])
        {
            
            [self updatepassword];
            
        }

    }
    else if(currentpassword.text != pswrd)
    {
          [self alertStatus:@"Please check the current password" :@"Warning!"];
    }
    else if(currentpassword.text != confirmpassword.text)
    {
        [self alertStatus:@"Password not match" :@"Warning!"];
    }
      // NSLog(@"pswrd == %@",pswrd);
}

-(void) updatepassword
{
    
    [currentpassword resignFirstResponder];
    
    @try {
       
        
        
        //first create the soap envelope
        soapMessage = [NSString stringWithFormat:@"<?xml version=\"1.0\" encoding=\"utf-8\"?>"
                       "<soap:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\">"
                       "<soap:Body>"
                       "<UserChangePassword xmlns=\"http://tempuri.org/\">"
                        "<Id>%@</Id>"
                       "<OldPassword>%@</OldPassword>"
                       "<NewPassword>%@</NewPassword>"
                       "</UserChangePassword>"
                       "</soap:Body>"
                       "</soap:Envelope>",userID,currentpassword.text,confirmpassword.text];
        // NSLog(@"The request format is %@",soapMessage);
        //Now create a request to the URL
        NSURL *url = [NSURL URLWithString:@"http://smartagentmobadmin.smartagent.sg/WebService1.asmx"];
        NSMutableURLRequest *theRequest = [NSMutableURLRequest requestWithURL:url];
        NSString *msgLength = [NSString stringWithFormat:@"%lu", (unsigned long)[soapMessage length]];
        
        //ad required headers to the request
        [theRequest addValue:@"smartagentmobadmin.smartagent.sg" forHTTPHeaderField:@"Host"];
        [theRequest addValue: @"text/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
        [theRequest addValue: @"http://tempuri.org/UserChangePassword"
          forHTTPHeaderField:@"SOAPAction"];
        [theRequest addValue: msgLength forHTTPHeaderField:@"Content-Length"];
        [theRequest setHTTPMethod:@"POST"];
        [theRequest setHTTPBody: [soapMessage dataUsingEncoding:NSUTF8StringEncoding]];
        
        //initiate the request
        NSURLConnection *connection =
        [[NSURLConnection alloc] initWithRequest:theRequest delegate:self];
        
        if(connection)
        {
            webResponseData = [NSMutableData data] ;
        }
        else
        {
            NSLog(@"Connection is NULL");
        }
    }
    @catch (NSException * e) {
        NSLog(@"Exception: %@", e);
        [self alertStatus:@"Login Failed." :@"Login Failed!"];
    }

}
//Implement the connection delegate methods.
-(void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    [self.webResponseData  setLength:0];
    //  [webResponseData setLength: 0];
}

-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    [self.webResponseData  appendData:data];
}

-(void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    NSLog(@"Some error in your Connection. Please try again.");
}

-(void)connectionDidFinishLoading:(NSURLConnection *)connection {
    NSLog(@"Received %lu Bytes", (unsigned long)[webResponseData length]);
    NSString *theXML = [[NSString alloc] initWithBytes:
                        [webResponseData mutableBytes] length:[webResponseData length] encoding:NSUTF8StringEncoding];
    
       NSLog(@"theXML :%@",theXML);
    
    //now parsing the xml
    
    NSData *myData = [theXML dataUsingEncoding:NSUTF8StringEncoding];
    // NSLog(@"myData :%@",myData);
    
    NSXMLParser *xmlParser = [[NSXMLParser alloc] initWithData:myData];
    
    //setting delegate of XML parser to self
    xmlParser.delegate = self;
    
    // Run the parser
    @try{
        BOOL parsingResult = [xmlParser parse];
        //  NSLog(@"parsing result = %hhd",parsingResult);
    }
    @catch (NSException* exception)
    {
        UIAlertView* alert = [[UIAlertView alloc]initWithTitle:@"Server Error" message:[exception reason] delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [alert show];
        return;
    }
}


//Implement the NSXmlParserDelegate methods
-(void) parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName
  namespaceURI:(NSString *)namespaceURI qualifiedName:
(NSString *)qName attributes:(NSDictionary *)attributeDict
{
    currentElement = elementName;
    //  NSLog(@"result : %@",currentElement);
}
- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string
{
    if ([currentElement isEqualToString:@"UserChangePasswordResult"] ) {
     
       //NSLog(@"resultLabel : %@",resultLabel.text);
        [self alertStatus:@"Password has been changed" :@"success!"];
      
    }
    //     NSLog(@"working");
    
}


- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName
  namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName
{
    //  NSLog(@"Parsed Element : %@", currentElement);
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
