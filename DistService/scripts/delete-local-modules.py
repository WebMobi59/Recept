import shutil
import os

script_dir = os.path.dirname(os.path.realpath(__file__))
local_modules_dir = script_dir + '/../local_modules'
node_modules_dir = script_dir + '/../node_modules'

local_modules = next(os.walk(local_modules_dir))[1]

for local_module in local_modules:
	node_module_dir = node_modules_dir + '/' + local_module
	if os.path.isdir(node_module_dir):
		print('Removing: ' + local_module + ' (to be reinstalled)')
		shutil.rmtree(node_module_dir)
