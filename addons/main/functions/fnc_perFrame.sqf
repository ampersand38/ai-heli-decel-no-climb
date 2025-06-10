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
    private _pitch = vectorDir _heli # 2;
    
    if (
        _altitude < _initAltitude // Descending
        || {_speed < MIN_SPEED} // Deceleration complete
        || {_pitch <= 0} // Nose down
    ) then {
        GVARMAIN(helisDecel) deleteAt _forEachIndex;
        continue;
    };

    private _altClimbed = _altitude - _initAltitude;
    private _velocityZ = (velocity _heli # 2) max 1;
    private _force = _altClimbed^2 * _velocityZ^2 * _pitch * getMass _heli * -0.01;
    
#ifdef DEBUG_MODE_FULL
    drawIcon3D [
        "a3\ui_f\data\Map\MarkerBrushes\cross_ca.paa",
        [1, 1, 1, 1],
        ASLToAGL [getPosASL _heli # 0, getPosASL _heli # 1, _initAltitude],
        1, 1, 0,
        format ["%1", round (velocity _heli # 2)]
    ];
    diag_log ["_force", _force, "_altClimbed", _altClimbed, "_velocityZ", _velocityZ, "_pitch", _pitch];
#endif

    _heli addForce [
        [0, 0, _force],
        getCenterOfMass _heli
    ]; // Force it level
} forEachReversed GVARMAIN(helisDecel);
  