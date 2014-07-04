private [ "_lightMarkers" ];

_lightMarkers = [ "fl1", "fl2", "fl3", "fl4", "fl5", "fl6", "fl7", "fl8", "fl9", "fl10", "fl11", "fl12", "fl13", "fl14", "fl15" ];
{
  _light = createVehicle [ "Land_PortableLight_double_F", markerPos _x, [], 0, "CAN_COLLIDE" ];
  _light setDir ((markerDir _x) - 180);
  _x setMarkerAlpha 0;
  _x setMarkerText "";
} forEach _lightMarkers;