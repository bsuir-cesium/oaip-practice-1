unit ListUtils;

interface

uses
  CoreTypes;

procedure ClearVacancies(var Head: PVacancyNode);
procedure ClearCandidates(var Head: PCandidateNode);
procedure ClearCompanies(var Head: PCompanyNode);

function DeleteVacancy(var Head: PVacancyNode; ID: Integer): Integer;
function DeleteCandidate(var Head: PCandidateNode; ID: Integer): Integer;
function DeleteCompany(var CompaniesHead: PCompanyNode; CompanyID: Integer;
  var VacanciesHead: PVacancyNode): Integer;
function DeleteVacanciesByCompany(var VacanciesHead: PVacancyNode;
  CompanyID: Integer): Integer;

procedure AppendVacancy(var Head: PVacancyNode; const Data: TVacancy);
procedure AppendCandidate(var Head: PCandidateNode; const Data: TCandidate);
procedure AppendCompany(var Head: PCompanyNode; const Data: TCompany);

function CompanyExists(Head: PCompanyNode; ID: Integer): Boolean;
function GetCompanyNameByID(Head: PCompanyNode; const ID: Integer): String;

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

procedure ClearCompanies(var Head: PCompanyNode);
var
  Temp: PCompanyNode;
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

function DeleteCompany(var CompaniesHead: PCompanyNode; CompanyID: Integer;
  var VacanciesHead: PVacancyNode): Integer;
var
  Current, Prev: PCompanyNode;
begin
  if (CompaniesHead <> nil) and CompanyExists(CompaniesHead, CompanyID) then
  begin
    DeleteVacanciesByCompany(VacanciesHead, CompanyID);

    if CompaniesHead^.Data^.ID = CompanyID then
    begin
      Current := CompaniesHead;
      CompaniesHead := CompaniesHead^.Next;
      Result := Current^.Data^.ID;
      Dispose(Current^.Data);
      Dispose(Current);
      Exit;
    end;

    Prev := CompaniesHead;
    Current := CompaniesHead^.Next;

    while Current <> nil do
    begin
      if Current^.Data^.ID = CompanyID then
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
  end
  else
    Result := -1
end;

function DeleteVacanciesByCompany(var VacanciesHead: PVacancyNode;
  CompanyID: Integer): Integer;
var
  Current, Prev: PVacancyNode;
  Count: Integer;
begin
  Count := 0;
  Current := VacanciesHead;
  Prev := nil;

  while Current <> nil do
  begin
    if Current^.Data^.CompanyID = CompanyID then
    begin
      if Prev = nil then
        VacanciesHead := Current^.Next
      else
        Prev^.Next := Current^.Next;

      Dispose(Current^.Data);
      Dispose(Current);
      Inc(Count);
    end
    else
    begin
      Prev := Current;
    end;
    Current := Current^.Next;
  end;

  Result := Count;
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

procedure AppendCompany(var Head: PCompanyNode; const Data: TCompany);
var
  NewNode, Current: PCompanyNode;
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

function CompanyExists(Head: PCompanyNode; ID: Integer): Boolean;
begin
  while Head <> nil do
  begin
    if Head^.Data^.ID = ID then
      Exit(True);
    Head := Head^.Next;
  end;
  Result := False;
end;

function GetCompanyNameByID(Head: PCompanyNode; const ID: Integer): String;
begin
  while Head <> nil do
  begin
    if Head^.Data^.ID = ID then
      Exit(Head^.Data^.Name);
    Head := Head^.Next;
  end;
end;

end.
