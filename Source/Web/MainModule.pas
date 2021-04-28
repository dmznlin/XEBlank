{*******************************************************************************
  ����: dmzn@163.com 2020-06-23
  ����: �û�ȫ����ģ��
*******************************************************************************}
unit MainModule;

interface

uses
  SysUtils, Classes, Controls, uniGUIMainModule, UniFSToast, UniFSConfirm;

type
  TButtonClickType = (ctYes, ctNo, ctCancel);
  TButtonClickEvent = reference to procedure(const nType: TButtonClickType);
  TButtonClickInputEvent = reference to procedure(const nType: TButtonClickType;
    const nText: string);
  //xxxxx

  TUniMainModule = class(TUniGUIMainModule)
    procedure UniGUIMainModuleCreate(Sender: TObject);
  private
    { Private declarations }
    FAdminLastLogin: Cardinal;
    {*����Ա����¼*}
  public
    FSToast1: TUniFSToast;
    FSConfirm1: TUniFSConfirm;
    FSTheme1: UniFSConfirm.TTheme;
    {*��Ϣ�����*}
    procedure VerifyAdministrator(const nEvent: TButtonClickInputEvent);
    {*��֤���*}
    procedure ShowMsg(const nHint: string; const nError: Boolean = False;
      nTitle: string = '');
    {*��Ϣ��ʾ��*}
    procedure ShowDlg(const nMsg: string; const nError: Boolean = False;
      const nEvent: TButtonClickEvent = nil; nTitle: string = '');
    procedure QueryDlg(const nMsg: string; const nEvent: TButtonClickEvent = nil;
      const nMask: string = ''; nTitle: string = '');
    procedure InputDlg(const nMsg,nTitle: string;
      const nEvent: TButtonClickInputEvent; const nBlank: string = '';
      const nSize: Integer = 0; const nPwd: Boolean = False);
    {*��Ϣ��ʾ��*}
  end;

function UniMainModule: TUniMainModule;

implementation

{$R *.dfm}

uses
  UniGUIVars, ServerModule, uniGUIApplication, ULibFun, UGoogleOTP,
  USysDB, USysConst;

function UniMainModule: TUniMainModule;
begin
  Result := TUniMainModule(UniApplication.UniMainModule)
end;

procedure TUniMainModule.UniGUIMainModuleCreate(Sender: TObject);
begin
  FAdminLastLogin := 0;
  FSTheme1 := TTheme.bootstrap;
  Background.Url := gSystem.FImages.FBgMain;
  LoginBackground.Url := gSystem.FImages.FBgLogin;
end;

//Date: 2021-04-28
//Desc: ��֤��ǰ�Ƿ����Ա
procedure TUniMainModule.VerifyAdministrator(const nEvent: TButtonClickInputEvent);
begin
  if TDateTimeHelper.GetTickCountDiff(FAdminLastLogin) < 10 * 60 * 1000 then
  begin
    nEvent(ctYes, '');
    Exit;
  end; //10 min valid

  InputDlg('���������Ա��̬����', '��֤',
    procedure(const nType: TButtonClickType; const nText: string)
    begin
      if (nType = ctYes) and TStringHelper.IsNumber(nText, False) then
       with TGoogleOTP do
        if Validate(EncodeBase32(sDefaultAdminKey), StrToInt(nText)) then
        begin
          FAdminLastLogin := TDateTimeHelper.GetTickCount();
          nEvent(ctYes, nText);
          Exit;
        end;

      nEvent(ctNo, nText);
      //verify failure
    end);
end;

//Date: 2021-04-20
//Parm: ��Ϣ����;����
//Desc: ������Ϣ��
procedure TUniMainModule.ShowMsg(const nHint: string; const nError: Boolean;
  nTitle: string);
begin
  with FSToast1 do
  begin
    Close := True;
    TimeOut := 5000;

    if nError then
    begin
      if nTitle = '' then
        nTitle := sError;
      Error(nTitle, nHint, bottomRight);
    end else
    begin
      if nTitle = '' then
        nTitle := sHint;
      Info(nTitle, nHint, bottomRight);
    end;
  end;
end;

//Date: 2021-04-20
//Parm: ��Ϣ;����
//Desc: ��ʾ�Ի���
procedure TUniMainModule.ShowDlg(const nMsg: string; const nError: Boolean;
  const nEvent: TButtonClickEvent; nTitle: string);
begin
  with FSConfirm1 do
  begin
    ButtonTextConfirm  := 'ȷ��';
    ButtonTextCancel   := 'ȡ��';

    if nError then
    begin
      if nTitle = '' then
        nTitle := sError;
      //xxxxx

      Alert(nTitle, nMsg, 'fa fa-ban', red, FSTheme1,
        procedure(nButton: TConfirmButton)
        begin
          if Assigned(nEvent) then
          begin
            case nButton of
             Ok: nEvent(ctYes);
            end;
          end;
        end);
    end else
    begin
      if nTitle = '' then
        nTitle := sHint;
      //xxxxx

      Alert(nTitle, nMsg, 'fa fa-info', blue, FSTheme1,
        procedure(nButton: TConfirmButton)
        begin
          if Assigned(nEvent) then
          begin
            case nButton of
             Ok: nEvent(ctYes);
            end;
          end;
        end);
    end;
  end;
end;

//Date: 2021-04-20
//Parm: ��Ϣ;����
//Desc: ѯ�ʶԻ���
procedure TUniMainModule.QueryDlg(const nMsg: string;
  const nEvent: TButtonClickEvent; const nMask: string; nTitle: string);
begin
  with FSConfirm1 do
  begin
    TypeColor := blue;
    Theme     := FSTheme1;
    RTL       := False;
    CloseIcon := False;

    ButtonTextConfirm  := '��';
    ButtonTextCancel   := '��';
    ScreenMask.Enabled := Trim(nMask) <> '';

    if ScreenMask.Enabled then
      ScreenMask.Text := nMask;
    //xxxxx

    if nTitle = '' then
      nTitle := sAsk;
    //xxxxx

    Question(nTitle, nMsg, 'fa fa-question-circle',
      procedure(nButton: TConfirmButton) //�����ص�����
      begin
        if Assigned(nEvent) then
        begin
          case nButton of
           Yes: nEvent(ctYes);
           No:  nEvent(ctNo);
          end;
        end;
      end);
  end;
end;

//Date: 2021-04-20
//Parm: ��Ϣ;����;�¼�;������д;��С;�Ƿ�����
//Desc: ��ʾ�����
procedure TUniMainModule.InputDlg(const nMsg,nTitle: string;
  const nEvent: TButtonClickInputEvent; const nBlank: string;
  const nSize: Integer; const nPwd: Boolean);
begin
  with FSConfirm1 do
  begin
    ButtonTextConfirm  := 'ȷ��';
    ButtonTextCancel   := 'ȡ��';
    PromptType.RequiredField := nBlank <> '';
    PromptType.TextRequiredField := nBlank;

    if nPwd then
         PromptType.TypePrompt := password
    else PromptType.TypePrompt := text;

    Prompt(nTitle, nMsg, 'fa fa-keyboard-o', green, FSTheme1,
      procedure(nButton: TConfirmButton; nResult: string)
      begin
        if Assigned(nEvent) then
        begin
          if (nSize > 0) and (Length(nResult) > nSize) then
            nResult := Copy(nResult, 1, nSize);
          //xxxxx

          case nButton of
           Yes: nEvent(ctYes, nResult);
           No:  nEvent(ctNo, nResult);
          end;
        end;
      end
    );
  end;
end;

initialization
  RegisterMainModuleClass(TUniMainModule);
end.
