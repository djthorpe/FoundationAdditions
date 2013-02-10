//
//  NSXMLDocument+KMLUtils.h
//  Fluxo
//
//  Created by David Thorpe on 17/07/2007.
//  Copyright 2007 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

/////////////////////////////////////////////////////////////////////////////

@interface NSXMLDocument (KMLUtils)
-(NSString* )KMLVersion;
-(NSString* )KMLName;
-(NSArray* )KMLFeatures;
@end

/////////////////////////////////////////////////////////////////////////////

@interface KMLGeometry : NSObject {
  NSXMLElement* m_theElement;    
}

+(KMLGeometry* )geometryWithElement:(NSXMLElement* )theElement;
-(NSXMLElement* )element;
-(NSString* )type;

@end

/////////////////////////////////////////////////////////////////////////////

@interface KMLPoint : KMLGeometry {
  double m_theLatitude;
  double m_theLongitude;
  double m_theAltitude;
}

+(KMLPoint* )pointWithLongitude:(double)theLongitude latitude:(double)theLongitude altitude:(double)theAltitude;
-(double)latitude;
-(double)longitude;
-(double)altitude;
-(void)setLatitude:(double)theLatitude;
-(void)setLongitude:(double)theLongitude;
-(void)setAltitude:(double)theAltitude;

@end

/////////////////////////////////////////////////////////////////////////////

@interface KMLLinearRing : KMLGeometry {
  NSMutableArray* m_theCoordinates;
}

-(NSArray* )coordinates;
-(BOOL)pointInsideLinearRing2D:(KMLPoint* )thePoint;

@end

/////////////////////////////////////////////////////////////////////////////

@interface KMLPolygon : KMLGeometry {
  
}

-(KMLLinearRing* )outerBoundary;
-(NSArray* )innerBoundaries;

@end

/////////////////////////////////////////////////////////////////////////////

@interface KMLFeature : NSObject {
  NSXMLElement* m_theElement;  
}

+(KMLFeature* )featureWithElement:(NSXMLElement* )theElement;
-(NSXMLElement* )element;
-(NSString* )type;
-(NSString* )name;
-(BOOL)visibility;
-(BOOL)open;
-(NSString* )desc;
-(KMLGeometry* )geometry;

@end

/////////////////////////////////////////////////////////////////////////////
