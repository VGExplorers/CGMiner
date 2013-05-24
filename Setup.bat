@ECHO OFF

ECHO Example Setup
ECHO Pool               mining.bitcoin.cz
ECHO Port Number        8332
ECHO Worker Username    User.Worker
ECHO Password           password123
ECHO Stock Clock Speed  800               Recommended- Double check your
ECHO                                                   specific video card's stock
ECHO                                                   clock core speed
ECHO Mining Clock Speed 850               Warning- Overclocking Setting, be careful
ECHO                                               with this, keep the same as
ECHO                                               Stock Clock Speed if you don't
ECHO                                               want to overclock
ECHO.

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