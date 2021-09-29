{*******************************************************************************
  ����: dmzn@163.com 2020-06-13
  ����: ϵͳ���ݿⳣ������
*******************************************************************************}
unit USysDB;

{$I Link.inc}
interface

uses
  SysUtils, Classes, UDBManager;

const
  cPrecision          = 100;
  {-----------------------------------------------------------------------------
   ����: ���㾫��
   *.����Ϊ�ֵļ�����,С��ֵ�Ƚϻ����������ʱ�������,���Ի��ȷŴ�,ȥ��
     С��λ������������.�Ŵ����ɾ���ֵȷ��.
  -----------------------------------------------------------------------------}

  {*Ȩ����*}
  sPopedom_Read       = 'A';                         //���
  sPopedom_Add        = 'B';                         //���
  sPopedom_Edit       = 'C';                         //�޸�
  sPopedom_Delete     = 'D';                         //ɾ��
  sPopedom_Preview    = 'E';                         //Ԥ��
  sPopedom_Print      = 'F';                         //��ӡ
  sPopedom_Export     = 'G';                         //����

  {*���ݿ��ʶ*}
  sFlag_DB_K3         = 'King_K3';                   //������ݿ�
  sFlag_DB_NC         = 'YonYou_NC';                 //�������ݿ�

  {*��ر��*}
  sFlag_Yes           = 'Y';                         //��
  sFlag_No            = 'N';                         //��
  sFlag_Unknow        = 'U';                         //δ֪
  sFlag_Enabled       = 'Y';                         //����
  sFlag_Disabled      = 'N';                         //����

  sFlag_ManualNo      = '%';                         //�ֶ�ָ��(��ϵͳ�Զ�)
  sFlag_NotMatter     = '@';                         //�޹ر��(�����Ŷ���)
  sFlag_ForceDone     = '#';                         //ǿ�����(δ���ǰ����)
  sFlag_FixedNo       = '$';                         //ָ�����(ʹ����ͬ���)

  {*���ݱ�*}
  sTable_Null         = 'Sys_Null';                  //�ձ�
  sTable_UserGroup    = 'Sys_UserGroup';             //�û���
  sTable_Popedom      = 'Sys_Popedom';               //Ȩ�ޱ�
  sTable_PopItem      = 'Sys_PopItem';               //Ȩ����

  sTable_ExtInfo      = 'Sys_ExtInfo';               //������Ϣ
  sTable_SysLog       = 'Sys_EventLog';              //ϵͳ��־
  sTable_BaseInfo     = 'Sys_BaseInfo';              //������Ϣ
  sTable_SerialStatus = 'Sys_SerialStatus';          //���״̬
  sTable_WorkePC      = 'Sys_WorkePC';               //��֤��Ȩ
  sTable_Factorys     = 'Sys_Factorys';              //�����б�
  sTable_ManualEvent  = 'Sys_ManualEvent';           //�˹���Ԥ

  sTable_Organization = 'Sys_Organization';          //��֯�ܹ�
  sTable_OrgAddress   = 'Sys_OrgAddress';            //ͨѶ��ַ
  sTable_OrgContact   = 'Sys_OrgContact';            //��ϵ��ʽ

implementation

