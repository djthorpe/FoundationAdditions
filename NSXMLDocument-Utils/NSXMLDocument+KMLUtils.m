
#import "NSXMLDocument+KMLUtils.h"

@implementation NSXMLElement (KMLUtils)
-(NSString* )KMLString {
  NSArray* theChildren = [self children];
  if([theChildren count]==0) return @"";
  NSMutableString* theString = [NSMutableString string];
  for(unsigned i = 0; i < [theChildren count]; i++) {
    [theString appendString:[[theChildren objectAtIndex:i] XMLString]];
  }
  return theString;
}
@end

/////////////////////////////////////////////////////////////////////////////

@implementation NSXMLDocument (KMLUtils)

-(NSString* )KMLVersion {
  // root member should be a 'kml' tag, xmlns is http://earth.google.com/kml/2.1, nothing else supported at the moment
  NSXMLElement* theElement = [self rootElement];
  if([[theElement name] isEqual:@"kml"]==NO) {
    return nil;
  }
  if([[theElement URI] isEqual:@"http://earth.google.com/kml/2.1"]==NO) {
    return nil;
  }
  // we expect one 'Document' element, nothing else is supported
  NSError* theError = nil;
  NSArray* theDocuments = [self nodesForXPath:@"/kml/Document" error:&theError];
  if([theDocuments count] != 1) {
    return nil;
  }
  return [theElement URI];
}

-(NSString* )KMLName {
  NSError* theError = nil;
  NSArray* theName = [self nodesForXPath:@"/kml/Document/name" error:&theError];
  if([theName count] != 1) {
    return nil;
  }
  return [[theName objectAtIndex:0] KMLString];
}

-(NSArray* )KMLFeatures {
  NSError* theError = nil;
  NSArray* theFeatures = [self nodesForXPath:@"/kml/Document/(Placemark | NetworkLink | ScreenOverlay | GroundOverlay)" error:&theError];
  NSMutableArray* theArray = [NSMutableArray arrayWithCapacity:[theFeatures count]];
  for(unsigned i = 0; i < [theFeatures count]; i++) {
    KMLFeature* theFeature = [KMLFeature featureWithElement:[theFeatures objectAtIndex:i]];
    if(theFeature) {
      [theArray addObject:theFeature];
    }
  }
  return theArray;
}

@end

/////////////////////////////////////////////////////////////////////////////

@implementation KMLFeature

-(id)initWithElement:(NSXMLElement* )theElement {
  self = [super init];
  if(self) {
    m_theElement = [theElement retain];
  }
  return self;
}

-(void)dealloc {
  [m_theElement release];
  [super dealloc];
}

+(KMLFeature* )featureWithElement:(NSXMLElement* )theElement {
  return [[[KMLFeature alloc] initWithElement:theElement] autorelease];
}

-(NSXMLElement* )element {
  return m_theElement;
}

-(NSString* )type {  
  return [[self element] name];
}

-(NSString* )name {
  NSError* theError = nil;
  NSArray* theElements = [[self element] nodesForXPath:@"/name" error:&theError];
  if([theElements count] != 1) {
    return nil;
  }
  return [[theElements objectAtIndex:0] KMLString];    
}

-(BOOL)visibility {
  NSError* theError = nil;
  NSArray* theElements = [[self element] nodesForXPath:@"/visibility" error:&theError];
  if([theElements count] != 1) {
    return NO;
  }
  return [[NSDecimalNumber decimalNumberWithString:[[theElements objectAtIndex:0] KMLString]] boolValue];  
}

-(BOOL)open {
  NSError* theError = nil;
  NSArray* theElements = [[self element] nodesForXPath:@"/open" error:&theError];
  if([theElements count] != 1) {
    return NO;
  }
  return [[NSDecimalNumber decimalNumberWithString:[[theElements objectAtIndex:0] KMLString]] boolValue];    
}

-(NSString* )desc {
  NSError* theError = nil;
  NSArray* theElements = [[self element] nodesForXPath:@"/description" error:&theError];
  if([theElements count] != 1) {
    return nil;
  }
  return [[theElements objectAtIndex:0] XMLString];      
}

-(KMLGeometry* )geometry {
  NSError* theError = nil;
  NSArray* theElements = [[self element] nodesForXPath:@"(Point | LineString | LinearRing | Polygon | MultiGeometry | Model)" error:&theError];
  if([theElements count] != 1) {
    return nil;
  }
  return [KMLGeometry geometryWithElement:[theElements objectAtIndex:0]];
}

