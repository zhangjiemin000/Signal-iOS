//
//  Copyright (c) 2018 Open Whisper Systems. All rights reserved.
//

#import "ContactTableViewCell.h"
#import "ContactCellView.h"
#import "UIFont+OWS.h"
#import "UIView+OWS.h"
#import <SignalServiceKit/SignalAccount.h>

NS_ASSUME_NONNULL_BEGIN

@interface ContactTableViewCell ()

@property (nonatomic) ContactCellView *cellView;

@end

#pragma mark -

@implementation ContactTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(nullable NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self configure];
    }
    return self;
}

+ (NSString *)reuseIdentifier
{
    return NSStringFromClass(self.class);
}

- (void)setAccessoryView:(nullable UIView *)accessoryView
{
    OWSFail(@"%@ don't use accessory view for this view.", self.logTag);
}

- (void)configure
{
    OWSAssert(!self.cellView);

    self.cellView = [ContactCellView new];
    [self.contentView addSubview:self.cellView];
    [self.cellView autoPinEdgesToSuperviewMargins];
}

- (void)configureWithSignalAccount:(SignalAccount *)signalAccount contactsManager:(OWSContactsManager *)contactsManager
{
    [self.cellView configureWithRecipientId:signalAccount.recipientId contactsManager:contactsManager];
}

- (void)configureWithRecipientId:(NSString *)recipientId contactsManager:(OWSContactsManager *)contactsManager
{
    [self.cellView configureWithRecipientId:recipientId contactsManager:contactsManager];

    // Force layout, since imageView isn't being initally rendered on App Store optimized build.
    [self layoutSubviews];
}

- (void)configureWithThread:(TSThread *)thread contactsManager:(OWSContactsManager *)contactsManager
{
    OWSAssert(thread);

    [self.cellView configureWithThread:thread contactsManager:contactsManager];

    // Force layout, since imageView isn't being initally rendered on App Store optimized build.
    [self layoutSubviews];
}

- (void)setAccessoryMessage:(nullable NSString *)accessoryMessage
{
    OWSAssert(self.cellView);

    self.cellView.accessoryMessage = accessoryMessage;
}

- (NSAttributedString *)verifiedSubtitle
{
    return self.cellView.verifiedSubtitle;
}

- (void)setAttributedSubtitle:(nullable NSAttributedString *)attributedSubtitle
{
    [self.cellView setAttributedSubtitle:attributedSubtitle];
}

- (void)prepareForReuse
{
    [super prepareForReuse];

    [self.cellView prepareForReuse];

    self.accessoryView = nil;
    self.accessoryType = UITableViewCellAccessoryNone;
}

@end

NS_ASSUME_NONNULL_END
