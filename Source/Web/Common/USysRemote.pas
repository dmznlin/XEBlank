{*******************************************************************************
  作者: dmzn@163.com 2020-06-23
  描述: 远程业务调用
*******************************************************************************}
unit USysRemote;

{$I Link.Inc}
interface

uses
  Windows, Classes, System.SysUtils, UBusinessConst, UBusinessPacker,
  UManagerGroup, USysDB, USysConst;

function GetSerialNo(const nGroup,nObject: string;
 const nUseDate: Boolean = True): string;
//获取串行编号

implementation

//Date: 2020-06-23
//Parm: 分组;对象;使用日期编码模式
//Desc: 依据nGroup.nObject生成串行编号
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


