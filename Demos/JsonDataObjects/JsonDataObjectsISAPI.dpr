(*
  Copyright 2016, Skuchain-Curiosity - REST Library

  Home: https://github.com/andrea-magni/Skuchain
*)
library JsonDataObjectsISAPI;

uses
  Winapi.ActiveX,
  System.Win.ComObj,
  Web.WebBroker,
  Web.Win.ISAPIApp,
  Web.Win.ISAPIThreadPool,
  Server.Ignition in 'Server.Ignition.pas',
  Server.Resources in 'Server.Resources.pas',
  Server.WebModule in 'Server.WebModule.pas' {ServerWebModule: TWebModule};

{$R *.res}

exports
  GetExtensionVersion,
  HttpExtensionProc,
  TerminateExtension;

begin
  CoInitFlags := COINIT_MULTITHREADED;
  Application.Initialize;
  Application.WebModuleClass := WebModuleClass;
  Application.Run;
end.
