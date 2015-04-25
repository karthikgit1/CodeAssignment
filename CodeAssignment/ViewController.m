

#import "ViewController.h"
#import "MyCustomCell.h"

#define FONT_SIZE 14.0f
#define CELL_CONTENT_MARGIN 10.0f
@interface ViewController ()
{
    NSMutableData *receivedData;
    
    UITableView *tableView;
    
    float screen_Height;
    float screen_Width;
    
    UIRefreshControl *refreshControl;
    
    dispatch_queue_t imageQueue ;
    
    NSDictionary *detailsDict;
    
    NSMutableDictionary *cachedImages;
}
@end

@implementation ViewController

#pragma mark - View Lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self getScreenDimensions];
    
    cachedImages = [[NSMutableDictionary alloc] init];
    
    imageQueue = dispatch_queue_create("com.company.app.imageQueue", NULL);
    
    [self createTableview];
    
    [self addConstraintsToTableView];
    
    [self getJsonDetails];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Tableview Delegate and Datasource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)theTableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)theTableView numberOfRowsInSection:(NSInteger)section
{
    return  [[detailsDict objectForKey:@"rows"] count];
}

static NSString *cellIdentifier = @"HistoryCell";

- (UITableViewCell *)tableView:(UITableView *)theTableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MyCustomCell *cell = (MyCustomCell *)[theTableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (cell == nil)
    {
        cell = [[MyCustomCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    
    cell.lblTitle.text = [NSString stringWithFormat:@"%@",[[[detailsDict objectForKey:@"rows"] objectAtIndex:indexPath.row]objectForKey:@"title"]] ;
    
    
    cell.lblDescription.text = [NSString stringWithFormat:@"%@",[[[detailsDict objectForKey:@"rows"] objectAtIndex:indexPath.row]objectForKey:@"description"]] ;
    
    //*****Show Spinner until Image is loaded from server********
    UIActivityIndicatorView *spinner = [[UIActivityIndicatorView alloc]
                                        initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    
    spinner.color = [UIColor redColor];
    
    
    [cell.imgvw addSubview:spinner];
    
    cell.imgvw.image = nil;
    
    [spinner startAnimating];
    
    //*****If the image is available in cache then show the image from cache******//
    if ([cachedImages valueForKey:[@(indexPath.row) stringValue ]])
    {
        [[cell imgvw] setImage:[cachedImages valueForKey:[@(indexPath.row) stringValue ]]];
        
        [spinner stopAnimating];
        spinner.hidden = true;
    }
    else
    {
        NSString *_imgurl = [NSString stringWithFormat:@"%@",[[[detailsDict objectForKey:@"rows"] objectAtIndex:indexPath.row]objectForKey:@"imageHref"]] ;
        
        if (![_imgurl isEqualToString:@"<null>"])
        {
            __block UIImage *buttonImage;
            
            dispatch_async(imageQueue, ^{
                
                NSData *imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:_imgurl]];
                
                buttonImage = [UIImage imageWithData:imageData];
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    //******Cache image based on indexpath so that we need not want to fetch the image each time from the server*****//
                    [cachedImages setValue:[UIImage imageWithData:imageData] forKey:[@(indexPath.row) stringValue ]];
                    
                    [[cell imgvw] setImage:buttonImage];
                    
                    
                    [spinner stopAnimating];
                    spinner.hidden = true;
                });
            });
            
        }
        else
        {
            [spinner stopAnimating];
            spinner.hidden = true;
            
        }
    }
    
    [cell setNeedsLayout];
    [cell layoutIfNeeded];
    
    
    return cell;
    
}

// when user tap the row, what action you want to perform
- (void)tableView:(UITableView *)theTableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"selected %ld row", (long)indexPath.row);
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return  [self heigtOfLabelForFromString:[NSString stringWithFormat:@"%@",[[[detailsDict objectForKey:@"rows"] objectAtIndex:indexPath.row]objectForKey:@"description"]]] + 30;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return  [self heigtOfLabelForFromString:[NSString stringWithFormat:@"%@",[[[detailsDict objectForKey:@"rows"] objectAtIndex:indexPath.row]objectForKey:@"description"]]] + 30;
    
}


#pragma mark NSURL CONNECTION METHODS
//------- method for no error -------

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    receivedData = [[NSMutableData alloc] init];
}

-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [receivedData appendData:data];
}

