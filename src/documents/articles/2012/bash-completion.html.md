--- yaml
layout: 'article'
title: 'Bash: 자동완성'
author: 'Changwoo Park'
date: '2012-3-18'
tags: ['bash', 'completion', 'Completion']
---

_이 글은 'An introduction to bash completion'([part 1][], [part 2][])을 정리한 것이다. DocPad에 Completion이 있으면 좀 편할 것 같아서 시작했다._

![tab-key](/articles/2012/bash-completion/tab-key.jpeg)

Bash Completion은 간단한 메커니즘으로 구현하는 것 같은데 막상 원하는 대로 조작하긴 쉽지 않다.

## Part 1

Completion 덕에 명령어와 인자를 좀 더 쉽게 사용할 수 있다. 자주 사용하는 명령어에 Completion을 구현하려면 이 글을 읽는 것이 좋다.

보통 셸에서 TAB 키를 누르면 파일 이름, 디렉토리 이름, 실행경로($PATH)에 있는 명령어를 자동으로 완성해준다:

    ls /bo[TAB]

`/bo` 다음에 TAB 키를 누르면 `/bo`가 `/boot`로 대체된다.

[Debian bash package][]는 `/etc/bash_completion`이라는 Completion 파일이 있고 이 파일에는 일반적인 명령어에 대한 Completion이 정의돼 있다. 아직 사용하고 있지 않으면 ". /etc/bash_completion"라고 실행해서 바로 사용하자:

    skx@lappy:~$ . /etc/bash_completion
    skx@lappy:~$ 

이걸 한 번만 해주면 다양한 명령어에 Completion을 이용할 수 있다:

    skx@lappy:~$ apt-get upd[TAB]
    skx@lappy:~$ apt-get upg[TAB]

그런데, 어떻게 만들지? 직접 만들고 싶은데. Completion 루틴은 'complete' 같은 bash 내부 명령어 몇 개를 조합해서 만든다. 이 루틴을 만들어 .bash_profile에 넣거나 별도의 파일로 만들어 /etc/bash_completion.d/에 넣을 수 있다.

/etc/bash_completion 파일을 로드하면(sourced) /etc/bash_completion.d 디렉토리에 있는 모든 파일이 같이 로드된다. 편리하다.

개중에는 호스트 이름을 완성해주는 것도 있다. 이 게 유용한 명령어도 있고 아닌 명령어도 있지만 하나 살펴보자.

저자인 [Steve][]는 [VNC로 관리하는 컴퓨터가 몇 대 있다][Remotely administering machines graphically, with VNC]. 보통 "xvncviewer hostname"이라고 실행한다.

다음과 같이 complete 명령을 실행해 주면 위 명령에서 hostname 부분을 Completion할 수 있다:

    skx@lappy:~$ complete -F _known_hosts xvncviewer

이 complete 명령을 한번 실행하고 [TAB]을 입력하면 다음과 같이 보여 줄 거다:

    skx@lappy:~$ xvncviewer s[TAB]
    savannah.gnu.org            ssh.tardis.ed.ac.uk
    scratchy                    steve.org.uk
    security.debian.org         security-master.debian.org
    sun
    skx@lappy:~$ xvncviewer sc[TAB]

이 호스트들은 나한테만 이렇게 보인다.

_known_hosts 함수는 /etc/bash_completion에 정의돼 있다. 이런 함수가 있다는 걸 내가 어떻게 알았을까? "compete -p" 명령을 실행하면 현재 사용하고 있는 것을 모두 보여준다:

    skx@lappy:~$ complete -p
    ....
    complete -F _known_hosts tracepath
    complete -F _known_hosts host
    ...

## Part 2

이제 직접 Completion 함수를 작성해 보자.

'part 1'에서 아무 명령에나 hostname을 완성하는 것을 만들어 봤다:

    complete -F _known_hosts xvncviewer

이 명령은 xvncviewer의 인자를 Completion할 때 _known_hosts 함수를 사용하라고 알리는 것이다.

이제는 이미 만들어진 함수를 사용하는 것이 아니라 직접 만들어 사용하는 것을 알아보자.

### A Basic Example

먼저 `foo`라는 명령어의 인자를 Completion하는 예제를 만들어보자. `foo`는 다음과 같은 인자를 가진 가짜 명령어다:

 * --help
  * Shows the help options for foo, and exits.
 * --version
  * Shows the version of the foo command, and exits.
 * --verbose
  * Runs foo with extra verbosity

/etc/bash_comletion을 로드할 때 자동으로 로드되도록 /etc/bash_completeion.d/foo 파일을 만든다. 

