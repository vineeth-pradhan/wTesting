(function _aBase_debug_s_() {

'use strict';

/*

+ implement test case tracking

+ move test routine methods out of test suite
+ implement routine only as option of test suite

+ adjust verbosity levels

+ make possible switch off parents test routines

fileStat : null

+ make "should/must not error" pass original messages through
  test.description = 'mustNotThrowError must return con with message';

  var con = new _.Consequence().give( '123' );
  test.mustNotThrowError( con )
  .ifNoErrorThen( function( got )
  {
    test.identical( got, '123' );
  })

+ improve inheritance
+ global search cant find test suites with inheritance

- implement options.list
- print information about case with color directive avoiding change of color state of logger

- implement support of glob path
- manual launch of test suite + global tests execution should not give extra test suite runs

+ after the last test case of test routine description should be changed

+ test.identical( undefined,undefined ) -> strange output, replacing undefined by null!

+ test suite should not pass if 0 / 0 test checks

+ track number of thrown errors

+ global / suite / routine basis statistic tracking

+ fails issue
+ implement silencing from test suite

- no suite/tester sanitare period if errror

- time measurements out of test

- sort-cuts for command line otpions

- warning if command line option is strange
- warning if test routine has unknown fields

- issue if first test suite has silencing:0 and other silencing:1

- less static information with verbosity:7, to introduce higher verbosity levels

- make onSuitBegin, onSuitEnd asynchronous

- when error not throwen under test.mustNotThrowError have "error was not thrown asynchronously, but expected"

*/

var _global = undefined;
if( !_global && typeof Global !== 'undefined' && Global.Global === Global ) _global = Global;
if( !_global && typeof global !== 'undefined' && global.global === global ) _global = global;
if( !_global && typeof window !== 'undefined' && window.window === window ) _global = window;
if( !_global && typeof self   !== 'undefined' && self.self === self ) _global = self;
var _globalReal = _global;
var _globalWas = _global._global_;
if( _global._global_ )
_global = _global._global_;
_global._global_ = _global;
_globalReal._globalReal_ = _globalReal;

if( _globalReal_._SeparatingTester_ )
{
  _global = _global._global_ = Object.create( _global._global_ );
  _global._UsingWtoolsPrivately_ = true;
  _global._globalWas_ = _globalWas;
}

if( typeof module !== 'undefined' )
{

  if( !_global_.wBase || _global_._UsingWtoolsPrivately_ )
  {
    let toolsPath = '../../../dwtools/Base.s';
    let _externalTools = 0;
    try
    {
      require.resolve( toolsPath );
    }
    catch( err )
    {
      _externalTools = 1;
      require( 'wTools' );
    }
    if( !_externalTools )
    require( toolsPath );
  }

  var _ = _global_.wTools;

  _.include( 'wCopyable' );
  _.include( 'wInstancing' );
  _.includeAny( 'wEventHandler','' );
  _.include( 'wConsequence' );
  _.include( 'wFiles' );
  _.include( 'wLogger' );

  _.assert( !_globalReal_.wTester || !_globalReal_.wTester._isFullImplementation,'wTester is already included' );

  // _.includeAny( 'wScriptLauncher' );

  require( './aTestSuite.debug.s' );
  require( './bTestRoutine.debug.s' );
  require( './cTester.debug.s' );
  require( './zLast.debug.s' );

}

})();