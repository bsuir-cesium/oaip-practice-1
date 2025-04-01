unit MenuUtils;

interface

uses
  CoreTypes, FileUtils;

procedure ShowMainMenu;

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
      2 .. 4:
        Writeln('debug');
      5:
        Writeln('debug');
//        ShowAddRecordMenu(VacancyHead, CandidateHead);
      6 .. 10:
        begin
          Writeln('Досвидание');
          break;
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