@end

/////////////////////////////////////////////////////////////////////////////

@implementation KMLGeometry 

-(id)initWithElement:(NSXMLElement* )theElement {
  self = [super init];
  if(self) {
    m_theElement = [theElement retain];
  }
  return self;
}

-(void)dealloc {
  [m_theElement release];
  [super dealloc];
}

+(KMLGeometry* )geometryWithElement:(NSXMLElement* )theElement {
  if([[theElement name] isEqual:@"Point"]) {
    return [[[KMLPoint alloc] initWithElement:theElement] autorelease];    
  } else if([[theElement name] isEqual:@"Polygon"]) {
      return [[[KMLPolygon alloc] initWithElement:theElement] autorelease];    
  } else if([[theElement name] isEqual:@"LinearRing"]) {
    return [[[KMLLinearRing alloc] initWithElement:theElement] autorelease];    
  } else {
    return [[[KMLGeometry alloc] initWithElement:theElement] autorelease];    
  }
}

-(NSXMLElement* )element {
  return m_theElement;
}

-(NSString* )type {  
  return [[self element] name];
}

@end

/////////////////////////////////////////////////////////////////////////////

@implementation KMLPoint

-(id)initWithElement:(NSXMLElement* )theElement {
  self = [super initWithElement:theElement];
  if(self) {
    // set latitude,longitude and altitude from <coordinates>
    NSError* theError = nil;
    NSArray* theElements = [[self element] nodesForXPath:@"coordinates" error:&theError];
    if([theElements count] != 1) {
      [self release];
      return nil;
    }
    // set the co-ordinates
    NSArray* theNumbers = [[[theElements objectAtIndex:0] KMLString] componentsSeparatedByString:@","];
    if([theNumbers count]==0 || ([theNumbers count]==1 && [[theNumbers objectAtIndex:0] isEqual:@""])) {
      [self release];
      return nil;
    }
    m_theLongitude = atof([[theNumbers objectAtIndex:0] UTF8String]);
    m_theLatitude = atof([[theNumbers objectAtIndex:1] UTF8String]);
    m_theAltitude = ([theNumbers count]==3 ? atof([[theNumbers objectAtIndex:0] UTF8String]) : 0.0);
  }
  return self;
}

-(id)initWithLongitude:(double)theLongitude latitude:(double)theLatitude altitude:(double)theAltitude {
  self = [super init];
  if(self) {
    m_theLongitude = theLongitude;
    m_theLatitude = theLatitude;
    m_theAltitude = theAltitude;
  }
  return self;
}

+(KMLPoint* )pointWithLongitude:(double)theLongitude latitude:(double)theLatitude altitude:(double)theAltitude {
  return [[[KMLPoint alloc] initWithLongitude:theLongitude latitude:theLatitude altitude:theAltitude] autorelease];
}

-(NSString* )type {  
  return @"Point";
}

-(double)latitude {
  return m_theLatitude;
}

-(double)longitude {
  return m_theLongitude;
}

-(double)altitude {
  return m_theAltitude;
}

-(void)setLatitude:(double)theLatitude {
  m_theLatitude = theLatitude;
}

-(void)setLongitude:(double)theLongitude {
  m_theLongitude = theLongitude;
}

-(void)setAltitude:(double)theAltitude {
  m_theAltitude = theAltitude;
}

-(NSString* )description {
  return [NSString stringWithFormat:@"<KMLPoint (Lat %f, Lng %f, Alt %f)>",[self latitude],[self longitude],[self altitude]];
}

@end

/////////////////////////////////////////////////////////////////////////////

@implementation KMLPolygon

-(NSString* )type {  
  return @"Polygon";
}

-(KMLLinearRing* )outerBoundary {
  NSError* theError = nil;
  NSArray* theElements = [[self element] nodesForXPath:@"outerBoundaryIs/LinearRing" error:&theError];
  if([theElements count] != 1) {
    return nil;
  }
  NSXMLElement* theLinearRing = [theElements objectAtIndex:0];
  
  if([[theLinearRing name] isEqual:@"LinearRing"]==NO) {
    return nil;
  }

  return (KMLLinearRing* )[KMLLinearRing geometryWithElement:theLinearRing];
}

