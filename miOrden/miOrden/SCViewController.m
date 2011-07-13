/*
 *  SCViewController.m
 *  Sensible TableView
 *  Version: 2.1 beta
 *
 *
 *	THIS SOURCE CODE AND ANY ACCOMPANYING DOCUMENTATION ARE PROTECTED BY UNITED STATES 
 *	INTELLECTUAL PROPERTY LAW AND INTERNATIONAL TREATIES. UNAUTHORIZED REPRODUCTION OR 
 *	DISTRIBUTION IS SUBJECT TO CIVIL AND CRIMINAL PENALTIES. YOU SHALL NOT DEVELOP NOR
 *	MAKE AVAILABLE ANY WORK THAT COMPETES WITH A SENSIBLE COCOA PRODUCT DERIVED FROM THIS 
 *	SOURCE CODE. THIS SOURCE CODE MAY NOT BE RESOLD OR REDISTRIBUTED ON A STAND ALONE BASIS.
 *
 *	USAGE OF THIS SOURCE CODE IS BOUND BY THE LICENSE AGREEMENT PROVIDED WITH THE 
 *	DOWNLOADED PRODUCT.
 *
 *  Copyright 2010-2011 Sensible Cocoa. All rights reserved.
 *
 *
 *	This notice may not be removed from this file.
 *
 */


#import "SCViewController.h"
#import "SCTableViewModel.h"
#import "SCGlobals.h"




@implementation SCViewController

@synthesize ownerViewController;
@synthesize tableView;
@synthesize tableViewModel;
@synthesize delegate;
@synthesize navigationBarType;
@synthesize addButton;
@synthesize cancelButton;
@synthesize doneButton;
@synthesize buttonsToolbar;
@synthesize cancelButtonTapped;
@synthesize doneButtonTapped;
@synthesize state;


- (id)init
{
	if( (self = [super init]) )
	{
		toolbarAdded = FALSE;
		ownerViewController = nil;
		delegate = nil;
		tableView = nil;
		tableViewModel = nil;
		navigationBarType = SCNavigationBarTypeNone;
		navigationBar = nil;
		addButton = nil;
		cancelButton = nil;
		doneButton = nil;
		
		// Create the toolbar that will hold the Add and Edit buttons
		buttonsToolbar = [[SCTransparentToolbar alloc] initWithFrame:CGRectMake(0, 0, 100, 44.01)];
		
		cancelButtonTapped = FALSE;
		doneButtonTapped = FALSE;
		
		state = SCViewControllerStateNew;
	}
	
	return self;
}

- (void)awakeFromNib
{
	toolbarAdded = FALSE;
	ownerViewController = nil;
	delegate = nil;
	tableView = nil;
	tableViewModel = nil;
	navigationBarType = SCNavigationBarTypeNone;
	navigationBar = nil;
	addButton = nil;
	cancelButton = nil;
	doneButton = nil;
	cancelButtonTapped = FALSE;
	doneButtonTapped = FALSE;
}


- (void)viewDidLoad
{
	[super viewDidLoad];
    
    
    // Check that tableViewModel's modeledTableView is the same as self.tableView (a discrepency could
	// occur when a low memory warning is issued and self.tableView is released).
	if(self.tableViewModel)
	{
		if(self.tableViewModel.modeledTableView != self.tableView
		   || self.tableViewModel.modeledTableView.dataSource != self.tableViewModel
		   || self.tableViewModel.modeledTableView.delegate != self.tableViewModel)
		{
			[self.tableViewModel replaceModeledTableViewWith:self.tableView];
		}
	}
}

- (void)viewDidAppear:(BOOL)animated
{
	[super viewDidAppear:animated];
	
	if(self.tableViewModel)
		self.tableViewModel.commitButton = self.doneButton;
	
	if([self.delegate conformsToProtocol:@protocol(SCViewControllerDelegate)]
	   && [self.delegate respondsToSelector:@selector(viewControllerDidAppear:)])
	{
		[self.delegate viewControllerDidAppear:self];
	}
	
	state = SCViewControllerStateActive;
}

