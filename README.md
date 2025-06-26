# Craftinfo

An addon for Ashita V4 Beta.

## Requirements:

This addon uses https://github.com/msva/lua-htmlparser library;
So, you must either install it in the addons/libs or directly
under this folder (such as craftinfo if you clone this from Github).

## Usage:

(Using "Sleep Arrow" and "Sleep Bolt" as examples):

```
/craftinfo "Sleep Arrow"

/craftinfo "Sleep Bolt"
```
## How it works:

It uses the htmlparser library to grab the Synthesis information
table from bg-wiki.com, and then it prints out the crafting material part
only.
