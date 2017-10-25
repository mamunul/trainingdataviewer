//
//  ViewController.m
//  TrainingDataViewer
//
//  Created by Mamunul on 10/24/17.
//  Copyright © 2017 Mamunul. All rights reserved.
//

#import "ViewController.h"
#import "Landmark.h"
#include <functional>

@interface ViewController (){

	NSMutableArray *imageFileArray;
	long imageArrayIndex;
	NSFileManager *fileManager;
	NSMutableArray *array;
	CGSize imageSize;
	

}

@end

@implementation ViewController

- (void)viewDidLoad {
	[super viewDidLoad];
	
	imageFileArray = [[NSMutableArray alloc] init];
	array = [[NSMutableArray alloc] init];
	
	fileManager = [NSFileManager defaultManager];

	// Do any additional setup after loading the view.

	[_imageView setAutoresizingMask:NSViewHeightSizable|NSViewWidthSizable];
	[_imageView setImageAlignment:NSImageAlignCenter];
	
}

-(IBAction)openFile:(id)sender{
	
	[imageFileArray removeAllObjects];

	NSOpenPanel *panel = [NSOpenPanel openPanel];
	
	NSArray *fileTypes = [[NSArray alloc] initWithObjects:@"jpg", @"JPG",@"JPEG",@"PNG",@"png", nil];
	[panel setCanChooseDirectories:YES];
	[panel setAllowedFileTypes:fileTypes];
	[panel setCanChooseFiles:YES];
	[panel setAllowsMultipleSelection:YES];
	
	[panel beginWithCompletionHandler:^(NSInteger result) {
		if (result == NSFileHandlingPanelOKButton) {
			NSError *error;
			
			for (NSURL *url in [panel URLs]) {
		
					[imageFileArray addObject:url];

			}
			[self updateImageView];
			
		}
	
	}];

}


-(void)keyDown:(NSEvent *)event{

	if ([event keyCode] == NSLeftArrowFunctionKey) {
		
		[self nextEvent:nil];
		
	}else if ([event keyCode] == NSRightArrowFunctionKey){
		[self previousEvent:nil];
	
	
	}



}

-(void)viewWillAppear{

	self.view.window.delegate = self;
}


-(void)windowDidResize:(NSNotification *)notification{
	
	dispatch_async(dispatch_get_main_queue(), ^{
		[_imageView setFrameSize:((NSWindow*)notification.object).frame.size];
		[_imageView setFrameOrigin:NSMakePoint(
											(NSWidth([self.view bounds]) - NSWidth([self.view frame])) / 2,
											(NSHeight([self.view bounds]) - NSHeight([self.view frame])) / 2
											)];
		
			NSLog(@"size:%f,size:%f,s:%f,a:%f",_imageView.frame.size.width,_imageView.frame.size.height,_imageView.image.size.width,_imageView.image.size.height);

	});

}

-(IBAction)previousEvent:(id)sender{
	
	if(--imageArrayIndex < 0){
	
		imageArrayIndex = 0;
	
	}
	

	[self updateImageView];

}

-(void)updateImageView{

	if(imageFileArray.count >0){
		
		NSURL *imageURL = [imageFileArray objectAtIndex:imageArrayIndex];
		NSImage *img =[ [NSImage alloc] initWithContentsOfURL:imageURL];
		
		imageSize = img.size;
	
		_imageView.image = img;
		
		NSURL *ptsURL = [[imageURL URLByDeletingPathExtension] URLByAppendingPathExtension:@"pts"];

		[self parsePoints:ptsURL];

		[self viewPoints];
		
	}

}

-(void)viewPoints{

	dispatch_async(dispatch_get_main_queue(), ^{
		for (Landmark *v in array) {
			
			NSView *landmarkView = [[NSView alloc] initWithFrame:NSMakeRect(v.x, v.y, 10, 10)];
			landmarkView.wantsLayer = YES;
			landmarkView.layer.backgroundColor = [[NSColor yellowColor] CGColor];
			
			[self.view addSubview:landmarkView];
			
//			NSLog(@"x:%f,y:%f",v.x,v.y);
		}

	});
	NSSize size;
	if (imageSize.height/imageSize.width > _imageView.frame.size.height/_imageView.frame.size.width) {
	
		size.width = _imageView.frame.size.width;
		size.height = _imageView.frame.size.width * imageSize.width/imageSize.height ;
	}else{
		size.height = _imageView.frame.size.height;
		size.width = _imageView.frame.size.height * imageSize.width/imageSize.height ;
	
	}
	NSLog(@"w:%f,h:%f,w:%f,h:%f,a:%f,b:%f",size.width,size.height,imageSize.width,imageSize.height,size.width/size.height,imageSize.height/imageSize.width);

}

-(void)parsePoints:(NSURL *)ptsURL{

	
	NSError *error;
	
	NSString *ptsString = [NSString stringWithContentsOfURL:ptsURL encoding:NSUTF8StringEncoding error:&error];
	
	NSArray *str = [ptsString componentsSeparatedByString:@"\n"];
	
	NSMutableArray *sr = [[NSMutableArray alloc] initWithArray:str];
	
	[sr removeObjectAtIndex:0];
	[sr removeObjectAtIndex:0];
	[sr removeObjectAtIndex:0];
	[sr removeObjectAtIndex:68];
	
	
	
	for (NSString *string in sr) {
		
		NSArray *y = [string componentsSeparatedByString:@" "];
		
		Landmark *lm = [[Landmark alloc] init];
		lm.x = [[y objectAtIndex:0] floatValue];
		lm.y = [[y objectAtIndex:1] floatValue];
		
		[array addObject:lm];
		//			NSLog(@"str:%@,%f,%f",y,lm.point.x,lm.point.y);
	}

}

-(IBAction)nextEvent:(id)sender{

	if (++imageArrayIndex == imageFileArray.count) {
		imageArrayIndex = imageFileArray.count - 1;
	}

	[self updateImageView];
}

- (void)setRepresentedObject:(id)representedObject {
	[super setRepresentedObject:representedObject];

	// Update the view, if already loaded.
}


@end
