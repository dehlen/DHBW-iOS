#import "DERoomViewController.h"

@interface DERoomViewController()
@end

@implementation DERoomViewController

-(void)viewDidLoad {
	[super viewDidLoad];
    
    UIImage *buttonImage = [UIImage imageNamed:@"back"];
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    
    buttonImage = [buttonImage imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    button.tintColor = [UIColor colorWithRed:0.941 green:0.241 blue:0.241 alpha:1.000];
    
    [button setImage:buttonImage forState:UIControlStateNormal];
    button.frame = CGRectMake(0, 0, buttonImage.size.width, buttonImage.size.height);
    [button addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *customBarItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    self.navigationItem.leftBarButtonItem = customBarItem;
    
    self.navigationItem.title = @"Raumsuche";
    UIView *customView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 30)];
    UISegmentedControl *segment = [[UISegmentedControl alloc] initWithItems:@[@"Raumnummer", @"Raumbezeichnung"]];
    segment.selectedSegmentIndex = 0;
    segment.frame = CGRectMake(customView.frame.size.width/2-120-20, 0, 240, 30);
    [segment addTarget:self action:@selector(onSegmentChanged:) forControlEvents:UIControlEventValueChanged];
    [customView addSubview:segment];
    self.navigationItem.titleView = customView;
    
    roomSearchBar = [[INSSearchBar alloc] initWithFrame:CGRectMake(self.view.bounds.size.width/2-22.0, 80.0, 44.0, 34.0)];
    roomSearchBar.delegate = self;
    [self.view addSubview:roomSearchBar];
    [self performSelector:@selector(unfoldSearchBar) withObject:nil afterDelay:.5];
    
    NSString *dbPath = [[NSBundle mainBundle] pathForResource:@"roomDB" ofType:@"sqlite"];
    sqliteManager = [[SQLiteManager alloc] initWithDatabaseNamed:dbPath];
    
    
    dropDownTitles = [[NSMutableArray alloc]initWithObjects:@"Audimax",@"Bibliothek",@"Hausmeister",@"Hausdruckerei",@"Lesesaal PC Arbeitsraum",@"Mensa",@"Rektor",@"Sanitätsraum",@"StuV-Zimmer", nil];
    NSMutableArray *dropdownItems = [[NSMutableArray alloc] init];
    for (int i = 0; i < dropDownTitles.count; i++) {
        IGLDropDownItem *item = [[IGLDropDownItem alloc] init];
        [item setText:dropDownTitles[i]];
        [dropdownItems addObject:item];
    }
    
    
    self.dropDownMenu = [[IGLDropDownMenu alloc] init];
    self.dropDownMenu.menuText = @"Raum wählen";
    self.dropDownMenu.dropDownItems = dropdownItems;
    self.dropDownMenu.paddingLeft = 15;
    [self.dropDownMenu setFrame:CGRectMake(16, 80.0, self.view.bounds.size.width-32, 40.0)];
    self.dropDownMenu.delegate = self;
    self.dropDownMenu.alphaOnFold = 0.5;
    
    [self setupDropdown];
    
    [self.dropDownMenu reloadView];
    
    [self.view addSubview:self.dropDownMenu];
    [self.dropDownMenu setHidden:YES];

}

-(void)unfoldSearchBar {
    [roomSearchBar animateToVisible];

}

- (void)dropDownMenu:(IGLDropDownMenu *)dropDownMenu selectedItemAtIndex:(NSInteger)index
{
    IGLDropDownItem *item = dropDownMenu.dropDownItems[index];
    [self getResultsForText:item.text];
    
}


#pragma mark - search bar delegate

- (CGRect)destinationFrameForSearchBar:(INSSearchBar *)searchBar
{
    return CGRectMake(20.0, 80.0, CGRectGetWidth(self.view.bounds) - 40.0, 34.0);
}

- (void)onSegmentChanged:(id)sender
{
    UISegmentedControl *segment = (UISegmentedControl *)sender;
    selectedIndex = segment.selectedSegmentIndex;

    if(selectedIndex == 0) {
        [self.dropDownMenu setHidden:YES];
        [roomSearchBar setHidden:NO];
    }
    else {
        [self.dropDownMenu resetParams];

        [self.dropDownMenu setHidden:NO];
        [self.dropDownMenu reloadView];

        [roomSearchBar setHidden:YES];
    }
}

-(void)setupDropdown {
   // self.dropDownMenu.type = IGLDropDownMenuTypeStack;
    self.dropDownMenu.gutterY = 5;
    self.dropDownMenu.type = IGLDropDownMenuTypeSlidingInBoth;
    self.dropDownMenu.itemAnimationDelay = 0.1;
}

