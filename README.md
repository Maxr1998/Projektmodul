# Weasley Clock - Hardware

Hardware definitions for the Weasley Clock project,
specifically the CAD designs for the gear system.

## Usage

The `.stl` and `.gcode` for the exported gears is part of the repository and can be used as is.

If you need to do any modifications to the OpenSCAD designs, you can re-export them through the provided `Makefile`.
The final design contains three driver gears and three main gears.
When running `openscad` manually, the exported gear can be selected through the `instance` parameter (1-3).

When customizing the PrusaSlicer configuration, make sure to export the configuration as "Configuration"
and not as "Configuration Bundle".
If you only have a bundle available, import the bundle first and then export it as normal configuration.

## License

<p>
    This project is licensed under
    <a href="https://creativecommons.org/licenses/by-sa/4.0/" target="_blank" rel="license noopener noreferrer" style="display:inline-block;">
        CC BY-SA 4.0
        <img alt="CC" height="20px" style="height:20px!important;margin-left:3px;vertical-align:text-bottom;" src="https://mirrors.creativecommons.org/presskit/icons/cc.svg"><img alt="BY" height="20px" style="height:20px!important;margin-left:3px;vertical-align:text-bottom;" src="https://mirrors.creativecommons.org/presskit/icons/by.svg"><img alt="SA" height="20px" style="height:20px!important;margin-left:3px;vertical-align:text-bottom;" src="https://mirrors.creativecommons.org/presskit/icons/sa.svg">
    </a>
</p>