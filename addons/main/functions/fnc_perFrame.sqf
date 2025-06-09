#include "script_component.hpp"
/*
* Author: Ampersand
* For all AI helicopters that are decelerating, force it level
*
* Arguments:
* 0: Time <NUMBER>
* 1: Handler ID <NUMBER>
*
* Return Value:
* None
*
* ahdnc_main_fnc_perFrame
*
*/

params ["_time", "_pfhId"];

if (isGamePaused) exitWith {};

{
    if (isNil QGVARMAIN(pfhID) || {count GVARMAIN(helisDecel) == 0}) exitWith {
        [GVARMAIN(pfhID)] call CBA_fnc_removePerFrameHandler;
        GVARMAIN(pfhID) = nil;
    };
    
    _x params ["_heli", "_initSpeed", "_initAltitude", "_initTime"];
    
    private _speed = speed _heli;
    private _altitude = getPosASL _heli # 2;
    
    if (
        _altitude < _initAltitude // Descending
        || {_speed < MIN_SPEED} // Deceleration complete
        || {vectorDir _heli # 2 <= 0} // Nose down
    ) then {
        GVARMAIN(helisDecel) deleteAt _forEachIndex;
        continue;
    };

    private _altClimbed = _altitude - _initAltitude;
    private _velocityZ = velocity _heli # 2;
    private _pitch = vectorDir _heli # 2;
    private _force = _altClimbed^2 * _velocityZ^2 * _pitch * getMass _heli * -0.01;
    
    _heli addForce [
        [0, 0, _force],
        getCenterOfMass _heli
    ]; // Force it level
} forEachReversed GVARMAIN(helisDecel);
  