if [ $1 = "push" ]; then
    git checkout master;
    git push origin master;
    git checkout server;
    git rebase master;
    if [ $? -eq 1 ]; then
        echo "rebase failed";
    else
        git push origin server -f;
        echo "rebase succeed";
    fi
    git checkout master;
    echo "push succeed";
elif [ $1 = "pull" ]; then
    git checkout master;
    git pull origin master;
    git checkout server;
    git pull origin server -f;
    echo "pull succeed";
else
    echo "unknown parameter";
fi
