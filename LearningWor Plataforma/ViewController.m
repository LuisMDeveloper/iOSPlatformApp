//
//  ViewController.m
//  LearningWor Plataforma
//
//  Created by David Ivan Perez Salazar on 9/3/13.
//  Copyright (c) 2013 David Ivan Perez Salazar. All rights reserved.
//

#import "ViewController.h"
#import "SBJson.h"


@interface ViewController (){
    NSUserDefaults *defaults;
    
}
@property(nonatomic, retain) NSArray *arrayLog;
@property(nonatomic, retain) IBOutlet UITextField *Usr;
@property(nonatomic, retain) IBOutlet UITextField *Pwd;
-(IBAction)login:(id)sender;
-(IBAction)dismiss:(id)sender;
@end

@implementation ViewController
@synthesize arrayLog;
@synthesize Usr, Pwd;

- (void)viewDidLoad
{
    [super viewDidLoad];
   
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    defaults = [NSUserDefaults standardUserDefaults];
    NSLog(@"usr=%@&&psw=%@", [defaults objectForKey:@"userVer"], [defaults objectForKey:@"passVer"]);
    if ([defaults objectForKey:@"userVer"] == [defaults objectForKey:@"user"] && [defaults objectForKey:@"passVer"] == [defaults objectForKey:@"pass"]) {
        [self performSegueWithIdentifier:@"mainSeg" sender:self];
    }
}
-(IBAction)dismiss:(id)sender
{
    [self resignFirstResponder];
}
- (void) alertStatus:(NSString *)msg :(NSString *)title
{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:title
                                                        message:msg
                                                       delegate:self
                                              cancelButtonTitle:@"Ok"
                                              otherButtonTitles:nil, nil];
    
    [alertView show];
}
-(IBAction)login:(id)sender
{
    defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:Usr.text forKey:@"user"];
    [defaults setObject:Pwd.text forKey:@"pass"];
    if (![defaults objectForKey:@"userVer"] && ![defaults objectForKey:@"passVer"]) {
        @try {
            
            if([[Usr text] isEqualToString:@""] || [[Pwd text] isEqualToString:@""] ) {
                [self alertStatus:@"Por Favor Introdusca la Contraseña y el Nombre de Usuario" :@"Error"];
            } else {
                NSString *post =[[NSString alloc] initWithFormat:@"userName=%@&password=%@",[Usr text],[Pwd text]];
                
                NSURL *url=[NSURL URLWithString:@"http://pod32g.learningwor.com/lol.php"];
                
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
                    NSLog(@"Response ==> %@", responseData);
                    
                    SBJsonParser *jsonParser = [SBJsonParser new];
                    NSDictionary *jsonData = (NSDictionary *) [jsonParser objectWithString:responseData error:nil];
                    NSLog(@"%@",jsonData);

                    NSString *suc;
                    NSArray *sec;
                    id object = [jsonData valueForKeyPath:@"ins_u"];
                    if ([object isKindOfClass:[NSDictionary class]]) {
                        sec = [NSArray arrayWithObject:object];
                    }
                    else{
                        sec = object;
                    }
                    suc = [sec objectAtIndex:0];
                    NSLog(@"suc = %@", suc);
                   
                    if([suc isEqualToString:@""])
                    {
                        NSString *error_msg = (NSString *) [jsonData objectForKey:@"error_message"];
                        [self alertStatus:error_msg :@"Error"];
                    } else {
                
                        [defaults setObject:Usr.text forKey:@"userVer"];
                        [defaults setObject:Pwd.text forKey:@"passVer"];
                        [defaults setObject:suc forKey:@"institucionVer"];
                        NSLog(@"Login SUCCESS");
                        [self removeFromParentViewController];
                        [self performSegueWithIdentifier:@"mainSeg" sender:self];
                    }
                    
                } else {
                    if (error) NSLog(@"Error: %@", error);
                    [self alertStatus:@"No hay coneccion a internet" :@"Error"];
                }
            }
        }
        @catch (NSException * e) {
            NSLog(@"Exception: %@", e);
            [self alertStatus:@"Compruebe los Datos" :@"Error"];
        }

    }
    
     

}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    
}

@end
