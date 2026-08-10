function aws-login
    aws sso login --sso-session flocksafety-commercial
    aws sts get-caller-identity
end