- (void)viewDidDisappear:(BOOL)animated
{
	[super viewDidDisappear:animated];
	
	if(state != SCViewControllerStateDismissed)
		state = SCViewControllerStateInactive;
	
	if([self.delegate conformsToProtocol:@protocol(SCViewControllerDelegate)]
	   && [self.delegate respondsToSelector:
		   @selector(viewControllerDidDisappear:cancelButtonTapped:doneButtonTapped:)])
	{
		[self.delegate viewControllerDidDisappear:self
							   cancelButtonTapped:self.cancelButtonTapped
								 doneButtonTapped:self.doneButtonTapped];
	}
}

- (void)viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:animated];
	
	if(self.navigationBarType==SCNavigationBarTypeAddEditRight && !toolbarAdded)
	{
		// Set the toolbar style to the correct style
		buttonsToolbar.barStyle = self.navigationController.navigationBar.barStyle;
		
		// create an array of the buttons
		NSMutableArray* buttons = [[NSMutableArray alloc] initWithCapacity:2];
		[buttons addObject:self.addButton];
		UIBarButtonItem *spacer = [[UIBarButtonItem alloc]
								   initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
								   target:nil
								   action:nil];
		[buttons addObject:spacer];
		[spacer release];
		[buttons addObject:self.editButton];
		
		// put the buttons in the toolbar
		[buttonsToolbar setItems:buttons animated:NO];
		[buttons release];
		
		// place the toolbar into the navigation bar
		UIBarButtonItem *toolbarButton = [[UIBarButtonItem alloc] initWithCustomView:buttonsToolbar];
		self.navigationItem.rightBarButtonItem = toolbarButton;
		[toolbarButton release];
		
		toolbarAdded = TRUE;
	}
	
	cancelButtonTapped = FALSE;
	doneButtonTapped = FALSE;
	
	if([self.delegate conformsToProtocol:@protocol(SCViewControllerDelegate)]
	   && [self.delegate respondsToSelector:@selector(viewControllerWillAppear:)])
	{
		[self.delegate viewControllerWillAppear:self];
	}
	
	if(state != SCViewControllerStateNew)
		state = SCViewControllerStateActive;
}

- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
	
	if(self.navigationController)
	{
		if([self.navigationController.viewControllers indexOfObject:self] == NSNotFound)
		{
			// self has been popped from the navigation controller
			state = SCViewControllerStateDismissed;
		}
	}
	
	if([self.delegate conformsToProtocol:@protocol(SCViewControllerDelegate)]
	   && [self.delegate respondsToSelector:
		   @selector(viewControllerWillDisappear:cancelButtonTapped:doneButtonTapped:)])
	{
		[self.delegate viewControllerWillDisappear:self
								cancelButtonTapped:self.cancelButtonTapped
								  doneButtonTapped:self.doneButtonTapped];
	}
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	return [self.ownerViewController shouldAutorotateToInterfaceOrientation:interfaceOrientation];
}

- (void)dealloc 
{
	[tableView release];
    [tableViewModel release];
	[navigationBar release];
	[addButton release];
	[cancelButton release];
	[doneButton release];
	[buttonsToolbar release];
	[super dealloc];
}

