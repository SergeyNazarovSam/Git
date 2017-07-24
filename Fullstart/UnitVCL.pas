unit UnitVCL;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls;

type
  TVCLForm = class(TForm)
    Button1: TButton;
    procedure Button1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  protected
     procedure WndProc(var Message: TMessage); override;

  public
    { Public declarations }
  end;

  const
szLogOut = 'gmslogout';
szLogin = 'gmslogin';

var
wLogout, wLogIn: Cardinal;

var
  VCLForm: TVCLForm;

implementation

{$R *.dfm}
uses UnitMain;

procedure TVclForm.WndProc(var Message: TMessage);
begin
  if Message.Msg = wLogOut then
  begin
    MainForm.DoLogOut;
  end else
    if Message.Msg = wLogIn then
    begin
      MainForm.FUsernumber := InttoStr(Message.wParam);
      MainForm.DoLogIn(MainForm.FUsernumber); //user_number of Table Users
    end;
  inherited WndProc(Message);
end;

procedure TVCLForm.Button1Click(Sender: TObject);
var dwRecipient: DWord;
wMsgValue: WPARAM;
begin
//SendLogout to Application, wenn nicht von jemand anderen kommt
//if Sender <> nil then
begin
wMsgValue := 0;
dwRecipient := BSM_APPLICATIONS;
BroadCastSystemMessage(BSF_POSTMESSAGE, @dwRecipient,
wLogout, wMsgVAlue, 0);
end;
end;

procedure TVCLForm.FormCreate(Sender: TObject);
begin
  wLogout := RegisterWindowMessage(szLogout);
  wLogin := RegisterWindowMessage(szLogin);
  self.hide;
end;

end.
