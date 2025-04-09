unit OutputUtils;

interface

uses
  CoreTypes;

procedure ShowVacancyDetailed(Vacancy: PVacancy);
procedure ShowCandidateDetailed(Candidate: PCandidate);
procedure ShowAllVacancies(VacanciesHead: PVacancyNode);
procedure ShowAllCandidates(CandidatesHead: PCandidateNode);

implementation

uses
  SysUtils;

function BoolToYesNo(Value: Boolean): string;
begin
  if Value then
    Result := '��'
  else
    Result := '���';
end;

procedure ShowVacancyDetailed(Vacancy: PVacancy);
begin
  if Vacancy = nil then
    Exit;

  Writeln('ID: ', Vacancy^.ID);
  Writeln('��������: ', Vacancy^.CompanyName);
  Writeln('�������������: ', Vacancy^.Specialty);
  Writeln('���������: ', Vacancy^.Position);
  Writeln('�����: ', Vacancy^.Salary:0:2);
  Writeln('���� �������: ', Vacancy^.VacationDays);
  Writeln('��������� ������: ', BoolToYesNo(Vacancy^.RequiresHigherEducation));
  Writeln('���������� ��������: ', Vacancy^.MinAge, '-', Vacancy^.MaxAge);
  Writeln('======================================');
  Writeln;
end;

procedure ShowCandidateDetailed(Candidate: PCandidate);
begin
  if Candidate = nil then
    Exit;

  Writeln('ID: ', Candidate^.ID);
  Writeln('���: ', Candidate^.FullName);
  Writeln('���� ��������: ', DateToStr(Candidate^.BirthDate));
  Writeln('�������������: ', Candidate^.Specialty);
  Writeln('������ �����������: ', BoolToYesNo(Candidate^.HasHigherEducation));
  Writeln('�������� ���������: ', Candidate^.DesiredPosition);
  Writeln('����������� �����: ', Candidate^.MinSalary:0:2);
  Writeln('======================================');
  Writeln;
end;

procedure ShowAllVacancies(VacanciesHead: PVacancyNode);
var
  Current: PVacancyNode;
begin
  if VacanciesHead = nil then
  begin
    Writeln('������ �������� ����.');
    Exit;
  end;

  Writeln('========== �������� ==========');
  Writeln;

  Current := VacanciesHead;
  while Current <> nil do
  begin
    ShowVacancyDetailed(Current^.Data);
    Current := Current^.Next;
  end;
end;

procedure ShowAllCandidates(CandidatesHead: PCandidateNode);
var
  Current: PCandidateNode;
begin
  if CandidatesHead = nil then
  begin
    Writeln('������ ���������� ����.');
    Exit;
  end;

  Writeln('========== ��������� ==========');
  Writeln;

  Current := CandidatesHead;
  while Current <> nil do
  begin
    ShowCandidateDetailed(Current^.Data);
    Current := Current^.Next;
  end;
end;

end.
