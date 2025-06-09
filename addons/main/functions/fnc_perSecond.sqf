#include "script_component.hpp"
/*
* Author: Ampersand
* Check for AI helicopters that are decelerating
*
* Arguments:
* 0: Args <nil>
* 1: Handler ID <NUMBER>
*
* Return Value:
* None
*
* ahdnc_main_fnc_perSecond
*
*/

params ["", "_pfhId"];

private _time = cba_missionTime;

{
    private _heli = _x;
    if (
        isNull _heli
        || {isPlayer currentPilot _heli}
        || {speed _heli < MIN_SPEED}
    ) then {
        GVARMAIN(helisDecel) deleteAt (GVARMAIN(helisDecel) find _heli);
        continue;
    };
    if !(
        local _heli
        && {alive _heli}
        && {isEngineOn _heli}
        && {isNull remoteControlled driver _heli}
    ) then {
        GVARMAIN(helisDecel) deleteAt (GVARMAIN(helisDecel) find _heli);
        continue;
    };
    
    if (GVARMAIN(helisDecel) findIf {_heli == _x # 0} > -1) then {
        continue;
    };

    private _speed = speed _heli;
    private _altitude = getPosASL _heli # 2;
    
    private _speedAlt = _heli getVariable [QGVARMAIN(speedAlt), [-1, -1, -1]];
    _speedAlt params ["_lastSpeed", "_lastAltitude", "_lastTime"];
    if (_lastTime + 2 < _time) then {
        // First check ever
        _heli setVariable [QGVARMAIN(speedAlt), [_speed, _altitude, _time]];
        continue;
    };
    
    if (
        _lastSpeed > _speed && // Decelerating
        {_lastAltitude < _altitude} && // Ascending
        {vectorDir _heli # 2 > 0} // Nose up
    ) then {
        GVARMAIN(helisDecel) pushBack [_heli, _speed, _altitude, _time];
    };
    
    // Start pfh
    if (count GVARMAIN(helisDecel) > 0 && {isNil QGVARMAIN(pfhID)}) then {
        GVARMAIN(pfhID) = [FUNC(perFrame), 0, cba_missionTime] call CBA_fnc_addPerFrameHandler;
    };

    // Update speed altitude and time
    _heli setVariable [QGVARMAIN(speedAlt), [_speed, _altitude, _time]];

} forEachReversed GVARMAIN(helis); 