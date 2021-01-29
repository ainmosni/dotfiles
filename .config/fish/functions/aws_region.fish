function aws_region -a cmd -d "AWS Region switcher"
  switch "$cmd"
    case list
      aws ec2 describe-regions --region us-east-1| jq -r '.Regions[].RegionName'

    case '*'
      if set -q argv[1]
        set -gx AWS_REGION "$argv[1]"
      else if ! set -q AWS_PROFILE
        aws_region list
      else
          echo $AWS_REGION
      end
  end
end
