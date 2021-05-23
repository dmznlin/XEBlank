{*******************************************************************************
  ����: dmzn@163.com 2020-06-23
  ����: ������,��������ģ��
*******************************************************************************}
unit UFormMain;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics,
  Controls, Forms, MainModule, uniGUITypes, uniGUIAbstractClasses,
  uniGUIClasses, uniGUIRegClasses, uniGUIForm, uniTreeView, uniPageControl,
  uniButton, uniBitBtn, UniFSButton, uniMultiItem, uniComboBox, uniPanel,
  uniStatusBar, uniLabel, uniImage, uniGUIBaseClasses, uniSplitter,
  UniFSConfirm, UniFSToast;

type
  TfFormMain = class(TUniForm)
    PanelTop: TUniSimplePanel;
    ImageRight: TUniImage;
    ImageLeft: TUniImage;
    LabelHint: TUniLabel;
    StatusBar1: TUniStatusBar;
    PanelClient: TUniSimplePanel;
    PanelMenus: TUniContainerPanel;
    PanelLeftTop: TUniPanel;
    PanelLeft: TUniContainerPanel;
    EditSearch: TUniComboBox;
    BtnGetMsg: TUniFSButton;
    BtnExpand: TUniFSButton;
    BtnCollasp: TUniFSButton;
    PageWork: TUniPageControl;
    SheetWelcome: TUniTabSheet;
    SplitterLeft: TUniSplitter;
    ImageWelcome: TUniImage;
    LabelCopyRight: TUniLabel;
    FSToast1: TUniFSToast;
    FSConfirm1: TUniFSConfirm;
    procedure UniFormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

function fFormMain: TfFormMain;

implementation

{$R *.dfm}

uses
  uniGUIVars, uniGUIApplication, UManagerGroup, UMenuManager,
  USysMenu, USysConst;

function fFormMain: TfFormMain;
begin
  Result := TfFormMain(UniMainModule.GetFormInstance(TfFormMain));
end;

procedure TfFormMain.UniFormCreate(Sender: TObject);
var nStr: string;
begin
  UniMainModule.FSToast1 := FSToast1;
  UniMainModule.FSConfirm1 := FSConfirm1;

  ImageLeft.Url := gSystem.FImages.FImgMainTL.FFile;
  ImageRight.Url := gSystem.FImages.FImgMainTR.FFile;
  LabelHint.Caption := gSystem.FMain.FActive.FDeployName;
  LabelCopyRight.Caption := gSystem.FMain.FActive.FCopyRight;

  with ImageWelcome do
  begin
    Url := gSystem.FImages.FImgWelcome.FFile;
    Width := gSystem.FImages.FImgWelcome.FWidth;
    Height := gSystem.FImages.FImgWelcome.FHeight;

    case gSystem.FImages.FImgWelcome.FPosition of
     ipTL, ipTM, ipTR: SheetWelcome.LayoutAttribs.Align := 'top';
     ipML, ipMM, ipMR: SheetWelcome.LayoutAttribs.Align := 'middle';
     ipBL, ipBM, ipBR: SheetWelcome.LayoutAttribs.Align := 'bottom';
    end;

    case gSystem.FImages.FImgWelcome.FPosition of
     ipTL, ipML, ipBL: SheetWelcome.LayoutAttribs.Pack := 'start';
     ipTM, ipMM, ipBM: SheetWelcome.LayoutAttribs.Pack := 'center';
     ipTR, ipMR, ipBR: SheetWelcome.LayoutAttribs.Pack := 'end';
    end;
  end;

  with UniMainModule, UniSession do
  begin
    nStr := '��.�û�:��%s�� ����:��%s�� ϵͳ:��%s�� �����:��%s��';
    nStr := Format(nStr, [FUser.FUserName, RemoteIP, SystemUser, UserAgent]);
    StatusBar1.SimpleText := nStr;
  end;
end;

initialization
  RegisterAppFormClass(TfFormMain);

end.
