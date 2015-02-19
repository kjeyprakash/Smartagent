//
//  UpdateViewController.m
//  SmartAgent
//
//  Created by Dhanam on 09/02/15.
//  Copyright (c) 2015 suhasoft. All rights reserved.
//

#import "UpdateViewController.h"

@interface UpdateViewController ()<NSXMLParserDelegate>
@property NSString *soapMessage;
@property NSString *currentElement;
@property NSMutableData *webResponseData;
#define Email_symbols @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";

@end

@implementation UpdateViewController
@synthesize agentname;
@synthesize estateagentname;
@synthesize designation;
@synthesize mobileno;
@synthesize emailaddress;
@synthesize scrollView,email_format;

@synthesize soapMessage,  webResponseData, currentElement;
- (IBAction)back:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}



- (void)viewDidLoad
{
    [super viewDidLoad];
    email_format = Email_symbols;
    userID = [[NSUserDefaults standardUserDefaults]
              stringForKey:@"userID"];
    NSLog(@"userID == %@",userID);
    
    
    username = [[NSUserDefaults standardUserDefaults]
              stringForKey:@"username"];
    NSLog(@"username == %@",username);
    self.agentname.text = username;
    
    email = [[NSUserDefaults standardUserDefaults]
              stringForKey:@"email"];
    NSLog(@"email == %@",email);
    self.emailaddress.text = email;
    
    mobile = [[NSUserDefaults standardUserDefaults]
              stringForKey:@"ContactNo"];
    NSLog(@"mobile == %@",mobile);
    self.mobileno.text = mobile;
    
    
    // Do any additional setup after loading the view.
}

-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    
    if(textField == agentname){
        [scrollView setContentOffset:CGPointMake(0, 0) animated:YES];
    }
    else if(textField == estateagentname){
        [scrollView setContentOffset:CGPointMake(0, 10) animated:YES];
    }
    else if(textField == emailaddress){
        [scrollView setContentOffset:CGPointMake(0, 20) animated:YES];
    }
    else if(textField == designation){
        [scrollView setContentOffset:CGPointMake(0, 30) animated:YES];
    }
    
    else if(textField == mobileno){
        [scrollView setContentOffset:CGPointMake(0, 40) animated:YES];
    }
    
    
    return YES;
}


- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    if (textField == agentname)
    {
        
        [textField resignFirstResponder];
        
        [estateagentname becomeFirstResponder];
        
    }
    
    else if (textField == estateagentname)
    {
        
        [textField resignFirstResponder];
        [scrollView setContentOffset:CGPointMake(0, 10)];
         [emailaddress becomeFirstResponder];
       // [self performSelector:@selector(Login:) withObject:nil];
        
    }
    else if (textField == emailaddress)
    {
        
        [textField resignFirstResponder];
        [scrollView setContentOffset:CGPointMake(0, 30)];
        [designation becomeFirstResponder];
        // [self performSelector:@selector(Login:) withObject:nil];
        
    }

    else if (textField == designation)
    {
        
        [textField resignFirstResponder];
        [scrollView setContentOffset:CGPointMake(0, 20)];
        [mobileno becomeFirstResponder];
        // [self performSelector:@selector(Login:) withObject:nil];
        
    }
    else if (textField == mobileno)
    {
        
        [textField resignFirstResponder];
        [scrollView setContentOffset:CGPointMake(0, 0)];
       
        [self performSelector:@selector(update:) withObject:nil];
        
    }


    
    return YES;
    
}




- (void) alertStatus:(NSString *)msg :(NSString *) title
{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:title message:msg delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    [alertView show];
}
- (IBAction)update:(id)sender {
    
    
     NSLog(@"username == %@",agentname.text);
     if([[agentname text] isEqualToString:@""] || [[emailaddress text] isEqualToString:@""]||[[mobileno text] isEqualToString:@""])
     {
         [self alertStatus:@"Please Enter the all fileds." :@"Warning!"];
         
     }
    else
    {
        [self UpdateUserProfileDetails];
        
    }
}

-(void)UpdateUserProfileDetails
{
    [mobileno resignFirstResponder];
    
    @try {
        
        NSString *emailRegEx = email_format;
        
        NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegEx];
        
        if ([emailTest evaluateWithObject:emailaddress.text] == NO)
        {
            [self alertStatus:@"Please correct email ID" :@"Register Failed!"];
            
        }
        
        
        //first create the soap envelope
        soapMessage = [NSString stringWithFormat:@"<?xml version=\"1.0\" encoding=\"utf-8\"?>"
                       "<soap:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\">"
                       "<soap:Body>"
                       "<UpdateUserProfileDetails xmlns=\"http://tempuri.org/\">"
                       "<Id>%@</Id>"
                       "<UserName>%@</UserName>"
                       "<UserIdEmailId>%@</UserIdEmailId>"
                       "<ContactNo>%@</ContactNo>"
                       "</UpdateUserProfileDetails>"
                       "</soap:Body>"
                       "</soap:Envelope>",userID,agentname.text,emailaddress.text,mobileno.text];
        // NSLog(@"The request format is %@",soapMessage);
        //Now create a request to the URL
        NSURL *url = [NSURL URLWithString:@"http://smartagentmobadmin.smartagent.sg/WebService1.asmx"];
        NSMutableURLRequest *theRequest = [NSMutableURLRequest requestWithURL:url];
        NSString *msgLength = [NSString stringWithFormat:@"%lu", (unsigned long)[soapMessage length]];
        
        //ad required headers to the request
        [theRequest addValue:@"smartagentmobadmin.smartagent.sg" forHTTPHeaderField:@"Host"];
        [theRequest addValue: @"text/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
        [theRequest addValue: @"http://tempuri.org/UpdateUserProfileDetails"
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
        [self alertStatus:@" Failed." :@" Warning!"];
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
    if ([currentElement isEqualToString:@"UpdateUserProfileDetailsResult"] ) {
        
        //NSLog(@"resultLabel : %@",resultLabel.text);
        [self alertStatus:@"Profile has been changed" :@"success!"];
        
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
