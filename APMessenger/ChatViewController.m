//
//  ChatViewController.m
//  APMessenger
//
//  Created by Inela Avdic Hukic on 1/28/17.
//  Copyright © 2017 Authority Partners. All rights reserved.
//

#import "ChatViewController.h"

@interface ChatViewController ()<UITableViewDataSource, UITableViewDelegate> {
    NSMutableArray *chatArray;
}

@property (weak, nonatomic) NSString *chatPerson;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UITextField *typedMessageTextField;

@end

@implementation ChatViewController

#pragma mark - View controller lifecycle methods

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Read chat person from performed segue
    self.chatPerson = @"Bill Gates";
    self.navigationItem.title = self.chatPerson;
    [self initializeChatArray];

    [self setTableViewBackgroundGradientWithTopColor:[UIColor colorWithRed:73.0/255 green:151.0/255 blue:165.0/255 alpha:1] bottomColor:[UIColor colorWithRed:48.0/255 green:74.0/255 blue:91.0/255 alpha:1]];
    
    self.typedMessageTextField.layer.cornerRadius = 5;
    self.typedMessageTextField.layer.masksToBounds = YES;
    self.typedMessageTextField.backgroundColor = [UIColor colorWithRed:48.0/255 green:74.0/255 blue:91.0/255 alpha:1];
    self.typedMessageTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Write your message..." attributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
    self.typedMessageTextField.delegate = self;
    
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight = 70;
    [self.tableView reloadData];
    
    UITapGestureRecognizer *gestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKeyboard)];
    [self.view addGestureRecognizer:gestureRecognizer];
    
    // Code for navigation bar - common for whole app
    UIImage *backButtonImage = [UIImage imageNamed:@"BackIcon"];
    backButtonImage = [backButtonImage imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc]
                                    initWithImage:backButtonImage
                                    style:UIBarButtonItemStylePlain
                                    target:self.navigationController
                                    action:@selector(popViewControllerAnimated:)];
    [backButton setTintColor:[UIColor whiteColor]];
    self.navigationItem.leftBarButtonItem = backButton;
    [self.navigationController.navigationBar setBarTintColor: [UIColor colorWithRed:93.0/255 green:168.0/255 blue:180.0/255 alpha:1]];
    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName: [UIColor whiteColor]};

}

- (void) viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    if (chatArray.count > 0) {
        [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:chatArray.count-1 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
    }
}

#pragma mark - Helper methods

- (void)setTableViewBackgroundGradientWithTopColor:(UIColor *)topColor bottomColor:(UIColor *)bottomColor {
    CAGradientLayer *gradientLayer = [[CAGradientLayer alloc] init];
    gradientLayer.colors = [NSArray arrayWithObjects: (id)topColor.CGColor, (id)bottomColor.CGColor, nil];
    gradientLayer.locations = @[@0.0,@1.0];
    gradientLayer.frame = self.tableView.bounds;
    UIView *newView = [[UIView alloc] initWithFrame:self.tableView.bounds];
    [newView.layer insertSublayer:gradientLayer atIndex:0];
    self.tableView.backgroundView = newView;
}

- (void)initializeChatArray {
    
    Message *message1 = [[Message alloc] initWithText:@"Hi Bill!" sender:@"test@authoritypartners.com" receiver:@"billgates@authoritypartners.com" time:[NSDate distantPast]];
    Message *message2 = [[Message alloc] initWithText:@"What's up?!" sender:@"billgates@authoritypartners.com" receiver:@"test@authoritypartners.com" time:[NSDate distantPast]];
    Message *message3 = [[Message alloc] initWithText:@"Lorem ipsum dolor sit amet, consectetur adipiscing elit" sender:@"test@authoritypartners.com" receiver:@"billgates@authoritypartners.com" time:[NSDate distantPast]];
    Message *message4 = [[Message alloc] initWithText:@"Lorem ipsum dolor sit amet, consectetur adipiscing elit" sender:@"billgates@authoritypartners.com" receiver:@"test@authoritypartners.com" time:[NSDate distantPast]];
    Message *message5 = [[Message alloc] initWithText:@"Lorem ipsum dolor sit amet, consectetur adipiscing elit" sender:@"test@authoritypartners.com" receiver:@"billgates@authoritypartners.com" time:[NSDate distantPast]];
    
    chatArray = [NSMutableArray arrayWithArray:@[message1, message2, message3, message4, message5]];
}

#pragma mark - UITableView DataSource Methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return chatArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    Message *message = [chatArray objectAtIndex:indexPath.row];

    if([message.sender isEqualToString: @"test@authoritypartners.com"]) {
        RightChatTableViewCell *cell = (RightChatTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"RightChatCell"];
        cell.chatTextLabel.text = message.text;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.bubbleView.layer.cornerRadius = 8;
        cell.bubbleView.layer.masksToBounds = YES;
        [cell layoutSubviews];
        return cell;
    } else {
        LeftChatTableViewCell *cell = (LeftChatTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"LeftChatCell"];
        cell.chatTextLabel.text = message.text;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.bubbleView.layer.cornerRadius = 8;
        cell.bubbleView.layer.masksToBounds = YES;
        [cell layoutSubviews];
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    cell.backgroundColor = [UIColor clearColor];
}

#pragma mark - Action methods

- (IBAction)sendMessage:(id)sender {
    if (![self.typedMessageTextField.text isEqualToString:@""]) {
        NSDate *now = [NSDate date];
        Message *newMessage = [[Message alloc] initWithText:self.typedMessageTextField.text sender:@"test@authoritypartners.com" receiver:@"billgates@authoritypartners.com" time:now];
        [chatArray addObject:newMessage];
        self.typedMessageTextField.text = @"";
        [self.tableView reloadData];
        [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:chatArray.count-1 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
        [self.tableView reloadData];
    }
}

- (void)dismissKeyboard {
    [self.typedMessageTextField resignFirstResponder];
}


#pragma mark - UITextFieldDelegate methods

-(void)textFieldDidBeginEditing:(UITextField *)textField {
    [self animateTextField:textField up:YES];
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    [self animateTextField:textField up:NO];
}

-(void)animateTextField:(UITextField*)textField up:(BOOL)up {
    const int movementDistance = -250;
    const float movementDuration = 0.3f;
    
    int movement = (up ? movementDistance : -movementDistance);
    
    [UIView beginAnimations: @"animateTextField" context: nil];
    [UIView setAnimationBeginsFromCurrentState: YES];
    [UIView setAnimationDuration: movementDuration];
    self.view.frame = CGRectOffset(self.view.frame, 0, movement);
    [UIView commitAnimations];
}

@end
