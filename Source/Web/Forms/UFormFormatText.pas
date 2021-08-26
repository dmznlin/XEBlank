{*******************************************************************************
  ����: dmzn@163.com 2021-08-25
  ����: ��ʽ���ı�
*******************************************************************************}
unit UFormFormatText;

interface

uses
  System.SysUtils, System.Classes, Vcl.Controls, Vcl.Forms, System.IniFiles,
  UFormBase, uniGUIBaseClasses, uniGUIClasses, uniButton, uniMemo, uniPanel,
  uniSplitter, uniCheckBox, uniEdit;

type
  TfFormFormatTxt = class(TfFormBase)
    EditFormat: TUniMemo;
    EditNormal: TUniMemo;
    PanelT: TUniSimplePanel;
    UniSplitter1: TUniSplitter;
    BtnFormat: TUniButton;
    EditBlank: TUniNumberEdit;
    BtnNormal: TUniButton;
    Check2: TUniCheckBox;
    EditEnt: TUniEdit;
    procedure BtnFormatClick(Sender: TObject);
    procedure BtnNormalClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    class function DescMe: TfFormDesc; override;
    procedure DoFormConfig(nIni: TIniFile; const nLoad: Boolean); override;
  end;

implementation

{$R *.dfm}

uses
  uniGUIVars, UManagerGroup, ULibFun, MainModule, USysBusiness;

const
  sTag   = '''';       //������
  sTags  = '''''';     //����������
  sBlank = ' ';        //�ո�

class function TfFormFormatTxt.DescMe: TfFormDesc;
begin
  Result := inherited DescMe();
  Result.FUserConfig := True;
  Result.FDesc := '�ı�ת��Ϊ����';
end;

procedure TfFormFormatTxt.DoFormConfig(nIni: TIniFile; const nLoad: Boolean);
var nInt: Integer;
begin
  if nLoad then
  begin
    EditNormal.Clear;
    EditFormat.Clear;
    //init first

    nInt := nIni.ReadInteger(Name, 'NormalHeight', 0);
    if nInt > 100 then
      EditNormal.Height := nInt;
    //xxxxx

    nInt := nIni.ReadInteger(Name, 'BlankNumber', 0);
    if nInt >= 0 then
      EditBlank.Text := IntToStr(nInt);
    //xxxxx

    EditEnt.Text := nIni.ReadString(Name, 'EnterTag', '#13#10');
    TWebSystem.LoadFormConfig(Self, nIni);
  end else
  begin
    if TStringHelper.IsNumber(EditBlank.Text, False) then
      nIni.WriteInteger(Name, 'BlankNumber', StrToInt(EditBlank.Text));
    //xxxxx

    nIni.WriteInteger(Name, 'NormalHeight', EditNormal.Height);
    nIni.WriteString(Name, 'EnterTag', EditEnt.Text);
    TWebSystem.SaveFormConfig(Self, nIni);
  end;
end;

//Desc: �ı�ת��
procedure TfFormFormatTxt.BtnFormatClick(Sender: TObject);
var nStr: string;
    nIdx,nInt,nCount: Integer;
begin
  if EditNormal.Lines.Count < 1 then
  begin
    UniMainModule.ShowMsg('����д����ʽ����ԭʼ�ı�');
    Exit;
  end;

  with EditFormat do
  try
    if EditBlank.Value < 0 then
      EditBlank.Value := 0;
    //xxxxx

    Lines.BeginUpdate;
    Lines.Clear;
    nInt := 0;

    nCount := EditNormal.Lines.Count - 1;
    for nIdx := 0 to nCount do
    begin
      nStr := TrimRight(EditNormal.Lines[nIdx]);
      //ȥ���Ҳ�ո�
      if nStr = '' then
      begin
        if (nInt = 0) and (EditNormal.Lines[nIdx] = '') then //�ϲ���������
          Lines.Add('');
        nInt := 1;
      end else
      begin
        nInt := 0;
        Lines.Add(nStr);
      end;
    end;

    nCount := Lines.Count - 1;
    for nIdx := 0 to nCount do
    begin
      nStr := StringReplace(Lines[nIdx], sTag, sTags, [rfReplaceAll]);
      //������ > ˫������

      if Check2.Checked then
        nStr := nStr + sBlank;
      //��β�ӿո�

      nStr := sTag + nStr + sTag;
      //���˵�����

      if nIdx < nCount then
      begin
        nStr := nStr + ' +';
        if EditEnt.Text <> '' then
          nStr := nStr + EditEnt.Text + '+';
        //��β�ӻس�
      end;

      nInt := Round(EditBlank.Value);
      if nInt > 0 then
        nStr := StringOfChar(sBlank, nInt) + nStr;
      //���׼ӿո�

      Lines[nIdx] := nStr;
      //apply format
    end;
  finally
    Lines.EndUpdate;
  end;
end;

//Desc: �ı���ԭ
procedure TfFormFormatTxt.BtnNormalClick(Sender: TObject);
var nStr: string;
    nIdx,j,nL,nR,nCount: Integer;
begin
  if EditFormat.Lines.Count < 1 then
  begin
    UniMainModule.ShowMsg('����д����ԭ���ı�');
    Exit;
  end;

  with EditNormal do
  try
    Lines.BeginUpdate;
    Lines.Clear;
    nCount := EditFormat.Lines.Count - 1;

    for nIdx := 0 to nCount do
    begin
      nStr := EditFormat.Lines[nIdx];
      nL := Pos(sTag, nStr);
      //��൥����

      if nL < 1 then
      begin
        Lines.Add(nStr);
        Continue;
      end;

      nR := 0;
      for j := Length(nStr) downto 1 do
       if nStr[j] = sTag then
       begin
         nR := j; //�Ҳ൥����
         Break;
       end;

      if nR - nL >= 1 then
        nStr := Copy(nStr, nL + 1, nR - nL - 1);
      //��ȡ��Ч

      Lines.Add(StringReplace(nStr, sTags, sTag, [rfReplaceAll]));
      //restore format
    end;
  finally
    Lines.EndUpdate;
  end;
end;

initialization
  TWebSystem.AddForm(TfFormFormatTxt);
end.
