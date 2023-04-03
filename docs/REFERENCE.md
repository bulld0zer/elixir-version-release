# Reference

## Levels
| level | description                         |                                   |
|-------|-------------------------------------|-----------------------------------|
| major | Creates major release version.     |  I.e. from 1.2.3 to 2.2.3         |
| minor | Creates minor release version.     |  I.e. from 1.2.3 to 1.3.3         |
| patch | Creates patch release version.     |  I.e. from 1.2.3 to 1.2.4         |
| rc    | Creates release candidate version. |  I.e. from 1.2.3 to 1.2.4-rc.0    |
| beta  | Creates beta release version.      |  I.e. from 1.2.3 to 1.2.4-beta.0  |
| alpha | Creates alpha release version.     |  I.e. from 1.2.3 to 1.2.4-alpha.0 |

## Settings
| Field       | Argument                | Type    | Description |
|-------------|-------------------------|---------|-------------|
| -           | -d, --dry-run           | Boolean | Preview all operations that will be executed. |
| tag_prefix  | --tag-prefix            | String  | Tag prefix usually just `v` (short for version). Will be created from version. I.e. if version is 1.2.3 and tag prefix is "ver" resulting tag will be `ver1.2.3` |
| hex_publish | -h, --skip-publish      | Boolean | Disabled by default. Enable publishing to hex.pm Should authorize beforehand. Check [Publishing a package](https://hex.pm/docs/publish) article. |
| hex_publish_force | -f, --force-publish | Boolean | Disabled by default. Publishing to hex.pm without confirmation. Check [Publishing a package from CI](https://hex.pm/docs/publish#publishing-from-ci) article. |
| git_push    | -g, --skip-push         | Boolean | Enabled by default. Enable git push at the end of all operations |
| dev_version | -v, --skip_dev_version  | Boolean | Will not bump version after release. Enabled by default |
| changelog   | -                       | Config  | Configuration for changelog. Check [Changelog](#changelog-config) section |
| merge       | -                       | Config  | Configuration for merging. Check [Merge](#merge) section |
| -           | -m, --skip_merge        | Boolean | Will skip merge if configures (NOT RELEASED) |
| commit_message  | -                   | String  | Overwrite for commit message. Replacement values are `{{version}}` |

## Changelog config
| Name          | Type      | Description                   |
|---------------|-----------|-------------------------------|
| creation      | Atom      | Mode of creation.             |
<!-- | replacements  | Config[]  | List of replacement settings. Check [Replacements config](#replacements-config) section | -->

### Creation settings
| Option        | Description                   |
|---------------|-------------------------------|
| disabled      | Changelog will not be created |
| manual        | Changelog will updated accordingly to replacements settings. Replacement values are `{{version}}`, `{{date}}`, `{{tag_name}}`. Everything that actually has changed should be written directly to changelog file |
| git_logs      | !Not implemented! Same as manual, but additionally if git commit massage starts with `add! `, `change! `, `fix! `, message will be added to changelog. |

### Replacements config
| Name      | Type      | Description                             |
|-----------|-----------|-----------------------------------------|
| file      | String    | File name in which to do replacements.  |
| patterns  | Config[]  | List of pattern settings. Check [Patterns config](#patterns-config) section |

### Patterns config
| Name      | Type          | Description                             |
|-----------|---------------|-----------------------------------------|
| search    | String/RegEx  | Pattern to search in specified file      |
| replace   | String        | String which will replace what is found. (`{{version}}`, `{{date}}`, `{{tag_name}}` Will be replaced accordingly)  |
| global    | Boolean       | File name in which to do replacements.  |

## Merge
| Name            | Type          | Description                                            |
|-----------------|---------------|--------------------------------------------------------|
| branches        | Mapping list  | Map of branch names to merge from and to. I.E. `%{from: "master", to: ["develop", "edge"]}`|
| ignore_conflicts | Boolean       | Will only warn on merge conflicts and will proceed by skipping branch with conflicts. Default `false` |
| message | String | Overwrite default merge message when merging branches |
