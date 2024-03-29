// This file is auto-generated by ./bin/rails stimulus:manifest:update
// Run that command whenever you add a new controller or create them with
// ./bin/rails generate stimulus controllerName

import { application } from "./application"

import CartController from "./cart_controller"
application.register("cart", CartController)

import DashboardController from "./dashboard_controller"
application.register("dashboard", DashboardController)

import ProductsController from "./products_controller"
application.register("products", ProductsController)
