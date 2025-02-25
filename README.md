Kallinstall
===========

A bash script to keep a unified step by step procedure for fresh kalli installs.
Just run the script : `bash ./kallinstall.sh` or `chmod +x ./kallinstall.sh && ./kallinstall.sh`
If you read this I believe you know the drill as they say.

How it works
------------
The script simply uses a binary mask for remembering steps already taken in case it failed or you quit it befores it ends.
Beware of using it prior to anything since and never again after since it uses `source` which is kinda dangerous by itself.
Also make sure the file holding the current state of the install is deleted after everything.
The file is labeled at the start of the script `_STEPS_FILENAME=".install.steps"` and is removed at the completion of the script.

Roadmap
-------
Look at the todos in the script.
Feel free to hack it, PR are welcome but heavily scrutinized.
