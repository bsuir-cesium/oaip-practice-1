unit MenuUtils;

interface

uses
  CoreTypes, FileUtils, InputUtils, OutputUtils;

procedure ShowMainMenu;
procedure ShowAddRecordMenu(var VacanciesHead: PVacancyNode;
  var CandidatesHead: PCandidateNode);

implementation

uses
  SysUtils, Windows;

procedure ClearScreen;
var
  hConsole: THandle;
  cursorPos: TCoord;
begin
  hConsole := GetStdHandle(STD_OUTPUT_HANDLE);
  Write(#27'[2J'#27'[3J');
  cursorPos.X := 0;
  cursorPos.Y := 0;
  SetConsoleCursorPosition(hConsole, cursorPos);
end;

procedure ShowViewSubmenu(VacanciesHead: PVacancyNode;
  CandidatesHead: PCandidateNode);
var
  Choice: Integer;
begin
  repeat
    ClearScreen;
    Writeln('1. Просмотр вакансий');
    Writeln('2. Просмотр кандидатов');
    Writeln('3. Назад');
    Write('Выберите: ');
    Readln(Choice);

    case Choice of
      1:
        begin
          ClearScreen;
          ShowAllVacancies(VacanciesHead);
          Writeln('Нажмите Enter для продолжения...');
          Readln;
        end;
      2:
        begin
          ClearScreen;
          ShowAllCandidates(CandidatesHead);
          Writeln('Нажмите Enter для продолжения...');
          Readln;
        end;
      3:
        Exit;
    else
      Writeln('Неверный выбор!');
      Readln;
    end;
  until False;
end;

procedure ShowAddRecordMenu(var VacanciesHead: PVacancyNode;
  var CandidatesHead: PCandidateNode);
var
  Choice: Integer;
begin
  repeat
    ClearScreen;
    Writeln('1. Добавить вакансию');
    Writeln('2. Добавить кандидата');
    Writeln('3. Назад');
    Write('Выберите: ');
    Readln(Choice);

    case Choice of
      1:
        AddNewVacancy(VacanciesHead);
      2:
        AddNewCandidate(CandidatesHead);
      3:
        Exit;
    else
      Writeln('Неверный выбор!');
      Readln;
    end;
  until False;
end;

procedure ShowMainMenu;
var
  Choice: Integer;
  VacancyHead: PVacancyNode;
  CandidateHead: PCandidateNode;
begin
  VacancyHead := nil;
  CandidateHead := nil;
  repeat
    ClearScreen;
    Writeln(' 1. Чтение данных из файла');
    Writeln(' 2. Просмотр всего списка');
    Writeln(' 3. Сортировка данных');
    Writeln(' 4. Поиск данных с использованием фильтров');
    Writeln(' 5. Добавление данных в список');
    Writeln(' 6. Удаление данных из списка');
    Writeln(' 7. Редактирование данных');
    Writeln(' 8. Подбор кандидатов для фирм (СФ)');
    Writeln(' 9. Выход из программы без сохранения изменений');
    Writeln('10. Выход с сохранением изменений');
    Write('Выберите пункт меню: ');
    Readln(Choice);

    case Choice of
      1:
        LoadAllData(VacancyHead, CandidateHead);
      2:
        ShowViewSubmenu(VacancyHead, CandidateHead);
      3 .. 4:
        Writeln('debug');
      5:
        ShowAddRecordMenu(VacancyHead, CandidateHead);
      6 .. 8:
        Writeln('debug');
      9 .. 10:
        begin
          if Choice = 10 then
            SaveAllData(VacancyHead, CandidateHead);

          ClearVacancies(VacancyHead);
          ClearCandidates(CandidateHead);

          Exit;
        end
    else
      begin
        Writeln('Неверный выбор. Нажмите любую клавишу и попробуйте снова.');
        Readln;
      end;
    end;
  until False;
end;

end.
