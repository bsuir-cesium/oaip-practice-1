unit InputUtils;

interface

uses
  CoreTypes, ListUtils, SysUtils;

procedure AddNewVacancy(var VacanciesHead: PVacancyNode);
procedure AddNewCandidate(var CandidatesHead: PCandidateNode);

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

procedure AddNewVacancy(var VacanciesHead: PVacancyNode);
var
  NewVacancy: TVacancy;
begin
  NewVacancy.ID := GetNextVacancyID();
  Write('Название компании: ');
  Readln(NewVacancy.CompanyName);
  Write('Специальность: ');
  Readln(NewVacancy.Specialty);
  Write('Должность: ');
  Readln(NewVacancy.Position);
  Write('Оклад: ');
  Readln(NewVacancy.Salary);
  Write('Дней отпуска: ');
  Readln(NewVacancy.VacationDays);
  NewVacancy.RequiresHigherEducation :=
    ReadBoolean('Требуется высшее образование (1-Да/0-Нет): ');
  Write('Минимальный возраст: ');
  Readln(NewVacancy.MinAge);
  Write('Максимальный возраст: ');
  Readln(NewVacancy.MaxAge);

  AppendVacancy(VacanciesHead, NewVacancy);
end;

procedure AddNewCandidate(var CandidatesHead: PCandidateNode);
var
  NewCandidate: TCandidate;
  DateStr: string;
  DateValue: TDateTime;
begin
  NewCandidate.ID := GetNextCandidateID;
  Write('ФИО кандидата: ');
  Readln(NewCandidate.FullName);
  repeat
    Write('Дата рождения (дд.мм.гггг): ');
    Readln(DateStr);
  until TryStrToDate(DateStr, DateValue);
  NewCandidate.BirthDate := DateValue;

  Write('Специальность: ');
  Readln(NewCandidate.Specialty);
  NewCandidate.HasHigherEducation :=
    ReadBoolean('Наличие высшего образования (1-Да/0-Нет): ');
  Write('Желаемая должность: ');
  Readln(NewCandidate.DesiredPosition);
  Write('Минимальный оклад: ');
  Readln(NewCandidate.MinSalary);

  AppendCandidate(CandidatesHead, NewCandidate);
end;

end.
