{*******************************************************************************
  作者: dmzn@163.com 2020-06-12
  描述: 系统主单元,负责其它模块的调用
*******************************************************************************}
unit UFormMain;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.StdCtrls,
  Vcl.ExtCtrls, cxGraphics, cxControls, cxLookAndFeels, cxLookAndFeelPainters,
  dxSkinsCore, dxSkinsDefaultPainters, dxStatusBar, cxSplitter,
  dxBarBuiltInMenu, cxPC;

type
  TfFormMain = class(TForm)
    PanelTop: TPanel;
    Image1: TImage;
    Image2: TImage;
    HintLabel: TLabel;
    sBar: TdxStatusBar;
    PanelArea: TPanel;
    cxSplitter1: TcxSplitter;
    cxPageControl1: TcxPageControl;
    cxTabSheet1: TcxTabSheet;
    cxPageControl2: TcxPageControl;
    cxTabSheet4: TcxTabSheet;
    cxTabSheet5: TcxTabSheet;
    cxTabSheet6: TcxTabSheet;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  fFormMain: TfFormMain;

implementation

{$R *.dfm}

end.
