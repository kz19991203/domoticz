local adapters = require('Adapters')()

return {

	baseType = 'device',

	name = 'OpenTherm gateway device adapter',

	matches = function (device)
		return (device.hardwareTypeVal == 20 and device.deviceSubType == 'SetPoint')
	end,

	process = function (device, data, domoticz, utils)

		device['SetPoint'] = device.rawData[1] or 0

		function device.updateSetPoint(setPoint, mode, untilDate)
			-- send the command using openURL otherwise, due to a bug in Domoticz, you will get a timeout on the script
			local url = 'http://' .. domoticz.settings['Domoticz ip'] .. ':' .. domoticz.settings['Domoticz port'] ..
					'/json.htm?type=command&param=udevice&idx=' .. device.id .. '&nvalue=0&svalue=' .. setPoint
			utils.log('Setting setpoint using openURL ' .. url, utils.LOG_DEBUG)
			domoticz.openURL(url)
		end

	end

}