파일에 다음과 같은 내용을 넣고 저장한다:

    _foo() 
    {
        local cur prev opts
        COMPREPLY=()
        cur="${COMP_WORDS[COMP_CWORD]}"
        prev="${COMP_WORDS[COMP_CWORD-1]}"
        opts="--help --verbose --version"

        if [[ ${cur} == -* ]] ; then
            COMPREPLY=( $(compgen -W "${opts}" -- ${cur}) )
            return 0
        fi
    }
    complete -F _foo foo

그리고 나서 이 파일만 읽어들여 테스트해본다: 

    skx@lappy:~$ . /etc/bash_completion.d/foo
    skx@lappy:~$ foo --[TAB]
    --help     --verbose  --version  

한번 해보면 인자가 자동으로 완성되는 것을 볼 수 있다. 그리고 예를 들어, "foo --h[TAB]"라고 입력하면 '--help' 옵션을 자동으로 완성해준다

이제 실제로 동작하는 것을 만들어 봤고 어떻게 동작하는 것인지 뜯어보자!

### How Completion Works

Completion에 사용할 함수를 간단하게 구현해봤다.

이 함수는 cur, prev, opts 옵션을 정의하면서 시작한다. cur는 '현재 입력된 단어(word)'에 사용하고, prev는 '이전에 입력된 단어'에, opts는 Completion할 옵션에 사용한다.

그리고 실제로 옵션을 Completion하는 것은 compgen이라는 명령어를 통해서다:

    COMPREPLY=( $(compgen -W "${opts}" -- ${cur}) )

compgen 명령의 결과를 $COMPREPLY에 할당한다:

    compgen -W "${opts}" -- ${cur}

여기서 변수 대신 실제 값을 넣어보면 이 명령이 실제로 어떻게 동작하는지 이해하기 쉬울 것이다:

    compgen -W "--help --verbose --version" -- "userinput"

compgen은 "--help --verbose --version" 중에서 "${cur}"와 일치하는 것을 찾아 리턴한다. 잘 이해가 안되면 바로 셸에서 이 명령을 직접 실행해 보면 알 수 있다:

    skx@lappy:~$ compgen -W "--help --verbose --version" -- --
    --help
    --verbose
    --version
    skx@lappy:~$ compgen -W "--help --verbose --version" -- --h
    --help

"--"라고 입력하면 세 옵션 모두 일치하므로 전부 반환된다. 하지만 "--h"만 입력하면 "--help"만 일치하므로 --help만 반환한다.

그래서 이 결과를 "COMPREPLY" 변수에 할당하면 bash가 입력 중인 부분의 글자를 대체시킨다. bash에서 COMPREPLY는 Completion 루틴에서 결과를 반환하는 방법이라서 특별한 의미가 있는 변수다.

[the bash reference manual][]에 있는 COMPREPLY에 대한 설명을 살펴보자:

#### COMPREPLY

Completion 함수가 반환한 결과를 배열 형태로 반환하고 Bash가 이 변수를 읽는다.

그리고 사용자가 입력하는 단어가 무엇인지 COMP_WORDS라는 배열로 알 수 있다. 그리고 현재 단어와 이전 단어가 무엇인지도 알 수 있다.

#### COMP_WORDS

지금 Command line에 있는 각 단어가 담긴 배열이다. 이 변수는 Completion을 만들 때 사용하는 명령어를 통해 호출한 함수에서만 사용할 수 있다.

#### COMP_CWORD

${COMP_WORDS} 배열에서 현 단어를 가리키는 인덱스다. 이것도 Completion 명령어가 호출한 함수에서만 사용할 수 있다.

### A Complex Example

옵션이 굉장히 복잡한 명령어도 많다. 이런 명령어는 상당히 정교한 작업이 필요하다.