- (void)searchBar:(INSSearchBar *)searchBar willStartTransitioningToState:(INSSearchBarState)destinationState
{
    // Do whatever you deem necessary.
}

- (void)searchBar:(INSSearchBar *)searchBar didEndTransitioningFromState:(INSSearchBarState)previousState
{
    // Do whatever you deem necessary.
}

- (void)searchBarDidTapReturn:(INSSearchBar *)searchBar
{
    // Do whatever you deem necessary.
    // Access the text from the search bar like searchBar.searchField.text
    [roomSearchBar resignFirstResponder];
    [roomSearchBar endEditing:YES];
    NSString *searchString = searchBar.searchField.text;
    BOOL isLowercase = [[NSCharacterSet lowercaseLetterCharacterSet] characterIsMember:[searchString characterAtIndex:0]];
    if (isLowercase) {
        searchString = [searchString capitalizedString];
    }
    [self getResultsForText:searchString];
}

- (void)searchBarTextDidChange:(INSSearchBar *)searchBar
{
    // Do whatever you deem necessary.
    // Access the text from the search bar like searchBar.searchField.text
}

-(void)getResultsForText:(NSString *)text {
    if(selectedIndex == 0) {
        NSArray *results1 = [sqliteManager getRowsForQuery:[NSString stringWithFormat:@"SELECT Stock FROM raum WHERE Raumnummer='%@';",text]];
        
         NSArray *results2 = [sqliteManager getRowsForQuery:[NSString stringWithFormat:@"SELECT Raumbezeichnung FROM raumbezeichnung WHERE EXISTS (SELECT FKRaumbezeichnung FROM raum WHERE Raumnummer='%@' and raum.FKRaumbezeichnung = raumbezeichnung.IDRaumbezeichnung);",text]];
        
          NSArray *results3 = [sqliteManager getRowsForQuery:[NSString stringWithFormat:@"SELECT Lokalisation FROM lokalisation WHERE EXISTS (SELECT FKLokalisation FROM raum WHERE Raumnummer='%@' and raum.FKLokalisation = lokalisation.IDLokalisation);",text]];
        
        NSArray *results4 = [sqliteManager getRowsForQuery:[NSString stringWithFormat:@"SELECT Fluegel FROM raumbereich WHERE EXISTS (SELECT FKFluegel FROM raum WHERE Raumnummer='%@' and raum.FKFluegel = raumbereich.IDFluegel);",text]];

        
        if(results1.count == 0 || results2.count == 0 || results3.count == 0 ||results4.count == 0) {
            [imageView setImage:[UIImage imageNamed:@"gebaeudeplan_uebersicht"]];
            [textView setText:@"Informationen: "];
            return;
        }
        
        NSDictionary *stockDict = [results1 objectAtIndex:0];
        NSString *stock = stockDict[@"Stock"];
        
       
        NSDictionary *bezeichnerDict = [results2 objectAtIndex:0];
        NSString *raumBezeichnung = bezeichnerDict[@"Raumbezeichnung"];
        
      
        NSDictionary *lokalisationDict = [results3 objectAtIndex:0];
        NSString *lokalisation = lokalisationDict[@"Lokalisation"];
        
        NSDictionary *fluegelDict = [results4 objectAtIndex:0];
        NSString *fluegel = fluegelDict[@"Fluegel"];
         [textView setText:[NSString stringWithFormat:@"Informationen:\nFlügel: %@\nStock: %@\nBereich: %@\nRaumbezeichnung: %@\n",fluegel,stock,lokalisation,raumBezeichnung]];
        
        [self setPictureForRoom:fluegel andLokalisation:lokalisation];
    }
    else {
        
        NSArray *results1 = [sqliteManager getRowsForQuery:[NSString stringWithFormat:@"SELECT Lokalisation FROM lokalisation WHERE EXISTS (SELECT FKLokalisation FROM raum JOIN raumbezeichnung ON raum.FKRaumbezeichnung= raumbezeichnung.IDRaumbezeichnung WHERE Raumbezeichnung='%@' and raum.FKLokalisation = lokalisation.IDLokalisation);",text]];
        
        
        NSArray *results2 = [sqliteManager getRowsForQuery:[NSString stringWithFormat:@"SELECT Fluegel FROM raumbereich WHERE EXISTS (SELECT FKFluegel FROM raum JOIN raumbezeichnung ON raum.FKRaumbezeichnung= raumbezeichnung.IDRaumbezeichnung WHERE Raumbezeichnung='%@' and raum.FKFluegel = raumbereich.IDFluegel);",text]];
        
        NSArray *results3 = [sqliteManager getRowsForQuery:[NSString stringWithFormat:@"SELECT Stock FROM raum JOIN raumbezeichnung ON raum.FKRaumbezeichnung= raumbezeichnung.IDRaumbezeichnung WHERE Raumbezeichnung='%@';",text]];

        
        if(results1.count == 0 || results2.count == 0 || results3.count == 0) {
            [imageView setImage:[UIImage imageNamed:@"gebaeudeplan_uebersicht"]];
            [textView setText:@"Informationen: "];
            return;
        }
        
        
        NSDictionary *lokalisationDict = [results1 objectAtIndex:0];
        NSString *lokalisation = lokalisationDict[@"Lokalisation"];
       
        NSDictionary *fluegelDict = [results2 objectAtIndex:0];
        NSString *fluegel = fluegelDict[@"Fluegel"];
        
        NSDictionary *stockDict = [results3 objectAtIndex:0];
        NSString *stock = stockDict[@"Stock"];
        
        [textView setText:[NSString stringWithFormat:@"Informationen:\nFlügel: %@\nStock: %@\nBereich: %@\n",fluegel,stock,lokalisation]];
        [self setPictureForRoom:fluegel andLokalisation:lokalisation];

    }
}

