{*******************************************************************************
  ����: dmzn@163.com 2020-06-23
  ����: �û�ȫ����ģ��
*******************************************************************************}
unit MainModule;

interface

uses
  SysUtils, Classes, Controls, uniGUITypes, uniGUIDialogs, uniGUIForm,
  uniGUIMainModule, UniFSToast, UniFSConfirm, uniImageList, System.ImageList,
  Vcl.ImgList, uniGUIBaseClasses, uniGUIClasses;

type
  TButtonClickType = (ctYes, ctNo, ctCancel);
  TButtonClickEvent = reference to procedure(const nType: TButtonClickType);
  TButtonClickInputEvent = reference to procedure(const nType: TButtonClickType;
    const nText: string);
  //xxxxx

  TUniMainModule = class(TUniGUIMainModule)
    SmallImages: TUniNativeImageList;
    MidImage: TUniNativeImageList;
    BigImages: TUniNativeImageList;
    ImagesAdapter1: TUniImageListAdapter;
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
    procedure VerifyAdministrator(const nPwd: string;
      const nCall: TButtonClickInputEvent;
      const nButton: TButtonClickType = ctYes); overload;
    procedure VerifyAdministrator(const nEvent: TButtonClickInputEvent;
      const nCaller: TUniBaseForm = nil); overload;
    {*��֤���*}
    procedure ShowMsg(const nHint: string; const nError: Boolean = False;
      nTitle: string = '');
    {*��Ϣ��ʾ��*}
    procedure ShowDlg(const nMsg: string; const nError: Boolean = False;
      const nCaller: TUniBaseForm = nil;
      const nEvent: TButtonClickEvent = nil; nTitle: string = '');
    procedure QueryDlg(const nMsg: string;
      const nEvent: TButtonClickEvent = nil;
      const nCaller: TUniBaseForm = nil;
      const nMask: string = ''; nTitle: string = '');
    procedure InputDlg(const nMsg,nTitle: string;
      const nEvent: TButtonClickInputEvent;
      const nCaller: TUniBaseForm = nil; const nBlank: string = '';
      const nSize: Integer = 0; const nPwd: Boolean = False);
    {*��Ϣ��ʾ��*}
  end;

function UniMainModule: TUniMainModule;

implementation

{$R *.dfm}

uses
  UniGUIVars, ServerModule, uniGUIApplication, ULibFun, UGoogleOTP,
  USysConst;

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

//Date: 2021-04-30
//Parm: ��̬����;��֤ͨ�����¼�;��ť����
//Desc: ��֤nPwd�Ƿ�Ϊ��Ч�Ĺ���Ա��̬����
procedure TUniMainModule.VerifyAdministrator(const nPwd: string;
  const nCall: TButtonClickInputEvent; const nButton: TButtonClickType);
begin
  if (nButton = ctYes) and TStringHelper.IsNumber(nPwd, False) then
   with TGoogleOTP, TApplicationHelper do
    if Validate(EncodeBase32(gSystem.FMain.FAdminKey), StrToInt(nPwd)) then
    begin
      FAdminLastLogin := TDateTimeHelper.GetTickCount();
      nCall(ctYes, nPwd);
      Exit;
    end;

  nCall(ctNo, nPwd);
  //verify failure
end;

//Date: 2021-04-28
//Parm: �ص�;���ô���
//Desc: ��֤��ǰ�Ƿ����Ա
procedure TUniMainModule.VerifyAdministrator(const nEvent: TButtonClickInputEvent;
  const nCaller: TUniBaseForm);
begin
  if (FAdminLastLogin > 0) and
     (TDateTimeHelper.GetTickCountDiff(FAdminLastLogin) < 10 * 60 * 1000) then
  begin
    nEvent(ctYes, '');
    Exit;
  end; //10 min valid

  InputDlg('���������Ա��̬����:', '',
    procedure(const nType: TButtonClickType; const nText: string)
    begin
      VerifyAdministrator(nText, nEvent, nType);
    end, nCaller);
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
//Parm: ��Ϣ;���ô���
//Desc: ��ʾ�Ի���
procedure TUniMainModule.ShowDlg(const nMsg: string; const nError: Boolean;
  const nCaller: TUniBaseForm; const nEvent: TButtonClickEvent; nTitle: string);
var nDType: TMsgDlgType;
begin
  if Assigned(nCaller) then
  begin
    if nError then
         nDType := mtError
    else nDType := mtInformation;

    nCaller.MessageDlg(nMsg, nDType, [mbOK],
      procedure(Sender: TComponent; nButton: Integer)
      begin
        if Assigned(nEvent) then
        begin
          if nButton = mrOk then
               nEvent(ctYes)
          else nEvent(ctNo);
        end;
      end);

    Exit;
  end;

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
//Parm: ��Ϣ;����;���ô���
//Desc: ѯ�ʶԻ���
procedure TUniMainModule.QueryDlg(const nMsg: string;
  const nEvent: TButtonClickEvent; const nCaller: TUniBaseForm;
  const nMask: string; nTitle: string);
begin
  if Assigned(nCaller) then
  begin
    nCaller.MessageDlg(nMsg, mtConfirmation, mbYesNo,
      procedure(Sender: TComponent; nButton: Integer)
      begin
        if Assigned(nEvent) then
        begin
          case nButton of
           mrYes: nEvent(ctYes);
           mrNo:  nEvent(ctNo);
          end;
        end;
      end);

    Exit;
  end;

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
//Parm: ��Ϣ;����;�¼�;���ô���;������д;��С;�Ƿ�����
//Desc: ��ʾ�����
procedure TUniMainModule.InputDlg(const nMsg,nTitle: string;
  const nEvent: TButtonClickInputEvent; const nCaller: TUniBaseForm;
  const nBlank: string; const nSize: Integer; const nPwd: Boolean);
begin
  if Assigned(nCaller) then
  begin
    nCaller.Prompt(TStringHelper.MS(['@*', ''], nPwd) + nMsg,
      nTitle, mtConfirmation, mbOKCancel,
      procedure (Sender: TComponent; nButton:Integer; nText: string)
      begin
        if Assigned(nEvent) then
        begin
          if (nSize > 0) and (Length(nText) > nSize) then
              nText := Copy(nText, 1, nSize);
            //xxxxx

          if nButton = mrOK then
               nEvent(ctYes, nText)
          else nEvent(ctNo, nText);
        end;
      end);

    Exit;
  end;

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
      procedure(nButton: TConfirmButton; nText: string)
      begin
        if Assigned(nEvent) then
        begin
          if (nSize > 0) and (Length(nText) > nSize) then
            nText := Copy(nText, 1, nSize);
          //xxxxx

          case nButton of
           Yes: nEvent(ctYes, nText);
           No:  nEvent(ctNo, nText);
          end;
        end;
      end
    );
  end;
end;

initialization
  RegisterMainModuleClass(TUniMainModule);
end.
