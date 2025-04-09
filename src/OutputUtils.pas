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
    Result := 'Да'
  else
    Result := 'Нет';
end;

procedure ShowVacancyDetailed(Vacancy: PVacancy);
begin
  if Vacancy = nil then
    Exit;

  Writeln('ID: ', Vacancy^.ID);
  Writeln('Компания: ', Vacancy^.CompanyName);
  Writeln('Специальность: ', Vacancy^.Specialty);
  Writeln('Должность: ', Vacancy^.Position);
  Writeln('Оклад: ', Vacancy^.Salary:0:2);
  Writeln('Дней отпуска: ', Vacancy^.VacationDays);
  Writeln('Требуется высшее: ', BoolToYesNo(Vacancy^.RequiresHigherEducation));
  Writeln('Возрастной диапазон: ', Vacancy^.MinAge, '-', Vacancy^.MaxAge);
  Writeln('======================================');
  Writeln;
end;

procedure ShowCandidateDetailed(Candidate: PCandidate);
begin
  if Candidate = nil then
    Exit;

  Writeln('ID: ', Candidate^.ID);
  Writeln('ФИО: ', Candidate^.FullName);
  Writeln('Дата рождения: ', DateToStr(Candidate^.BirthDate));
  Writeln('Специальность: ', Candidate^.Specialty);
  Writeln('Высшее образование: ', BoolToYesNo(Candidate^.HasHigherEducation));
  Writeln('Желаемая должность: ', Candidate^.DesiredPosition);
  Writeln('Минимальный оклад: ', Candidate^.MinSalary:0:2);
  Writeln('======================================');
  Writeln;
end;

procedure ShowAllVacancies(VacanciesHead: PVacancyNode);
var
  Current: PVacancyNode;
begin
  if VacanciesHead = nil then
  begin
    Writeln('Список вакансий пуст.');
    Exit;
  end;

  Writeln('========== ВАКАНСИИ ==========');
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
    Writeln('Список кандидатов пуст.');
    Exit;
  end;

  Writeln('========== КАНДИДАТЫ ==========');
  Writeln;

  Current := CandidatesHead;
  while Current <> nil do
  begin
    ShowCandidateDetailed(Current^.Data);
    Current := Current^.Next;
  end;
end;

end.
