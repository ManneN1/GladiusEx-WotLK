# GladiusEx - WotLK

The famous (and imo, far superior) arena frame AddOn GladiusEx - now for WotLK 3.3.5!

The AddOn will not work on Classic WotLK, it will only work on the original WotLK client.

# Installing

To download the addon, go to the [release page](https://github.com/ManneN1/GladiusEx-WotLK/releases/) and download the latest version as a zip file. Unzip it.

The Addon is to be placed in /Interface/AddOns (relative the WoW root folder).

When downloading the latest commit (Code -> Download ZIP) the folder "GladiusEx-WotLK-master must be renamed to "GladiusEx".

# Notes

Supports spectating based on [ArenaSpectator](https://github.com/azerothcore/azerothcore-wotlk/blob/master/src/server/game/ArenaSpectator/ArenaSpectator.cpp) (or variants thereof) which is available on some servers. Don't expect it to be perfect.

The "Incoming" Absorb/Heal portion of the healthbar module has been removed as the underlying API is non-existent in WotLK.

The "Cooldowns" module is only in beta mode. It works, but some abilities might be missing / having an incorrect spell ID (thus not working) / have an incorrect CD / be missing some conditional (e.g., lower CD if some other talent that we know is picked). Feel free to report specific improvements that can be done, or create a pull request.
