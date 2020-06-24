{*******************************************************************************
  作者: dmzn@ylsoft.com 2018-03-15
  描述: 项目通用常,变量定义单元
*******************************************************************************}
unit USysConst;

interface

uses
  SysUtils, Classes, Data.DB, uniPageControl;

const
  cSBar_Date            = 0;                         //日期面板索引
  cSBar_Time            = 1;                         //时间面板索引
  cSBar_User            = 2;                         //用户面板索引
  cRecMenuMax           = 5;                         //最近使用导航区最大条目数

  {*Command*}
  cCmd_RefreshData      = $0002;                     //刷新数据
  cCmd_ViewSysLog       = $0003;                     //系统日志

  cCmd_ModalResult      = $1001;                     //Modal窗体
  cCmd_FormClose        = $1002;                     //关闭窗口
  cCmd_AddData          = $1003;                     //添加数据
  cCmd_EditData         = $1005;                     //修改数据
  cCmd_ViewData         = $1006;                     //查看数据
  cCmd_GetData          = $1007;                     //选择数据

type
  TAdoConnectionType = (ctMain, ctWork);
  //连接类型

  PAdoConnectionData = ^TAdoConnectionData;
  TAdoConnectionData = record
    FConnUser : string;                              //用户设置连接字符串
    FConnStr  : string;                              //系统有效连接字符串
  end;
  //连接对象数据

  TFactoryItem = record
    FFactoryID  : string;                            //工厂编号
    FFactoryName: string;                            //工厂名称
    FMITServURL : string;                            //业务服务
    FHardMonURL : string;                            //硬件守护
    FWechatURL  : string;                            //微信服务
    FDBWorkOn   : string;                            //工作数据库
  end;

  TFactoryItems = array of TFactoryItem;
  //工厂列表

  PSysParam = ^TSysParam;
  TSysParam = record
    FProgID     : string;                            //程序标识
    FAppTitle   : string;                            //程序标题栏提示
    FMainTitle  : string;                            //主窗体标题
    FHintText   : string;                            //提示文本
    FCopyRight  : string;                            //主窗体提示内容

    FUserID     : string;                            //用户标识
    FUserName   : string;                            //当前用户
    FUserPwd    : string;                            //用户口令
    FGroupID    : string;                            //所在组
    FIsAdmin    : Boolean;                           //是否管理员

    FLocalIP    : string;                            //本机IP
    FLocalMAC   : string;                            //本机MAC
    FLocalName  : string;                            //本机名称
    FOSUser     : string;                            //操作系统
    FUserAgent  : string;                            //浏览器类型
    FFactory    : Integer;                           //所属工厂索引
  end;
  //系统参数

  TServerParam = record
    FPort       : Integer;                           //服务端口
    FExtJS      : string;                            //ext脚本目录
    FUniJS      : string;                            //uni脚本目录
    FDBMain     : string;                            //主数据库连接
  end;

  TModuleItemType = (mtFrame, mtForm);
  //模块类型

  PMenuModuleItem = ^TMenuModuleItem;
  TMenuModuleItem = record
    FMenuID: string;                                 //菜单名称
    FModule: string;                                 //模块类型
    FTabSheet: TUniTabSheet;                         //所在页面
    FItemType: TModuleItemType;                      //模块类型
  end;

  TMenuModuleItems = array of TMenuModuleItem;       //模块列表

  PFormCommandParam = ^TFormCommandParam;
  TFormCommandParam = record
    FCommand: integer;                               //命令
    FParamA: Variant;
    FParamB: Variant;
    FParamC: Variant;
    FParamD: Variant;
    FParamE: Variant;                                //参数A-E
  end;

  TFormModalResult = reference to  procedure(const nResult: Integer;
    const nParam: PFormCommandParam = nil);
  //模式窗体结果回调

//------------------------------------------------------------------------------
var
  gPath: string;                                     //程序所在路径
  gSysParam:TSysParam;                               //程序环境参数
  gServerParam: TServerParam;                        //服务器参数

  gAllFactorys: TFactoryItems;                       //系统有效工厂列表
  gAllUsers: TList;                                  //已登录用户列表

ResourceString
  sProgID             = 'DMZN';                      //默认标识
  sAppTitle           = 'DMZN';                      //程序标题
  sMainCaption        = 'DMZN';                      //主窗口标题

  sHint               = '提示';                      //对话框标题
  sWarn               = '警告';                      //==
  sAsk                = '询问';                      //询问对话框
  sError              = '未知错误';                  //错误对话框

  sDate               = '日期:【%s】';               //任务栏日期
  sTime               = '时间:【%s】';               //任务栏时间
  sUser               = '用户:【%s】';               //任务栏用户

  sLogDir             = 'Logs\';                     //日志目录
  sLogExt             = '.log';                      //日志扩展名
  sLogField           = #9;                          //记录分隔符

  sImageDir           = 'Images\';                   //图片目录
  sReportDir          = 'Report\';                   //报表目录
  sBackupDir          = 'Backup\';                   //备份目录
  sBackupFile         = 'Bacup.idx';                 //备份索引
  sCameraDir          = 'Camera\';                   //抓拍目录

  sConfigFile         = 'Config.Ini';                //主配置文件
  sConfigSec          = 'Config';                    //主配置小节
  sVerifyCode         = ';Verify:';                  //校验码标记
  sFormConfig         = 'FormInfo.ini';              //窗体配置

  sExportExt          = '.txt';                      //导出默认扩展名
  sExportFilter       = '文本(*.txt)|*.txt|所有文件(*.*)|*.*';
                                                     //导出过滤条件 

  sInvalidConfig      = '配置文件无效或已经损坏';    //配置文件无效
  sCloseQuery         = '确定要退出程序吗?';         //主窗口退出

implementation

initialization

finalization

end.


