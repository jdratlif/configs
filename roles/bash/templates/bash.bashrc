# THIS FILE WAS AUTO-GENERATED | LOCAL CHANGES MAY BE OVERWRITTEN
# ansible template: home-dir-config/roles/bash/templates/bashrc.j2

{% if not bash_zsh %}
# Source global definitions
if [ -f /etc/bashrc ]; then
    . /etc/bashrc
fi

{% endif %}
# set PATH so it includes user's private bin if it exists
if [ -d "$HOME/bin" ] ; then
    PATH="$HOME/bin:$PATH"
fi

# set PATH so it includes user's private bin if it exists
if [ -d "$HOME/.local/bin" ] ; then
    PATH="$HOME/.local/bin:$PATH"
fi

{% if bash_custom_prompt %}
PROMPT_COMMAND=my_prompt
    {%- if not bash_custom_my_prompt %}


git_branch() {
    git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/\1/'
}

my_prompt() {
    local exit_code="$?"

    RESET="\[\033[0m\]"
    RED="\[\033[0;31m\]"
    GREEN="\[\033[01;32m\]"
    BLUE="\[\033[01;34m\]"
    YELLOW="\[\033[01;33m\]"
    CYAN="\[\033[00;36m\]"

    GIT_BRANCH=$(git_branch)

    if [[ $exit_code -ne 0 ]]; then
        PS1="(${RED}"
    else
        PS1="(${GREEN}"
    fi

    PS1="${PS1}${exit_code}${RESET}) ${YELLOW}$(hostname -f)${RESET} [${BLUE}\w${RESET}]"

    if [[ ! -z $GIT_BRANCH ]]; then
        PS1="${PS1} (${CYAN}${GIT_BRANCH}${RESET})"
    fi

    PS1="${PS1}\n\$ "

    if [[ ! -z $VIRTUAL_ENV ]]; then
        venv=$(basename $VIRTUAL_ENV)
        PS1="($venv) $PS1"
    fi
}
    {%- endif %}
{% endif %}


# history options
{% for option in bash_history_options %}
{{ 'setopt' if bash_zsh else 'shopt -s' }} {{ option }}
{% endfor %}

{% if not bash_zsh %}
export HISTCONTROL="ignoreboth"
{% endif %}
export HISTTIMEFORMAT="{{ bash_history_time_format }}"
export HISTSIZE={{ bash_history_size }}
export HISTFILESIZE={{ bash_history_file_size }}

export EDITOR={{ bash_editor }}

export PAGER="{{ bash_pager }}"
export LIBVIRT_DEFAULT_URI='qemu:///system'

# setup LANG and LC_ALL
export LC_ALL=en_US.UTF-8
export LANG=en_US.UTF-8

{% if bash_path_pre | length > 0 or bash_path_post | length > 0 %}
export PATH="{{ (bash_path_pre + ['$PATH'] + bash_path_post) | join(':') }}"

{% endif %}
{% if bash_exports %}
# begin local exports
{% for item in bash_exports | dictsort %}
export {{ item[0] }}='{{ item[1] }}'
{% endfor %}
# end local exports

{% endif %}
{% if bash_functions %}
# begin local functions
    {%- for item in bash_functions | dictsort %}

function {{ item[0] }} {
        {%- for line in item[1] %}

    {{ line }}
        {%- endfor %}

}
    {%- endfor %}

# end local functions
{% endif %}

{% if bash_aliases %}
# begin local aliases
    {%- for item in bash_aliases | dictsort %}

alias {{ item[0] }}={{ item[1] | quote }}
    {%- endfor %}

# end local aliases
{% endif %}

# func will show all defined shell function names (similar to alias)
{% if bash_zsh %}
alias func="print -l ${(ok)functions[(I)[^_]*]}"
{% else %}
alias func="declare -F | grep -v 'declare -f _' | awk '{print \$3}'"
{% endif %}

# tab-completion
{% if bash_zsh %}
autoload -Uz compinit && compinit
{% else %}
if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
  fi
fi
{% endif %}

{% if bash_sources | length > 0 %}
# begin source imports
    {%- for item in bash_sources %}
source {{ item }}
    {%- endfor %}
# end source imports

{% endif %}
# User specific aliases and functions
if [ -d ~/{{ bash_rc_file }}.d ]; then
    for rc in ~/{{ bash_rc_file }}.d/*; do
        if [ -f "$rc" ]; then
            . "$rc"
        fi
    done
fi
unset rc
