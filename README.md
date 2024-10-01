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

Why
---
I'm a not a fan of docker for kali, I've posted some issues a few years ago on docker github and still didn't get any answer.
That being said, I feel like I need to add that I love docker and use it all the time for anything in web development to reduce frictions while working in a team.
Also the security model of docker is near non existent if I'm not mistaken (it may change but I don't see how).
I like keeping my knowledge about the linux OS fresh and so I often install new vms or make fresh installs but I'm tired of doing the same boring steps over and over.
Oh and also, it's kind of a toy project. I wanted to know if I could make an implementation of a binary mask logic in bash only. :)

Roadmap
-------
Look at the todos in the script.
Feel free to hack it, PR are welcome but heavily scrutinized.
