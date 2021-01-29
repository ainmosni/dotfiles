function aws_profile -a cmd -d "AWS Profile switcher"
  switch "$cmd"
    case list
      command sed -n -e 's/^\[\(.*\)\]/\1/p' "$HOME/.aws/credentials"

    case '*'
      if set -q argv[1]
        set -gx AWS_PROFILE "$argv[1]"
      else if ! set -q AWS_PROFILE
        aws_profile list
      else
          echo $AWS_PROFILE
      end
  end
end
