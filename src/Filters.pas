unit Filters;

interface

uses
  CoreTypes;

procedure FilterVacancies(SourceHead: PVacancyNode; MinSalary: Double;
  RequiresEducation: Boolean; MinAge: Integer; MaxAge: Integer;
  Specialty: string; var ResultHead: PVacancyNode);

procedure FilterCandidates(SourceHead: PCandidateNode; MinDesiredSalary: Double;
  HasEducation: Boolean; MinAge: Integer; MaxAge: Integer; Specialty: string;
  var ResultHead: PCandidateNode);

implementation

uses
  SysUtils, DateUtils;

procedure FilterVacancies(SourceHead: PVacancyNode; MinSalary: Double;
  RequiresEducation: Boolean; MinAge: Integer; MaxAge: Integer;
  Specialty: string; var ResultHead: PVacancyNode);
var
  Current, NewNode: PVacancyNode;
begin
  ResultHead := nil;
  Current := SourceHead;

  while Current <> nil do
  begin
    if (Current^.Data^.Salary >= MinSalary) and
      (Current^.Data^.RequiresHigherEducation = RequiresEducation) and
      (Current^.Data^.MaxAge <= MaxAge) and (Current^.Data^.MinAge >= MinAge)
      and (Pos(LowerCase(Specialty), LowerCase(Current^.Data^.Specialty)) > 0)
    then
    begin
      New(NewNode);
      New(NewNode^.Data);
      NewNode^.Data^ := Current^.Data^;
      NewNode^.Next := ResultHead;
      ResultHead := NewNode;
    end;
    Current := Current^.Next;
  end;
end;

procedure FilterCandidates(SourceHead: PCandidateNode; MinDesiredSalary: Double;
  HasEducation: Boolean; MinAge: Integer; MaxAge: Integer; Specialty: string;
  var ResultHead: PCandidateNode);
var
  Current, NewNode: PCandidateNode;
  Age: Integer;
begin
  ResultHead := nil;
  Current := SourceHead;

  while Current <> nil do
  begin
    Age := YearsBetween(Date, Current^.Data^.BirthDate);

    if (Current^.Data^.MinSalary >= MinDesiredSalary) and
      (Current^.Data^.HasHigherEducation = HasEducation) and (Age >= MinAge) and
      (Age <= MaxAge) and
      (Pos(LowerCase(Specialty), LowerCase(Current^.Data^.Specialty)) > 0) then
    begin
      New(NewNode);
      New(NewNode^.Data);
      NewNode^.Data^ := Current^.Data^;
      NewNode^.Next := ResultHead;
      ResultHead := NewNode;
    end;
    Current := Current^.Next;
  end;
end;

end.
