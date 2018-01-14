unit tests.generics.hashmaps;

{$mode delphi}

interface

uses
  fpcunit, testregistry, testutils, typinfo,
  Classes, SysUtils, StrUtils, Generics.Collections, Generics.Defaults;

type
  PCollectionNotification = ^TCollectionNotification;

  { TTestHashMaps }

  TTestHashMaps= class(TTestCase)
  private
    procedure CountAsKey_Check(const AWhat: string; AValue, AExpectedValue: Integer;
      AAction: PCollectionNotification);
    procedure CountAsKey_Notify(const AKind: string; ASender: TObject; constref AItem: Integer; AAction: TCollectionNotification);
    procedure CountAsKey_NotifyValue(ASender: TObject; constref AItem: Integer; AAction: TCollectionNotification);
    procedure CountAsKey_NotifyKey(ASender: TObject; constref AItem: Integer; AAction: TCollectionNotification);
  published
    procedure Test_CountAsKey_OpenAddressingLP;
    procedure Test_CountAsKey_OpenAddressingLPT;
    procedure Test_CountAsKey_OpenAddressingQP;
    procedure Test_CountAsKey_OpenAddressingDH;
    procedure Test_CountAsKey_CuckooD2;
    procedure Test_CountAsKey_CuckooD4;
    procedure Test_CountAsKey_CuckooD6;

    procedure Test_QuadraticProbing_InfinityLoop;
  end;

implementation

{ TTestHashMaps }

procedure TTestHashMaps.CountAsKey_Check(const AWhat: string; AValue, AExpectedValue: Integer;
    AAction: PCollectionNotification);
var
  LCollectionNotificationStr: string;
begin
  if Assigned(AAction) then
    LCollectionNotificationStr := GetEnumName(TypeInfo(TCollectionNotification), Ord(AAction^));

  AssertEquals(AWhat + LCollectionNotificationStr, AExpectedValue, AValue);
end;

procedure TTestHashMaps.CountAsKey_Notify(const AKind: string; ASender: TObject; constref
  AItem: Integer; AAction: TCollectionNotification);
var
  LCount: Integer;
begin
  CountAsKey_Check('Item ('+AKind+')', AItem, 0, @AAction);
  LCount := TCustomDictionary<Integer, Integer, TDefaultHashFactory>(ASender).Count;
  case AAction of
    cnAdded:
      CountAsKey_Check('Count', LCount, 1, @AAction);
    cnRemoved:
      CountAsKey_Check('Count', LCount, 0, @AAction);
    cnExtracted: Halt(4);
  end;
end;

procedure TTestHashMaps.CountAsKey_NotifyValue(ASender: TObject; constref AItem: Integer;
  AAction: TCollectionNotification);
begin
  CountAsKey_Notify('Value', ASender, AItem, AAction);
end;

procedure TTestHashMaps.CountAsKey_NotifyKey(ASender: TObject; constref AItem: Integer;
  AAction: TCollectionNotification);
begin
  CountAsKey_Notify('Key', ASender, AItem, AAction);
end;

procedure TTestHashMaps.Test_CountAsKey_OpenAddressingLP;
var
  LDictionary: TOpenAddressingLP<Integer, Integer>;
begin
  // TOpenAddressingLP
  LDictionary := TOpenAddressingLP<Integer, Integer>.Create;
  LDictionary.OnKeyNotify := CountAsKey_NotifyKey;
  LDictionary.OnValueNotify := CountAsKey_NotifyValue;
  CountAsKey_Check('Count', LDictionary.Count, 0, nil);
  LDictionary.Add(LDictionary.Count,LDictionary.Count);
  CountAsKey_Check('Item', LDictionary[0], 0, nil);
  LDictionary.Free;
end;

procedure TTestHashMaps.Test_CountAsKey_OpenAddressingLPT;
var
  LDictionary: TOpenAddressingLPT<Integer, Integer>;
begin
  // TOpenAddressingLPT
  LDictionary := TOpenAddressingLPT<Integer, Integer>.Create;
  LDictionary.OnKeyNotify := CountAsKey_NotifyKey;
  LDictionary.OnValueNotify := CountAsKey_NotifyValue;
  CountAsKey_Check('Count', LDictionary.Count, 0, nil);
  LDictionary.Add(LDictionary.Count,LDictionary.Count);
  CountAsKey_Check('Item', LDictionary[0], 0, nil);
  LDictionary.Free;
