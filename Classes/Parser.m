//
//  Parser.m
//  Days
//
//  Created by dawaller on 5/20/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "Parser.h"

@interface Parser() <NSXMLParserDelegate>

	@property (strong, nonatomic) NSMutableString *currentTitle;  
	@property (strong, nonatomic) NSMutableString *currentDate;  
	@property (strong, nonatomic) NSMutableString *currentSummary;  
	@property (strong, nonatomic) NSMutableString *currentPodcastLink;
    @property (strong, nonatomic) NSMutableString *currentBlogLink;
@end


 @implementation Parser  
   
 @synthesize items, responseData, currentElement;  
 @synthesize currentTitle;  
 @synthesize currentDate;  
 @synthesize currentSummary;  
 @synthesize currentPodcastLink;
 @synthesize currentBlogLink;


 - (void)parseRssFeed:(NSString *)url withDelegate:(id)aDelegate {  
     [self setDelegate:aDelegate];  
   
   //  responseData = [[NSMutableData data] retain];
    // NSURL *baseURL = [[NSURL URLWithString:url] retain];
     responseData = [NSMutableData data];
     NSURL *baseURL = [NSURL URLWithString:url];
       
       
     NSURLRequest *request = [NSURLRequest requestWithURL:baseURL];  
     
     //arc change removed autorelease
     [[NSURLConnection alloc] initWithRequest:request delegate:self];
     //[[[NSURLConnection alloc] initWithRequest:request delegate:self]autorelease];
	 //[baseURL release];
 }  
   
 - (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response  
 {  
     [responseData setLength:0];
     self.items = [[NSMutableArray alloc] init];
     
 }  
   
 - (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data  
 {  
     [responseData appendData:data];  
 }  
   
 - (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error  
 {  
     NSString * errorString = [NSString stringWithFormat:@"Unable to download xml data (Error code %i )", [error code]];  
       
     UIAlertView * errorAlert = [[UIAlertView alloc] initWithTitle:@"Error loading content" message:errorString delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];  
     [errorAlert show];  
	 //[errorAlert release];
 }  
   
 - (void)connectionDidFinishLoading:(NSURLConnection *)connection  
 {  
     
       
     NSXMLParser *newParser = [[NSXMLParser alloc] initWithData:responseData];  
	 
     [newParser setDelegate:self];
       
     [newParser parse];		
     //[newParser release];
    
 }  
   
 #pragma mark rssParser methods  
   
 - (void)parserDidStartDocument:(NSXMLParser *)parser {  
 }  
   
 - (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict{  
       
     self.currentElement = elementName;
	 
     if ([elementName isEqualToString:@"item"]) {  
         item = [[NSMutableDictionary alloc] init];
		 currentTitle = [[NSMutableString alloc] init];  
         currentDate = [[NSMutableString alloc] init];  
         currentSummary = [[NSMutableString alloc] init];  
         currentPodcastLink = [[NSMutableString alloc] init];
         currentBlogLink = [[NSMutableString alloc] init];
}  
       
     // podcast url is an attribute of the element enclosure  
     if ([currentElement isEqualToString:@"enclosure"]) {  
         [currentPodcastLink appendString:[attributeDict objectForKey:@"url"]];
     }  
	 
	 
	 
 }  
   
 - (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName{  
     
     NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
     //NSMutableString *blogString = [[NSMutableString alloc] init];
	 
     if ([elementName isEqualToString:@"item"]) {  
         [item setObject:self.currentTitle forKey:@"title"];  
         [item setObject:self.currentSummary forKey:@"summary"];
         [item setObject:self.currentPodcastLink forKey:@"podcastLink"];
         [item setObject:self.currentBlogLink forKey:@"blogLink"];
    
         // Parse date here  
                    
         [dateFormatter setDateFormat:@"E, d LLL yyyy HH:mm:ss Z"]; // Thu, 18 Jun 2010 04:48:09 -0700
         NSDate *date = [dateFormatter dateFromString:self.currentDate];
		 [item setObject:date forKey:@"date"]; 
		 [items addObject:item];
         
         
         //NSString *temp =[NSString stringWithFormat:@"<p><b>%@</b><br></p>",self.currentTitle];
         //[blogString appendString:temp];
        
         //temp = [NSString stringWithFormat:@"<b style=\"color:red\">%@</b>",[dateFormatter stringFromDate:date]];
         //[blogString appendString:temp];
         //[blogString appendString:self.currentSummary];
         //currentSummary = blogString;
         [item setObject:self.currentSummary forKey:@"summary"];
     }  
 }  

 - (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string{
     if ([currentElement isEqualToString:@"title"]) {
         [currentTitle appendString:string];
    } else if ([currentElement isEqualToString:@"pubDate"]) {
		 [currentDate appendString:string];
         [currentDate setString: [self.currentDate stringByTrimmingCharactersInSet: [NSCharacterSet whitespaceAndNewlineCharacterSet]]];
     } else if ([currentElement isEqualToString:@"content:encoded"]) {
         [currentSummary appendString:string];
         
     }  else if ([currentElement isEqualToString:@"comments"]) {
         [currentBlogLink appendString:[string stringByReplacingOccurrencesOfString:@"#comments" withString:@""]];
     }
     //[string release];
 }  

 - (void)parserDidEndDocument:(NSXMLParser *)parser {  
     if ([_delegate respondsToSelector:@selector(receivedItems:)])  
         [_delegate receivedItems:items];  
     else  
     {   
         [NSException raise:NSInternalInconsistencyException  
                     format:@"Delegate doesn't respond to receivedItems:"];  
     }  
 }  
   
   
#pragma mark Delegate methods  

- (id)delegate {  
	return _delegate;  
}  

- (void)setDelegate:(id)new_delegate {  
	_delegate = new_delegate;  
}  



@end
