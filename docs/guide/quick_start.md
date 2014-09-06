# Quick Start

After [Installation]() of `Susanoo` head to you terminal to create a new project:

```bash
$ susanoo new example_project
```

Above command will ask you a few questions about your new project and download
couple of files and the generate the new project for you.

**Note:** You have to know about `Apache Cordova` basic usage to continue.

ok now you have a `Susanoo` hello world application.

## How can I run my new app ?
Running a `Susanoo` application is easy too but you have to learn a little about
the running process. In order to run you application you have to build it first
(of caurse susanoo will do it automatically but it's a good idea to know about
these stuff).

Your code live at `src/` by default but `cordova` except a `www/` directory in your
project, so by using:

```bash
$ susanoo build
```

You can compile your assets and ruby code to a static application (which `cordova`
excepts) and put them in `www/` directory. There is an other command which allows
you to run the built result:

```bash
$ susanoo run PLATFORM
```

will run the built resulted in given **PLATFORM** (NOTE: `run` will also run the
`build` command too). Bear in mind that **YOU HAVE TO ALREADY INSTALLED YOU PLATFORM SDK BEFORE**
so `run` command can find your **SDK** and run the project using that SDK.

For example to run the application under `Android` platform you have to connect an android
device or use some emulators like [genymotion](http://www.genymotion.com).
