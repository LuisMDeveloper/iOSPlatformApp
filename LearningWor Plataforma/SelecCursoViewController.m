//
//  SelecCursoViewController.m
//  LearningWor Plataforma
//
//  Created by David Ivan Perez Salazar on 9/27/13.
//  Copyright (c) 2013 David Ivan Perez Salazar. All rights reserved.
//

#import "SelecCursoViewController.h"
#import "SBJson.h"
#import "TareaViewController.h"

@interface SelecCursoViewController (){
    NSUserDefaults *defaults;
    NSArray * curseC;
    NSArray * nombre;
}

@end

@implementation SelecCursoViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
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
        
        NSString *post =[[NSString alloc] initWithFormat:@"instName=%@",[defaults objectForKey:@"institucionVer"]];
        
        NSURL *url=[NSURL URLWithString:@"http://pod32g.learningwor.com/getIC.php"];
        
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
            id object = [jsonData valueForKeyPath:@"code"];
            id object2 = [jsonData valueForKey:@"name_c"];
            if ([object isKindOfClass:[NSDictionary class]]) {
                curseC  = [NSArray arrayWithObject:object];
                nombre = [NSArray arrayWithObject:object2];
            }
            else{
                curseC  = object;
                nombre = object2;
            }
            
            
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

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{

    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{

    // Return the number of rows in the section.
    return nombre.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    defaults = [NSUserDefaults standardUserDefaults];
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
     NSString *title = nombre[indexPath.row];
    
    cell.textLabel.text = title;
        
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *curseCode = curseC[indexPath.row];
    [defaults setObject:curseCode forKey:@"curseCode"];
    NSLog(@"%@", [defaults objectForKey:@"curseCode"]);
    if ([[defaults objectForKey:@"cursoSeg"] isEqualToString:@"T"]) {
         [self performSegueWithIdentifier:@"tareaSegDet" sender:indexPath];
    }
    else if ([[defaults objectForKey:@"cursoSeg"] isEqualToString:@"C"]){
        [self performSegueWithIdentifier:@"cursoSegDet" sender:self];
    }
   
    
    
}

#pragma mark - Navigation

// In a story board-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    
}



@end
