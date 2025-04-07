unit ListUtils;

interface

uses
  CoreTypes;

function DeleteVacancy(var Head: PVacancyNode; ID: Integer): Integer;
function DeleteCandidate(var Head: PCandidateNode; ID: Integer): Integer;

implementation

function DeleteVacancy(var Head: PVacancyNode; ID: Integer): Integer;
var
  Current, Prev, Temp: PVacancyNode;
begin
  Result := -1;
  if Head = nil then Exit;

  if Head^.Data^.ID = ID then
  begin
    Temp := Head;
    Head := Head^.Next;
    Result := Temp^.Data^.ID;
    Dispose(Temp^.Data);
    Dispose(Temp);
    Exit;
  end;

  Prev := Head;
  Current := Head^.Next;

  while Current <> nil do
  begin
    if Current^.Data^.ID = ID then
    begin
      Prev^.Next := Current^.Next;
      Result := Current^.Data^.ID;
      Dispose(Current^.Data);
      Dispose(Current);
      Exit;
    end;

    Prev := Current;
    Current := Current^.Next;
  end;
end;

function DeleteCandidate(var Head: PCandidateNode; ID: Integer): Integer;
var
  Current, Prev, Temp: PCandidateNode;
begin
  Result := -1;
  if Head = nil then Exit;

  if Head^.Data^.ID = ID then
  begin
    Temp := Head;
    Head := Head^.Next;
    Result := Temp^.Data^.ID;
    Dispose(Temp^.Data);
    Dispose(Temp);
    Exit;
  end;

  Prev := Head;
  Current := Head^.Next;

  while Current <> nil do
  begin
    if Current^.Data^.ID = ID then
    begin
      Prev^.Next := Current^.Next;
      Result := Current^.Data^.ID;
      Dispose(Current^.Data);
      Dispose(Current);
      Exit;
    end;

    Prev := Current;
    Current := Current^.Next;
  end;
end;

end.