Xen에 있는 xm 명령어의 예를 살펴보자([developerworks의 Xen 소개](http://www.ibm.com/developerworks/kr/library/l-xen/)):

 * xm list
  * List all running Xen instances
 * xm create ConfigName
  * Create a new Xen instances using the configuration file in /etc/xen called ConfigName.
 * xm console Name
  * Connect to the console of the running machine named "Name".

예를 들어, "xm operation args" 라는 명령어에서 "args"는 앞에 "operation"이 무엇이냐에 따라 다르다.

먼저 "operation"의 Completion을 구현하는 것은 앞에서 설명했던 것과 방법이 같다. "--" 없이 구현하고 사용하면 된다. 하지만, 후속 인자를 Completion하는 것은 특별한 처리가 필요하다.

Completion할 때 이전 토큰을 알아야 해서 명령어마다 다르게 처리한다. 예를 들자면:

    _xm() 
    {
        local cur prev opts base
        COMPREPLY=()
        cur="${COMP_WORDS[COMP_CWORD]}"
        prev="${COMP_WORDS[COMP_CWORD-1]}"

        #
        #  The basic options we'll complete.
        #
        opts="console create list"


        #
        #  Complete the arguments to some of the basic commands.
        #
        case "${prev}" in
            console)
                local running=$(for x in `xm list --long | grep \(name | grep -v Domain-0 | awk '{ print $2 }' | tr -d \)`; do echo ${x} ; done )

                COMPREPLY=( $(compgen -W "${running}" -- ${cur}) )
                return 0
                ;;
            create)
                local names=$(for x in `ls -1 /etc/xen/*.cfg`; do echo ${x/\/etc\/xen\//} ; done )

                COMPREPLY=( $(compgen -W "${names}" -- ${cur}) )
                return 0
                ;;
            *)
                ;;
        esac

        COMPREPLY=($(compgen -W "${opts}" -- ${cur}))  
        return 0
    }
    complete -F _xm xm

이 코드는 "operation"을 Completion하는 것이고 "create"와 "console"이라는 "operation"에 대해서는 추가적인 코드를 더 했다. 
사용자가 입력하는 값을 Completion하기 위해 compgen을 사용하는 것까지는 같지만, 상황에 따라 다른 목록을 사용한다.

"console" operation에 사용하는 목록은 다음과 같은 명령으로 만든다:

    xm list --long | grep \(name | grep -v Domain-0 | awk '{ print $2 }' | tr -d \)

이 명령은 지금 도는 Xen 시스템의 목록을 반환한다.

"creation" operation에 사용하는 목록은 다음 명령으로 만든다:

    for x in `ls -1 /etc/xen/*.cfg`; do echo ${x/\/etc\/xen\//} ; done

이 명령은 /etc/xen 디렉토리에 있는 '*.cfg' 파일을 모두 반환한다. 예를 들면 다음과 같다:

    skx@lappy:~$ for x in `ls -1 /etc/xen/*.cfg`; do echo ${x/\/etc\/xen\//}; done
    etch.cfg
    root.cfg
    sarge.cfg
    steve.cfg
    x.cfg
    skx@lappy:~$ 

### Other Completion

지금까지 compgen을 사용해서 사용자가 입력한 값과 일치하는 스트링을 찾았다. 찾을 스트링은 하드 코딩한 목록이거나 명령어가 반환하는 결과에서 찾았다. 디렉토리 이름이나 프로세스 이름등 다른 것에서 찾을 수도 있다. 자세한 내용은 "man bash"를 실행해서 살펴볼 수 있다.

다음은 파일과 호스트이름을 Completion하는 방법을 설명하는 예제다:

    #
    #  Completion for foo:
    #
    #  foo file [filename]
    #  foo hostname [hostname]
    #
    _foo() 
    {
        local cur prev opts
        COMPREPLY=()
        cur="${COMP_WORDS[COMP_CWORD]}"
        prev="${COMP_WORDS[COMP_CWORD-1]}"
        opts="file hostname"
     
        case "${prev}" in
            file)
            COMPREPLY=( $(compgen -f ${cur}) )
                return 0
                ;;
            hostname)
            COMPREPLY=( $(compgen -A hostname ${cur}) )
                return 0
                ;;
            *)
            ;;
        esac

        COMPREPLY=( $(compgen -W "${opts}" -- ${cur}) )
    }
    complete -F _foo foo

이 예제를 활용하면 직접 Completion 함수를 만들 수 있다. 사실 Completion 함수를 만드는데 시간이 많이 들고 나머지는 매우 간단하다.

[Steve]가 작성한 [xm Completion 코드][xm completion]를 읽어 볼 수 있다.

@pismute가 만든 [docpad-completion.bash][]도 읽어 볼 수 있다.

[docpad-completion.bash]: https://github.com/dogfeet/docpad/blob/dogfeet/contrib/docpad-completion.bash
[the bash reference manual]: http://www.gnu.org/software/bash/manual/bash.html
[xm completion]: http://www.cvsrepository.org/cgi-bin/trac/xen-tools/dir?d=xen-tools/misc
[Debian bash package]: http://packages.debian.org/bash
[Remotely administering machines graphically, with VNC]: http://www.debian-administration.org/articles/135
[part 1]: http://www.debian-administration.org/articles/316
[part 2]: http://www.debian-administration.org/articles/317
[steve]: http://www.debian-administration.org/users/Steve
