# RUF r187-Release
### Fixed
* Cast Bars should stay disabled after a relog if set to be disabled.
* Cast Bar unit options should now take effect immediately.
* Cast Bars are clamped to the screen space now so you cannot accidentally move them off-screen.
* Health bar background should properly resize so there is no empty background area when a unit has 0 power or when changing specs on live.

### Known Issues
* After using Test Mode, a UI Reload should be done as some elements will not properly work after.
* Settings that affect individual bar borders require a reload to take effect.