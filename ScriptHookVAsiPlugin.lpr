library ScriptHookVAsiPlugin;

{$mode objfpc}
{$H+}

uses
  Windows, ctypes, ScriptHookV, Natives, IniFiles, SysUtils, Classes;

const
  sct_AutoAssign: string = 'AutoAssign';


{************************
 Changes the player hash
 ************************}
procedure SetPlayerHash(p: Ped; h: Hash);
var
  baseaddr: ptruint;
  info1: ptruint;
begin
  baseaddr := ptruint(getScriptHandleBaseAddress(p));
  if baseaddr = 0 then exit;
  info1 := pptruint(baseaddr + $20)^;
  if info1 = 0 then exit;
  PHash(info1 + $18)^ := h;
end;

{************************
 MAIN SCRIPT FUNCTION
 ************************}
procedure ScriptMain; cdecl;
var
  plyr: Player;
  p: Ped;
  start_time: ULONGLONG;
  propertiesHash: Hash;
  delay_in_ms: integer;
  hash_applied: boolean = false;
  settings: TIniFile;
begin
  settings := TIniFile.Create('Jupiter_CharSwap_Lite.ini');
  try
    propertiesHash := settings.ReadInteger(sct_AutoAssign, 'PropertiesHash', 0);
    delay_in_ms := settings.ReadInteger(sct_AutoAssign, 'Delay', 5000);

    start_time := GetTickCount64;

    while not hash_applied do
    begin
      if (GetTickCount64 - start_time > ULONGLONG(delay_in_ms)) then
      begin
        plyr := GET_PLAYER_INDEX;
        p := GET_PLAYER_PED(plyr);

        if (p <> 0) and (IS_PLAYER_PLAYING(plyr) <> BOOL(0)) then
        begin
          SetPlayerHash(p, propertiesHash);
          hash_applied := true;
        end;
      end;
      ScriptHookVWait(0);
    end;
  finally
    settings.Free;
  end;
end;

{************************
 PLUGIN INITIALIZATION AND FINALIZATION CODE
 ************************}
procedure EndDll(reason: PtrInt);
begin
  scriptUnregister(HInstance);
end;

begin
  Dll_Process_Detach_Hook := @EndDll;
  scriptRegister(HInstance, @ScriptMain);
end.
