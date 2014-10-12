// Main Application Module
// -----------------------
// This module is the start point of application.
var App = angular.module("Application", ["ngAnimate",  "gettext", "ui.router"]);

// configuration section ---------------------------
App.config(["$stateProvider", "$urlRouterProvider", function($stateProvider, $urlRouterProvider){

     $urlRouterProvider.otherwise("/");
    // Configuring application index route.
    // Add any route you need here.
    $stateProvider.
        state("root", {
            url: "/",
            templateUrl: template_url("main"),
            controller: "MainController"
        });

}]);

App.controller("MainController", ["$scope", "gettext", function($scope, gettext){
    // Main controller of application. This controller is responsible for `/` url
    $scope.msg = gettext("Hello world");
}]);
