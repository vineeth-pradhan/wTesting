#! /usr/bin/env node

if( typeof module !== 'undefined' )
{
  let _ = require( '../../Tools.s' );
  _.include( 'wFiles' );
  _.include( 'wExternalFundamentals' );
}

let _ = wTools;
let shell = _.shellNodePassingThrough
({
  execPath : _.path.join( __dirname, 'MainTop.s' ),
  verbosity : 0,
  passingThrough : 1,
  throwingExitCode : 0,
});