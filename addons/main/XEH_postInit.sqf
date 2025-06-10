#include "script_component.hpp"

if (isNil QGVARMAIN(pshID)) then {
  GVARMAIN(pshID) = [FUNC(perSecond), 1, nil] call CBA_fnc_addPerFrameHandler;
};

{
  [_x, "Init", {
      params ["_heli"];
      GVARMAIN(helis) pushBack _heli;
  }, true, [], true] call CBA_fnc_addClassEventHandler;
} forEach [
  "VTOL_Base_F",
  "Helicopter"
];