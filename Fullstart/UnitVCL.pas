unit UnitVCL;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls;

type
  TVCLForm = class(TForm)
    Button: TButton;
    procedure ButtonClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  protected
    procedure WndProc(var Message: TMessage); override;
  public
    { Public declarations }
  end;

const
  CLogout = 'gmslogout';
  CLogin = 'gmslogin';

var
  VLogout, VLogIn: Cardinal;

var
  VCLForm: TVCLForm;

implementation

uses UnitMain;

{$R *.dfm}


procedure TVclForm.WndProc(var Message: TMessage);
begin
  if message.Msg = VLogout then
  begin
    MainForm.DoLogOut;
  end
  else
    if message.Msg = VLogin then
    begin
      MainForm.FUsernumber := InttoStr(message.WParam);
      MainForm.DoLogIn(MainForm.FUsernumber); // user_number of Table Users
    end;
  inherited WndProc(message);
end;

procedure TVCLForm.ButtonClick(Sender: TObject);
var
  ARecipient: DWORD;
  AMsgValue: WPARAM;
begin
  AMsgValue := 0;
  ARecipient := BSM_APPLICATIONS;
  BroadCastSystemMessage(BSF_POSTMESSAGE,@ARecipient, VLogout, AMsgValue, 0);
end;

procedure TVCLForm.FormCreate(Sender: TObject);
begin
  VLogout := RegisterWindowMessage(CLogout);
  VLogin := RegisterWindowMessage(CLogin);
  Self.Hide;
end;

end.
