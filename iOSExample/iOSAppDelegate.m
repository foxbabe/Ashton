#import "iOSAppDelegate.h"
#import "AshtonHTMLReader.h"
#import "AshtonHTMLWriter.h"
#import "AshtonUIKit.h"

@implementation iOSAppDelegate {
    NSAttributedString *_attributedText;
}

- (void)applicationDidFinishLaunching:(UIApplication *)application {
    self.intermediateAS = [self readAttributedStringFromHTMLFile:@"Test1"];
    self.intermediateAS = [self.intermediateAS attributedSubstringFromRange:NSMakeRange(0, 30)];
    _attributedText = [[AshtonUIKit sharedInstance] targetRepresentationWithIntermediateRepresentation:self.intermediateAS];
    NSError *error = nil;
    NSData *rtfData = [_attributedText dataFromRange:NSMakeRange(0, _attributedText.length) documentAttributes:@{ NSDocumentTypeDocumentAttribute: NSRTFTextDocumentType } error:&error];
    NSString *rtf = [[NSString alloc] initWithData:rtfData encoding:NSASCIIStringEncoding];
    [rtf length];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 5000000000), dispatch_get_main_queue(), ^{
        [self writeBench];
    });
}

- (NSAttributedString *)readAttributedStringFromHTMLFile:(NSString *)name {
    NSString *path = [[NSBundle bundleForClass:[self class]] pathForResource:name ofType:@"html"];
    NSString *html = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:NULL];
    return [[AshtonHTMLReader HTMLReader] attributedStringFromHTMLString:html];
}

#pragma mark - Benchmark

- (void)writeBench {
    [self writeBenchRTF];
    [self writeBenchAshton];
    [self writeBenchRTF];
    [self writeBenchAshton];
}

- (void)writeBenchRTF {
    CFAbsoluteTime startTime = CFAbsoluteTimeGetCurrent();
    for (int i = 0; i<1000; i++) {
    NSError *error = nil;
    NSData *rtfData = [_attributedText dataFromRange:NSMakeRange(0, _attributedText.length) documentAttributes:@{ NSDocumentTypeDocumentAttribute: NSRTFTextDocumentType } error:&error];
    NSString *rtf = [[NSString alloc] initWithData:rtfData encoding:NSASCIIStringEncoding];
    [rtf length];
    }
    CFAbsoluteTime endTime = CFAbsoluteTimeGetCurrent();
    NSLog(@"RTF took %2.5f seconds", endTime - startTime);
}

- (void)writeBenchAshton {
    CFAbsoluteTime startTime = CFAbsoluteTimeGetCurrent();
    for (int i = 0; i<1000; i++) {
        NSAttributedString *intermediate = [[AshtonUIKit sharedInstance] intermediateRepresentationWithTargetRepresentation:_attributedText];
        NSString *html = [[AshtonHTMLWriter sharedInstance] HTMLStringFromAttributedString:intermediate];
        [html length];
    }
    CFAbsoluteTime endTime = CFAbsoluteTimeGetCurrent();
    NSLog(@"Ashton took %2.5f seconds", endTime - startTime);
}


//- (void)readRTF {
//    NSData *data;
//    NSAttributedString *output = [[NSAttributedString alloc] initWithData:data options:@{ NSDocumentTypeDocumentAttribute: NSRTFTextDocumentType } documentAttributes:nil error:nil];
//}

@end
