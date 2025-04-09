unit ListUtils;

interface

uses
  CoreTypes;

procedure ClearVacancies(var Head: PVacancyNode);
procedure ClearCandidates(var Head: PCandidateNode);

function DeleteVacancy(var Head: PVacancyNode; ID: Integer): Integer;
function DeleteCandidate(var Head: PCandidateNode; ID: Integer): Integer;

procedure AppendVacancy(var Head: PVacancyNode; const Data: TVacancy);
procedure AppendCandidate(var Head: PCandidateNode; const Data: TCandidate);

implementation

procedure ClearVacancies(var Head: PVacancyNode);
var
  Temp: PVacancyNode;
begin
  while Head <> nil do
  begin
    Temp := Head;
    Head := Head^.Next;
    Dispose(Temp^.Data);
    Dispose(Temp);
  end;
end;

procedure ClearCandidates(var Head: PCandidateNode);
var
  Temp: PCandidateNode;
begin
  while Head <> nil do
  begin
    Temp := Head;
    Head := Head^.Next;
    Dispose(Temp^.Data);
    Dispose(Temp);
  end;
end;

function DeleteVacancy(var Head: PVacancyNode; ID: Integer): Integer;
var
  Current, Prev: PVacancyNode;
begin
  Result := -1;
  if Head = nil then
    Exit;

  if Head^.Data^.ID = ID then
  begin
    Current := Head;
    Head := Head^.Next;
    Result := Current^.Data^.ID;
    Dispose(Current^.Data);
    Dispose(Current);
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
  Current, Prev: PCandidateNode;
begin
  Result := -1;
  if Head = nil then
    Exit;

  if Head^.Data^.ID = ID then
  begin
    Current := Head;
    Head := Head^.Next;
    Result := Current^.Data^.ID;
    Dispose(Current^.Data);
    Dispose(Current);
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

procedure AppendVacancy(var Head: PVacancyNode; const Data: TVacancy);
var
  NewNode, Current: PVacancyNode;
begin
  New(NewNode);
  New(NewNode^.Data);
  NewNode^.Data^ := Data;
  NewNode^.Next := nil;
  if Head = nil then
    Head := NewNode
  else
  begin
    Current := Head;
    while Current^.Next <> nil do
      Current := Current^.Next;
    Current^.Next := NewNode;
  end;
end;

procedure AppendCandidate(var Head: PCandidateNode; const Data: TCandidate);
var
  NewNode, Current: PCandidateNode;
begin
  New(NewNode);
  New(NewNode^.Data);
  NewNode^.Data^ := Data;
  NewNode^.Next := nil;
  if Head = nil then
    Head := NewNode
  else
  begin
    Current := Head;
    while Current^.Next <> nil do
      Current := Current^.Next;
    Current^.Next := NewNode;
  end;
end;

end.
