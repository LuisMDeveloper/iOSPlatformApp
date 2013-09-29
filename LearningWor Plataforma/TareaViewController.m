//
//  TareaViewController.m
//  LearningWor Plataforma
//
//  Created by David Ivan Perez Salazar on 9/27/13.
//  Copyright (c) 2013 David Ivan Perez Salazar. All rights reserved.
//

#import "TareaViewController.h"
#import "SBJson.h"
#import "TareaDetailViewController.h"

@interface TareaViewController (){
    NSUserDefaults *defaults;
    NSArray *tareas;
    NSArray *codigoTarea;
    NSArray *descripcion;
    
}

@end

@implementation TareaViewController


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
        
        NSString *post =[[NSString alloc] initWithFormat:@"curseCode=%@",[defaults objectForKey:@"curseCode"]];
        NSLog(@"%@", post);
        NSURL *url=[NSURL URLWithString:@"http://pod32g.learningwor.com/getHome.php"];
        
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
            id object = [jsonData valueForKeyPath:@"title"];
            id object2 = [jsonData valueForKeyPath:@"code"];
            id object3 = [jsonData valueForKeyPath:@"description"];
            if ([object isKindOfClass:[NSDictionary class]]) {
                tareas  = [NSArray arrayWithObject:object];
                codigoTarea = [NSArray arrayWithObject:object2];
                descripcion = [NSArray arrayWithObject:object3];
            }
            else{
                tareas  = object;
                codigoTarea = object2;
                descripcion = object3;
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
    return tareas.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    NSString *title = tareas[indexPath.row];
    cell.textLabel.text = title;
    
    
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self performSegueWithIdentifier:@"tareaDetail" sender:indexPath];
}


#pragma mark - Navigation

// In a story board-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
   if ([[segue identifier] isEqualToString:@"tareaDetail"]) {
       NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
       NSString *tareaT = tareas[indexPath.row];
       NSString *codigo = codigoTarea[indexPath.row];
       NSString *descripcionT = descripcion[indexPath.row];
       [[segue destinationViewController] setTitulo:tareaT];
       [[segue destinationViewController] setCode:codigo];
       [[segue destinationViewController] setTexto:descripcionT];
       
   }
}



@end
