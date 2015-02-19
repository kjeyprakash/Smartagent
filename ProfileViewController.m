//
//  ProfileViewController.m
//  SmartAgent
//
//  Created by Dhanam on 09/02/15.
//  Copyright (c) 2015 suhasoft. All rights reserved.
//

#import "ProfileViewController.h"

@interface ProfileViewController ()<NSXMLParserDelegate>
@property NSString *soapMessage;
@property NSString *currentElement;

@property NSMutableData *webResponseData;
@end


@implementation ProfileViewController
@synthesize agentname;
@synthesize cearegnumber;
@synthesize companynumber;
@synthesize mobilenumber;
@synthesize emailid;
@synthesize soapMessage,webResponseData,currentElement,password;



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
    password.hidden = YES;
    
    self.profileImageView.layer.cornerRadius = self.profileImageView.frame.size.width / 2;
    self.profileImageView.clipsToBounds = YES;
    userID = [[NSUserDefaults standardUserDefaults]
              stringForKey:@"userID"];
    NSLog(@"userID == %@",userID);
    [self userlistmobile];
    
    
    // Do any additional setup after loading the view.
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
                   "</soap:Envelope>",userID];
    //   NSLog(@"The request format is %@",soapMessage);
    //Now create a request to the URL
    NSURL *url = [NSURL URLWithString:@"c"];
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
    //     NSLog(@"currentElement : %@",currentElement);
    
}
- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string
{
    
    if ([currentElement isEqualToString:@"UserName"])
    {
        
        self.agentname.text = string;
        NSLog(@"agentname : %@",agentname.text);
          username = agentname.text;
        NSUserDefaults *uid = [NSUserDefaults standardUserDefaults];
        [uid setObject:username forKey:@"username"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        NSLog(@"%@",username);
        
    }
    else if ([currentElement isEqualToString:@"CeaRegNo"])
    {
        
        self.cearegnumber.text = string;
        NSLog(@"cearegnumber : %@",cearegnumber.text);
        
    }
    
    
    else  if ([currentElement isEqualToString:@"CompanyName"])
    {
        self.companynumber.text = string;
        NSLog(@"companynumber %@",companynumber.text);
    }
    
    else if ([currentElement isEqualToString:@"ContactNo"])
    {
        self.mobilenumber.text = string;
        mobileno = mobilenumber.text;
        NSLog(@"mobilenumber %@",mobilenumber.text);
        NSUserDefaults *uid = [NSUserDefaults standardUserDefaults];
        [uid setObject:mobileno forKey:@"ContactNo"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        NSLog(@"mobileno : %@",mobileno);
        

    }
    
    else if ([currentElement isEqualToString:@"UserIdEmailId"])
    {
        self.emailid.text = string;
        NSLog(@"UserIdEmailId %@",emailid.text);
        email = emailid.text;
        NSUserDefaults *uid = [NSUserDefaults standardUserDefaults];
        [uid setObject:email forKey:@"email"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        NSLog(@"email : %@",email);
        
        

        
    }
    
    else if ([currentElement isEqualToString:@"Password"])
    {
        self.password.text = string;
        //NSLog(@"password %@",password.text);

        pswrd = password.text;
       
        NSUserDefaults *uid = [NSUserDefaults standardUserDefaults];
        [uid setObject:pswrd forKey:@"password"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        NSLog(@"pswrd %@",pswrd);

    }

    
    
}


- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName
  namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName
{
    //  NSLog(@"Parsed Element : %@", currentElement);
}




@end
