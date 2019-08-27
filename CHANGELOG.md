# RUF r148-Alpha
### Changed
* RUF now includes a modified version of oUF to check client type (classic/live) so oUF doesn't try to register vehicle frame events. Should stop Lua errors preventing frames from initialising.

### Known Issues
* When switching profiles, some custom text elements don't update correctly (Fix upcoming) - ReloadUI fixes this
* The Options panel settings for Buffs and Debuffs requires a reload to take effect.
* Adding or removing text areas requires a reload
* For classic there is currently no Master Looter icon (coming soon)
