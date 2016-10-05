# emacs

These are my personal emacs configuration files. They are intended to work on macOS, though they will probably also work on most *nix systems.

## Organization

init.el.symlink
init.el
-- general
	|-- packages.el
	|-- solar-mode.el
-- helm.el
-- dired.el
-- projectile.el
-- org-mode
	|-- my-org.el
	|-- notes.el
	|-- tasks.el
	|-- agenda.el
	|-- time-tracking.el
	|-- reporting.el
	|-- gcal.el
-- coding.el
-- magit.el
-- emacs.secrets (not tracked)

This is cascaded so that init.el.symlink contains general settings and then loads the subfiles for specific configurations, allowing the code to be more manageable.

## Use

This is intended to be used in conjunction with my "dotfiles" repository as a git submodule. Everything labled *.symlink within that repository gets symlinked to the home directory automatically. In the case of our emacs configs, this simply points us back to the propery directory so that everything else is loaded correctly.








	
