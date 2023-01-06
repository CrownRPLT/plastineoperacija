Config = {}
Config.Locale = 'en' -- Set Locale file to use.

Config.DrawDistance = 10 -- Marker Draw Distance.

Config.SurgMarker = {Type = 1, r = 102, g = 102, b = 204, x = 1.5, y = 1.5, z = 1.0} -- Surgery Marker Settings.
Config.BlipSurgery = {Sprite = 403, Color = 0, Display = 2, Scale = 1.0} -- Surgery Blip Settings.

Config.UseSurgeon = true -- true = Allows Players to edit their Character.
Config.UseSurgeonBlips = true -- true = Use Surgery Blips.
Config.SurgeryPrice = 7700 -- Surgery Price.

Config.Locations = {
	Locs = {
		Surgery = {
			vector3(-270.7556, 6322.0757, 31.4261), -- esx_ambulancejob Inside
		}
	}
}
