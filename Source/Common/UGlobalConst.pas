{*******************************************************************************
  作者: dmzn@ylsoft.com 2021-10-08
  描述: 项目所有模块公用常、变量定义单元
*******************************************************************************}
unit UGlobalConst;

interface

uses
  SysUtils, Classes, ULibFun;

const
  sOrganizationNames: array[TApplicationHelper.TOrganizationStructure] of
    string = ('集团', '区域', '工厂');
  //组织结构名称

type
  POrganizationItem = ^TOrganizationItem;
  TOrganizationItem = record
    FID     : string;                                    //记录标识
    FName   : string;                                    //组织名称
    FParent : string;                                    //上级标识
    FType   : TApplicationHelper.TOrganizationStructure; //组织类型
  end;
  TOrganizationItems = TArray<TOrganizationItem>;

implementation

end.


