function xrepo
    switch $argv[1]
        case fzf-start
            set branch $argv[2]
            set extra_args $argv[3..]

            if test -z "$branch"
                echo "usage: xrepo fzf-start <branch-name> [repo-start-flags...]" >&2
                return 1
            end

            set selected (repo list | fzf --multi --prompt="pick projects> ")
            if test -z "$selected"
                return 1
            end

            # each line is "path : name"; extract name (field 2)
            set projects (string split -f 2 -- ' : ' $selected)
            repo start $branch $extra_args $projects

        case '*'
            repo $argv
    end
end
