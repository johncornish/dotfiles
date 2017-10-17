alias fltodo="ftime -f ~/org/tasks.yml todo"
alias flopen="emacs ~/org/tasks.yml"
alias flpush="aws s3 cp ~/org/tasks.yml s3://org.s3.johncorni.sh"
alias flpull="aws s3 cp s3://org.s3.johncorni.sh ~/org/tasks.yml"

export EDITOR="emacsclient -c"