- (BOOL) containsString: (NSString *)string andSubstring:(NSString*) substring
{
    NSRange range = [string rangeOfString : substring];
    BOOL found = ( range.location != NSNotFound );
    return found;
}

/**Exakte Methode aus Android APP  -- vielleicht mal refactoren **/
-(void)setPictureForRoom:(NSString *)fluegel andLokalisation:(NSString *)lokalisation {
    if ([self containsString:fluegel andSubstring:@"Nordflügel"])
    {
        if ([self containsString:lokalisation andSubstring:@"Ganganfang"]) {
            [imageView setImage:[UIImage imageNamed:@"gebaeudeplan_nordvorne"]];
        }
        else if ([self containsString:lokalisation andSubstring:@"Gangmitte"]) {
            [imageView setImage:[UIImage imageNamed:@"gebaeudeplan_nordmitte"]];
        }
        else if ([self containsString:lokalisation andSubstring:@"Gangende"]) {
            [imageView setImage:[UIImage imageNamed:@"gebaeudeplan_nordhinten"]];
        }
    }
    else if ([self containsString:fluegel andSubstring:@"Mittelbau II"]) {
        [imageView setImage:[UIImage imageNamed:@"gebaeudeplan_mittel2"]];
    }
    else if ([self containsString:fluegel andSubstring:@"Mittelflügel"])
    {
        if ([self containsString:lokalisation andSubstring:@"Ganganfang"]) {
            [imageView setImage:[UIImage imageNamed:@"gebaeudeplan_mittelvorne"]];

        }
        else if ([self containsString:lokalisation andSubstring:@"Gangmitte"]) {
            [imageView setImage:[UIImage imageNamed:@"gebaeudeplan_mittelmitte"]];
        }
        else if ([self containsString:lokalisation andSubstring:@"Gangende"]) {
            [imageView setImage:[UIImage imageNamed:@"gebaeudeplan_mittelhinten"]];
        }
    }
    else if ([self containsString:fluegel andSubstring:@"Mittelbau I"]) {
        [imageView setImage:[UIImage imageNamed:@"gebaeudeplan_mittel1"]];
    }
    else if ([self containsString:fluegel andSubstring:@"Südflügel"])
    {
        if ([self containsString:lokalisation andSubstring:@"Ganganfang"]) {
            [imageView setImage:[UIImage imageNamed:@"gebaeudeplan_suedvorne"]];
            
        }
        else if ([self containsString:lokalisation andSubstring:@"Gangmitte"]) {
            [imageView setImage:[UIImage imageNamed:@"gebaeudeplan_suedmitte"]];
        }
        else if ([self containsString:lokalisation andSubstring:@"Gangende"]) {
            [imageView setImage:[UIImage imageNamed:@"gebaeudeplan_suedhinten"]];
        }
    }
    else if ([self containsString:fluegel andSubstring:@"Erweiterung"]) {
        [imageView setImage:[UIImage imageNamed:@"gebaeudeplan_erweiterung"]];
    }
    else {
        [imageView setImage:[UIImage imageNamed:@"gebaeudeplan_uebersicht"]];
    }
}


-(void)back {
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)didReceiveMemoryWarning {
	[super didReceiveMemoryWarning];
}

@end