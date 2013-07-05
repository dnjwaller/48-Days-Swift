//
//  DayParse.m
//  Days
//
//  Created by dawaller on 6/9/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "DayParse.h"

@interface DayParse () <NSXMLParserDelegate>

@property (strong, nonatomic) NSMutableString *currentTitle;  
@property (strong, nonatomic) NSMutableString *currentSummary;  
@property (strong, nonatomic) NSMutableString *index;

@end



@implementation DayParse

@synthesize items, responseData, currentElement;  
@synthesize currentTitle;  
@synthesize currentSummary, index;  



#pragma mark rssParser methods  

-(void) parse:(NSString *)path withDelegate:(id) aDelegate {
	[self setDelegate:aDelegate];  
	responseData = [NSMutableData data];
	[responseData setLength:0];
	NSData *xmlData = [NSData dataWithContentsOfFile:path];
	[responseData appendData:xmlData];
	
	self.items = [[NSMutableArray alloc] init];
	NSXMLParser *xmlParser = [[NSXMLParser alloc] initWithData:responseData];    
	
	
	[xmlParser setDelegate:self];
	
	[xmlParser parse];
	
}



- (void)parserDidStartDocument:(NSXMLParser *)parser {  
}  

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict{  
	self.currentElement = elementName;  
	if ([elementName isEqualToString:@"item"]) {  
		item = [[NSMutableDictionary alloc] init];  
		currentTitle = [[NSMutableString alloc] init];  
		currentSummary = [[NSMutableString alloc] init];  
		index = [[NSMutableString alloc] init];
	}  
	
}  

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName{  
	
		if ([elementName isEqualToString:@"item"]) {  
		[item setObject:self.index forKey:@"index"];
		[item setObject:self.currentTitle forKey:@"title"];  
		[item setObject:self.currentSummary forKey:@"summary"];  
		[items addObject:item]; 
	}  
}  

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string{  
	if ([currentElement isEqualToString:@"daynum"]) {  
		[currentTitle appendString:string];  
	} else if ([currentElement isEqualToString:@"content:encoded"]) {  
		[currentSummary appendString:string];  
	} else if ([currentElement isEqualToString:@"index"]) {
		[index appendString:string];
	} 
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
