Kallinstall
===========

A personnal bash script to keep a unified step by step procedure for fresh kali installs.
Just run the script : `sudo bash ./kallinstall.sh` or `chmod +x ./kallinstall.sh && sudo ./kallinstall.sh`

How it works
------------
The script simply uses a binary mask for remembering steps already taken in case it failed or you quit it befores it ends.
Beware of using it prior to anything since and never again after since it uses `source` which is kinda dangerous by itself.
Also make sure the file holding the current state of the install is deleted after everything.
The file is labeled at the start of the script `_STEPS_FILENAME=".install.steps"` and is removed at the completion of the script.
