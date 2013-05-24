@ECHO OFF

set /P     Pool="Pool               "
ECHO %Pool%     > Automate\Settings.txt

set /P     Port="Port Number        "
ECHO %Port%     >> Automate\Settings.txt

set /P   Worker="Worker Username    "
ECHO %Worker%   >> Automate\Settings.txt

set /P Password="Password           "
ECHO %Password% >> Automate\Settings.txt

set /P    Stock="Stock Clock Speed  "
ECHO %Stock%    >> Automate\Settings.txt

set /P     Mine="Mining Clock Speed "
ECHO %Mine%     >> Automate\Settings.txt