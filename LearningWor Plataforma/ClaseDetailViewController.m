//
//  ClaseDetailViewController.m
//  LearningWor Plataforma
//
//  Created by David Ivan Perez Salazar on 9/28/13.
//  Copyright (c) 2013 David Ivan Perez Salazar. All rights reserved.
//

#import "ClaseDetailViewController.h"

@interface ClaseDetailViewController (){
    IBOutlet UITextView *textView;
    NSUserDefaults *defaults;
}
-(IBAction)openInSafari:(id)sender;
@end

@implementation ClaseDetailViewController
@synthesize topic, CurlD, texto;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(IBAction)openInSafari:(id)sender{
    UIActionSheet *actionsheet = [[UIActionSheet alloc] initWithTitle:@"Menú" delegate:self cancelButtonTitle:@"Cancelar" destructiveButtonTitle:nil otherButtonTitles:@"Abrir URL en Safari", nil];
    [actionsheet showInView:self.view];
}
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 0) {
        NSURL *url = [NSURL URLWithString:CurlD];
        [[UIApplication sharedApplication] openURL:url];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	self.title = topic;
    textView.text = texto;
    NSLog(@"titulo=%@ texto=%@", topic, texto);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