- (void)setNavigationBarType:(SCNavigationBarType)barType
{
	navigationBarType = barType;
	
	// Reset buttons
	[addButton release];
	addButton = nil;
	[cancelButton release];
	cancelButton = nil;
	[doneButton release];
	doneButton = nil;
		
	if(self.navigationItem && self.navigationBarType!=SCNavigationBarTypeNone)
	{
		UIBarButtonItem *tempAddButton = [[UIBarButtonItem alloc] 
										  initWithBarButtonSystemItem:UIBarButtonSystemItemAdd 
										  target:nil 
										  action:nil];
		UIBarButtonItem *tempCancelButton = [[UIBarButtonItem alloc] 
											 initWithBarButtonSystemItem:UIBarButtonSystemItemCancel 
											 target:self 
											 action:@selector(cancelButtonAction)];
		UIBarButtonItem *tempDoneButton = [[UIBarButtonItem alloc] 
										   initWithBarButtonSystemItem:UIBarButtonSystemItemDone 
										   target:self 
										   action:@selector(doneButtonAction)];
		
		UINavigationItem *navItem = self.navigationItem;
		
		switch (self.navigationBarType)
		{
			case SCNavigationBarTypeAddLeft:
				navItem.leftBarButtonItem = tempAddButton;
				addButton = [tempAddButton retain];
				break;
			case SCNavigationBarTypeAddRight:
				navItem.rightBarButtonItem = tempAddButton;
				addButton = [tempAddButton retain];
				break;
			case SCNavigationBarTypeEditLeft:
				navItem.leftBarButtonItem = self.editButton;
				break;
			case SCNavigationBarTypeEditRight:
				navItem.rightBarButtonItem = self.editButton;
				break;
			case SCNavigationBarTypeAddRightEditLeft:
				navItem.rightBarButtonItem = tempAddButton;
				addButton = [tempAddButton retain];
				navItem.leftBarButtonItem = self.editButton;
				break;
			case SCNavigationBarTypeAddLeftEditRight:
				navItem.leftBarButtonItem = tempAddButton;
				addButton = [tempAddButton retain];
				navItem.rightBarButtonItem = self.editButton;
				break;
			case SCNavigationBarTypeDoneLeft:
				navItem.leftBarButtonItem = tempDoneButton;
				doneButton = [tempDoneButton retain];
				break;
			case SCNavigationBarTypeDoneRight:
				navItem.rightBarButtonItem = tempDoneButton;
				doneButton = [tempDoneButton retain];
				break;
			case SCNavigationBarTypeDoneLeftCancelRight:
				navItem.leftBarButtonItem = tempDoneButton;
				doneButton = [tempDoneButton retain];
				navItem.rightBarButtonItem = tempCancelButton;
				cancelButton = [tempCancelButton retain];
				break;
			case SCNavigationBarTypeDoneRightCancelLeft:
				navItem.rightBarButtonItem = tempDoneButton;
				doneButton = [tempDoneButton retain];
				navItem.leftBarButtonItem = tempCancelButton;
				cancelButton = [tempCancelButton retain];
				break;
			case SCNavigationBarTypeAddEditRight:
			{
				addButton = [tempAddButton retain];
				addButton.style = UIBarButtonItemStyleBordered;
				
				// Add the toolbar later (on viewWillAppear) when the toolbar style can be determined
			}
				break;
				
			default:
				break;
		}
		
		[tempAddButton release];
		[tempCancelButton release];
		[tempDoneButton release];
	}
}

- (UIBarButtonItem *)editButton
{
	return [self editButtonItem];
}

- (void)cancelButtonAction
{
	[self dismissWithCancelValue:TRUE doneValue:FALSE];
}

- (void)doneButtonAction
{
	[self dismissWithCancelValue:FALSE doneValue:TRUE];
}

- (void)dismissWithCancelValue:(BOOL)cancelValue doneValue:(BOOL)doneValue
{
	cancelButtonTapped = cancelValue;
	doneButtonTapped = doneValue;
	
	state = SCViewControllerStateDismissed;
	
	if(self.navigationController)
	{
		// check if self is the rootViewController
		if([self.navigationController.viewControllers objectAtIndex:0] == self)
		{
			[self dismissModalViewControllerAnimated:YES];
		}
		else
			[self.navigationController popViewControllerAnimated:YES];
	}
	else
		[self dismissModalViewControllerAnimated:YES];
}



@end

