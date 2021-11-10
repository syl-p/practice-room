// This file is auto-generated by ./bin/rails stimulus:manifest:update
// Run that command whenever you add a new controller

import { application } from "./application"

import ApplicationController from "./application_controller.js"
application.register("application", ApplicationController)

import CommentController from "./comment_controller.js"
application.register("comment", CommentController)

import HelloController from "./hello_controller.js"
application.register("hello", HelloController)

import MarkdownController from "./markdown_controller.js"
application.register("markdown", MarkdownController)

import PracticerNavController from "./practicer_nav_controller.js"
application.register("practicer-nav", PracticerNavController)

import PracticerSidebarController from "./practicer_sidebar_controller.js"
application.register("practicer-sidebar", PracticerSidebarController)

import TabsController from "./tabs_controller.js"
application.register("tabs", TabsController)
