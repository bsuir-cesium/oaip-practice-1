unit InputUtils;

interface

uses
  CoreTypes, SysUtils;

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
  until TryStrToInt(InputStr, InputFlag) and ((InputFlag = 0) or (InputFlag = 1));
  Result := Boolean(InputFlag);
end;

procedure AddNewVacancy(var VacanciesHead: PVacancyNode);
var
  NewVacancy: PVacancy;
  NewNode: PVacancyNode;
begin
  New(NewVacancy);
  try
    Write('Название компании: ');
    Readln(NewVacancy^.CompanyName);
    Write('Специальность: ');
    Readln(NewVacancy^.Specialty);
    Write('Должность: ');
    Readln(NewVacancy^.Position);
    Write('Оклад: ');
    Readln(NewVacancy^.Salary);
    Write('Дней отпуска: ');
    Readln(NewVacancy^.VacationDays);
    NewVacancy^.RequiresHigherEducation := ReadBoolean('Требуется высшее образование (1-Да/0-Нет): ');
    Write('Минимальный возраст: ');
    Readln(NewVacancy^.MinAge);
    Write('Максимальный возраст: ');
    Readln(NewVacancy^.MaxAge);

    // Создаем новый узел
    New(NewNode);
    NewNode^.Data := NewVacancy;
    NewNode^.Next := VacanciesHead;
    VacanciesHead := NewNode;

  except
    Dispose(NewVacancy);
    raise;
  end;
end;

procedure AddNewCandidate(var CandidatesHead: PCandidateNode);
var
  NewCandidate: PCandidate;
  NewNode: PCandidateNode;
  DateStr: string;
  DateValue: TDateTime;
begin
  New(NewCandidate);
  try
    Write('ФИО кандидата: ');
    Readln(NewCandidate^.FullName);
    repeat
      Write('Дата рождения (дд.мм.гггг): ');
      Readln(DateStr);
    until TryStrToDate(DateStr, DateValue);
    NewCandidate^.BirthDate := DateValue;

    Write('Специальность: ');
    Readln(NewCandidate^.Specialty);
    NewCandidate^.HasHigherEducation := ReadBoolean('Наличие высшего образования (1-Да/0-Нет): ');
    Write('Желаемая должность: ');
    Readln(NewCandidate^.DesiredPosition);
    Write('Минимальный оклад: ');
    Readln(NewCandidate^.MinSalary);

    // Создаем новый узел
    New(NewNode);
    NewNode^.Data := NewCandidate;
    NewNode^.Next := CandidatesHead;
    CandidatesHead := NewNode;

  except
    Dispose(NewCandidate);
    raise;
  end;
end;

end.