-(NSArray* )innerBoundaries {
  NSError* theError = nil;
  NSArray* theElements = [[self element] nodesForXPath:@"innerBoundaryIs/LinearRing" error:&theError];
  NSMutableArray* theArray = [NSMutableArray arrayWithCapacity:[theElements count]];  
  for(unsigned i = 0; i < [theElements count]; i++) {
    KMLLinearRing* theLinearRing = (KMLLinearRing* )[KMLLinearRing geometryWithElement:[theElements objectAtIndex:i]];
    if(theLinearRing==nil) {
      return nil;
    }
    [theArray addObject:theLinearRing];
  }
  return theArray;
}

@end

/////////////////////////////////////////////////////////////////////////////

@implementation KMLLinearRing

-(id)initWithElement:(NSXMLElement* )theElement {
  self = [super initWithElement:theElement];
  if(self) {
    NSError* theError = nil;
    NSArray* theElements = [[self element] nodesForXPath:@"coordinates" error:&theError];
    if([theElements count] != 1) {
      return nil;
    }
    // set the co-ordinates
    NSArray* theCoordinates = [[[theElements objectAtIndex:0] KMLString] componentsSeparatedByString:@" "];
    m_theCoordinates = [[NSMutableArray alloc] initWithCapacity:[theCoordinates count]];    
    for(unsigned i = 0; i < [theCoordinates count]; i++) {
      NSString* theValues = [[theCoordinates objectAtIndex:i] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
      NSArray* theNumbers = [theValues componentsSeparatedByString:@","];
      if([theNumbers count]==0) {
        continue;        
      }
      if([theNumbers count]==1 && [[theNumbers objectAtIndex:0] isEqual:@""]) {
        continue;
      }
      if([theNumbers count]==1 || [theNumbers count] > 3) {
        [self release];
        return nil;
      }
      double theLongitude = atof([[theNumbers objectAtIndex:0] UTF8String]);
      double theLatitude = atof([[theNumbers objectAtIndex:1] UTF8String]);
      double theAltitude = ([theNumbers count]==3 ? atof([[theNumbers objectAtIndex:2] UTF8String]) : 0.0);
      [m_theCoordinates addObject:[KMLPoint pointWithLongitude:theLongitude latitude:theLatitude altitude:theAltitude]];
    }
  }
  return self;
}

-(void)dealloc {
  [m_theCoordinates release];
  [super dealloc];
}

-(NSString* )type {  
  return @"LinearRing";
}

-(NSArray* )coordinates {
  return m_theCoordinates;
}

-(double)normalizedLongitudeForPoint:(KMLPoint* )thePoint {
  return [thePoint longitude]; // + 180.0;
}

-(double)normalizedLatitudeForPoint:(KMLPoint* )thePoint {
  return [thePoint latitude]; // + 180.0;  
}

-(BOOL)pointInsideLinearRing2D:(KMLPoint* )thePoint {
  // if number of points is less than three, return NO as there's no way it could be inside
  if([[self coordinates] count] < 3) {
    return NO;
  }
  KMLPoint* theOld = [[self coordinates] lastObject];
  double xold = [self normalizedLongitudeForPoint:theOld];
  double yold = [self normalizedLatitudeForPoint:theOld];  
  double xt = [self normalizedLongitudeForPoint:thePoint];
  double yt = [self normalizedLatitudeForPoint:thePoint];  
  double x1,y1;
  double x2,y2;
  BOOL theInside = NO;
  for(unsigned i = 0; i < [[self coordinates] count]; i++) {
    KMLPoint* theNew = [[self coordinates] objectAtIndex:i];    
    double xnew = [self normalizedLongitudeForPoint:theNew];
    double ynew = [self normalizedLatitudeForPoint:theNew];
    if(xnew > xold) {      
      x1 = xold;
      x2 = xnew;
      y1 = yold;
      y2 = ynew;
    } else {
      x1 = xnew;
      x2 = xold;
      y1 = ynew;
      y2 = yold;
    }    
    /* edge "open" at one end */
    if ((xnew < xt) == (xt <= xold)   & (yt-y1)*(x2-x1) < (y2-y1)*(xt-x1)) {
      theInside = theInside ? NO : YES;
    }
    xold = xnew;
    yold = ynew;
  }
  return theInside;
}

@end
