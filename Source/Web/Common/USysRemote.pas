{*******************************************************************************
  ����: dmzn@163.com 2020-06-23
  ����: Զ��ҵ�����
*******************************************************************************}
unit USysRemote;

{$I Link.Inc}
interface

uses
  Windows, Classes, System.SysUtils, UBusinessConst, UBusinessPacker,
  UManagerGroup, USysDB, USysConst;

function GetSerialNo(const nGroup,nObject: string;
 const nUseDate: Boolean = True): string;
//��ȡ���б��

implementation

//Date: 2020-06-23
//Parm: ����;����;ʹ�����ڱ���ģʽ
//Desc: ����nGroup.nObject���ɴ��б��
function GetSerialNo(const nGroup,nObject: string;
 const nUseDate: Boolean): string;
var nStr: string;
    nList: TStrings;
    nOut: TWorkerBusinessCommand;
begin
  Result := '';
  nList := nil;
  try
    nList := gMG.FObjectPool.Lock(TStrings) as TStrings;
    nList.Values['Group'] := nGroup;
    nList.Values['Object'] := nObject;

    if nUseDate then
         nStr := sFlag_Yes
    else nStr := sFlag_No;

    //if CallBusinessCommand(cBC_GetSerialNO, nList.Text, nStr, @nOut) then
      Result := nOut.FData;
    //xxxxx
  finally
    gMG.FObjectPool.Release(nList);
  end;
end;

end.


