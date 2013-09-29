//
//  DetailViewController.m
//  LearningWor Plataforma
//
//  Created by David Ivan Perez Salazar on 9/26/13.
//  Copyright (c) 2013 David Ivan Perez Salazar. All rights reserved.
//

#import "DetailViewController.h"
#import "SBJson.h"

@interface DetailViewController ()
- (void)configureView;

@end

@implementation DetailViewController
@synthesize titulo, titule, texto, textL, of, ofL, fecha, dateL, code;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
- (void)setDetailItem:(id)newDetailItem
{
    if (titule!= newDetailItem) {
        titule = newDetailItem;
        // Update the view.
        [self configureView];
    }
}
- (void)configureView
{
    // Update the user interface for the detail item.
    
    if (self.titule) {
        self.titulo.text = [self.title description];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    NSLog(@"%@", titule);
    NSString *all = [NSString stringWithFormat:@"De: %@\n\nFecha de Recibido: %@\n\n %@", of, fecha, texto];
    self.title = titule;
    textL.text = all;
	
    @try {
        
        NSString *post =[[NSString alloc] initWithFormat:@"code=%@",code];
        
        NSURL *url=[NSURL URLWithString:@"http://pod32g.learningwor.com/msgU.php"];
        
        NSData *postData = [post dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
        
        NSString *postLength = [NSString stringWithFormat:@"%d", [postData length]];
        
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
        [request setURL:url];
        [request setHTTPMethod:@"POST"];
        [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
        [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
        [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
        [request setHTTPBody:postData];
        NSLog(@"%@", request);
        //[NSURLRequest setAllowsAnyHTTPSCertificate:YES forHost:[url host]];
        }
    @catch (NSException * e) {
        NSLog(@"Exception: %@", e);
        
    }
}




- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