end;

procedure TTestHashMaps.Test_CountAsKey_OpenAddressingQP;
var
  LDictionary: TOpenAddressingQP<Integer, Integer>;
begin
  // TOpenAddressingQP
  LDictionary := TOpenAddressingQP<Integer, Integer>.Create;
  LDictionary.OnKeyNotify := CountAsKey_NotifyKey;
  LDictionary.OnValueNotify := CountAsKey_NotifyValue;
  CountAsKey_Check('Count', LDictionary.Count, 0, nil);
  LDictionary.Add(LDictionary.Count,LDictionary.Count);
  CountAsKey_Check('Item', LDictionary[0], 0, nil);
  LDictionary.Free;
end;

procedure TTestHashMaps.Test_CountAsKey_OpenAddressingDH;
var
  LDictionary: TOpenAddressingDH<Integer, Integer>;
begin
  // TOpenAddressingDH
  LDictionary := TOpenAddressingDH<Integer, Integer>.Create;
  LDictionary.OnKeyNotify := CountAsKey_NotifyKey;
  LDictionary.OnValueNotify := CountAsKey_NotifyValue;
  CountAsKey_Check('Count', LDictionary.Count, 0, nil);
  LDictionary.Add(LDictionary.Count,LDictionary.Count);
  CountAsKey_Check('Item', LDictionary[0], 0, nil);
  LDictionary.Free;
end;

procedure TTestHashMaps.Test_CountAsKey_CuckooD2;
var
  LDictionary: TCuckooD2<Integer, Integer>;
begin
  // TCuckooD2
  LDictionary := TCuckooD2<Integer, Integer>.Create;
  LDictionary.OnKeyNotify := CountAsKey_NotifyKey;
  LDictionary.OnValueNotify := CountAsKey_NotifyValue;
  CountAsKey_Check('Count', LDictionary.Count, 0, nil);
  LDictionary.Add(LDictionary.Count,LDictionary.Count);
  CountAsKey_Check('Item', LDictionary[0], 0, nil);
  LDictionary.Free;
end;

procedure TTestHashMaps.Test_CountAsKey_CuckooD4;
var
  LDictionary: TCuckooD4<Integer, Integer>;
begin
  // TCuckooD4
  LDictionary := TCuckooD4<Integer, Integer>.Create;
  LDictionary.OnKeyNotify := CountAsKey_NotifyKey;
  LDictionary.OnValueNotify := CountAsKey_NotifyValue;
  CountAsKey_Check('Count', LDictionary.Count, 0, nil);
  LDictionary.Add(LDictionary.Count,LDictionary.Count);
  CountAsKey_Check('Item', LDictionary[0], 0, nil);
  LDictionary.Free;
end;

procedure TTestHashMaps.Test_CountAsKey_CuckooD6;
var
  LDictionary: TCuckooD6<Integer, Integer>;
begin
  // TCuckooD6
  LDictionary := TCuckooD6<Integer, Integer>.Create;
  LDictionary.OnKeyNotify := CountAsKey_NotifyKey;
  LDictionary.OnValueNotify := CountAsKey_NotifyValue;
  CountAsKey_Check('Count', LDictionary.Count, 0, nil);
  LDictionary.Add(LDictionary.Count,LDictionary.Count);
  CountAsKey_Check('Item', LDictionary[0], 0, nil);
  LDictionary.Free;
end;

procedure TTestHashMaps.Test_QuadraticProbing_InfinityLoop;
// https://github.com/maciej-izak/generics.collections/issues/4
var
  LMap: TOpenAddressingQP<string, pointer, TDelphiHashFactory>;
begin
  LMap := TOpenAddressingQP<string, pointer, TDelphiHashFactory>.Create();
  LMap.Add(#178#178#107#141#143#151#168#39#172#38#83#194#130#90#101, nil);
  LMap.Add(#193#190#172#41#144#231#52#62#45#117#108#45#217#71#77, nil);
  LMap.Add(#49#116#202#160#38#131#41#37#217#171#227#215#122#151#71, nil);
  LMap.Add(#148#159#199#71#198#97#69#201#116#45#195#184#178#129#200, nil);
  CheckEquals(false, LMap.ContainsKey(#$E6'h=fzb'#$E5#$B4#$A0#$C4#$E6'B6r>'));
  LMap.Free;
end;


begin
  RegisterTest(TTestHashMaps);
end.
