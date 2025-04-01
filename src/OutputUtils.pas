unit OutputUtils;

interface

uses
  CoreTypes;

procedure ShowAllVacancies(VacanciesHead: PVacancyNode);
procedure ShowAllCandidates(CandidatesHead: PCandidateNode);

implementation

uses
  SysUtils, Windows;

function BoolToYesNo(Value: Boolean): string;
begin
  if Value then
    Result := 'Да'
  else
    Result := 'Нет';
end;

procedure ShowAllVacancies(VacanciesHead: PVacancyNode);
var
  Current: PVacancyNode;
  i: Integer;
begin
  if VacanciesHead = nil then
  begin
    Writeln('Список вакансий пуст.');
    Exit;
  end;

  Writeln('Список вакансий:');
  Writeln('==============================================================================================================');
  Writeln('| Компания           | Специальность      | Должность          | Оклад     | Отпуск | Образование | Возраст   |');
  Writeln('==============================================================================================================');

  Current := VacanciesHead;
  i := 1;
  while Current <> nil do
  begin
    with Current^.Data^ do
    begin
      WriteLn(Format('| %-18s | %-18s | %-18s | %-9.2f | %-6d | %-11s | %d-%d     |',
        [CompanyName,
         Specialty,
         Position,
         Salary,
         VacationDays,
         BoolToYesNo(RequiresHigherEducation),
         MinAge,
         MaxAge]));
    end;
    Current := Current^.Next;
    Inc(i);
  end;
  Writeln('==============================================================================================================');
end;

procedure ShowAllCandidates(CandidatesHead: PCandidateNode);
var
  Current: PCandidateNode;
  i: Integer;
begin
  if CandidatesHead = nil then
  begin
    Writeln('Список кандидатов пуст.');
    Exit;
  end;

  Writeln('Список кандидатов:');
  Writeln('======================================================================================================');
  Writeln('| ФИО               | Дата рождения | Специальность | Образование | Должность       | Мин. оклад   |');
  Writeln('======================================================================================================');

  Current := CandidatesHead;
  i := 1;
  while Current <> nil do
  begin
    with Current^.Data^ do
    begin
      WriteLn(Format('| %-18s | %-13s | %-14s | %-11s | %-16s | %-12.2f |',
        [FullName,
         DateToStr(BirthDate),
         Specialty,
         BoolToYesNo(HasHigherEducation),
         DesiredPosition,
         MinSalary]));
    end;
    Current := Current^.Next;
    Inc(i);
  end;
  Writeln('======================================================================================================');
end;

end.
