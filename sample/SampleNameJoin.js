
if( typeof module !== 'undefined' )
require( 'wPathFundamentals' );
var _ = wTools;

var name = _.path.nameJoin( '/a', './b/' ); // returns '/a/b'
console.log( 'name is ' + name );
