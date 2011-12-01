---
layout: 'article'
title: 'Cake'
author: 'Changwoo Park'
date: '2011-11-21T16:06:05.000Z'
tags: ['Cake', 'CoffeeScript']
---

![CoffeeScript](http://jashkenas.github.com/coffee-script/documentation/images/logo.png "CoffeeScript")

Cake는 정말 쉽고 간단하다. Makefile대신 Cakefile만 만들면 된다.

### Hello World!

Cake 자체는 별로 설명할게 없다. Cakefile을 우선 다음과 같이 만든다:

    :::coffee
    task 'say:hello', 'Description of task', ->
      console.log 'Hello World!'

그리고 `task say:hello`라고 실행하면:

    :::bash
    $ cake say:hello
    Hello World!

task 이름 없이 실행하면 실행할 수 있는 task를 모두 보여준다:

    $ cake
    
    cake say:hello             # Description of task

### Option

production, development 등 환경에 따라 다르게 실행시키고 싶다면 다음과 같이 option을 정의한다:

    :::coffee
    option '-e', '--environment [ENVIRONMENT_NAME]', 'set the environment for `task:withDefaults`'
    task 'task:withDefaults', 'Description of task', (options) ->
      options.environment or= 'production'

이 코드는 다음과 같이 실행한다.

    :::bash
    $ cake -e "development" task:withDefaults

## Use Case

### Compile

src/*.coffee 파일을 out/*.js로 컴파일하는 명령어는 다음과 같다:

    $ coffee --compile --output lib/ src/

이 cake로 하려면 다음과 같이 한다.

    :::coffee
    {exec} = require 'child_process'
    task 'build', 'Build project from src/*.coffee to lib/*.js', ->
      exec 'coffee --compile --output lib/ src/', (err, stdout, stderr) ->
        throw err if err
        console.log stdout + stderr

`{exec} = require 'child_process'`는 [Destructuring Assignment][2]라는 것으로 js로 컴파일시 `var exec = require('child_process').exec`와 같다.

간단히 말해서 task를 이용해서 child process로 `coffee --compile --output lib/ src/`를 실행하는 것 뿐이다.

### Concatenating Files

파일을 하나로 합친다. 한 마디로 브라우저용이다. 개발은 Module별로 파일을 나눠서 하지만 배포는 하나로 하는 것이다.

    fs     = require 'fs'
    {exec} = require 'child_process'

    appFiles  = [
      # omit src/ and .coffee to make the below lines a little shorter
      'content/scripts/statusbar'
      'content/scripts/command/quickMacro'
      'content/scripts/command/selectionTools/general'
    ]

    task 'build', 'Build single application file from source files', ->
      appContents = new Array remaining = appFiles.length
      for file, index in appFiles then do (file, index) ->
        fs.readFile "src/#{file}.coffee", 'utf8', (err, fileContents) ->
          throw err if err
          appContents[index] = fileContents
          process() if --remaining is 0
      process = ->
        fs.writeFile 'lib/app.coffee', appContents.join('\n\n'), 'utf8', (err) ->
          throw err if err
          exec 'coffee --compile lib/app.coffee', (err, stdout, stderr) ->
            throw err if err
            console.log stdout + stderr
            fs.unlink 'lib/app.coffee', (err) ->
              throw err if err
              console.log 'Done.'

### Minify/Compress Your Files

[Google Closore Compiler][]로 컴파일 하기

    task 'minify', 'Minify the resulting application file after build', ->
      exec 'java -jar "/home/stan/public/compiler.jar" --js lib/app.js --js_output_file lib/app.production.js', (err, stdout, stderr) ->
        throw err if err
        console.log stdout + stderr

[Google Closore Compiler]: http://code.google.com/closure/compiler/

## 참고

 - [Compiling and Setting Up Build Tools][1]

[1]: https://github.com/jashkenas/coffee-script/wiki/%5BHowTo%5D-Compiling-and-Setting-Up-Build-Tools
[2]: http://jashkenas.github.com/coffee-script/

