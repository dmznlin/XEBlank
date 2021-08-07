{*******************************************************************************
  ����: dmzn@163.com 2021-08-07
  ����: ���ڹ���
*******************************************************************************}
unit UFormDateFilter;

interface

uses
  System.SysUtils, UFormNormal, UFormBase, System.IniFiles, ULibFun, Data.DB,
  uniGUITypes, uniCheckBox, uniGUIClasses, uniDateTimePicker, uniPanel,
  System.Classes, Vcl.Controls, Vcl.Forms, uniGUIBaseClasses, uniButton,
  uniBitBtn, UniFSButton;

type
  TfFormDateFilter = class(TfFormNormal)
    EditBegin: TUniDateTimePicker;
    EditEnd: TUniDateTimePicker;
    Check1: TUniCheckBox;
    procedure BtnOKClick(Sender: TObject);
  private
    { Private declarations }
    procedure InitDatePicker(const nType: TFieldType;
      const nPicker: TUniDateTimePicker);
    {*��ʼ������*}
  public
    { Public declarations }
    class function DescMe: TfFormDesc; override;
    function SetData(const nData: PCommandParam): Boolean; override;
  end;

implementation

{$R *.dfm}

uses
  UManagerGroup, MainModule, USysBusiness, USysConst;

class function TfFormDateFilter.DescMe: TfFormDesc;
begin
  Result := inherited DescMe();
  Result.FDesc := '����ʱ������';
end;

procedure TfFormDateFilter.InitDatePicker(const nType: TFieldType;
  const nPicker: TUniDateTimePicker);
begin
  with nPicker do
  begin
    FieldLabelWidth := 56;
    DateFormat := 'yyyy-MM-dd';
    TimeFormat := 'HH:mm:ss';

    case nType of
     ftDate:
      begin
        Kind := tUniDate;
      end;
     ftTime:
      begin
        Kind := tUniTime;
      end;
     ftDateTime:
      begin
        Kind := tUniDateTime;
        //DateMode := dtmDateTime;
      end;
    end;
  end;
end;

function TfFormDateFilter.SetData(const nData: PCommandParam): Boolean;
var nType: TFieldType;
    nBegin,nEnd: TDateTime;
begin
  Result := inherited SetData(nData);
  if nData.Command <> cCmd_EditData then Exit;

  if not (nData.IsValid(ptInt) and            //�ֶ�����
          nData.IsValid(ptPtr, 2)) then Exit; //��ʼʱ��,����ʱ��
  //xxxxxx

  nBegin := PDateTime(nData.Ptr[0])^;
  nEnd := PDateTime(nData.Ptr[1])^;
  nType := TFieldType(nData.Int[0]);

  case nType of
   ftDate:
    begin
      Caption := '����';
      EditBegin.FieldLabel := '��ʼ����';
      EditEnd.FieldLabel := '��������';
    end;
   ftTime:
    begin
      Caption := 'ʱ��';
      EditBegin.FieldLabel := '��ʼʱ��';
      EditEnd.FieldLabel := '����ʱ��';
    end;
   ftDateTime:
    begin
      Caption := '����ʱ��';
      EditBegin.FieldLabel := '��ʼʱ��';
      EditEnd.FieldLabel := '����ʱ��';
    end;
  end;

  InitDatePicker(nType, EditBegin);
  InitDatePicker(nType, EditEnd);
  EditBegin.DateTime := nBegin;
  EditEnd.DateTime := nEnd;

  if nData.IsValid(ptPtr, 3) then
  begin
    Check1.Caption := '��ѯʱʹ��' + Caption;
    Check1.Checked := PBoolean(nData.Ptr[2])^;
  end else
  begin
    Check1.Visible := False;
  end;
end;

procedure TfFormDateFilter.BtnOKClick(Sender: TObject);
begin
  if EditBegin.DateTime >= EditEnd.DateTime then
  begin
    UniMainModule.ShowMsg(Format('%s Ӧ���� %s', [EditEnd.FieldLabel,
      EditBegin.FieldLabel]), True);
    Exit;
  end;

  if FParam.IsValid(ptPtr, 2) then
  begin
    PDateTime(FParam.Ptr[0])^ := EditBegin.DateTime;
    PDateTime(FParam.Ptr[1])^ := EditEnd.DateTime;

    if FParam.IsValid(ptPtr, 3) then
      PBoolean(FParam.Ptr[2])^ := Check1.Checked;
    //xxxxx
  end;

  ModalResult := mrOk;
end;

initialization
  TWebSystem.AddForm(TfFormDateFilter);
end.
