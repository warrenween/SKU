(*
  Copyright 2016, Skuchain-Curiosity library

  Home: https://github.com/andrea-magni/Skuchain
*)
unit Server.Forms.Main;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics,
  Controls, Forms, Dialogs, ActnList, StdCtrls, ExtCtrls

  , Diagnostics
  , IdContext

  , Skuchain.Core.Engine
  , Skuchain.http.Server.Indy


  , Skuchain.Core.Application, System.Actions
  {$ifdef DelphiXE4_UP}
  , System.Actions
  {$endif}

  {$IFDEF MSWINDOWS}
  , Skuchain.mORMotJWT.Token
  {$ELSE}
  , Skuchain.JOSEJWT.Token
  {$ENDIF}

  ;

type
  TMainForm = class(TForm)
    TopPanel: TPanel;
    StartButton: TButton;
    StopButton: TButton;
    MainActionList: TActionList;
    StartServerAction: TAction;
    StopServerAction: TAction;
    PortNumberEdit: TEdit;
    Label1: TLabel;
    procedure StartServerActionExecute(Sender: TObject);
    procedure StartServerActionUpdate(Sender: TObject);
    procedure StopServerActionExecute(Sender: TObject);
    procedure StopServerActionUpdate(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormDestroy(Sender: TObject);
    procedure PortNumberEditChange(Sender: TObject);
  private
    FServer: TSkuchainhttpServerIndy;
    FEngine: TSkuchainEngine;
  public
  end;

var
  MainForm: TMainForm;

implementation

{$R *.dfm}

uses
  Web.HttpApp
  , Skuchain.Core.URL
  , Skuchain.Core.MessageBodyWriter, Skuchain.Core.MessageBodyWriters
  , Skuchain.Core.MessageBodyReader, Skuchain.Core.MessageBodyReaders
  , Skuchain.Utils.Parameters.IniFile
  ;

procedure TMainForm.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  StopServerAction.Execute;
end;

procedure TMainForm.FormCreate(Sender: TObject);
begin
  // Skuchain-Curiosity Engine
  FEngine := TSkuchainEngine.Create;
  try
    FEngine.Parameters.LoadFromIniFile;
    FEngine.AddApplication('DefaultApp', '/default', ['Server.*']);
    PortNumberEdit.Text := FEngine.Port.ToString;

    // skip favicon requests (browser)
    FEngine.OnBeforeHandleRequest :=
      function (AEngine: TSkuchainEngine; AURL: TSkuchainURL;
        ARequest: TWebRequest; AResponse: TWebResponse; var Handled: Boolean
      ): Boolean
      begin
        Result := True;
        if SameText(AURL.Document, 'favicon.ico') then
        begin
          Result := False;
          Handled := True;
        end
      end;

    StartServerAction.Execute;
  except
    FreeAndNil(FEngine);
    raise;
  end;
end;

procedure TMainForm.FormDestroy(Sender: TObject);
begin
  FreeAndNil(FEngine);
end;

procedure TMainForm.PortNumberEditChange(Sender: TObject);
begin
  FEngine.Port := StrToInt(PortNumberEdit.Text);
end;

procedure TMainForm.StartServerActionExecute(Sender: TObject);
begin
  // http server implementation
  FServer := TSkuchainhttpServerIndy.Create(FEngine);
  try
    FServer.DefaultPort := FEngine.Port;
    FServer.Active := True;
  except
    FServer.Free;
    raise;
  end;
end;

procedure TMainForm.StartServerActionUpdate(Sender: TObject);
begin
  StartServerAction.Enabled := (FServer = nil) or (FServer.Active = False);
end;

procedure TMainForm.StopServerActionExecute(Sender: TObject);
begin
  FServer.Active := False;
  FreeAndNil(FServer);
end;

procedure TMainForm.StopServerActionUpdate(Sender: TObject);
begin
  StopServerAction.Enabled := Assigned(FServer) and (FServer.Active = True);
end;

end.
