unit UDM;

interface

uses
  SysUtils, Classes, DB, mySQLDbTables;

type
  Tdm = class(TDataModule)
    xConn: TmySQLDatabase;
    QShow: TmySQLQuery;
    function terkoneksi:Boolean;
    procedure SQLExec(aQuery: TmySQLQuery; _SQL: string; isSearch: boolean);
  private
    _host, _db, _user, _password: string;
    _port: Integer;
    { Private declarations }
  public
    { Public declarations }
  end;

var
  dm: Tdm;
  FRootPath, AppPath : string;
  
implementation

{$R *.dfm}

procedure Tdm.SQLExec(aQuery: TmySQLQuery; _SQL: string; isSearch: boolean);
begin
  with aQuery do
  begin
    Close;
    sql.Clear;
    SQL.Text := _SQL;
    if isSearch then
      Open
    else
      ExecSQL;
  end;
end;

function krupuk(const s: string; CryptInt: Integer): string;
var
  i: integer;
  s2: string;
begin
  if not (Length(s) = 0) then
    for i := 1 to Length(s) do
      s2 := s2 + Chr(Ord(s[i]) - cryptint);
  Result := s2;
end;

function Tdm.terkoneksi:Boolean;
var
  data, pusat, jalur1, jalur2, nama, kata: string;
  X: TextFile;
begin
  assignfile(X, FRootPath + '\Tools\koneksi.cbCon');
  try
    reset(X);
    readln(X, pusat);
    readln(X, data);
    readln(X, jalur2);
    readln(X, nama);
    readln(X, kata);
    closefile(X);

    jalur1 := krupuk(jalur2, 6);

    _host := krupuk(pusat, 6);
    _db := krupuk(data, 6);
    _user := krupuk(nama, 6);
    _password := krupuk(kata, 6);
    _port := strtoint(jalur1);

    with xConn do
    begin
      Connected := False;
      Host := _host;
      DatabaseName := _db;
      UserName := _user;
      UserPassword := _password;
      port := _port;
      Connected := True;
    end;
    Result:= True;
  except
    Result:= False;
  end;
end;

end.

