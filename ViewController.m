//
//  ViewController.m
//  SoapWebServiceDemo
//
//  Created by Amogh Natu on 25/04/14.
//  Copyright (c) 2014 Amogh Natu. All rights reserved./Users/dhanam/Desktop/Dhanam/SoapWebServiceDemo-master 2/SoapWebServiceDemo/ViewController.m
//

#import "ViewController.h"
#import "HomeViewController.h"
#import "ProfileViewController.h"

@interface ViewController ()
@property NSString *soapMessage;
@property NSString *currentElement;
@property NSMutableData *webResponseData;
@end

@implementation ViewController

@synthesize resultLabel;
@synthesize scrollView;
@synthesize soapMessage, celsiusText,passwordtext, webResponseData, currentElement;

- (void)viewDidLoad
{
    [super viewDidLoad];
    resultLabel.hidden = YES;
	// Do any additional setup after loading the view, typically from a nib.
}
-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    
    if(textField == celsiusText){
        [scrollView setContentOffset:CGPointMake(0, 0) animated:YES];
    }
    else if(textField == passwordtext){
        [scrollView setContentOffset:CGPointMake(0, 100) animated:YES];
    }
    
    return YES;
}


- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    if (textField == celsiusText)
    {
        
        [textField resignFirstResponder];
        
        [passwordtext becomeFirstResponder];
        
    }
    
    else if (textField == passwordtext)
    {
        
        [textField resignFirstResponder];
        [scrollView setContentOffset:CGPointMake(0, 0)];
        [self performSelector:@selector(Login:) withObject:nil];
        
    }
    
    return YES;
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) alertStatus:(NSString *)msg :(NSString *) title
{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:title message:msg delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    [alertView show];
}

- (IBAction)Login:(id)sender {
    
    [celsiusText resignFirstResponder];
    
    @try {
            if([[celsiusText text] isEqualToString:@""] || [[passwordtext text] isEqualToString:@""] ) {
        [self alertStatus:@"Please enter both Username and Password" :@"Login Failed!"];
    }
    
    
    //first create the soap envelope
    soapMessage = [NSString stringWithFormat:@"<?xml version=\"1.0\" encoding=\"utf-8\"?>"
                   "<soap:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\">"
                   "<soap:Body>"
                   "<LoginVerify xmlns=\"http://tempuri.org/\">"
                   "<UserName>%@</UserName>"
                   "<Password>%@</Password>"
                   "</LoginVerify>"
                   "</soap:Body>"
                   "</soap:Envelope>",celsiusText.text,passwordtext.text];
   // NSLog(@"The request format is %@",soapMessage);
    //Now create a request to the URL
    NSURL *url = [NSURL URLWithString:@"http://smartagentmobadmin.smartagent.sg/WebService1.asmx"];
    NSMutableURLRequest *theRequest = [NSMutableURLRequest requestWithURL:url];
    NSString *msgLength = [NSString stringWithFormat:@"%lu", (unsigned long)[soapMessage length]];
    
    //ad required headers to the request
    [theRequest addValue:@"smartagentmobadmin.smartagent.sg" forHTTPHeaderField:@"Host"];
    [theRequest addValue: @"text/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [theRequest addValue: @"http://tempuri.org/LoginVerify"
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
    
 //   NSLog(@"theXML :%@",theXML);
    
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
    if ([currentElement isEqualToString:@"LoginVerifyResult"] ) {
        self.resultLabel.text = string;
        
        
        NSLog(@"resultLabel : %@",resultLabel.text);
        
        if (![resultLabel.text  isEqual: @"0"]) {
            NSLog(@"Login Success");
            [self userlistmobile];
                    }
        else
        {
            
            NSLog(@"iu : %@",resultLabel.text);
            
        }
        // [self test];
    }
    //     NSLog(@"working");
    else if([currentElement isEqualToString:@"Id"])
    {
        
        NSString *userid;
      [currentElement isEqualToString:@"Id"];
        
        
        userid = resultLabel.text;
      
        self.resultLabel.text = string;
        
        
        NSLog(@"Label : %@",resultLabel.text);
        
        NSUserDefaults *uid = [NSUserDefaults standardUserDefaults];
        [uid setObject:userid forKey:@"userID"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        ProfileViewController *view=[self.storyboard instantiateViewControllerWithIdentifier:@"ProfileViewController"];
        
        
        [self.navigationController pushViewController:view animated:YES ];
        
        

        
        // AppDelegate.userid = userid;
        
        //  NSLog(@"Appdelegate id:%@", AppDelegate.userid);
        // NSLog(@"Status: %@", status);
        NSLog(@"Userid: %@", userid);
        // [self test];
    }
  //  NSLog(@"Label : %@",resultLabel.text);
    
}


- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName
  namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName
{
    //  NSLog(@"Parsed Element : %@", currentElement);
}

///userlistmobile

-(void)userlistmobile
{
    soapMessage = [NSString stringWithFormat:@"<?xml version=\"1.0\" encoding=\"utf-8\"?>"
                   "<soap:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\">"
                   "<soap:Body>"
                   "<UserListmobile xmlns=\"http://tempuri.org/\">"
                   "<userId>%@</userId>"
                   "</UserListmobile>"
                   "</soap:Body>"
                   "</soap:Envelope>",resultLabel.text];
    NSLog(@"The request format is %@",soapMessage);
    //Now create a request to the URL
    NSURL *url = [NSURL URLWithString:@"http://smartagentmobadmin.smartagent.sg/WebService1.asmx"];
    NSMutableURLRequest *theRequest = [NSMutableURLRequest requestWithURL:url];
    NSString *msgLength = [NSString stringWithFormat:@"%lu", (unsigned long)[soapMessage length]];
    
    //ad required headers to the request
    [theRequest addValue:@"smartagentmobadmin.smartagent.sg" forHTTPHeaderField:@"Host"];
    [theRequest addValue: @"text/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [theRequest addValue: @"http://tempuri.org/UserListmobile"
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


@end

