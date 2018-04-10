(*
  Copyright 2016, Skuchain-Curiosity library

  Home: https://github.com/andrea-magni/Skuchain
*)


interface

uses
  Classes, SysUtils

  , Skuchain.Core.Registry
  , Skuchain.Core.Attributes
  , Skuchain.Core.MediaType
  , Skuchain.Core.JSON
  , Skuchain.Core.MessageBodyWriters
  , Skuchain.Core.MessageBodyReaders
  ;

type
  [Path('/helloworld'), Produces(TMediaType.TEXT_PLAIN)]
  THelloWorldResource = class
  private
  protected
  public
    [GET]
    function HelloWorld(): string;

    // Subresource and parameter examples
    [GET, Path('/echostring/{AString}')]
    function EchoString([PathParam] AString: string): string;

    [GET, Path('/reversestring/{AString}')]
    [Produces(TMediaType.TEXT_PLAIN)]
    function ReverseString([PathParam] AString: string): string;

    [GET, Path('/params/{AOne}/{ATwo}')]
    [Produces(TMediaType.TEXT_PLAIN)]
    function Params([PathParam] AOne: string; [PathParam] ATwo: string): string;

    [GET, Path('/sum/{First}/{Second}')]
    function Sum([PathParam] First: Integer; [PathParam] Second: Integer): Integer;

    [POST, Path('/countitems'), Produces(TMediaType.APPLICATION_JSON)]
    function CountItems([BodyParam] Data: TJSONArray): TJSONObject;

    [GET, Path('/slow/{ms}/{error}')]
    function Slow([PathParam] ms: Integer; [PathParam] error: Integer): string;

  end;

implementation

uses
  StrUtils
  , Skuchain.Core.Exceptions
  ;

{ THelloWorldResource }

function THelloWorldResource.CountItems(Data: TJSONArray): TJSONObject;
begin
  Result := TJSONObject.Create;
  if Assigned(Data) then
    Result.WriteIntegerValue('count', Data.Count)
  else
    Result.WriteStringValue('error', 'no input')
end;

function THelloWorldResource.EchoString(AString: string): string;
begin
  Result := AString;
end;

function THelloWorldResource.HelloWorld(): string;
begin
  Result := 'Hello, World!';
end;

function THelloWorldResource.Params(AOne, ATwo: string): string;
begin
  Result := 'One: ' + AOne + sLineBreak + 'Two: ' + ATwo;
end;

function THelloWorldResource.ReverseString(AString: string): string;
begin
  Result := StrUtils.ReverseString(AString);
end;


function THelloWorldResource.Slow(ms: Integer; error: Integer): string;
begin
  Sleep(ms);
  Result := 'Waited ' + IntToStr(ms) + ' ms';
  if error > 0 then
    raise ESkuchainHttpException.Create('Ho fatto errore come richiesto', 501);
end;

function THelloWorldResource.Sum(First, Second: Integer): Integer;
begin
  Result := First + Second;
end;

initialization
  TSkuchainResourceRegistry.Instance.RegisterResource<THelloWorldResource>;

end.