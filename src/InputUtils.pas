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
    Write('�������� ��������: ');
    Readln(NewVacancy^.CompanyName);
    Write('�������������: ');
    Readln(NewVacancy^.Specialty);
    Write('���������: ');
    Readln(NewVacancy^.Position);
    Write('�����: ');
    Readln(NewVacancy^.Salary);
    Write('���� �������: ');
    Readln(NewVacancy^.VacationDays);
    NewVacancy^.RequiresHigherEducation := ReadBoolean('��������� ������ ����������� (1-��/0-���): ');
    Write('����������� �������: ');
    Readln(NewVacancy^.MinAge);
    Write('������������ �������: ');
    Readln(NewVacancy^.MaxAge);

    // ������� ����� ����
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
    Write('��� ���������: ');
    Readln(NewCandidate^.FullName);
    repeat
      Write('���� �������� (��.��.����): ');
      Readln(DateStr);
    until TryStrToDate(DateStr, DateValue);
    NewCandidate^.BirthDate := DateValue;

    Write('�������������: ');
    Readln(NewCandidate^.Specialty);
    NewCandidate^.HasHigherEducation := ReadBoolean('������� ������� ����������� (1-��/0-���): ');
    Write('�������� ���������: ');
    Readln(NewCandidate^.DesiredPosition);
    Write('����������� �����: ');
    Readln(NewCandidate^.MinSalary);

    // ������� ����� ����
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
