import { YoutubePlayer } from "./youtube_player/youtube_player"
customElements.define('youtube-player', YoutubePlayer)

import { Tabs } from "./tabs/tabs"
customElements.define('tabs-section', Tabs)

import { DragAndDrop } from "./drag-and-drop/drag-and-drop";
customElements.define('drag-and-drop', DragAndDrop)


import { Skeleton } from "./skeleton/skeleton";
customElements.define('skeleton-box', Skeleton)

import { Stat } from "./stat/stat";
customElements.define('stat-box', Stat)

import { Collapse } from "./collapse/collapse";
customElements.define('collapse-section', Collapse)
