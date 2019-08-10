
if( typeof module !== 'undefined' )
require( 'wPathFundamentals' );
require( 'wFiles' )
var _ = wTools;


// Refine
var path = '../../foo/bar/';
var got = _.path.isRefinedMaybeTrailed( path );

logger.log( 'isRefinedMaybeTrailed', got);

var path = '../../foo/bar/';
var got = _.path.isRefined( path );

logger.log( 'isRefined', got);

var path = '../../foo/bar';
var got = _.path.isRefined( path );

logger.log( 'is Refined without trail', got);
logger.log( '' );

// Normalize
var path = '../../foo/bar/';
var got = _.path.isNormalizedMaybeTrailed( path );

logger.log( 'isNormalizedMaybeTrailed', got);

var path = '../../foo/bar/';
var got = _.path.isNormalized( path );

logger.log( 'isNormalized', got);

var path = '../../foo/bar';
var got = _.path.isNormalized( path );

logger.log( 'is Normalized without trail', got);
logger.log( '' );


logger.log( _.path.normalize( '../..//foo/../bar/' ) );
logger.log( _.path.refine( '../..//foo/../bar/' ) );
