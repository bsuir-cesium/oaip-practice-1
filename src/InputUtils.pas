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
  Write('Введите ID компании: ');
  Readln(CompanyID);

  if not CompanyExists(CompaniesHead, CompanyID) then
  begin
    Writeln('Ошибка! Компания не существует!');
    Exit;
  end;
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

  NewVacancy.CompanyID := CompanyID;
  AppendVacancy(VacanciesHead, NewVacancy);
  Write('Вакансия с ID: ');
  Write(NewVacancy.CompanyID);
  Writeln(' была успешна создана!');
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
  Write('Кандидат ' + NewCandidate.FullName + 'с ID: ');
  Write(NewCandidate.ID);
  Writeln(' был успешно создан!');
end;

procedure AddNewCompany(var CompaniesHead: PCompanyNode);
var
  NewCompany: TCompany;
begin
  NewCompany.ID := GetNextCompanyID();
  Write('Название компании: ');
  Readln(NewCompany.Name);

  AppendCompany(CompaniesHead, NewCompany);
  Write('Компания ' + NewCompany.Name + ' с ID: ');
  Write(NewCompany.ID);
  Writeln(' была успешно создана!');
end;

end.
