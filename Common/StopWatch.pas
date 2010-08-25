(*******************************************************************************
 *
 * Description:
 * This unit implements a stopwatch class.
 *
 * Author:
 * Simon Kallweit, Kallweit Electronics
 *
 * ToDo:
 * Nothing
 *
 * History:
 * 29.08.2003 - SK - Initial release
 *
 ******************************************************************************)

unit StopWatch;

interface

type
  (**
   * This class implements a stopwatch. With the Start() method the measurement
   * is started. With the ElapsedTime property the elapsed time can be queried.
   *)
  TStopWatch = class(TObject)
    private
      CounterFreq : Int64;
      StartTime : Int64;

    public
      constructor Create;
      destructor Destroy; override;

      procedure Start;

    private
      function  GetElapsedTime : Integer;

    public
      property  ElapsedTime : Integer read GetElapsedTime;

  end;

implementation

uses
  Windows;

(**
 * Description:
 * Standard constructor.
 *)
constructor TStopWatch.Create;
begin
  inherited Create;

  QueryPerformanceFrequency(CounterFreq);
end;

(**
 * Description:
 * Standard destructor.
 *)
destructor TStopWatch.Destroy;
begin
  inherited Destroy;
end;

(**
 * Description:
 * This method is used to (re)start the stopwatch.
 *)
procedure TStopWatch.Start;
begin
  QueryPerformanceCounter(StartTime);
end;

(**
 * Description:
 * This method is used to measure the elapsed time in milliseconds.
 *
 * Returns:
 * Returns the elapsed time since the last call to the Start() method in
 * milliseconds.
 *)
function  TStopWatch.GetElapsedTime : Integer;
var
  EndTime : Int64;
begin
  QueryPerformanceCounter(EndTime);
  Result := Round((EndTime - StartTime) / CounterFreq * 1000);
end;

end.

