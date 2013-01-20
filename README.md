mimosa-skeleton
===========

## Overview

For more information regarding Mimosa, see http://mimosajs.com.

* mimosa-skeleton module released on 1/19. Now it just needs actual skeletons.  I'll probably create one or two, but will rely on skeletons being contributed down the road. If you build it they will hopefully come? mimosa-skeleton will become a default module once it has a few skeletons.
* mimosa-skeleton introduces 3 commands, `skel:new`, `skel:list` and `skel:search`. `skel:new` creates a new skeleton from the [registry](https://github.com/dbashford/mimosa-skeleton/blob/master/registry.json), from a github repo url, or from a system path (if testing skeletons). `skel:list` lists all skeletons from the registry. `skel:search` lists registry skeletons that match a provided keyword.
* To contribute a skeleton, just submit a pull request to get your skeleton added to the [registry](https://github.com/dbashford/mimosa-skeleton/blob/master/registry.json). I will curate the list ever so slightly. I don't care if you use Backbone or Ember or Angular or Batman, and I don't care how you organize your projects (that much)...but don't submit a Yeoman project. =)
* I'll also be adding some docs to the mimosajs.com website soon.