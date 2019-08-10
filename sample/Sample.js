
if( typeof module !== 'undefined' )
require( '..' /* 'wpathtools' */ );
var _ = wTools;

var dst = '/dst'
var src = '/dst'
var pathMap = _.path.mapExtend( null, dst, src );
console.log( 'Path map\n', pathMap );
