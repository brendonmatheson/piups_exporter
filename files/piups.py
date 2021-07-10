#!/usr/bin/env python

# IMPORT THE LIBERARY.
from ina219 import INA219
from ina219 import DeviceRangeError
SHUNT_OHMS = 0.05

def read():
	"""Define method to read information from coulometer."""
	ina = INA219(SHUNT_OHMS)
	ina.configure()

	print("# HELP piups_bus_voltage_volts The voltage supplied to the connected device(s)")
	print("# TYPE piups_bus_voltage_volts gauge")
	print("piups_bus_voltage_volts %.3f" % ina.voltage())

	try:
		print("# HELP piups_bus_current_milliamps The current drawn by the connected device(s)")
		print("# TYPE piups_bus_current_milliamps gauge")
		print("piups_bus_current_milliamps %.3f" % ina.current())

		print("# HELP piups_power_milliwatts The power consumed by the connected devices in milli-watts")
		print("# TYPE piups_power_milliwatts gauge")
		print("piups_power_milliwatts %.3f" % ina.power())

		print("# HELP piups_shunt_voltage_millivolts TBD")
		print("# TYPE piups_shunt_voltage_millivolts gauge")
		print("piups_shunt_voltage_millivolts %.3f" % ina.shunt_voltage())

	except DeviceRangeError as e:
		print(e)

if __name__ == "__main__":
	read()

