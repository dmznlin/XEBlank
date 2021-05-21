{*******************************************************************************
  作者: dmzn@163.com 2020-06-23
  描述: 主窗口,调度其它模块
*******************************************************************************}
unit UFormMain;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics,
  Controls, Forms, MainModule, uniGUITypes, uniGUIAbstractClasses,
  uniGUIClasses, uniGUIRegClasses, uniGUIForm, uniTreeView, uniPageControl,
  uniButton, uniBitBtn, UniFSButton, uniMultiItem, uniComboBox, uniPanel,
  uniStatusBar, uniLabel, uniImage, uniGUIBaseClasses, uniSplitter;

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
    PanelWelcome: TUniPanel;
    SplitterLeft: TUniSplitter;
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
begin
  ImageLeft.Url := gSystem.FImages.FImgMainTL;
  ImageRight.Url := gSystem.FImages.FImgMainTR;
  LabelHint.Caption := gSystem.FMain.FActive.FDeployName;
  PanelWelcome.Caption := gSystem.FMain.FActive.FCopyRight;
end;

initialization
  RegisterAppFormClass(TfFormMain);

end.
