// This file is auto-generated by ./bin/rails stimulus:manifest:update
// Run that command whenever you add a new controller

import { application } from "./application"

import ApplicationController from "./application_controller.js"
application.register("application", ApplicationController)

import CommentController from "./comment_controller.js"
application.register("comment", CommentController)

import HelloController from "./hello_controller.js"
application.register("hello", HelloController)

import PracticesController from "./practices_controller.js"
application.register("practices", PracticesController)

import UserNavController from "./user_nav_controller.js"
application.register("user-nav", UserNavController)

import UploadAsyncController from "./upload_async_controller.js"
application.register("upload-async", UploadAsyncController)

import Popup from "./popup_controller"
application.register("popup", Popup)
