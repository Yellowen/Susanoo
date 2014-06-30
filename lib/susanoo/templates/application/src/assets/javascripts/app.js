// Main Application Module
// -----------------------
// This module is the start point of application.
var App = angular.module("Application", ["ngTouch", "ngAnimate", "ngRoute", "gettext", "angular-gestures"<% if is_ionic? %>, "ionic"<% end %>]);

// configuration section ---------------------------
App.config(["$routeProvider", function($routeProvider){

    // Configuring application index route.
    // Add any route you need here.
    $routeProvider.
        when("/", {
            templateUrl: template("main"),
            controller: "MainController"
        });

}]);

App.controller("MainController", ["$scope", "gettext", function($scope, gettext){
    // Main controller of application. This controller is responsible for `/` url
    $scope.msg = gettext("Hello world");
}]);
