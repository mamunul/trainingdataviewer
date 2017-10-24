//
//  ViewController.m
//  TrainingDataViewer
//
//  Created by Mamunul on 10/24/17.
//  Copyright © 2017 Mamunul. All rights reserved.
//

#import "ViewController.h"

@interface ViewController (){

	NSMutableArray *imageFileArray;

}

@end

@implementation ViewController

- (void)viewDidLoad {
	[super viewDidLoad];
	
	imageFileArray = [[NSMutableArray alloc] init];

	// Do any additional setup after loading the view.
	
//	NSWindow *window = [self.w]
	
	[_imageView setAutoresizingMask:NSViewHeightSizable|NSViewWidthSizable ];
	[_imageView setImageAlignment:NSImageAlignCenter];
	
	NSOpenPanel *panel = [NSOpenPanel openPanel];
	
	NSArray *fileTypes = [[NSArray alloc] initWithObjects:@"jpg", @"JPG",@"JPEG",@"PNG", nil];
//	NSArray *fileTypes = [[NSArray alloc] initWithObjects:@"jpg", @"JPG",@"JPEG",@"PNG",@"png",@"pts", nil];
	[panel setCanChooseDirectories:YES];
	[panel setAllowedFileTypes:fileTypes];
	[panel setCanChooseFiles:YES];
	[panel setAllowsMultipleSelection:YES];
	
	[panel beginWithCompletionHandler:^(NSInteger result) {
		if (result == NSFileHandlingPanelOKButton) {
			
			for (NSURL *url in [panel URLs]) {
		
				[imageFileArray addObject:url];
    
			}
			
			NSImage *img =[ [NSImage alloc] initWithContentsOfURL:[imageFileArray objectAtIndex:0]];
			
			NSLog(@"url:%@,%@",img,[imageFileArray objectAtIndex:0]);
			_imageView.image = img;
			
//			// grab a reference to what has been selected
//			NSURL *theDocument = [[panel URLs]objectAtIndex:0];
//			
//			// write our file name to a label
//			NSString *theString = [NSString stringWithFormat:@"%@", theDocument];
//			
//			NSLog(@"%@",theString);
		}
			
			
	}];
	
	
}

-(void)viewWillAppear{

	self.view.window.delegate = self;
}


-(void)windowDidResize:(NSNotification *)notification{
	
	
	
//	NSLog(@"size:%@",NSStringFromSize(((NSWindow*)notification.object).frame.size));

	dispatch_async(dispatch_get_main_queue(), ^{
		[_imageView setFrameSize:((NSWindow*)notification.object).frame.size];
	});
	
	


}

- (void)setRepresentedObject:(id)representedObject {
	[super setRepresentedObject:representedObject];

	// Update the view, if already loaded.
}


@end
