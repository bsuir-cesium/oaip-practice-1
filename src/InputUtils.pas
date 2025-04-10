unit InputUtils;

interface

uses
  CoreTypes, ListUtils, SysUtils;

procedure AddNewVacancy(var VacanciesHead: PVacancyNode;
  CompaniesHead: PCompanyNode);
procedure AddNewCandidate(var CandidatesHead: PCandidateNode);
procedure AddNewCompany(var CompaniesHead: PCompanyNode);

implementation

function ReadBoolean(const Prompt: string): Boolean;
var
  InputStr: string;
  InputFlag: Integer;
begin
  repeat
    Write(Prompt);
    Readln(InputStr);
  until TryStrToInt(InputStr, InputFlag) and
    ((InputFlag = 0) or (InputFlag = 1));
  Result := Boolean(InputFlag);
end;

procedure AddNewVacancy(var VacanciesHead: PVacancyNode;
  CompaniesHead: PCompanyNode);
var
  NewVacancy: TVacancy;
  CompanyID: Integer;
begin
  NewVacancy.ID := GetNextVacancyID();
  Write('������� ID ��������: ');
  Readln(CompanyID);

  if not CompanyExists(CompaniesHead, CompanyID) then
  begin
    Writeln('������! �������� �� ����������!');
    Exit;
  end;
  Write('�������������: ');
  Readln(NewVacancy.Specialty);
  Write('���������: ');
  Readln(NewVacancy.Position);
  Write('�����: ');
  Readln(NewVacancy.Salary);
  Write('���� �������: ');
  Readln(NewVacancy.VacationDays);
  NewVacancy.RequiresHigherEducation :=
    ReadBoolean('��������� ������ ����������� (1-��/0-���): ');
  Write('����������� �������: ');
  Readln(NewVacancy.MinAge);
  Write('������������ �������: ');
  Readln(NewVacancy.MaxAge);

  NewVacancy.CompanyID := CompanyID;
  AppendVacancy(VacanciesHead, NewVacancy);
  Write('�������� � ID: ');
  Write(NewVacancy.CompanyID);
  Writeln(' ���� ������� �������!');
end;

procedure AddNewCandidate(var CandidatesHead: PCandidateNode);
var
  NewCandidate: TCandidate;
  DateStr: string;
  DateValue: TDateTime;
begin
  NewCandidate.ID := GetNextCandidateID;
  Write('��� ���������: ');
  Readln(NewCandidate.FullName);
  repeat
    Write('���� �������� (��.��.����): ');
    Readln(DateStr);
  until TryStrToDate(DateStr, DateValue);
  NewCandidate.BirthDate := DateValue;

  Write('�������������: ');
  Readln(NewCandidate.Specialty);
  NewCandidate.HasHigherEducation :=
    ReadBoolean('������� ������� ����������� (1-��/0-���): ');
  Write('�������� ���������: ');
  Readln(NewCandidate.DesiredPosition);
  Write('����������� �����: ');
  Readln(NewCandidate.MinSalary);

  AppendCandidate(CandidatesHead, NewCandidate);
  Write('�������� ' + NewCandidate.FullName + '� ID: ');
  Write(NewCandidate.ID);
  Writeln(' ��� ������� ������!');
end;

procedure AddNewCompany(var CompaniesHead: PCompanyNode);
var
  NewCompany: TCompany;
begin
  NewCompany.ID := GetNextCompanyID();
  Write('�������� ��������: ');
  Readln(NewCompany.Name);

  AppendCompany(CompaniesHead, NewCompany);
  Write('�������� ' + NewCompany.Name + ' � ID: ');
  Write(NewCompany.ID);
  Writeln(' ���� ������� �������!');
end;

end.
