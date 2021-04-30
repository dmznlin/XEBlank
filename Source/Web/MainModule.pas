{*******************************************************************************
  作者: dmzn@163.com 2020-06-23
  描述: 用户全局主模块
*******************************************************************************}
unit MainModule;

interface

uses
  SysUtils, Classes, Controls, uniGUITypes, uniGUIDialogs, uniGUIForm,
  uniGUIMainModule, UniFSToast, UniFSConfirm;

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
    {*管理员最后登录*}
  public
    FSToast1: TUniFSToast;
    FSConfirm1: TUniFSConfirm;
    FSTheme1: UniFSConfirm.TTheme;
    {*消息框对象*}
    procedure VerifyAdministrator(const nPwd: string;
      const nCall: TButtonClickInputEvent;
      const nButton: TButtonClickType = ctYes); overload;
    procedure VerifyAdministrator(const nEvent: TButtonClickInputEvent;
      const nCaller: TUniBaseForm = nil); overload;
    {*验证身份*}
    procedure ShowMsg(const nHint: string; const nError: Boolean = False;
      nTitle: string = '');
    {*消息提示条*}
    procedure ShowDlg(const nMsg: string; const nError: Boolean = False;
      const nEvent: TButtonClickEvent = nil; nTitle: string = '');
    procedure QueryDlg(const nMsg: string; const nEvent: TButtonClickEvent = nil;
      const nMask: string = ''; nTitle: string = '');
    procedure InputDlg(const nMsg,nTitle: string;
      const nEvent: TButtonClickInputEvent; const nBlank: string = '';
      const nSize: Integer = 0; const nPwd: Boolean = False);
    {*消息提示框*}
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
//Parm: 动态密码;验证通过后事件;按钮类型
//Desc: 验证nPwd是否为有效的管理员动态口令
procedure TUniMainModule.VerifyAdministrator(const nPwd: string;
  const nCall: TButtonClickInputEvent; const nButton: TButtonClickType);
begin
  if (nButton = ctYes) and TStringHelper.IsNumber(nPwd, False) then
   with TGoogleOTP, TApplicationHelper do
    if Validate(EncodeBase32(sDefaultAdminKey), StrToInt(nPwd)) then
    begin
      FAdminLastLogin := TDateTimeHelper.GetTickCount();
      nCall(ctYes, nPwd);
      Exit;
    end;

  nCall(ctNo, nPwd);
  //verify failure
end;

//Date: 2021-04-28
//Parm: 回调;调用窗体
//Desc: 验证当前是否管理员
procedure TUniMainModule.VerifyAdministrator(const nEvent: TButtonClickInputEvent;
  const nCaller: TUniBaseForm);
begin
  if (FAdminLastLogin > 0) and
     (TDateTimeHelper.GetTickCountDiff(FAdminLastLogin) < 10 * 60 * 1000) then
  begin
    nEvent(ctYes, '');
    Exit;
  end; //10 min valid

  if Assigned(nCaller) then
    nCaller.Prompt('请输入管理员动态口令:', '', mtInformation, mbOKCancel,
      procedure (Sender: TComponent; nResult:Integer; nText: string)
      begin
        if nResult = mrOK then
             VerifyAdministrator(nText, nEvent, ctYes)
        else VerifyAdministrator(nText, nEvent, ctNo);
      end)
  else
    InputDlg('请输入管理员动态口令:', '验证',
      procedure(const nType: TButtonClickType; const nText: string)
      begin
        VerifyAdministrator(nText, nEvent, nType);
      end);
end;

//Date: 2021-04-20
//Parm: 消息内容;标题
//Desc: 弹出消息框
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
//Parm: 消息;标题
//Desc: 提示对话框
procedure TUniMainModule.ShowDlg(const nMsg: string; const nError: Boolean;
  const nEvent: TButtonClickEvent; nTitle: string);
begin
  with FSConfirm1 do
  begin
    ButtonTextConfirm  := '确定';
    ButtonTextCancel   := '取消';

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
//Parm: 消息;标题
//Desc: 询问对话框
procedure TUniMainModule.QueryDlg(const nMsg: string;
  const nEvent: TButtonClickEvent; const nMask: string; nTitle: string);
begin
  with FSConfirm1 do
  begin
    TypeColor := blue;
    Theme     := FSTheme1;
    RTL       := False;
    CloseIcon := False;

    ButtonTextConfirm  := '是';
    ButtonTextCancel   := '否';
    ScreenMask.Enabled := Trim(nMask) <> '';

    if ScreenMask.Enabled then
      ScreenMask.Text := nMask;
    //xxxxx

    if nTitle = '' then
      nTitle := sAsk;
    //xxxxx

    Question(nTitle, nMsg, 'fa fa-question-circle',
      procedure(nButton: TConfirmButton) //匿名回调函数
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
//Parm: 消息;标题;事件;允许不填写;大小;是否密码
//Desc: 显示输入框
procedure TUniMainModule.InputDlg(const nMsg,nTitle: string;
  const nEvent: TButtonClickInputEvent; const nBlank: string;
  const nSize: Integer; const nPwd: Boolean);
begin
  with FSConfirm1 do
  begin
    ButtonTextConfirm  := '确定';
    ButtonTextCancel   := '取消';
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
