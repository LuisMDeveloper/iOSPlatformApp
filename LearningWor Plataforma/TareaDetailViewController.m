//
//  TareaDetailViewController.m
//  LearningWor Plataforma
//
//  Created by David Ivan Perez Salazar on 9/28/13.
//  Copyright (c) 2013 David Ivan Perez Salazar. All rights reserved.
//

#import "TareaDetailViewController.h"
#import "SBJson.h"

@interface TareaDetailViewController (){
    IBOutlet UILabel *tituloL;
    IBOutlet UILabel *calificacion;
    IBOutlet UITextView *descripcion;
    NSUserDefaults *defaults;
}

@end

@implementation TareaDetailViewController
@synthesize code, texto, titulo;

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
    defaults = [NSUserDefaults standardUserDefaults];
    @try {
        
        NSString *post =[[NSString alloc] initWithFormat:@"homeCode=%@&&studentCode=%@",code,[defaults objectForKey:@"userCode"]];
        NSLog(@"%@", post);
        NSURL *url=[NSURL URLWithString:@"http://pod32g.learningwor.com/getHC.php"];
        
        NSData *postData = [post dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
        
        NSString *postLength = [NSString stringWithFormat:@"%d", [postData length]];
        
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
        [request setURL:url];
        [request setHTTPMethod:@"POST"];
        [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
        [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
        [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
        [request setHTTPBody:postData];
        
        //[NSURLRequest setAllowsAnyHTTPSCertificate:YES forHost:[url host]];
        
        NSError *error = [[NSError alloc] init];
        NSHTTPURLResponse *response = nil;
        NSData *urlData=[NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
        
        NSLog(@"Response code: %d", [response statusCode]);
        if ([response statusCode] >=200 && [response statusCode] <300)
        {
            NSString *responseData = [[NSString alloc]initWithData:urlData encoding:NSUTF8StringEncoding];
            
            
            SBJsonParser *jsonParser = [SBJsonParser new];
            NSDictionary *jsonData = (NSDictionary *) [jsonParser objectWithString:responseData error:nil];
            
            NSLog(@"%@",jsonData);
            id object = [jsonData valueForKeyPath:@"rate"];
            NSArray *cal;
            if ([object isKindOfClass:[NSDictionary class]]) {
                 cal  = [NSArray arrayWithObject:object];
            }
            else{
                cal = object;
            }
            NSString *cali = [cal objectAtIndex:0];
            NSString *all = [NSString stringWithFormat:@"%@\n\nCalificacion:\t%@\n\n%@", titulo, cali, texto];
            descripcion.text = all;
           
            
        }
        else{
            
        }
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