//Desc: ��ṹ�����������ֵ�
procedure SystemTables(const nList: TList);
begin
  gDBManager.DefaultFit := dtMSSQL;
  //Ĭ�����ݿ�����: SQL Server

  gDBManager.AddTable(sTable_ExtInfo, nList).
    AddF('R_ID',        sField_SQLServer_AutoInc,    '��¼���').
    AddF('I_Group',     'varChar(20)',               '��Ϣ����').
    AddF('I_ItemID',    'varChar(20)',               '��Ϣ��ʶ').
    AddF('I_Item',      'varChar(30)',               '��Ϣ��').
    AddF('I_Info',      'varChar(500)',              '��Ϣ����').
    AddF('I_ParamA',    sField_SQLServer_Decimal,    '�������').
    AddF('I_ParamB',    'varChar(50)',               '�ַ�����').
    AddF('I_Index',     'Integer Default 0',         '��ʾ����',    '0');
  //ExtInfo

  gDBManager.AddTable(sTable_SysLog, nList).
    AddF('R_ID',        sField_SQLServer_AutoInc,    '��¼���').
    AddF('L_Date',      'DateTime',                  '��������').
    AddF('L_Man',       'varChar(32)',               '������').
    AddF('L_Group',     'varChar(20)',               '��Ϣ����').
    AddF('L_ItemID',    'varChar(20)',               '��Ϣ��ʶ').
    AddF('L_KeyID',     'varChar(20)',               '������ʶ').
    AddF('L_Event',     'varChar(220)',              '�¼�').
    AddI('idx_date',    'L_Date DESC');
  //SysLog

  gDBManager.AddTable(sTable_BaseInfo, nList).
    AddF('R_ID',        sField_SQLServer_AutoInc,    '��¼���').
    AddF('B_ID',        'varChar(15)',               '�ڵ���').
    AddF('B_Group',     'varChar(15)',               '����').
    AddF('B_Text',      'varChar(100)',              '����').
    AddF('B_Py',        'varChar(100)',              'ƴ����д').
    AddF('B_Memo',      'varChar(50)',               '��ע��Ϣ').
    AddF('B_Parent',    'varChar(15)',               '�ϼ��ڵ�').
    AddF('B_Index',     sField_SQLServer_Decimal,    '����˳��',    '0').
    AddI('idx_group',   'B_Group ASC');
  //BaseInfo

  gDBManager.AddTable(sTable_SerialStatus, nList).
    AddF('R_ID',        sField_SQLServer_AutoInc,    '��¼���').
    AddF('S_Object',    'varChar(32)',               '����').
    AddF('S_SerailID',  'varChar(32)',               '���б��').
    AddF('S_PairID',    'varChar(32)',               '��Ա��').
    AddF('S_Status',    'Char(1) Default ''N''',     '״̬(Y,N)',  'N').
    AddF('S_Date',      'DateTime',                  '����ʱ��').
    AddI('idx_status',  'S_Status ASC').
    AddI('idx_object',  'S_Object DESC,S_SerailID DESC');
  //SerialStatus

  gDBManager.AddTable(sTable_WorkePC, nList).
    AddF('R_ID',        sField_SQLServer_AutoInc,    '��¼���').
    AddF('W_Name',      'varChar(100)',              '��������').
    AddF('W_MAC',       'varChar(32)',               'MAC��ַ').
    AddF('W_Factory',   'varChar(32)',               '�������').
    AddF('W_Departmen', 'varChar(32)',               '����').
    AddF('W_Serial',    'varChar(32)',               '���').
    AddF('W_ReqMan',    'varChar(32)',               '������').
    AddF('W_ReqTime',   'DateTime',                  '����ʱ��').
    AddF('W_RatifyMan', 'varChar(32)',               '��׼��').
    AddF('W_RatifyTime','DateTime',                  '��׼ʱ��').
    AddF('W_PoundID',   'varChar(32)',               '��վ���').
    AddF('W_MITUrl',    'varChar(128)',              'ҵ�����').
    AddF('W_HardUrl',   'varChar(128)',              'Ӳ������').
    AddF('W_Valid',     'Char(1) Default ''N''',     '��Ч(Y/N)',  'N');
  //WorkPC

  gDBManager.AddTable(sTable_Factorys, nList).
    AddF('R_ID',        sField_SQLServer_AutoInc,    '��¼���').
    AddF('F_ID',        'varChar(32)',               '�������').
    AddF('F_Name',      'varChar(100)',              '��������').
    AddF('F_MITUrl',    'varChar(128)',              '�м����ַ').
    AddF('F_HardUrl',   'varChar(128)',              'Ӳ���ػ���ַ').
    AddF('F_WechatUrl', 'varChar(128)',              '΢�ŷ����ַ').
    AddF('F_DBConn',    'varChar(500)',              '���ݿ���������').
    AddF('F_Valid',     'Char(1) Default ''Y''',     '��Ч(Y/N)').
    AddF('F_Index',     sField_SQLServer_Decimal,    '����˳��',    '0');
  //Factorys

  gDBManager.AddTable(sTable_ManualEvent, nList).
    AddF('R_ID',        sField_SQLServer_AutoInc,    '��¼���').
    AddF('E_ID',        'varChar(32)',               '��ˮ��').
    AddF('E_From',      'varChar(32)',               '��Դ').
    AddF('E_Key',       'varChar(32)',               '��¼��ʶ').
    AddF('E_Event',     'varChar(200)',              '�¼�').
    AddF('E_Solution',  'varChar(100)',              '������').
    AddF('E_Result',    'varChar(12)',               '������').
    AddF('E_Departmen', 'varChar(32)',               '������').
    AddF('E_Date',      'DateTime',                  '����ʱ��').
    AddF('E_ManDeal',   'varChar(32)',               '������').
    AddF('E_DateDeal',  'DateTime',                  '����ʱ��').
    AddF('E_ParamA',    'Integer',                   '���β���').
    AddF('E_ParamB',    'varChar(128)',              '�ַ�������').
    AddF('E_Memo',      'varChar(512)',              '��ע��Ϣ').
    AddI('idx_date',    'E_Date DESC').
    AddI('idx_event',   'E_Date DESC, E_Result ASC, E_Departmen ASC');
  //ManualEvent

  gDBManager.AddTable(sTable_Organization, nList).
    AddF('R_ID',        sField_SQLServer_AutoInc,    '��¼���').
    AddF('O_ID',        'varChar(32)',               '��λ���').
    AddF('O_Name',      'varChar(100)',              '��λ����').
    AddF('O_NamePy',    'varChar(100)',              '��λ����').
    AddF('O_Type',      'varChar(16)',               '��λ����').
    AddF('O_Parent',    'varChar(32)',               '�ϼ���λ').
    AddF('O_Admin',     'varChar(32)',               '����Ա').
    AddF('O_ValidOn',   'DateTime',                  '��Ȩʱ��').
    AddI('idx_id',      'O_ID ASC').
    AddI('idx_parent',  'O_Parent ASC');
  //organization

  gDBManager.AddTable(sTable_OrgAddress, nList).
    AddF('R_ID',        sField_SQLServer_AutoInc,    '��¼���').
    AddF('A_ID',        'varChar(32)',               '��ַ���').
    AddF('A_Name',      'varChar(100)',              '��ַ����').
    AddF('A_PostCode',  'varChar(16)',               '��������').
    AddF('A_Address',   'varChar(320)',              '��ϸ��ַ').
    AddF('A_Owner',     'varChar(32)',               '������λ').
    AddI('idx_id',      'A_ID ASC').
    AddI('idx_owner',   'A_Owner ASC');
  //address

  gDBManager.AddTable(sTable_OrgContact, nList).
    AddF('R_ID',        sField_SQLServer_AutoInc,    '��¼���').
    AddF('C_ID',        'varChar(32)',               'ͨѶ���').
    AddF('C_Name',      'varChar(100)',              'ͨѶ����').
    AddF('C_Phone',     'varChar(50)',               '�绰����').
    AddF('C_Mail',      'varChar(50)',               '��������').
    AddF('C_Owner',     'varChar(32)',               '������λ').
    AddI('idx_id',      'C_ID ASC').
    AddI('idx_owner',   'C_Owner ASC');
  //contact

  gDBManager.AddTable(sTable_Null, nList).
    AddF('R_ID',        sField_SQLServer_AutoInc,    '��¼���').
    AddP('DB_ShowFiles', //��ʾ���ݿ���ļ�ռ��
//++++++++++++++++++++++++++++ �洢����: ��ʼ ++++++++++++++++++++++++++++++++++
'CREATE PROCEDURE DB_ShowFiles' +sEnt+
'AS' +sEnt+
'SELECT a.name [�ļ�����]' +sEnt+
' ,CAST(a.[size]*1.0/128 as decimal(12,1)) AS [�ļ����ô�С(MB)]' +sEnt+
' ,CAST(fileproperty(s.name,''SpaceUsed'')/(8*16.0) AS DECIMAL(12,1)) AS [�ļ���ռ�ռ�(MB)]' +sEnt+
' ,CAST((fileproperty(s.name,''SpaceUsed'')/(8*16.0))/(s.size/(8*16.0))*100.0  AS DECIMAL(12,1)) AS [��ռ�ռ���%]' +sEnt+
' ,CASE WHEN A.growth =0 THEN ''�ļ���С�̶�����������'' ELSE ''�ļ����Զ�����'' end [����ģʽ]' +sEnt+
' ,CASE WHEN A.growth > 0 AND is_percent_growth = 0 THEN ''����Ϊ�̶���С''' +sEnt+
'	WHEN A.growth > 0 AND is_percent_growth = 1 THEN ''�������������ٷֱȱ�ʾ''' +sEnt+
'	ELSE ''�ļ���С�̶�����������'' END AS [����ģʽ]' +sEnt+
' ,CASE WHEN A.growth > 0 AND is_percent_growth = 0 THEN cast(cast(a.growth*1.0/128as decimal(12,0)) AS VARCHAR)+''MB''' +sEnt+
'	WHEN A.growth > 0 AND is_percent_growth = 1 THEN cast(cast(a.growth AS decimal(12,0)) AS VARCHAR)+''%''' +sEnt+
'	ELSE ''�ļ���С�̶�����������'' end AS [����ֵ(%��MB)]' +sEnt+
' ,a.physical_name AS [�ļ�����Ŀ¼]' +sEnt+
' ,a.type_desc AS [�ļ�����]' +sEnt+
'FROM sys.database_files  a' +sEnt+
'INNER JOIN sys.sysfiles AS s ON a.[file_id]=s.fileid' +sEnt+
'LEFT JOIN sys.dm_db_file_space_usage b ON a.[file_id]=b.[file_id]' +sEnt+
'ORDER BY a.[type]').
//------------------------------------------------------------------------------
    AddP('DB_ShowTables ', //��ʾ��ռ�ռ��
//++++++++++++++++++++++++++++ �洢����: ��ʼ ++++++++++++++++++++++++++++++++++
'CREATE PROCEDURE DB_ShowTables' +sEnt+
'  @nByRows bit = 1,   --1,����¼��;0,���ռ��С' +sEnt+
'  @nByDesc bit = 1    --1,����;0,����' +sEnt+
'AS' +sEnt+
'BEGIN' +sEnt+
'  declare @nStr varChar(200)' +sEnt+
'  declare @nOrder varChar(200)' +sEnt+
'  create table #t(name varchar(255), rows bigint, reserved varchar(20),' +sEnt+
'    data varchar(20), index_size varchar(20), unused varchar(20))' +sEnt+
'  exec sp_MSforeachtable "insert into #t exec sp_spaceused ''?''"' +sEnt+
'' +sEnt+
'  if @nByRows = 1' +sEnt+
'	   select @nOrder = ''order by rows''' +sEnt+
'  else select @nOrder = ''order by datasize''' +sEnt+
'  if @nByDesc = 1' +sEnt+
'	   select @nOrder = @nOrder + '' desc''' +sEnt+
'  else select @nOrder = @nOrder + '' asc''' +sEnt+
'' +sEnt+
'  select @nStr = ''select *,convert(int,left(data,' +sEnt+
'    charindex(''''KB'''',data)-1)) as datasize from #t''' +sEnt+
'  select @nStr = ''select * from ('' + @nStr + '') t '' + @nOrder' +sEnt+
'  exec(@nStr)' +sEnt+
'  drop table #t' +sEnt+
'END').
//------------------------------------------------------------------------------
    AddP('Data_OutputData', //����ָ��������
//++++++++++++++++++++++++++++ �洢����: ��ʼ ++++++++++++++++++++++++++++++++++
'CREATE PROCEDURE [Data_OutputData] ' +sEnt+
'  @tablename sysname,' +sEnt+
'  @wherefilter NVARCHAR(MAX) = ''''' +sEnt+
'AS' +sEnt+
'  declare @column NVARCHAR(MAX)' +sEnt+
'  declare @columndata NVARCHAR(MAX)' +sEnt+
'  declare @sql NVARCHAR(MAX)' +sEnt+
'  declare @xtype tinyint' +sEnt+
'  declare @name sysname' +sEnt+
'  declare @objectId int' +sEnt+
'  declare @objectname sysname' +sEnt+
'  declare @ident int' +sEnt+
'' +sEnt+
'  set nocount on' +sEnt+
'  set @objectId=object_id(@tablename)' +sEnt+
'  if @objectId is null   --�ж϶����Ƿ����' +sEnt+
'  begin' +sEnt+
'    print @tablename + ''���󲻴���''' +sEnt+
'    return' +sEnt+
'  end' +sEnt+
'' +sEnt+
'  set @objectname=rtrim(object_name(@objectId))' +sEnt+
'  if @objectname is null or charindex(@objectname,@tablename)=0' +sEnt+
'  begin' +sEnt+
'    print @tablename + ''�����ڵ�ǰ���ݿ���''' +sEnt+
'    return' +sEnt+
'  end' +sEnt+
'' +sEnt+
'  if OBJECTPROPERTY(@objectId,''IsTable'') <> 1 --�ж϶����Ƿ��Ǳ�' +sEnt+
'  begin' +sEnt+
'    print @tablename + ''�����Ǳ�''' +sEnt+
'    return' +sEnt+
'  end' +sEnt+
'' +sEnt+
'  select @ident=status&0x80 from syscolumns' +sEnt+
'  where id=@objectid and status&0x80=0x80' +sEnt+
'  if @ident is not null' +sEnt+
'    print ''SET IDENTITY_INSERT ''+ @TableName + '' ON''' +sEnt+
'  --' +sEnt+
'' +sEnt+
'  --�����α꣬ѭ��ȡ���ݲ�����Insert���' +sEnt+
'  declare syscolumns_cursor cursor for' +sEnt+
'  select c.name,c.xtype from syscolumns c' +sEnt+
'  where c.id=@objectid order by c.colid' +sEnt+
'' +sEnt+
'  --���α�' +sEnt+
'  open syscolumns_cursor' +sEnt+
'  set @column=''''' +sEnt+
'  set @columndata=''''' +sEnt+
'  fetch next from syscolumns_cursor into @name,@xtype' +sEnt+
'  while @@fetch_status <> -1' +sEnt+
'  begin' +sEnt+
'    if @@fetch_status <> -2' +sEnt+
'    begin' +sEnt+
'      if @xtype not in(189,34,35,99,98)' +sEnt+
'	  --timestamp���账��image,text,ntext,sql_variant ��ʱ������' +sEnt+
'      begin' +sEnt+
'        set @column=@column +' +sEnt+
'        case when len(@column)=0 then '''' else '','' end + @name' +sEnt+
'        set @columndata = @columndata +' +sEnt+
'        case when len(@columndata)=0 then '''' else '','''','''','' end  +' +sEnt+
'' +sEnt+
'        case when @xtype in(167,175) then ''''''''''''''''''+''+@name+''+''''''''''''''''''' +sEnt+
'			 --varchar,char' +sEnt+
'             when @xtype in(231,239) then ''''''N''''''''''''+''+@name+''+''''''''''''''''''' +sEnt+
'			 --nvarchar,nchar' +sEnt+
'             when @xtype=6 then ''''''''''''''''''+convert(char(23),''+@name+'',121)+''''''''''''''''''' +sEnt+
'			 --datetime' +sEnt+
'             when @xtype=58 then ''''''''''''''''''+convert(char(16),''+@name+'',120)+''''''''''''''''''' +sEnt+
'			 --smalldatetime' +sEnt+
'             when @xtype=36 then ''''''''''''''''''+convert(char(36),''+@name+'')+''''''''''''''''''' +sEnt+
'			 --uniqueidentifier' +sEnt+
'             else @name' +sEnt+
'        end' +sEnt+
'      end' +sEnt+
'    end' +sEnt+
'    fetch next from syscolumns_cursor into @name,@xtype' +sEnt+
'  end' +sEnt+
'  close syscolumns_cursor' +sEnt+
'  deallocate syscolumns_cursor' +sEnt+
'' +sEnt+
'  set @sql=''set nocount on select ''''insert ''+@tablename+''(''+@column+'') values(''''as ''''--'''',''+@columndata+'','''')'''' from ''+@tablename' +sEnt+
'  if @wherefilter <> ''''' +sEnt+
'  begin' +sEnt+
'    set @sql = @sql + '' where '' + @wherefilter' +sEnt+
'  end' +sEnt+
'' +sEnt+
'  print ''--''+@sql' +sEnt+
'  exec(@sql)' +sEnt+
'' +sEnt+
'  if @ident is not null' +sEnt+
'  print ''SET IDENTITY_INSERT ''+@TableName+'' OFF''').
//------------------------------------------------------------------------------
    AddP('Data_GetTree', //����ָ���ڵ�����и��ڵ���ӽڵ�
//++++++++++++++++++++++++++++ �洢����: ��ʼ ++++++++++++++++++++++++++++++++++
'CREATE PROCEDURE [dbo].[Data_GetTree](' +sEnt+
'  @nID NVARCHAR(MAX),             ---��¼��ʶ' +sEnt+
'  @nColID NVARCHAR(MAX),          ---��¼�����ֶ�' +sEnt+
'  @nColParent NVARCHAR(MAX),      ---���ڵ��ֶ���' +sEnt+
'  @nTable NVARCHAR(MAX),          ---������' +sEnt+
'  @nToChild bit = 0,              ---1,�ӽڵ�;0,���ڵ�' +sEnt+
'  @nWhere NVARCHAR(MAX) = Null,   ---��������' +sEnt+
'  @nFields NVARCHAR(MAX) = ''*''    ---���ص��ֶ�' +sEnt+
') AS' +sEnt+
'BEGIN' +sEnt+
'  DECLARE @nExtWhere NVARCHAR(MAX);' +sEnt+
'  DECLARE @nExtDir NVARCHAR(MAX);' +sEnt+
'  if @nWhere is Null' +sEnt+
'       SET @nExtWhere = ''''' +sEnt+
'  else SET @nExtWhere = '' and ('' + @nWhere + '')'';' +sEnt+
'  if @nToChild = 0' +sEnt+
'	      SET @nExtDir = @nColID + ''=b.'' + @nColParent' +sEnt+
'  else SET @nExtDir = @nColParent + ''=b.'' + @nColID' +sEnt+
'' +sEnt+
'  DECLARE @nSQL NVARCHAR(MAX);' +sEnt+
'  SET @nSQL = ''with CTE as (' +sEnt+
'    select 0 as Level,* from '' + @nTable + ''' +sEnt+
'    where '' + @nColID + ''='''''' + @nID + '''''''' + @nExtWhere + ''' +sEnt+
'    union all' +sEnt+
'    select Level+1,a.* from '' + @nTable + '' a' +sEnt+
'    inner join CTE b on a.'' + @nExtDir + @nExtWhere + ''' +sEnt+
'  ) select '' + @nFields + '' from CTE'';' +sEnt+
'' +sEnt+
'  EXEC sp_executesql @nSQL;' +sEnt+
'END');
end;

initialization
  if Assigned(gDBManager) then
    gDBManager.AddTableBuilder(SystemTables);
  //�����ݱ��ύ�����ݿ������
end.


