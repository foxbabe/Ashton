#import "AshtonHTMLTests.h"
#import "AshtonHTMLReader.h"
#import "AshtonHTMLWriter.h"
#import "AshtonIntermediate.h"

@implementation AshtonHTMLTests {
    AshtonHTMLReader *reader;
    AshtonHTMLWriter *writer;
}

- (void)setUp {
    [super setUp];
    reader = [[AshtonHTMLReader alloc] init];
    writer = [[AshtonHTMLWriter alloc] init];
}

- (void)tearDown {
    reader = nil;
    writer = nil;
    [super tearDown];
}

- (void)testHTMLEscapingInAhrefInline {
    NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:@"Test: Link to test. That's it"];
    [string setAttributes:@{ AshtonAttrLink: @"http://google.com/?a='b\"&c=<>" } range:NSMakeRange(6, 13)];
    NSString *htmlString = [writer HTMLStringFromAttributedString:string];
    NSAttributedString *roundtripped = [reader attributedStringFromHTMLString:htmlString];
    XCTAssertEqualObjects(string, roundtripped, @"HTML escaping of inline link failed");
}

- (void)testHTMLEscapingInAhrefParagraph {
    NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:@"Test: Link to test. That's it" attributes:@{ AshtonAttrLink: @"http://google.com/?a='b\"&c=<>" }];
    NSString *htmlString = [writer HTMLStringFromAttributedString:string];
    NSAttributedString *roundtripped = [reader attributedStringFromHTMLString:htmlString];
    XCTAssertEqualObjects(string, roundtripped, @"HTML escaping of linked paragraph failed");
}

- (void)testBackgroundColor {
    NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:@"Test: Background Color."];
    [string setAttributes:@{ AshtonAttrBackgroundColor: @[ @(1), @(1), @(0), @(1.) ] } range:NSMakeRange(6, 10)];
    NSString *htmlString = [writer HTMLStringFromAttributedString:string];
    NSAttributedString *roundtripped = [reader attributedStringFromHTMLString:htmlString];
    XCTAssertEqualObjects(string, roundtripped, @"HTML output for background color failed");
}


@end