-(void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    UIAlertView *_alert = [[UIAlertView alloc] initWithTitle:@""
                                                     message:@"Network Error" delegate:self
                                           cancelButtonTitle:@"OK"
                                           otherButtonTitles:nil, nil];
    
    
    [_alert show];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    NSError *localError = nil;
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    
    NSString* _newStr = [[NSString alloc] initWithData:receivedData encoding:NSISOLatin1StringEncoding];
    
    NSData *_data = [_newStr dataUsingEncoding:NSUTF8StringEncoding];
    
    detailsDict = [NSJSONSerialization JSONObjectWithData:_data options:kNilOptions error:&localError];
    
    if (localError != nil)
    {
        UIAlertView *_alert = [[UIAlertView alloc] initWithTitle:@""
                                                         message:@"Incorrect Json file" delegate:self
                                               cancelButtonTitle:@"OK"
                                               otherButtonTitles:nil, nil];
        
        
        [_alert show];
        
        
    }
    else
    {
        [tableView reloadData];
    }
    
}
- (NSCachedURLResponse *)connection:(NSURLConnection *)connection willCacheResponse:(NSCachedURLResponse*)cachedResponse
{
    // Return nil to indicate not necessary to store a cached response for this connection
    return nil;
}

#pragma mark - Other Functions

-(void)createTableview
{
    tableView = [[UITableView alloc] initWithFrame:CGRectZero];
    
    tableView.delegate = self;
    tableView.dataSource = self;
    
    tableView.backgroundColor = [UIColor cyanColor];
    
    
    [tableView registerClass:[MyCustomCell class] forCellReuseIdentifier:cellIdentifier];
    
    tableView.translatesAutoresizingMaskIntoConstraints = NO;
    
    tableView.autoresizingMask = UIViewAutoresizingFlexibleWidth |
    UIViewAutoresizingFlexibleHeight;
    [self.view addSubview:tableView];
    
    tableView.estimatedRowHeight = UITableViewAutomaticDimension;
    
    
}

-(void)addConstraintsToTableView
{
    //*******Leading Space Constraints *************
    NSLayoutConstraint *constraint = [NSLayoutConstraint constraintWithItem:tableView attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeading multiplier:1.0f constant:0.0f];
    
    [self.view addConstraint:constraint];
    
    //************Trailing Space Constraints**************
    constraint = [NSLayoutConstraint constraintWithItem:tableView attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTrailing multiplier:1.0f constant:0.f];
    
    [self.view addConstraint:constraint];
    
    //**************Top Space Constraints**********
    constraint = [NSLayoutConstraint constraintWithItem:tableView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTop multiplier:1.0f constant:10.f];
    
    [self.view addConstraint:constraint];
    
    
    //****************Bottom Space Constraints**********
    constraint = [NSLayoutConstraint constraintWithItem:tableView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeBottom multiplier:1.0f constant:0.f];
    
    [self.view addConstraint:constraint];
    
    refreshControl = [[UIRefreshControl alloc] init];
    [refreshControl addTarget:self action:@selector(refreshTableview:) forControlEvents:UIControlEventValueChanged];
    [tableView addSubview:refreshControl];
}

-(void)getJsonDetails
{
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    
    NSString * _url =   [NSString stringWithFormat:@"https://dl.dropboxusercontent.com/u/746330/facts.json" ];
    
    // Create the request.
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:_url]];
    
    
    request.HTTPMethod = @"GET";
    // Create url connection and fire request
    [[NSURLConnection alloc] initWithRequest:request delegate:self];
    
}

- (void)refreshTableview:(UIRefreshControl *)refreshControl
{
    [self getJsonDetails];
    [refreshControl endRefreshing];
}

-(void)getScreenDimensions
{
    if ([[[UIDevice currentDevice] systemVersion] floatValue]  >= 8)
    {
        screen_Height = [[UIScreen mainScreen] bounds].size.height;
        screen_Width = [[UIScreen mainScreen] bounds].size.width;
    }
    else
    {
        screen_Height = ((([UIApplication sharedApplication].statusBarOrientation == UIInterfaceOrientationPortrait) || ([UIApplication sharedApplication].statusBarOrientation == UIInterfaceOrientationPortraitUpsideDown)) ? [[UIScreen mainScreen] bounds].size.height : [[UIScreen mainScreen] bounds].size.width);
        screen_Width = ((([UIApplication sharedApplication].statusBarOrientation == UIInterfaceOrientationPortrait) || ([UIApplication sharedApplication].statusBarOrientation == UIInterfaceOrientationPortraitUpsideDown)) ? [[UIScreen mainScreen] bounds].size.width : [[UIScreen mainScreen] bounds].size.height);
    }
    
}

//************Get Height of a control by passing the text*******//
- (CGFloat)heigtOfLabelForFromString:(NSString *)text
{
    
    CGSize constraint = CGSizeMake(screen_Width - 100 , 20000.0f);
    
    NSAttributedString *attributedText =
    [[NSAttributedString alloc]
     initWithString:text
     attributes:@
     {
     NSFontAttributeName:[UIFont systemFontOfSize:FONT_SIZE]
     }];
    
    CGRect rect = [attributedText boundingRectWithSize:constraint
                                               options:NSStringDrawingUsesLineFragmentOrigin
                                               context:nil];
    CGSize size = rect.size;
    
    
    CGFloat height = MAX(size.height, 120.0f);
    
    return height ;
}

@end
