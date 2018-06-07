(function _bTestRoutine_debug_s_() {

'use strict';

//

var _global = _global_; var _ = _global_.wTools;
var Parent = null;
var Self = function wTestRoutineDescriptor( o )
{
  if( !( this instanceof Self ) )
  if( o instanceof Self )
  return o;
  else
  return new( _.routineJoin( Self, Self, arguments ) );
  return Self.prototype.init.apply( this,arguments );
}

Self.nameShort = 'TestRoutineDescriptor';

//

function init( o )
{
  var self = this;

  _.instanceInit( self );

  Object.preventExtensions( self );

  if( o )
  self.copy( o );

  self._returnCon = null;

  self._reportForm();

  _.assert( _.routineIs( self.routine ) );
  _.assert( _.strIsNotEmpty( self.routine.name ),'Test routine should have name, ' + self.name + ' test routine of test suit',self.suit.name,'does not have name' );
  _.assert( Object.isPrototypeOf.call( _.TestSuit.prototype,self.suit ) );
  _.assert( Object.isPrototypeOf.call( Self.prototype,self ) );
  _.assert( arguments.length === 1 );

  var proxy =
  {
    get : function( obj, k )
    {
      if( obj[ k ] !== undefined )
      return obj[ k ];
      return obj.suit[ k ];
    }
  }

  var self = new Proxy( self, proxy );

  return self;
}

// --
// run
// --

function _testRoutineBegin()
{
  var trd = this;
  var suit = trd.suit;

  _.assert( arguments.length === 0 );

  var msg =
  [
    'Running test routine ( ' + trd.routine.name + ' ) ..'
  ];

  suit.logger.begin({ verbosity : -4 });

  suit.logger.begin({ 'routine' : trd.routine.name });
  suit.logger.logUp( msg.join( '\n' ) );
  suit.logger.end( 'routine' );

  suit.logger.end({ verbosity : -4 });

  _.assert( !suit.currentRoutine );
  suit.currentRoutine = trd;

  try
  {
    suit.onRoutineBegin.call( trd.context,trd );
    if( trd.eventGive )
    trd.eventGive({ kind : 'routineBegin', testRoutine : trd, context : trd.context });
  }
  catch( err )
  {
    suit._exceptionConsider( err );
  }

}

//

function _testRoutineEnd()
{
  var trd = this;
  var suit = trd.suit;
  var ok = trd._reportIsPositive();

  _.assert( arguments.length === 0 );
  _.assert( _.strIsNotEmpty( trd.routine.name ),'test routine should have name' );
  _.assert( suit.currentRoutine === trd );

  var suitHasConsoleInOutputs = suit.logger._hasOutput( console,{ deep : 0, ignoringUnbar : 0 } );

  if( !suitHasConsoleInOutputs )
  {
    var bar = _.Tester._bar.bar;

    _.Tester._bar.bar = 0;
    suit.logger.consoleBar( _.Tester._bar );

    if( bar )
    {
      _.Tester._bar.bar = bar;
      suit.logger.consoleBar( _.Tester._bar );
    }

    var err = _.err( 'Console is missing in logger`s outputs, probably logger was modified in, suit:', _.strQuote( suit.name ),'test routine:', _.strQuote( trd.routine.name ) );
    suit.exceptionReport
    ({
      err : err,
    });
  }

  try
  {
    suit.onRoutineEnd.call( trd.context,trd,ok );
    if( trd.eventGive )
    trd.eventGive({ kind : 'routineEnd', testRoutine : trd, context : trd.context });
  }
  catch( err )
  {
    suit._exceptionConsider( err );
  }

  if( trd.report.testCheckFails )
  suit.report.testRoutineFails += 1;
  else
  suit.report.testRoutinePasses += 1;

  suit.logger.begin( 'routine','end' );
  suit.logger.begin({ 'connotation' : ok ? 'positive' : 'negative' });

  suit.logger.begin({ verbosity : -3 });

  if( ok )
  {

    suit.logger.logDown( 'Passed test routine ( ' + trd.routine.name + ' ).' );

  }
  else
  {

    suit.logger.begin({ verbosity : -3+suit.importanceOfNegative });
    suit.logger.logDown( 'Failed test routine ( ' + trd.routine.name + ' ).' );
    suit.logger.end({ verbosity : -3+suit.importanceOfNegative });

  }

  suit.logger.end({ 'connotation' : ok ? 'positive' : 'negative' });
  suit.logger.end( 'routine','end' );

  suit.logger.end({ verbosity : -3 });

  suit.currentRoutine = null;

}

//

function _testRoutineHandleReturn( err,msg )
{
  var trd = this;
  var suit = trd.suit;

  if( err )
  if( err.timeOut )
  err = _._err
  ({
    args : [ 'Test routine ( ' + trd.routine.name + ' ) time out!' ],
    usingSourceCode : 0,
  });

  trd.description = '';

  if( err )
  {
    trd.exceptionReport
    ({
      err : err,
    });
  }
  else
  {
    if( trd.report.testCheckPasses === 0 && trd.report.testCheckFails === 0 )
    trd._outcomeReportBoolean
    ({
      outcome : 0,
      msg : 'test routine has passed none test check',
      usingSourceCode : 0,
      usingDescription : 0,
    });
    else
    trd._outcomeReportBoolean
    ({
      outcome : 1,
      msg : 'test routine has not thrown an error',
      usingSourceCode : 0,
      usingDescription : 0,
    });
  }

}

// --
// case
// --

function _descriptionGet()
{
  var trd = this;
  return trd[ descriptionSymbol ];
}

//

function _descriptionSet( src )
{
  var trd = this;
  trd[ descriptionSymbol ] = src;

  if( src )
  trd.testCaseNext();

}

//

function testCaseNext()
{
  var trd = this;
  var report = trd.report;

  trd._testCaseConsider( !report.testCheckFailsOfTestCase );

}

//

function _testCaseConsider( outcome )
{
  var trd = this;
  var report = trd.report;

  if( outcome )
  report.testCasePasses += 1;
  else
  report.testCaseFails += 1;

  trd.suit._testCaseConsider( outcome );
}

// --
// store
// --

function checkCurrent()
{
  var trd = this;
  var result = Object.create( null );

  _.assert( arguments.length === 0 );

  result.description = trd.description;
  result._checkIndex = trd._checkIndex;

  return result;
}

//

function checkNext( description )
{
  var trd = this;

  _.assert( trd instanceof Self );
  _.assert( arguments.length === 0 || arguments.length === 1 );

  if( !trd._checksStack.length )
  if( trd.name === 'row' || trd.name === 'include' )
  {
    console.log( 'trd._checkIndex',trd._checkIndex );
    console.log( _.diagnosticStack() );
    debugger;
  }

  if( !trd._checkIndex )
  trd._checkIndex = 1;
  else
  trd._checkIndex += 1;

  if( description !== undefined )
  trd.description = description;

  return trd.checkCurrent();
}

//

function checkStore()
{
  var trd = this;
  var result = trd.checkCurrent();

  _.assert( arguments.length === 0 );

  trd._checksStack.push( result );

  return result;
}

//

function checkRestore( acheck )
{
  var trd = this;

  _.assert( arguments.length === 0 || arguments.length === 1 );

  if( acheck )
  {
    trd.checkStore();
  }
  else
  {
    _.assert( _.arrayIs( trd._checksStack ) && trd._checksStack.length, 'checkRestore : no stored check in stack' );
    acheck = trd._checksStack.pop();
  }

  trd.description = acheck.description;
  trd._checkIndex = acheck._checkIndex;

  return trd;
}

// --
// equalizer
// --

function shouldBe( outcome )
{
  var trd = this;

  // _.assert( _.boolLike( outcome ),'shouldBe expects single bool argument' );
  // _.assert( arguments.length === 1,'shouldBe expects single bool argument' );

  if( !_.boolLike( outcome ) || arguments.length !== 1 )
  trd._outcomeReportBoolean
  ({
    outcome : 0,
    msg : 'shouldBe expects single bool argument',
  });
  else
  trd._outcomeReportBoolean
  ({
    outcome : outcome,
    msg : 'expected true',
  });

  return outcome;
}

//

function shouldBeNotError( maybeErrror )
{
  var trd = this;

  // _.assert( arguments.length === 1,'shouldBeNotError expects single argument' );

  if( arguments.length !== 1 )
  trd._outcomeReportBoolean
  ({
    outcome : 0,
    msg : 'shouldBeNotError expects single argument',
  });
  else
  trd._outcomeReportBoolean
  ({
    outcome : !_.errIs( maybeErrror ),
    msg : 'expected variable is not error',
  });

}

//

function isNotIdentical( got,expected )
{
  var trd = this;
  var iterator = Object.create( null );

  _.assert( arguments.length === 2 );

  var outcome = _.entityIdentical( got,expected,iterator );

  _.assert( iterator.lastPath !== undefined );

  trd._outcomeReportCompare
  ({
    outcome : !outcome,
    got : got,
    expected : expected,
    path : iterator.lastPath,
    usingExtraDetails : 0,
  });

  return outcome;
}

//

/**
 * Checks if test passes a specified condition by deep strict comparsing result of code execution( got )
 * with target( expected ). Uses recursive comparsion for objects,arrays and array-like objects.
 * If entity( got ) is equal to entity( expected ) test is passed successfully. After check function reports result of test
 * to the testing system. If test is failed function also outputs additional information.
 * Returns true if test is done successfully, otherwise false.
 *
 * @param {*} got - Source entity.
 * @param {*} expected - Target entity.
 *
 * @example
 * function someTest( test )
 * {
 *  test.description = 'single zero';
 *  var got = 0;
 *  var expected = 0;
 *  test.identical( got, expected );//returns true
 *
 *  test.description = 'single number';
 *  var got = 2;
 *  var expected = 1;
 *  test.identical( got, expected );//returns false
 * }
 *
 * _.Tester.test( { name : 'test', tests : { sometest : sometest } } );
 *
 * @throws {Exception} If no arguments provided.
 * @method identical
 * @memberof wTestRoutineDescriptor
 */

function identical( got,expected )
{
  var trd = this;
  var iterator = Object.create( null );

  _.assert( arguments.length === 2,'expects two arguments' );

  var outcome = _.entityIdentical( got,expected,iterator );

  _.assert( iterator.lastPath !== undefined );

  trd._outcomeReportCompare
  ({
    outcome : outcome,
    got : got,
    expected : expected,
    path : iterator.lastPath,
    usingExtraDetails : 1,
  });

  return outcome;
}

//

/**
 * Checks if test passes a specified condition by deep soft comparsing result of code execution( got )
 * with target( expected ). Uses recursive comparsion for objects,arrays and array-like objects. Two entities are equivalent if
 * difference between their values are less or equal to( eps ). Example: ( got - expected ) <= ( eps ).
 * If entity( got ) is equivalent to entity( expected ) test is passed successfully. After check function reports result of test
 * to the testing system. If test is failed function also outputs additional information.
 * Returns true if test is done successfully, otherwise false.
 *
 * @param {*} got - Source entity.
 * @param {*} expected - Target entity.
 * @param {*} [ eps=1e-5 ] - Maximal distance between two values.
 *
 * @example
 * function sometest( test )
 * {
 *  test.description = 'single number';
 *  var got = 0.5;
 *  var expected = 1;
 *  var eps = 0.5;
 *  test.equivalent( got, expected, eps );//returns true
 *
 *  test.description = 'single number';
 *  var got = 0.5;
 *  var expected = 2;
 *  var eps = 0.5;
 *  test.equivalent( got, expected, eps );//returns false
 * }
 * _.Tester.test( { name : 'test', tests : { sometest : sometest } } );
 *
 * @throws {Exception} If no arguments provided.
 * @method equivalent
 * @memberof wTestRoutineDescriptor
 */

function equivalent( got,expected,eps )
{
  var trd = this;
  var iterator = Object.create( null );

  if( eps === undefined )
  eps = trd.eps;

  iterator.eps = eps;

  _.assert( arguments.length === 2 || arguments.length === 3,'expects two or three arguments' );

  var outcome = _.entityEquivalent( got,expected,iterator );

  trd._outcomeReportCompare
  ({
    outcome : outcome,
    got : got,
    expected : expected,
    path : iterator.lastPath,
    usingExtraDetails : 1,
  });

  return outcome;
}

//

/**
 * Checks if test passes a specified condition by deep contain comparsing result of code execution( got )
 * with target( expected ). Uses recursive comparsion for objects,arrays and array-like objects.
 * If entity( got ) contains keys/values from entity( expected ) or they are indentical test is passed successfully. After check function reports result of test
 * to the testing system. If test is failed function also outputs additional information.
 * Returns true if test is done successfully, otherwise false.
 *
 * @param {*} got - Source entity.
 * @param {*} expected - Target entity.
 *
 * @example
 * function sometest( test )
 * {
 *  test.description = 'array';
 *  var got = [ 0, 1, 2 ];
 *  var expected = [ 0 ];
 *  test.contain( got, expected );//returns true
 *
 *  test.description = 'array';
 *  var got = [ 0, 1, 2 ];
 *  var expected = [ 4 ];
 *  test.contain( got, expected );//returns false
 * }
 * _.Tester.test( { name : 'test', tests : { sometest : sometest } } );
 *
 * @throws {Exception} If no arguments provided.
 * @method contain
 * @memberof wTestRoutineDescriptor
 */

function contain( got,expected )
{
  var trd = this;
  var iterator = Object.create( null );

  _.assert( arguments.length === 2,'expects two arguments' );

  var outcome = _.entityContain( got,expected,iterator );

  trd._outcomeReportCompare
  ({
    outcome : outcome,
    got : got,
    expected : expected,
    path : iterator.lastPath,
    usingExtraDetails : 1,
  });

  return outcome;
}

//

function _shouldDo( o )
{
  var trd = this;
  var second = 0;
  var reported = 0;
  var good = 1;
  var async = 0;
  var stack = _.diagnosticStack( 2,-1 );
  var logger = trd.logger;
  var err,arg;

  _.routineOptions( _shouldDo,o );
  _.assert( arguments.length === 1 );

  var acheck = trd.checkCurrent();
  trd._inroutineCon.choke();
  var con = new _.Consequence();

  /* */

  function begin( positive )
  {
    if( positive )
    _.assert( !reported );
    good = positive;

    if( reported || async )
    trd.checkRestore( acheck );

    logger.begin({ verbosity : positive ? -5 : -5+trd.importanceOfNegative });
    logger.begin({ connotation : positive ? 'positive' : 'negative' });
  }

  function end( positive,arg )
  {
    _.assert( arguments.length === 2 );

    logger.end({ verbosity : positive ? -5 : -5+trd.importanceOfNegative });
    logger.end({ connotation : positive ? 'positive' : 'negative' });

    if( reported )
    debugger;
    if( reported || async )
    trd.checkRestore();

    if( positive )
    con.give( null,arg );
    else
    con.give( arg,null );

    trd._inroutineCon.give();

    reported = 1;
  }

  /* */

  function reportAsync()
  {

    if( reported )
    return;

    if( o.ignoringError )
    {
      begin( 1 );

      trd._outcomeReportBoolean
      ({
        outcome : 1,
        msg : 'got single message',
        stack : stack,
      });

      end( 1,err ? err : arg );
    }
    else if( err )
    {
      begin( o.expectingAsyncError );

      trd.exceptionReport
      ({
        err : err,
        sync : 0,
        considering : 0,
        outcome : o.expectingAsyncError,
      });

      if( o.expectingAsyncError )
      trd._outcomeReportBoolean
      ({
        outcome : o.expectingAsyncError,
        msg : 'error thrown asynchronously as expected',
        stack : stack,
      });
      else
      trd._outcomeReportBoolean
      ({
        outcome : o.expectingAsyncError,
        msg : 'error thrown asynchronously, not expected',
        stack : stack,
      });

      if( o.expectingAsyncError )
      end( o.expectingAsyncError,err );
      else
      end( o.expectingAsyncError,err );
    }
    else
    {
      begin( !o.expectingAsyncError );

      var msg = 'error was not thrown asynchronously, but expected';
      if( o.expectingAsyncError )
      msg = 'error was thrown asynchronously as expected';
      else if( !o.expectingAsyncError && !o.expectingSyncError && good )
      msg = 'error was not thrown as expected';

      trd._outcomeReportBoolean
      ({
        outcome : !o.expectingAsyncError,
        msg : msg,
        stack : stack,
      });

      if( o.expectingAsyncError )
      end( !o.expectingAsyncError,_.err( msg ) );
      else
      end( !o.expectingAsyncError,arg );

    }

  }

  /* */

  if( !_.routineIs( o.routine ) )
  {

    begin( 0 );
    trd._outcomeReportBoolean
    ({
      outcome : 0,
      msg : 'expects Routine or Consequence, but got ' + _.strTypeOf( o.routine ),
      stack : stack,
    });
    end( 0,null );

    _.assert( !_.consequenceIs( o.routine ) )
    return con;
  }

  /* */

  var result;
  if( _.consequenceIs( o.routine ) )
  {
    result = o.routine;
  }
  else try
  {
    result = o.routine.call( this );
  }
  catch( _err )
  {

    err = _err;

    if( o.ignoringError )
    {
      begin( 1 );
      trd._outcomeReportBoolean
      ({
        outcome : 1,
        msg : 'error throwen synchronously, ignored',
        stack : stack,
      });
      end( 1,err );
      return con;
    }

    trd.exceptionReport
    ({
      err : err,
      sync : 1,
      considering : 0,
      outcome : o.expectingSyncError,
    });

    if( !o.ignoringError )
    {

      begin( o.expectingSyncError );

      if( o.expectingSyncError )
      {

        trd._outcomeReportBoolean
        ({
          outcome : o.expectingSyncError,
          msg : 'error thrown synchronously as expected',
          stack : stack,
        });

      }
      else
      {

        trd._outcomeReportBoolean
        ({
          outcome : o.expectingSyncError,
          msg : 'error thrown synchronously, what was not expected',
          stack : stack,
        });

      }

      end( o.expectingSyncError,err );

      return con;
    }

  }

  /* no error, but expected */

  if( !o.ignoringError && !o.expectingAsyncError && o.expectingSyncError && !err )
  {
    begin( 0 );

    var msg = 'error not thrown synchronously, but expected';

    trd._outcomeReportBoolean
    ({
      outcome : 0,
      msg : msg,
      stack : stack,
    });

    end( 0,_.err( msg ) );
    return con;
  }

  /* */

  if( _.consequenceIs( result ) )
  {

    trd.checkNext();
    async = 1;

    result.got( function( _err,_arg )
    {
      err = _err;
      arg = _arg;

      debugger;

      if( !o.ignoringError && !reported )
      if( err && !o.expectingAsyncError )
      reportAsync();
      else if( !err && o.expectingAsyncError )
      reportAsync();

      /* */

      if( !reported )
      if( !o.allowingMultipleMessages )
      _.timeOut( 10,function()
      {

        if( result.messagesGet().length )
        if( reported )
        {
          _.assert( !good );
        }
        else
        {

          begin( 0 );
          debugger;

          _.assert( !reported );

          trd._outcomeReportBoolean
          ({
            outcome : 0,
            msg : 'got more than one message',
            stack : stack,
          });

          end( 0,_.err( msg ) );
        }

        if( !reported )
        reportAsync();

      });

    });

    /* */

    if( !o.allowingMultipleMessages )
    result.doThen( function( err,data )
    {
      if( reported && !good )
      return;

      begin( 0 );

      second = 1;
      var msg = 'got more than one message';

      trd._outcomeReportBoolean
      ({
        outcome : 0,
        msg : msg,
        stack : stack,
      });

      end( 0,_.err( msg ) );
    });

  }
  else
  {

    if( ( o.expectingAsyncError || o.expectingSyncError ) && !err )
    {
      begin( 0 );

      var msg = 'error not thrown asynchronously, but expected';
      if( o.expectingAsyncError )
      msg = 'error not thrown, but expected either synchronosuly or asynchronously';

      trd._outcomeReportBoolean
      ({
        outcome : 0,
        msg : msg,
        stack : stack,
      });

      end( 0,_.err( msg ) );
    }
    else if( !o.expectingSyncError && !err )
    {
      begin( 1 );

      trd._outcomeReportBoolean
      ({
        outcome : 1,
        msg : 'no error thrown, as expected',
        stack : stack,
      });

      end( 1,result );
    }
    else
    {
      debugger;
      _.assert( 0,'unexpected' );
      trd.checkNext();
    }

  }

  /* */

  return con;
}

_shouldDo.defaults =
{
  routine : null,
  expectingSyncError : 1,
  expectingAsyncError : 1,
  ignoringError : 0,
  allowingMultipleMessages : 0,
}

//

function shouldThrowErrorAsync( routine )
{
  var trd = this;

  return trd._shouldDo
  ({
    routine : routine,
    expectingSyncError : 0,
    expectingAsyncError : 1,
  });

}

//

function shouldThrowErrorSync( routine )
{
  var trd = this;

  return trd._shouldDo
  ({
    routine : routine,
    expectingSyncError : 1,
    expectingAsyncError : 0,
  });

}

//

/**
 * Error throwing test. Expects one argument( routine ) - function to call or wConsequence instance.
 * If argument is a function runs it and checks if it throws an error. Otherwise if argument is a consequence  checks if it has a error message.
 * If its not a error or consequence contains more then one message test is failed. After check function reports result of test to the testing system.
 * If test is failed function also outputs additional information. Returns wConsequence instance to perform next call in chain.
 *
 * @param {Function|wConsequence} routine - Funtion to call or wConsequence instance.
 *
 * @example
 * function sometest( test )
 * {
 *  test.description = 'shouldThrowErrorSync';
 *  test.shouldThrowErrorSync( function()
 *  {
 *    throw _.err( 'Error' );
 *  });
 * }
 * _.Tester.test( { name : 'test', tests : { sometest : sometest } } );
 *
 * @example
 * function sometest( test )
 * {
 *  var consequence = new _.Consequence().give();
 *  consequence
 *  .ifNoErrorThen( function()
 *  {
 *    test.description = 'shouldThrowErrorSync';
 *    var con = new wConsequence( )
 *    .error( _.err() ); //wConsequence instance with error message
 *    return test.shouldThrowErrorSync( con );//test passes
 *  })
 *  .ifNoErrorThen( function()
 *  {
 *    test.description = 'shouldThrowError2';
 *    var con = new wConsequence( )
 *    .error( _.err() )
 *    .error( _.err() ); //wConsequence instance with two error messages
 *    return test.shouldThrowErrorSync( con ); //test fails
 *  });
 *
 *  return consequence;
 * }
 * _.Tester.test( { name : 'test', tests : { sometest : sometest } } );
 *
 * @throws {Exception} If no arguments provided.
 * @throws {Exception} If passed argument is not a Routine.
 * @method shouldThrowErrorSync
 * @memberof wTestRoutineDescriptor
 */

function shouldThrowError( routine )
{
  var trd = this;

  return trd._shouldDo
  ({
    routine : routine,
    expectingSyncError : 1,
    expectingAsyncError : 1,
  });

}

//

function mustNotThrowError( routine )
{
  var trd = this;

  return trd._shouldDo
  ({
    routine : routine,
    ignoringError : 0,
    expectingSyncError : 0,
    expectingAsyncError : 0,
  });

}

//

function shouldMessageOnlyOnce( routine )
{
  var trd = this;

  return trd._shouldDo
  ({
    routine : routine,
    ignoringError : 1,
    expectingSyncError : 0,
    expectingAsyncError : 0,
  });

}

// --
// output
// --

function _outcomeConsider( outcome )
{
  var trd = this;

  _.assert( arguments.length === 1 );
  _.assert( trd.constructor === Self );

  if( outcome )
  {
    trd.report.testCheckPasses += 1;
    trd.report.testCheckPassesOfTestCase += 1;
  }
  else
  {
    trd.report.testCheckFails += 1;
    trd.report.testCheckFailsOfTestCase += 1;
    // console.log( 'wTestRoutineDescriptor.testCheckFailsOfTestCase += 1' )
    // debugger;
  }

  trd.suit._outcomeConsider( outcome );

  trd.checkNext();

}

//

function _exceptionConsider( err )
{
  var trd = this;

  _.assert( arguments.length === 1 );
  _.assert( trd.constructor === Self );

  trd.report.errorsArray.push( err );
  trd.suit._exceptionConsider( err );

}

//

function _outcomeReportAct( outcome )
{
  var trd = this;

  trd._outcomeConsider( outcome );

  if( !_.Tester._canContinue() )
  {
    if( trd._returnCon )
    trd._returnCon.cancel();
    _.Tester.cancel( _.err( 'Too many fails',_.Tester.settings.fails, '<=', trd.report.testCheckFails ) );
  }

  _.assert( arguments.length === 1 );

}

//

function _outcomeReport( o )
{
  var trd = this;
  var logger = trd.logger;
  var sourceCode = '';

  _.routineOptions( _outcomeReport,o );
  _.assert( arguments.length === 1 );

  /* */

  function sourceCodeGet()
  {
    var code;
    if( trd.usingSourceCode && o.usingSourceCode )
    {
      var _location = o.stack ? _.diagnosticLocation({ stack : o.stack }) : _.diagnosticLocation({ level : 4 });
      var _code = _.diagnosticCode
      ({
        location : _location,
        selectMode : 'end',
        numberOfLines : 5,
      });
      if( _code )
      code = '\n' + _code;
      else
      code = '\n' + _location.full;
    }

    if( code )
    code = ' #ignoreDirectives : 1# ' + code + ' #ignoreDirectives : 0# ';

    return code;
  }

  /* */

  logger.begin({ verbosity : o.verbosity });

  if( o.considering )
  {
    logger.begin({ 'check' : trd.description || trd._checkIndex });
    logger.begin({ 'checkIndex' : trd._checkIndex });
  }

  if( o.considering )
  trd._outcomeReportAct( o.outcome );

  if( o.outcome )
  {
    logger.begin({ verbosity : o.verbosity });
    logger.up();
    logger.begin({ 'connotation' : 'positive' });

    logger.begin({ verbosity : o.verbosity-1 });

    if( o.details )
    logger.begin( 'details' ).log( o.details ).end( 'details' );

    sourceCode = sourceCodeGet();
    if( sourceCode )
    logger.begin( 'sourceCode' ).log( sourceCode ).end( 'sourceCode' );

    logger.end({ verbosity : o.verbosity-1 });

    logger.begin( 'message' ).logDown( o.msg ).end( 'message' );

    logger.end({ 'connotation' : 'positive' });
    if( logger.verbosityReserve() > 1 )
    logger.log();

    logger.end({ verbosity : o.verbosity });
  }
  else
  {

    sourceCode = sourceCodeGet();

    logger.begin({ verbosity : o.verbosity+trd.importanceOfNegative });

    logger.up();
    if( logger.verbosityReserve() > 1 )
    logger.log();
    logger.begin({ 'connotation' : 'negative' });

    logger.begin({ verbosity : o.verbosity-1+trd.importanceOfNegative });

    if( o.details )
    logger.begin( 'details' ).log( o.details ).end( 'details' );

    if( sourceCode )
    logger.begin( 'sourceCode' ).log( sourceCode ).end( 'sourceCode' );

    logger.end({ verbosity : o.verbosity-1+trd.importanceOfNegative });

    logger.begin( 'message' ).logDown( o.msg ).end( 'message' );

    logger.end({ 'connotation' : 'negative' });
    if( logger.verbosityReserve() > 1 )
    logger.log();

    logger.end({ verbosity : o.verbosity+trd.importanceOfNegative });

  }

  if( o.considering )
  logger.end( 'check','checkIndex' );
  logger.end({ verbosity : o.verbosity });

}

_outcomeReport.defaults =
{
  outcome : null,
  msg : null,
  details : null,
  stack : null,
  usingSourceCode : 1,
  considering : 1,
  verbosity : -4,
}

//

function _outcomeReportBoolean( o )
{
  var trd = this;

  _.assert( arguments.length === 1 );
  _.routineOptions( _outcomeReportBoolean,o );

  o.msg = trd._reportTestCaseTextMake
  ({
    outcome : o.outcome,
    msg : o.msg,
    usingDescription : o.usingDescription,
  });

  trd._outcomeReport
  ({
    outcome : o.outcome,
    msg : o.msg,
    details : '',
    stack : o.stack,
    usingSourceCode : o.usingSourceCode,
  });

}

_outcomeReportBoolean.defaults =
{
  outcome : null,
  msg : null,
  stack : null,
  usingSourceCode : 1,
  usingDescription : 1,
}

//

function _outcomeReportCompare( o )
{
  var trd = this;

  var got = o.got;
  var expected = o.expected;

  _.assert( trd._testRoutineDescriptorIs );
  _.assert( arguments.length === 1 );
  _.routineOptions( _outcomeReportCompare,o );

  o.got = got;
  o.expected = expected;

  /**/

  function msgExpectedGot()
  {
    return '' +
    'got :\n' + _.toStr( o.got,{ stringWrapper : '\'' } ) + '\n' +
    'expected :\n' + _.toStr( o.expected,{ stringWrapper : '\'' } ) +
    '';
  }

  /**/

  if( o.outcome )
  {

    var details = msgExpectedGot();
    var msg = trd._reportTestCaseTextMake({ outcome : 1 });

    trd._outcomeReport
    ({
      outcome : o.outcome,
      msg : msg,
      details : details,
    });

  }
  else
  {

    var details = msgExpectedGot();

    if( o.usingExtraDetails )
    if( !_.primitiveIs( o.got ) && !_.primitiveIs( o.expected ) && o.path )
    details +=
    (
      '\nat : ' + o.path +
      '\ngot :\n' + _.toStr( _.entitySelect( o.got,o.path ) ) +
      '\nexpected :\n' + _.toStr( _.entitySelect( o.expected,o.path ) ) +
      ''
    );

    if( o.usingExtraDetails )
    if( _.strIs( o.expected ) && _.strIs( o.got ) )
    details += '\ndifference :\n' + _.strDifference( o.expected,o.got );

    var msg = trd._reportTestCaseTextMake({ outcome : 0 });

    trd._outcomeReport
    ({
      outcome : o.outcome,
      msg : msg,
      details : details,
    });

    if( trd.debug )
    debugger;
  }

}

_outcomeReportCompare.defaults =
{
  got : null,
  expected : null,
  outcome : null,
  path : null,
  usingExtraDetails : 1,
}

//

function exceptionReport( o )
{
  var trd = this;

  _.routineOptions( exceptionReport,o );
  _.assert( arguments.length === 1 );

  o.stack = o.stack || o.err.stack;

  if( trd.onError )
  debugger;
  if( trd.onError )
  trd.onError.call( trd,o );

  var msg = null;
  if( o.considering )
  {
    msg = trd._reportTestCaseTextMake({ outcome : null }) + ' ... failed throwing error';
  }
  else
  {
    msg = 'Error throwen'
  }

  if( o.sync !== null )
  msg += ( o.sync ? ' synchronously' : ' asynchronously' );

  var err = _.errAttend( o.err );
  var details = err.toString();

  if( o.considering )
  trd._exceptionConsider( err );

  trd._outcomeReport
  ({
    outcome : o.outcome,
    msg : msg,
    details : details,
    stack : o.stack,
    usingSourceCode : o.usingSourceCode,
    considering : o.considering,
  });

}

exceptionReport.defaults =
{
  err : null,
  stack : null,
  usingSourceCode : 0,
  considering : 1,
  outcome : 0,
  sync : null,
}

// --
// report
// --

function _reportForm()
{
  var self = this;

  _.assert( !self.report );
  var report = self.report = Object.create( null );

  report.errorsArray = [];

  report.testCheckPasses = 0;
  report.testCheckFails = 0;

  report.testCheckPassesOfTestCase = 0;
  report.testCheckFailsOfTestCase = 0;

  report.testCasePasses = 0;
  report.testCaseFails = 0;

  Object.preventExtensions( report );

}

//

function _reportIsPositive()
{
  var self = this;

  if( self.report.testCheckFails !== 0 )
  return false;

  if( !( self.report.testCheckPasses > 0 ) )
  return false;

  if( self.report.errorsArray.length )
  return false;

  return true;
}

//

function _reportTestCaseTextMake( o )
{
  var trd = this;

  o = _.routineOptions( _reportTestCaseTextMake,o );
  _.assert( arguments.length === 1 );
  _.assert( o.outcome === null || _.boolLike( o.outcome ) );
  _.assert( o.msg === null || _.strIs( o.msg ) );
  _.assert( trd._testRoutineDescriptorIs );
  _.assert( trd._checkIndex >= 0 );
  _.assert( _.strIsNotEmpty( trd.routine.name ),'test routine descriptor should have name' );

  var name = trd.routine.name;
  if( trd.description && o.usingDescription )
  name += ' : ' + trd.description;

  var result = '' +
    'Test check' + ' ( ' + name + ' )' +
    ' # ' + trd._checkIndex
  ;

  if( o.msg )
  result += ' : ' + o.msg;

  if( o.outcome !== null )
  {
    if( o.outcome )
    result += ' ... ok';
    else
    result += ' ... failed';
  }

  return result;
}

_reportTestCaseTextMake.defaults =
{
  outcome : null,
  msg : null,
  usingDescription : 1,
}

// --
// relationships
// --

var descriptionSymbol = Symbol.for( 'description' );

var Composes =
{
  name : null,
  description : null,
}

var Aggregates =
{
}

var Associates =
{
  suit : null,
  routine : null,
}

var Restricts =
{

  _checkIndex : 1,
  _testRoutineDescriptorIs : 1,

  // _cancelCon : null,
  _returnCon : null,

  report : null,
  _checksStack : [],

}

var Statics =
{
}

var Events =
{
}

var Forbids =
{
  _storedStates : '_storedStates',
  _currentRoutineFails : '_currentRoutineFails',
  _currentRoutinePasses : '_currentRoutinePasses',
}

var Accessors =
{
  description : 'description',
  will : 'will',
}

// --
// prototype
// --

var Proto =
{

  // inter

  init : init,


  // run

  _testRoutineBegin : _testRoutineBegin,
  _testRoutineEnd : _testRoutineEnd,
  _testRoutineHandleReturn : _testRoutineHandleReturn,


  // case

  _descriptionGet : _descriptionGet,
  _descriptionSet : _descriptionSet,
  _willGet : _descriptionGet,
  _willSet : _descriptionSet,

  testCaseNext : testCaseNext,
  _testCaseConsider : _testCaseConsider,


  // check

  checkCurrent : checkCurrent,
  checkNext : checkNext,
  checkStore : checkStore,
  checkRestore : checkRestore,


  // equalizer

  shouldBe : shouldBe,
  shouldBeNotError : shouldBeNotError,
  isNotIdentical : isNotIdentical,
  identical : identical,
  equivalent : equivalent,
  contain : contain,

  _shouldDo : _shouldDo,

  shouldThrowErrorSync : shouldThrowErrorSync,
  shouldThrowErrorAsync : shouldThrowErrorAsync,
  shouldThrowError : shouldThrowError,
  mustNotThrowError : mustNotThrowError,
  shouldMessageOnlyOnce : shouldMessageOnlyOnce,


  // output

  _outcomeConsider : _outcomeConsider,
  _exceptionConsider : _exceptionConsider,

  _outcomeReportAct : _outcomeReportAct,
  _outcomeReport : _outcomeReport,
  _outcomeReportBoolean : _outcomeReportBoolean,
  _outcomeReportCompare : _outcomeReportCompare,

  exceptionReport : exceptionReport,


  // report

  _reportForm : _reportForm,
  _reportIsPositive : _reportIsPositive,
  _reportTestCaseTextMake : _reportTestCaseTextMake,


  // relationships

  strictEventHandling : 0,
  constructor : Self,
  Composes : Composes,
  Aggregates : Aggregates,
  Associates : Associates,
  Restricts : Restricts,
  Statics : Statics,
  Events : Events,

}

//

_.classMake
({
  cls : Self,
  parent : Parent,
  extend : Proto,
});

_.Copyable.mixin( Self );

_.accessorForbid( Self.prototype,Forbids );
_.accessor( Self.prototype,Accessors );

// export

if( typeof module !== 'undefined' )
module[ 'exports' ] = Self;
_[ Self.nameShort ] = Self;

})();
