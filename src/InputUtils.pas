unit InputUtils;

interface

uses
  CoreTypes, ListUtils, SysUtils;

procedure AddNewVacancy(var VacanciesHead: PVacancyNode;
  CompaniesHead: PCompanyNode);
procedure AddNewCandidate(var CandidatesHead: PCandidateNode);
procedure AddNewCompany(var CompaniesHead: PCompanyNode);
procedure EditVacancy(VacanciesHead: PVacancyNode; ID: Integer);
procedure EditCandidate(CandidatesHead: PCandidateNode; ID: Integer);
procedure EditCompany(CompaniesHead: PCompanyNode; ID: Integer);
function ReadBoolean(const Prompt: string): Boolean;

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
  Write('Кандидат ' + NewCandidate.FullName + ' с ID: ');
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

procedure EditVacancy(VacanciesHead: PVacancyNode; ID: Integer);
var
  isFinded: Boolean;
begin
  isFinded := False;

  while VacanciesHead <> nil do
  begin
    if VacanciesHead^.Data^.ID = ID then
    begin
      isFinded := True;
      Write('Специальность: ');
      Readln(VacanciesHead^.Data^.Specialty);
      Write('Должность: ');
      Readln(VacanciesHead^.Data^.Position);
      Write('Оклад: ');
      Readln(VacanciesHead^.Data^.Salary);
      Write('Дней отпуска: ');
      Readln(VacanciesHead^.Data^.VacationDays);
      VacanciesHead^.Data^.RequiresHigherEducation :=
        ReadBoolean('Требуется высшее образование (1-Да/0-Нет): ');
      Write('Минимальный возраст: ');
      Readln(VacanciesHead^.Data^.MinAge);
      Write('Максимальный возраст: ');
      Readln(VacanciesHead^.Data^.MaxAge);
    end;
    VacanciesHead := VacanciesHead^.Next;
  end;

  if not isFinded then
    Writeln('Вакансия с ID: ', ID, ' не найдена.');
end;

procedure EditCandidate(CandidatesHead: PCandidateNode; ID: Integer);
var
  isFinded: Boolean;
  DateStr: string;
  DateValue: TDateTime;
begin
  isFinded := False;

  while CandidatesHead <> nil do
  begin
    if CandidatesHead^.Data^.ID = ID then
    begin
      isFinded := False;
      Write('ФИО кандидата: ');
      Readln(CandidatesHead^.Data^.FullName);
      repeat
        Write('Дата рождения (дд.мм.гггг): ');
        Readln(DateStr);
      until TryStrToDate(DateStr, DateValue);
      CandidatesHead^.Data^.BirthDate := DateValue;

      Write('Специальность: ');
      Readln(CandidatesHead^.Data^.Specialty);
      CandidatesHead^.Data^.HasHigherEducation :=
        ReadBoolean('Наличие высшего образования (1-Да/0-Нет): ');
      Write('Желаемая должность: ');
      Readln(CandidatesHead^.Data^.DesiredPosition);
      Write('Минимальный оклад: ');
      Readln(CandidatesHead^.Data^.MinSalary);
    end;
    CandidatesHead := CandidatesHead^.Next;
  end;

  if not isFinded then
    Writeln('Кандидат с ID: ', ID, ' не найден.');
end;

procedure EditCompany(CompaniesHead: PCompanyNode; ID: Integer);
var
  isFinded: Boolean;
begin
  isFinded := False;

  while CompaniesHead <> nil do
  begin
    if CompaniesHead^.Data^.ID = ID then
    begin
      isFinded := True;
      Write('Название компании: ');
      Readln(CompaniesHead^.Data^.Name);
    end;
    CompaniesHead := CompaniesHead^.Next;
  end;

  if not isFinded then
    Writeln('Компания с ID: ', ID, ' не найдена.');

end;

end.
