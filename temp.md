## Mapper

### Events
* `onMoveFail` - raised to indicate that you attempted to move but no move was made.
* `onVisionFail` - raised to indicate that you moved successfully, but are unable to gather some or all of the necessary info about the room.
* `onRandomMove` - raised to indicate that you moved, but do not know the direction you moved in.
* `onNewRoom` - raised to indcate that a room has been detected, typically after moving or looking.
* `onPrompt` - raised to indicate that a prompt has been detected.
* `onForcedMove` - raised to indicate that you moved without entering a command, but you know the direction you went.

